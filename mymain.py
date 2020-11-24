#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Nov 21 16:02:18 2020

@author: dengqingyuan
"""

# include main_part1.py
import re
import time
import pymysql
from hashlib import md5
from datetime import datetime

from flask import Flask, request, session, url_for, redirect, \
	 render_template, abort, g, flash, _app_ctx_stack,get_flashed_messages
from flaskext.mysql import MySQL
from werkzeug.security import generate_password_hash, check_password_hash
import itertools
import random

# ============================ Basic Setup ============================

app = Flask(__name__)
app.secret_key = "secret key"

app.config.from_object(__name__)
app.config.from_envvar('FLASKR_SETTINGS', silent=True)

mysql = MySQL()

# MySQL configurations
app.config['MYSQL_DATABASE_USER'] = 'root'
app.config['MYSQL_DATABASE_PASSWORD'] = '19970611Dqy'       #your password here
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

@app.route('/logout')
def logout():
	session.pop('user_id', None)
	return redirect(url_for('index'))

@app.route('/back_home')
def back_home():
    # user_judge()
    username = session['user_id']
    _is_student, _ = is_student(username)
    _is_admin, _ = is_admin(username)
    _is_labtech, _ = is_labtech(username)
    _is_tester, _ = is_tester(username)
    
    if _is_student:
        return redirect(url_for('student_home'))
    elif _is_admin:
        return redirect(url_for('admin_home'))
    elif _is_labtech and not _is_tester:
        return redirect(url_for('labtech_home'))
    elif not _is_labtech and _is_tester:
        return redirect(url_for('sitetester_home'))
    elif _is_labtech and _is_tester:
        return redirect(url_for('labtech_sitetester_home'))
    else:
        error = 'Invalid User, please login'
        return render_template('login.html', error = error)

def user_judge():
	if not session['user_id']:
		error = 'Invalid User, please login'
		return render_template('login.html', error = error)
    
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
        
        cursor.execute('select * from user where username = %s', (_username))
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

                if labtech and not sitetester:
                    session['user_id'] = labtech[0]
                    return redirect(url_for('labtech_home'))
                elif not labtech and sitetester:
                    session['user_id'] = sitetester[0]
                    return redirect(url_for('sitetester_home'))
                elif labtech and sitetester:
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
        if _instr == 'View My Results':
            return redirect(url_for("student_view_test_results"))
        elif _instr == 'View Aggregate Results':
            return redirect(url_for("aggregrate_test_results"))
        elif  _instr == 'Sign Up for a Test':
            return redirect(url_for("signup_for_a_test"))
        elif  _instr == 'View Daily Results':
            return redirect(url_for("daily"))
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
    if request.method == 'POST':
        if 'Process Pool' == request.form["submit_button"]:
            return redirect(url_for("login"))
        
        elif 'View My Processed Tests' == request.form["submit_button"]:
            return redirect(url_for("lab_tech_tests_processed"))
        
        elif 'Create Pool' == request.form["submit_button"]:
            return redirect(url_for("login"))
        
        elif 'View Aggregate Results' == request.form["submit_button"]:
            return redirect(url_for("aggregrate_test_results"))
        elif 'View Pools' == request.form["submit_button"]:
            return redirect(url_for("view_pools"))
        
        elif 'View Daily Results' == request.form["submit_button"]:
            return redirect(url_for("daily"))
        else:
            error = "Invalid selection"
            return render_template("labtech_home.html", error = error)
    else:
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
    else:
        error = "Invalid selection"
        return render_template("admin_home.html", error = error)

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
    
def get_testing_site():
    """
    This function returns a list of testing site, 
    i.e. 'Bobby Dodd Stadium'
    """
    cursor.execute('select distinct site_name from site')
    site_name = cursor.fetchall()
    return list(itertools.chain(*site_name))

def check_none(judge):
    if judge=="":
        return None
    else:
        return judge
# Have change student_home
# screen 4: connect to screen 3: student home
@app.route("/student_home/student_view_test_results", methods=("GET", "POST"))
def student_view_test_results():
    
    _username=session['user_id']
    
    if request.method == "POST":
        _instr = request.form['submit_button']
        
        if _instr == 'Back(Home)':
            return redirect(url_for("student_home"))
        
        elif _instr == "Filter":
            _test_status = request.form.get("_test_status")
            _start_date = request.form["_start_date"]
            _end_date = request.form["_end_date"]
            
            _test_status=check_none(_test_status)
            _start_date=check_none(_start_date)
            _end_date=check_none(_end_date)
            flag=1
        
        elif  _instr == "Reset":
            _test_status,_start_date,_end_date,flag=None,None,None,0 
        
    elif request.method == "GET":
        _test_status,_start_date,_end_date,flag=None,None,None,0
        
    cursor.callproc('student_view_results',(_username, _test_status,_start_date,_end_date,))
    cursor.execute("select * from student_view_results_result;")
    data=cursor.fetchall()
    return render_template("student_view_test_results.html", data=data,flag=flag)       



# screen 5: connect to screen 4
@app.route("/student_home/student_view_test_results/explore_test_result/<id>", methods=("GET", "POST"))
def explore_test_result(id):
    if request.method == "POST":
        _instr = request.form['submit_button']
        if _instr == 'Back(Home)':
            return redirect(url_for("student_view_test_results"))

    elif request.method == "GET":
        _test_id=id
        cursor.callproc('explore_results',(_test_id,))
        cursor.execute("select * from explore_results_result;")
        data=cursor.fetchall()
        return render_template("explore_test_result.html",data=data)


# screen 6 :connect to screen 3 student home
# need to add def get_testing_site()
@app.route("/student_home/aggregrate_test_results", methods=("GET", "POST"))
def aggregrate_test_results():
    site=get_testing_site()
    housing=get_housing()
    location=get_location()
    
    if request.method == "POST":
        _instr = request.form['submit_button']
        
        if _instr == 'Back(Home)':
            return redirect(url_for("back_home"))
        
        if _instr == "Filter":
            _location=request.form.get("_location")
            _housing=request.form.get("_housing")
            _testing_site=request.form.get("_testing_site")
            _start_date = request.form["_start_date"]
            _end_date = request.form["_end_date"]
            
            _location=check_none(_location)
            _housing=check_none(_housing)
            _testing_site=check_none(_testing_site)
            _start_date=check_none(_start_date)
            _end_date=check_none(_end_date)
            flag=1

        elif  _instr == "Reset":
            _location,_housing,_testing_site,_start_date,_end_date,flag=None,None,None,None,None,0
        
    elif request.method == "GET":
        _location,_housing,_testing_site,_start_date,_end_date,flag=None,None,None,None,None,0
    
    cursor.callproc('aggregate_results',(_location,_housing,_testing_site,_start_date,_end_date))
    cursor.execute("select * from aggregate_results_result;")
    data=cursor.fetchall()
    total=0
    for row in data:
        total+=row[1]
    return render_template("aggregrate_test_results.html",
                           data=data,
                           total=total,
                           site=site,
                           location=location,
                           housing=housing,
                           flag=flag)

# screen 7: connect to screen 3: student home
@app.route("/student_home/signup_for_a_test", methods=("GET", "POST"))
def signup_for_a_test():
    error=None
    site=get_testing_site()
    _username=session['user_id']
    if request.method == "POST":
        _instr = request.form['submit_button']
        
        if _instr == 'Back(Home)':
            return redirect(url_for("back_home"))
        
        if _instr == "Filter":
            _testing_site=request.form.get("_testing_site")
            _start_date = request.form["_start_date"]
            _end_date = request.form["_end_date"]
            _start_time = request.form["_start_time"]
            _end_time = request.form["_end_time"]            

            _testing_site=check_none(_testing_site)
            _start_date=check_none(_start_date)
            _end_date=check_none(_end_date)
            _start_time=check_none(_start_time)
            _end_time=check_none(_end_time)            
            flag=1

        elif  _instr == "Reset":
            _testing_site,_start_date,_end_date,_start_time,_end_time,flag=None,None,None,None,None,0
        
        elif _instr == "Sign up":
            _testing_site,_start_date,_end_date,_start_time,_end_time,flag=None,None,None,None,None,0
            if request.form.get("clickIn") is not None:
                sql="select count(*) from test;"
                cursor.execute(sql)
                count_test=cursor.fetchone()
                row=request.form["clickIn"]
                row=row.split(',')
                _appt_date=str(row[0])
                _appt_time=str(row[1])
                _site_name=str(row[3])
                _test_id=str(100060+int(random.uniform(1,1000)))
                print(" _site_name:",_site_name,'  _appt_date:', _appt_date,' _appt_time:',_appt_time,' _test_id',_test_id)
                cursor.callproc('test_sign_up',(_username,_site_name,_appt_date,_appt_time,_test_id,))
                #cursor.callproc('test_sign_up',('mgeller3','Bobby Dodd Stadium','2020-09-16', '12:00:00','100061',))
                #cursor.callproc('mgeller3', 'Bobby Dodd Stadium', '2020-10-01', '11:00:00',))
                conn.commit()
                cursor.execute(sql)
                count_test_update=cursor.fetchone()
                if count_test_update[0]>count_test[0]:
                    error='Successfully create an appointment!'+'  Test ID:'+_test_id+'  Date:'+_appt_date+'  Time:'+_appt_time+'  Site:'+_site_name
                else:
                    error="You already have one upcoming appointment!"
            else:
                error="Please choose one bullect point to sign up for an appointment!"
        
    elif request.method == "GET":
        _testing_site,_start_date,_end_date,_start_time,_end_time,flag=None,None,None,None,None,0
    
    flash(error)
    cursor.callproc('test_sign_up_filter',(_username,_testing_site,_start_date,_end_date,_start_time,_end_time))
    cursor.execute("select * from test_sign_up_filter_result;")
    data=cursor.fetchall()
    return render_template('signup_for_a_test.html',data=data,site=site,error=error)


# screen 8: connect to screen 3: labtech home
@app.route("/labtech_home/lab_tech_tests_processed", methods=("GET", "POST"))
def lab_tech_tests_processed():
    _lab_tech_username=session['user_id']
    
    if request.method == "POST":
        _instr = request.form['submit_button']
        
        if _instr == 'Back(Home)':
            return redirect(url_for("labtech_home"))
        
        elif _instr == "Filter":
            _test_status = request.form.get("_test_status")
            _start_date = request.form["_start_date"]
            _end_date = request.form["_end_date"]
            
            _test_status=check_none(_test_status)
            _start_date=check_none(_start_date)
            _end_date=check_none(_end_date)
            flag=1
        
        elif  _instr == "Reset":
            _test_status,_start_date,_end_date,flag=None,None,None,0 
        
    elif request.method == "GET":
        _test_status,_start_date,_end_date,flag=None,None,None,0
        
    cursor.callproc('tests_processed',(_start_date,_end_date,_test_status,_lab_tech_username,))
    cursor.execute("select * from tests_processed_result;")
    data=cursor.fetchall()     
    return render_template('lab_tech_tests_processed.html', data=data,flag=flag)

# screen 9: connect to screen 3: 
@app.route("/view_pools", methods=("GET", "POST"))
def view_pools():
    """
    view_pools
    """
    error = None
    rows = (())
    l = range(len(rows))
    rows_dict = {"pool_id": [row[0] for row in rows],
                 "test_id": [row[1] for row in rows],
                 "date_processed": [row[2] for row in rows],
                 "processed_by": [row[3] for row in rows],
                 "pool_status": [row[4] for row in rows]
                 }
    data = rows_dict
    flash(error)

    #data = json.dumps(rows_dict)
    if request.method == 'POST':

        if str(request.form['begin_process_date'] == ''):
            _begin_process_date = None
        else:
            _begin_process_date = request.form['begin_process_date']

        if str(request.form['end_process_date'] == ''):
            _end_process_date = None
        else:
            _end_process_date = request.form['end_process_date']

        if str(request.form.get('utypes')) == 'ALL':
            _pool_status = None
        elif str(request.form.get('utypes')) == 'Positive':
            _pool_status = 'positive'
        else:
            _pool_status = 'negative'

        if str(request.form['processed_by']) == '':
            _processed_by = None
        else:
            _processed_by = request.form['processed_by']

        cursor.callproc('view_pools', (_begin_process_date, _end_process_date, _pool_status, _processed_by,))
        conn.commit()
        cursor.execute('select * from view_pools_result; ')
        rows = cursor.fetchall()

        error = None
        rows_dict = {"pool_id": [row[0] for row in rows],
                     "test_id": [row[1] for row in rows],
                     "date_processed": [row[2] for row in rows],
                     "processed_by": [row[3] for row in rows],
                     "pool_status": [row[4] for row in rows]
                    }
        l = range(len(rows))
        data = rows_dict
        #data = json.dumps(rows_dict,indent=4, sort_keys=True, default=str)
        flash(error)
        return render_template('view_pools.html',error=error,data = data,l = l)
    else:
        return render_template('view_pools.html',error=error,data = data,l = l)
    

    
if __name__ == '__main__':
	app.run(debug=True)