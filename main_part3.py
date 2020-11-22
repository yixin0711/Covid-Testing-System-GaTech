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

import itertools

# ============================ Basic Setup ============================

app = Flask(__name__)
app.secret_key = "secret key"

app.config.from_object(__name__)
app.config.from_envvar('FLASKR_SETTINGS', silent=True)

mysql = MySQL()

# MySQL configurations
app.config['MYSQL_DATABASE_USER'] = 'root'
app.config['MYSQL_DATABASE_PASSWORD'] = '680212ok'       #your password here
app.config['MYSQL_DATABASE_DB'] = 'covidtest_fall2020'
app.config['MYSQL_DATABASE_HOST'] = 'localhost'

mysql.init_app(app)
conn = mysql.connect()
cursor = conn.cursor()

# ============================ Basic Syntax for MySQL ============================
# execute query
# cursor.execute('select * from user where username = %s', (_username,))
# user = cursor.fetchall()/fetchone()

# call procedure 
# cursor.callproc('pool_metadata', (_i_pool_id))
# insert procedure
# conn.commit()
# if len(data) is 0 then success
# data = cursor.fetchall()

# ============================ Helper functions ================

def get_tester():
    """
    This function returns a list of testers's First name and Last name, 
    i.e. 'John Smith'
    """
    cursor.execute('select concat(fname, " ",lname) as name from user where username in (select * from sitetester)')
    tester = cursor.fetchall()
    return list(itertools.chain(*tester))

def get_housing():
    """
    This function returns a list of housing types, 
    i.e. 'Off-campus Apartment'
    """
    cursor.execute('select distinct housing_type from student')
    types = cursor.fetchall()
    return list(itertools.chain(*types))

def get_location():
    """
    This function returns a list of location, 
    i.e. 'West'
    """
    cursor.execute('select distinct location from student')
    location = cursor.fetchall()
    return list(itertools.chain(*location))

def get_states():
    """
    This function returns a list of US States, 
    i.e. 'West'
    """
    states = ["AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DC", "DE", "FL", "GA", 
          "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", 
          "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", 
          "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC", 
          "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY"]
    return states

def is_student(username):
    """
    This function check if a user name is a student or not
    Return: 
        Bool (result)
    """
    
    result = False
    cursor.execute('select * from student where student_username = %s', (username,))
    student = cursor.fetchone()
    if student:
        result = True
    return result, student

def is_admin(username):
    """
    This function check if a user name is an administrator or not
    Return: 
        Bool (result)
    """
    
    result = False
    cursor.execute('select * from administrator where admin_username = %s', (username,))
    admin = cursor.fetchone()
    if admin:
        result = True
    return result, admin

def is_labtech(username):
    """
    This function check if a user name is a lab technician or not
    Return: 
        Bool (result)
    """
    
    result = False
    cursor.execute('select * from labtech where labtech_username = %s', (username,))
    labtech = cursor.fetchone()
    if labtech:
        result = True
    return result, labtech

def is_tester(username):
    """
    This function check if a user name is a tester or not
    Return: 
        Bool (result)
    """
    
    result = False
    cursor.execute('select * from sitetester where sitetester_username = %s', (username,))
    tester = cursor.fetchone()
    if tester:
        result = True
    return result, tester

def is_employee(username):
    """
    This function check if a user name is a employee or not
    Return: 
        Bool (result)
    """
    
    result = False
    cursor.execute('select * from employee where emp_username = %s', (username,))
    emp = cursor.fetchone()
    if emp:
        result = True
    return result, emp

def is_user(username):
    """
    This function check if a user name is a user or not
    Return: 
        Bool (result)
    """
    result = False
    cursor.execute('select * from user where username = %s', (username))
    user = cursor.fetchone()
    if user:
        result = True
    return result, user

# 添加简单的安全性检查
def user_judge():
	if not session['user_id']:
		error = 'Invalid User, please login'
		return render_template('login.html', error = error)
    
@app.before_request
def before_request():
	g.user = None
	if 'user_id' in session:
		g.user = session['user_id']

# ========================= Functional Screens =========================
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
        
        user_bool, user = is_user(_username)
        
        error = None
        
        if not user:
            error = 'Invalid username'    
        elif not user[1] == md5(_password.encode('utf-8')).hexdigest():
            error = 'Invalid password'
    
        if error is None:
        
            student_bool, student = is_student(_username)
            admin_bool, admin = is_admin(_username)
            emp_bool, emp = is_employee(_username)
            
            if student_bool:
                session['user_id'] = student[0]
                return redirect(url_for('student_home'))
            
            elif emp_bool:
                labtech_bool, labtech = is_labtech(_username)
                tester_bool, tester = is_tester(_username)

                if labtech_bool and not tester_bool:
                    session['user_id'] = labtech[0]
                    return redirect(url_for('labtech_home'))
                elif not labtech_bool and tester_bool:
                    session['user_id'] = tester[0]
                    return redirect(url_for('sitetester_home'))
                elif labtech_bool and tester_bool:
                    session['user_id'] = labtech[0]
                    return redirect(url_for('labtech_sitetester_home'))
                else: 
                    error = 'Cannot find user'
            
            elif admin_bool:
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

            if str(_select_user) == 'Student':
                _select_house = str(request.form.get('htypes'))
                _select_location = str(request.form.get('ltypes'))
                
                try:
                    cursor.callproc('register_student', (_username, _email, _fname, _lname, _select_location, _select_house, _password,))
                    conn.commit()

                except Exception as e:
                    error = str(e)
                    return render_template("register.html", error = error)
                
            elif str(_select_user) == 'Employee':
                _phone_num = str(request.form['phone'])                  
                is_site_tester = bool(request.form.get('site_tester'))
                is_lab_tech = bool(request.form.get('lab_tech'))
                    
                if not is_site_tester and not is_lab_tech:
                    error = "You much select the checkbox."
                    return render_template("register.html", error = error)
                
                try:
                    cursor.callproc('register_employee', (_username, _email, _fname, _lname, _phone_num, is_site_tester, is_lab_tech, _password,))
                    conn.commit()

                except Exception as e:
                    error = str(e)
                    return render_template("register.html", error = error)
                
            else:
                error = "You much select a user type."
                return render_template("register.html", error = error)
            return redirect(url_for("login"))

    return render_template("register.html", error = error)


@app.route('/logout')
def logout():
	session.pop('user_id', None)
	return redirect(url_for('index'))

# 添加简单的安全性检查
def user_judge():
	if not session['user_id']:
		error = 'Invalid User, please login'
		return render_template('login.html', error = error)

#screen 3: home screens
@app.route("/student_home", methods=("GET", "POST"))
def student_home():
    """
    Home screen for student:
        A student can:
            a. View all their test results
            b. Get tested/sign up for a timeslot
            c. View aggregate test results
            d. View daily test results
        
    """
    error = None
    if request.method == 'POST':
        _instr = request.form['submit_button']
        
        if _instr == 'view_my':
            id = session['user_id']
            return redirect(url_for("view", id = id))
        elif _instr == 'sign_up':
            return redirect(url_for("login"))
        elif  _instr == 'view_daily':
            return redirect(url_for("login"))
        elif  _instr == 'view_agg':
            return redirect(url_for("login"))
        else:
            error = "Invalid selection"
            return render_template("student_home.html", error = error)
    else:
        return render_template("student_home.html", error = error)

@app.route("/labtech_home", methods=("GET", "POST"))
def labtech_home():
    """
    Home screen for lab technician:
        A Lab Technician can:
            a. Process a pool
            b. Create a pool
            c. View all pools
            d. View tests I have processed
            e. View aggregate test results
            f. View daily test results
    """
    error = None
    if 'view_my' in request.form:
        return redirect(url_for("login"))
    elif 'view_pools' in request.form:
        return redirect(url_for("login"))
    elif 'view_daily' in request.form:
        return redirect(url_for("login"))
    elif 'view_agg' in request.form:
        return redirect(url_for("login"))
    elif 'process_pool' in request.form:
        return redirect(url_for("login"))
    elif 'create_pool' in request.form:
        return redirect(url_for("login"))
    else:
        error = "Invalid selection"
        return render_template("labtech_home.html", error = error)

@app.route("/sitetester_home", methods=("GET", "POST"))
def sitetester_home():
    """
    Home screen for Tester:
        A Tester can:
            a. Change their testing site
            b. View apspointments for the site they work at
            c. Create an appointment for their testing site
            d. View aggregate test results
            e. View daily test results
    """
    error = None
    if 'change_site' in request.form:
        return redirect(url_for("login"))
    elif 'view_appt' in request.form:
        return redirect(url_for("login"))
    elif 'view_daily' in request.form:
        return redirect(url_for("login"))
    elif 'view_agg' in request.form:
        return redirect(url_for("login"))
    elif 'create_appt' in request.form:
        return redirect(url_for("login"))
    else:
        error = "Invalid selection"
        return render_template("sitetester_home.html", error = error)

@app.route("/labtech_sitetester_home", methods=("GET", "POST"))
def labtech_sitetester_home():
    """
    Home screen for Lab Technician / Site Tester:
        A Lab Tech/Tester can:
            Do any functionality associated with a Lab Technician or a Tester
    """
    error = None
    if 'change_site' in request.form:
        return redirect(url_for("login"))
    elif 'view_appt' in request.form:
        return redirect(url_for("login"))
    elif 'view_daily' in request.form:
        return redirect(url_for("login"))
    elif 'view_agg' in request.form:
        return redirect(url_for("login"))
    elif 'create_appt' in request.form:
        return redirect(url_for("login"))
    else:
        error = "Invalid selection"
        return render_template("labtech_sitetester_home.html", error = error)
    
@app.route("/admin_home", methods=("GET", "POST"))
def admin_home():
    """
    Home screen for Admin:
        Admin can:
        a. Create available timeslots
        b. View all appointments created so far
        c. Reassign testers to a testing site
        d. Create a new testing site
        e. View aggregate test results
        f. View daily test results
    """
    error = None
    if 'change_site' in request.form:
        return redirect(url_for("login"))
    elif 'view_appt' in request.form:
        return redirect(url_for("login"))
    elif 'view_daily' in request.form:
        return redirect(url_for("login"))
    elif 'view_agg' in request.form:
        return redirect(url_for("login"))
    elif 'create_appt' in request.form:
        return redirect(url_for("login"))
    elif 'create_site' in request.form:
        return redirect(url_for("admin_create_site"))
    else:
        error = "Invalid selection"
        return render_template("admin_home.html", error = error)

#screen 15
@app.route("/admin/createsite", methods=("GET", "POST"))
def admin_createsite():
    """
    This screen is for an Admin to create a testing sites.
    """
    error = None
    testers = get_tester()
    states = get_states()
    locations = get_location()
    
    _is_admin, _ = is_admin(session['user_id'])
    if not _is_admin:
        error = 'You do not have access to this page.'
        return render_template('login.html', error = error)
    
    if request.method == "POST":
        _site_name = request.form["name"]
        _street = request.form["street"]
        _city = request.form['city']
        _state = request.form.get('state')
        _zip = request.form['zip']
        _location = request.form.get('location')
        _tester = request.form.get('tester')
        
        if not _site_name or not _street or not _city or not _zip:
            error = "All field are required."
        elif _state == 'select1':
            error = "State is required."
        elif _location == '--select--':
            error = "Location is required."
        elif _tester == '--select--':
            error = "A site cannot be created without at least one tester."
        
        names = _tester.split()
        cursor.execute('select username from user where fname = %s and lname = %s', (names[0], names[1],))
        _username = cursor.fetchone()[0]
        if not _username:
            error = "Site Tester does not exist."
    
    if error is None:
        try:
            cursor.callproc('create_testing_site', 
                            (_site_name, 
                             _street, 
                             _city,
		                     _state, 
	    	                 _zip, 
		                     _location, 
		                     _username,))
            conn.commit()
            return redirect(url_for('admin_createsite'))
        
        except Exception as e:
            error = str(e)
    
    return render_template("admin_createsite.html", error = error, 
                           tester_list = testers, 
                           state_list = states,
                           location_list = locations)

#screen 16 (和screen 9连接)
@app.route("/labtech/viewpool/<id>", methods=("GET", "POST"))
def labtech_viewpool(id):
    """
    This screen allows the user to look into an already processed pool.
    """
    _is_labtech, _ = is_labtech(session['user_id'])
    if not _is_labtech:
        error = 'You do not have access to this page.'
        return render_template('login.html', error = error)
        
    if request.method == 'POST':
        _pool_id = id
        cursor.callproc('pool_metadata', (_pool_id,))
        cursor.execute('select * from pool_metadata_result')
        pool_data = cursor.fetchall()

        cursor.callproc('tests_in_pool', (_pool_id,))
        cursor.execute('select * from tests_in_pool_result')
        tests_data = cursor.fetchall()
        return redirect(url_for('latech_viewpool', id = id))
    return render_template("login.html", pool = pool_data, tests = tests_data)


#screen 18
@app.route("/daily", methods=("GET", "POST"))
def daily():
    """
    This screen shows testing statistics grouped by processing date
    """
    user_judge()
    cursor.callproc('daily_results')
    cursor.execute('select * from daily_results_result')
    daily_data = cursor.fetchall()
    return render_template("daily.html", results = daily_data)


if __name__ == '__main__':
	app.run(debug=True)
    
    