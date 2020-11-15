#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Nov 15 13:30:54 2020

@author: Sharonvy
"""

# -*- coding: utf-8 -*-
import time
from sqlite3 import dbapi2 as sqlite3
from hashlib import md5
from datetime import datetime
from flask import Flask, request, session, url_for, redirect, \
	 render_template, abort, g, flash, _app_ctx_stack
from werkzeug.security import check_password_hash, generate_password_hash
import time

#CONFIGURATION
DATABASE = 'book.db'
DEBUG = True
SECRET_KEY = 'development key'
MANAGER_NAME = 'admin'
MANAGER_PWD = '123456'

app = Flask(__name__)

app.config.from_object(__name__)
app.config.from_envvar('FLASKR_SETTINGS', silent=True)

def get_db():
	top = _app_ctx_stack.top
	if not hasattr(top, 'sqlite_db'):
		top.sqlite_db = sqlite3.connect(app.config['DATABASE'])
		top.sqlite_db.row_factory = sqlite3.Row
	return top.sqlite_db

@app.teardown_appcontext
def close_database(exception):
	top = _app_ctx_stack.top
	if hasattr(top, 'sqlite_db'):
		top.sqlite_db.close()

def init_db():
	with app.app_context():
		db = get_db()
		with app.open_resource('book.sql', mode='r') as f:
			db.cursor().executescript(f.read())
		db.commit()

def query_db(query, args=(), one=False):
	cur = get_db().execute(query, args)
	rv = cur.fetchall()
	return (rv[0] if rv else None) if one else rv


def get_user_id(username):
	rv = query_db('select user_id from users where user_name = ?',
				  [username], one=True)
	return rv[0] if rv else None

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
        user = query_db('''select * from users where username = ?''',
				[request.form['username']], one=True)
        if not user:
            error = 'Invalid username'    
        elif not check_password_hash(user['user_password'], request.form['password']):
            error = 'Invalid password'
    
    if error is None:
        session['user_id'] = user['username']
        
        student = query_db('''select * from student where student_username = ?''',
				[request.form['username']], one=True)
        employee = query_db('''select * from employee where emp_username = ?''',
				[request.form['username']], one=True)
        admin = query_db('''select * from administrator where admin_username = ?''',
				[request.form['username']], one=True)
        
        if student:
            return redirect(url_for('student_home'))
        elif employee:
            labtech = query_db('''select * from labtech where labtech_username = ?''',
				[request.form['username']], one=True)
            sitetester = query_db('''select * from sitetester where sitetester_username = ?''',
				[request.form['username']], one=True)
            if labtech is not None and sitetester is None:
                return redirect(url_for('labtech_home'))
            elif labtech is None and sitetester is not None:
                return redirect(url_for('sitetester_home'))
            else:
                return redirect(url_for('labtech_sitetester_home'))
        elif admin:
            return redirect(url_for('admin_home'))
    return render_template('login.html', error = error)


#screen 2: register
@app.route("/register", methods=("GET", "POST"))
def register():
    
    """
    Register a new user:
        
    Validates that the username is not already taken. 
    Hashes the password for security.
    """
    
    if request.method == "POST":
        username = request.form["username"]
        password = request.form["password"]
        db = get_db()
        error = None

        if not username:
            error = "Username is required."
        elif not password:
            error = "Password is required."
        elif (
            db.execute("SELECT id FROM user WHERE username = ?", (username,)).fetchone()
            is not None
        ):
            error = "User {0} is already registered.".format(username)

        if error is None:
            # the name is available, store it in the database and go to
            # the login page
            db.execute(
                "INSERT INTO user (username, password) VALUES (?, ?)",
                (username, generate_password_hash(password)),
            )
            db.commit()
            return redirect(url_for("auth.login"))

        flash(error)

    return render_template("auth/register.html")