#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Nov 16 11:53:53 2020

@author: Sharonvy
"""

import re
import time
import pymysql
from hashlib import md5
from datetime import datetime

from flask import Flask, request, session, url_for, redirect, \
	 render_template, abort, g, flash, _app_ctx_stack
from flaskext.mysql import MySQL
from werkzeug.security import generate_password_hash, check_password_hash

# ============================ Basic Setup ============================

app = Flask(__name__)
app.secret_key = "secret key"

app.config.from_object(__name__)
app.config.from_envvar('FLASKR_SETTINGS', silent=True)

mysql = MySQL()

# MySQL configurations
app.config['MYSQL_DATABASE_USER'] = 'root'
app.config['MYSQL_DATABASE_PASSWORD'] = '*******'       #your password here
app.config['MYSQL_DATABASE_DB'] = 'covidtest_fall2020'
app.config['MYSQL_DATABASE_HOST'] = 'localhost'
mysql.init_app(app)

conn = mysql.connect()
cursor = conn.cursor()
# ============================ Basic Setup ============================

# ============================ Basic Syntax for MySQL ============================
# execute query
# cursor.execute('select * from user where username = %s', (_username,))
# user = cursor.fetchall()
# call procedure 
# cursor.callproc('pool_metadata', (_i_pool_id))
# if len(data) is 0 then success
# data = cursor.fetchall()

#screen 0: home page
@app.route('/')
def index():
    
    """
    Home page:
        
    Users can either login or register
    """
    
    return render_template('index.html')

#screen 1: login
@app.route('/login', methods=['GET', 'POST'])
def login():
    
    """
    Login to home screen:
    
    All users are using the same login page.
    Different users may redirect to different home screen.
    """
    error = None
    if request.method == 'POST':
                
        _username = request.form['username']
        _password = request.form['password']
        
        cursor.execute('select * from user where username = %s', (_username,))
        user = cursor.fetchone()
        
        error = None
        
        if not user:
            error = 'Invalid username'    
        elif not user[1] == md5(_password.encode('utf-8')).hexdigest():
            error = 'Invalid password'
    
        if error is None:
        
            cursor.execute('select * from student where student_username = %s', (_username,))
            student = cursor.fetchone()
        
            cursor.execute('select * from employee where emp_username = %s', (_username,))
            emp = cursor.fetchone()
        
            cursor.execute('select * from administrator where admin_username = %s', (_username,))
            admin = cursor.fetchone()
        
            if student:
                session['user_id'] = student[0]
                return redirect(url_for('student_home'))
            
            elif emp:
            
                cursor.execute('select * from labtech where labtech_username = %s', (_username,))
                labtech = cursor.fetchone()
            
                cursor.execute('select * from sitetester where sitetester_username = %s', (_username,))
                sitetester = cursor.fetchone()

                if len(labtech) == 0 and len(sitetester) != 0:
                    session['user_id'] = labtech[0]
                    return redirect(url_for('labtech_home'))
                elif len(labtech) != 0 and len(sitetester) == 0:
                    session['user_id'] = sitetester[0]
                    return redirect(url_for('sitetester_home'))
                elif len(labtech) != 0 and len(sitetester) != 0:
                    session['user_id'] = labtech[0]
                    return redirect(url_for('labtech_sitetester_home'))
                else: 
                    error = 'Cannot find user'
            
            elif admin:
                session['user_id'] = admin[0]
                return redirect(url_for('admin_home'))
            
        flash(error)
        
    return render_template('login.html', error = error)

#screen 2: register
@app.route("/register", methods=("GET", "POST"))
def register():
    
    """
    Register a new user:
        
    Validates that the username is not already taken. 
    Hashes the password for security.
    """
    error = None
    if request.method == "POST":
        _username = request.form["username"]
        _password = request.form["password"]
        _cpassword = request.form['cpassword']
        _email = request.form['email']
        _fname = request.form['fname']
        _lname = request.form['lname']
        

        error = None

        if not _username:
            error = "Username is required."
        elif not _password:
            error = "Password is required."
        elif not _cpassword:
            error = "Confirm password is required."
        elif not _email:
            error = "Emaill address is required."
        elif not _fname:
            error = "First name is required."
        elif not _lname:
            error = "Last name is required."
        elif (_password != _cpassword):
            error = "Password does not matched."
        elif (len(_password) < 8):
            error = "Password must be at least 8 characters."
        elif not (re.match("\A(?P<name>[\w\-_]+)@(?P<domain>[\w\-_]+).(?P<toplevel>[\w]+)\Z", _email, re.IGNORECASE)):
            error = "Invalid email address."
        elif (len(_email) < 5):
            error = "Invalid email address."
        elif str(request.form.get('utypes')) == 'select1':
            error = 'Please select a user type'
        else:
            cursor.execute('select username from user where username = %s', (_username,))
            user = cursor.fetchone()
            if user is not None:
                error = "User {0} is already registered.".format(_username)
                    

        if error is None:
            # the name is available, store it in the database and go to
            # the login page
            _select_user = request.form.get('utypes')
            if str(_select_user) == 'Student' or str(_select_user) == 'Employee':
                cursor.execute(
                    "INSERT INTO user (username, user_password, email, fname, lname) VALUES (%s, %s, %s, %s, %s)",
                    (_username, _password, _email, _fname, _lname),
                )
                cursor.commit()
                if str(_select_user) == 'Student':
                    _select_house = str(request.form.get('htypes'))
                    _select_location = str(request.form.get('ltypes'))
                    cursor.execute(
                        "INSERT INTO student (student_username, housing_type, location) VALUES (%s, %s, %s)",
                        (_username, _select_house, _select_location),
                    )
                    cursor.commit()
                elif str(_select_user) == 'Employee':
                    _phone_num = request.form['phone']
                    cursor.execute(
                        "INSERT INTO employee (emp_username, phone_num) VALUES (%s, %s)",
                        (_username, _phone_num),
                    )
                    cursor.commit()
                    if request.form.get('site_tester'):
                        cursor.execute(
                            "INSERT INTO sitetester (sitetester_username) VALUES (%s)",
                            (_username),
                        )
                        cursor.commit()
                    if request.form.get('lab_tech'):
                        cursor.execute(
                            "INSERT INTO labtech (labtech_username) VALUES (%s)",
                            (_username),
                        )
                        cursor.commit()
                    if not request.form.get('site_tester') and not request.form.get('lab_tech'):
                        error = "You much select the checkbox."
                        return render_template("register.html", error = error)
                        
                else:
                    error = "You much select a user type."
                    return render_template("register.html", error = error)
            return redirect(url_for("login"))

    return render_template("register.html", error = error)

if __name__ == '__main__':
	app.run(debug=True)