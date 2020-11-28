#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Nov 24 14:20:14 2020
@author: dengqingyuan
"""

# !/usr/bin/env python3
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
import random

# ============================ Basic Setup ============================

app = Flask(__name__)
app.secret_key = "secret key"

app.config.from_object(__name__)
app.config.from_envvar('FLASKR_SETTINGS', silent=True)

mysql = MySQL()

# MySQL configurations
app.config['MYSQL_DATABASE_USER'] = 'root'
app.config['MYSQL_DATABASE_PASSWORD'] = '680212ok'  # your password here
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
    i.e. 'GA'
    """
    states = ["AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DC", "DE", "FL", "GA",
              "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD",
              "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ",
              "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC",
              "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY"]
    return states


def get_testing_site():
    """
    This function returns a list of testing site,
    i.e. 'Bobby Dodd Stadium'
    """
    cursor.execute('select distinct site_name from site')
    site_name = cursor.fetchall()
    return list(itertools.chain(*site_name))


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
        return render_template('login.html', error=error)


@app.before_request
def before_request():
    g.user = None
    if 'user_id' in session:
        g.user = session['user_id']


def check_none(judge):
    if judge == "":
        return None
    else:
        return judge


# ========================= Functional Screens =========================
# screen 0: home page

@app.route('/')
def index():
    """
    Home page:

    Users can either login or register
    """

    return render_template('index.html')


# screen 1: login
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

    return render_template('login.html', error=error)


# screen 2: register
@app.route("/register", methods=("GET", "POST"))
def register():
    """
    Register a new user:

    Validates that the username is not already taken.
    Hashes the password for security.
    """
    error = None
    housing_list = get_housing()
    location_list = get_location()

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
                    cursor.callproc('register_student',
                                    (_username, _email, _fname, _lname, _select_location, _select_house, _password,))
                    conn.commit()

                except Exception as e:
                    error = str(e)
                    return render_template("register.html", error=error)

            elif str(_select_user) == 'Employee':
                _phone_num = str(request.form['phone'])
                is_site_tester = bool(request.form.get('site_tester'))
                is_lab_tech = bool(request.form.get('lab_tech'))

                if not is_site_tester and not is_lab_tech:
                    error = "You much select the checkbox."
                    return render_template("register.html", error=error)

                try:
                    cursor.callproc('register_employee', (
                    _username, _email, _fname, _lname, _phone_num, is_lab_tech, is_site_tester, _password,))
                    conn.commit()

                except Exception as e:
                    error = str(e)
                    return render_template("register.html", error=error, housing = housing_list, location = location_list)

            else:
                error = "You much select a user type."
                return render_template("register.html", error=error, housing = housing_list, location = location_list)
            return redirect(url_for("login"))

    return render_template("register.html", error=error, housing = housing_list, location = location_list)


@app.route('/logout')
def logout():
    session.pop('user_id', None)
    return redirect(url_for('index'))


@app.route('/back_home')
def back_home():
    user_judge()
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
        return render_template('login.html', error=error)


# screen 3: home screen
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
    
    username = session['user_id']
    _is_student, _ = is_student(username)
    if not _is_student:
        error = 'You do not have access to this page.'
        return render_template('login.html', error=error)
        
    if request.method == 'POST':
        _instr = request.form['submit_button']
        if _instr == 'View My Results':
            return redirect(url_for("student_view_test_results"))
        elif _instr == 'View Aggregate Results':
            return redirect(url_for("aggregrate_test_results"))
        elif _instr == 'Sign Up for a Test':
            return redirect(url_for("signup_for_a_test"))
        elif _instr == 'View Daily Results':
            return redirect(url_for("daily"))
        else:
            error = "Invalid selection"
            return render_template("student_home.html", error=error)
    else:
        return render_template("student_home.html", error=error)


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
    
    username = session['user_id']
    _is_labtech, _ = is_labtech(username)
    if not _is_labtech:
        error = 'You do not have access to this page.'
        return render_template('login.html', error=error)
    
    if request.method == 'POST':
        if 'Process Pool' == request.form["submit_button"]:
            return redirect(url_for("view_process_pools"))

        elif 'View My Processed Tests' == request.form["submit_button"]:
            return redirect(url_for("lab_tech_tests_processed"))

        elif 'Create Pool' == request.form["submit_button"]:
            return redirect(url_for("create_pool"))

        elif 'View Aggregate Results' == request.form["submit_button"]:
            return redirect(url_for("aggregrate_test_results"))

        elif 'View Pools' == request.form["submit_button"]:
            return redirect(url_for("view_pools"))

        elif 'View Daily Results' == request.form["submit_button"]:
            return redirect(url_for("daily"))
        else:
            error = "Invalid selection"
            return render_template("labtech_home.html", error=error)
    else:
        return render_template("labtech_home.html", error=error)


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
    
    username = session['user_id']
    _is_tester, _ = is_tester(username)
    if not _is_tester:
        error = 'You do not have access to this page.'
        return render_template('login.html', error=error)
    
    if request.method == 'POST':
        _instr = request.form['submit_button']
        if _instr == 'Aggregate':
            return redirect(url_for("aggregrate_test_results"))
        elif _instr == 'Daily':
            return redirect(url_for("daily"))
        elif _instr == 'Change Sites':
            return redirect(url_for("tester_changesite", id = username))
        elif _instr == 'View Appointments':
            return redirect(url_for("view_appointments"))
        elif _instr == 'Create Appointment':
            return redirect(url_for('create_appointment'))
        else:
            error = "Invalid selection"
            return render_template("sitetester_home.html", error=error)
    else:
        return render_template("sitetester_home.html", error=error)


@app.route("/labtech_sitetester_home", methods=("GET", "POST"))
def labtech_sitetester_home():
    """
    Home screen for Lab Technician / Site Tester:
        A Lab Tech/Tester can:
            Do any functionality associated with a Lab Technician or a Tester
    """
    error = None
    
    username = session['user_id']
    _is_tester, _ = is_tester(username)
    _is_labtech, _ = is_labtech(username)
    if not _is_tester and not _is_labtech:
        error = 'You do not have access to this page.'
        return render_template('login.html', error=error)
    
    if request.method == 'POST':
        _instr = request.form['submit_button']
        if _instr == 'View My Processed Tests':
            return redirect(url_for("lab_tech_tests_processed"))
        elif _instr == 'Aggregate':
            return redirect(url_for("aggregrate_test_results"))
        elif _instr == 'Process Pool':
            return redirect(url_for("labtech_processpool", id = username))
        elif _instr == 'Daily':
            return redirect(url_for("daily"))
        elif _instr == 'Create Pool':
            return redirect(url_for("create_pool"))
        elif _instr == 'View Pools':
            return redirect(url_for("view_pools"))
        elif _instr == 'Change Sites':
            return redirect(url_for("tester_changesite", id =username))
        elif _instr == 'View Appointments':
            return redirect(url_for("view_appointments"))
        elif _instr == 'Create Appointment':
            return redirect(url_for('create_appointment'))
        else:
            error = "Invalid selection"
            return render_template("labtech_sitetester_home.html", error=error)
    else:
        return render_template("labtech_sitetester_home.html", error=error)


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
    
    username = session['user_id']
    _is_admin, _ = is_admin(username)
    if not _is_admin:
        error = 'You do not have access to this page.'
        return render_template('login.html', error=error)
    
    
    if request.method == 'POST':
        _instr = request.form['submit_button']
        if _instr == 'Reassign Testers':
            return redirect(url_for("admin_reassign"))
        elif _instr == 'Create Testing Site':
            return redirect(url_for("admin_createsite"))
        elif _instr == 'Create Appointment':
            return redirect(url_for("create_appointment"))
        elif _instr == 'View Appointments':
            return redirect(url_for("view_appointments"))
        elif _instr == 'Aggregate':
            return redirect(url_for("aggregrate_test_results"))
        elif _instr == 'Daily':
            return redirect(url_for("daily"))
        else:
            error = "Invalid selection"
            return render_template("admin_home.html", error=error)
    else:
        return render_template("admin_home.html", error=error)


# Have change student_home
# screen 4: connect to screen 3: student home
@app.route("/student_home/student_view_test_results", methods=("GET", "POST"))
def student_view_test_results():
    e=0
    _username = session['user_id']
    _is_student, _ = is_student(_username)
    if not _is_student:
        error = 'You do not have access to this page.'
        return render_template('login.html', error=error)

    if request.method == "POST":
        _instr = request.form['submit_button']

        if _instr == 'Back(Home)':
            return redirect(url_for("student_home"))

        elif _instr == "Filter":
            _test_status = request.form.get("_test_status")
            _start_date = request.form["_start_date"]
            _end_date = request.form["_end_date"]

            _test_status = check_none(_test_status)
            _start_date = check_none(_start_date)
            _end_date = check_none(_end_date)
            flag = 1

        elif _instr == "Reset":
            _test_status, _start_date, _end_date, flag = None, None, None, 0

    elif request.method == "GET":
        _test_status, _start_date, _end_date, flag = None, None, None, 0
    cursor.callproc('student_view_results', (_username, _test_status, _start_date, _end_date,))
    #cursor.callproc('student_view_results', ("dengqingyuan4", None,None,None,))
    cursor.execute("select * from student_view_results_result;")
    data = cursor.fetchall()
    if data==(()):
        e=1
    data1=[]
    data2=[]
    for row in data:
        if row[4]=='pending':
            data2.append(row)
        else:
            data1.append(row)
    return render_template("student_view_test_results.html", data1=data1,data2=data2, flag=flag,e=e)


# screen 5: connect to screen 4
@app.route("/student_home/student_view_test_results/explore_test_result/<id>", methods=("GET", "POST"))
def explore_test_result(id):
    
    error = None
    _username = session['user_id']
    _is_student, _ = is_student(_username)
    if not _is_student:
        error = 'You do not have access to this page.'
        return render_template('login.html', error=error)
    
    if request.method == "POST":
        _instr = request.form['submit_button']
        if _instr == 'Back(Home)':
            return redirect(url_for("student_view_test_results"))

    elif request.method == "GET":
        _test_id = id
        cursor.callproc('explore_results', (_test_id,))
        cursor.execute("select * from explore_results_result;")
        data = cursor.fetchall()
        if data == ():
            error = "This test has not been tested."
            flash(error)
            return redirect(url_for("student_view_test_results"))
        else:
            return render_template("explore_test_result.html", data=data)


# screen 6 :connect to screen 3 student home
# need to add def get_testing_site()
@app.route("/aggregrate_test_results", methods=("GET", "POST"))
def aggregrate_test_results():
    
    user_judge()
    
    site = get_testing_site()
    housing = get_housing()
    location = get_location()

    if request.method == "POST":
        _instr = request.form['submit_button']

        if _instr == 'Back(Home)':
            return redirect(url_for("back_home"))

        if _instr == "Filter":
            _location = request.form.get("_location")
            _housing = request.form.get("_housing")
            _testing_site = request.form.get("_testing_site")
            _start_date = request.form["_start_date"]
            _end_date = request.form["_end_date"]

            _location = check_none(_location)
            _housing = check_none(_housing)
            _testing_site = check_none(_testing_site)
            _start_date = check_none(_start_date)
            _end_date = check_none(_end_date)
            flag = 1

        elif _instr == "Reset":
            _location, _housing, _testing_site, _start_date, _end_date, flag = None, None, None, None, None, 0

    elif request.method == "GET":
        _location, _housing, _testing_site, _start_date, _end_date, flag = None, None, None, None, None, 0

    cursor.callproc('aggregate_results', (_location, _housing, _testing_site, _start_date, _end_date))
    cursor.execute("select * from aggregate_results_result;")
    data = cursor.fetchall()
    total = 0
    for row in data:
        total += row[1]
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
    
    error = None
    message=None
    site = get_testing_site()
    
    _username = session['user_id']
    _is_student, _ = is_student(_username)
    if not _is_student:
        error = 'You do not have access to this page.'
        return render_template('login.html', error=error)
    
    if request.method == "POST":
        _instr = request.form['submit_button']

        if _instr == 'Back(Home)':
            return redirect(url_for("back_home"))

        if _instr == "Filter":
            _testing_site = request.form.get("_testing_site")
            _start_date = request.form["_start_date"]
            _end_date = request.form["_end_date"]
            _start_time = request.form["_start_time"]
            _end_time = request.form["_end_time"]

            _testing_site = check_none(_testing_site)
            _start_date = check_none(_start_date)
            _end_date = check_none(_end_date)
            _start_time = check_none(_start_time)
            _end_time = check_none(_end_time)
            flag = 1

        elif _instr == "Reset":
            _testing_site, _start_date, _end_date, _start_time, _end_time, flag = None, None, None, None, None, 0

        elif _instr == "Sign up":
            _testing_site = request.form.get("_testing_site")
            _start_date = request.form["_start_date"]
            _end_date = request.form["_end_date"]
            _start_time = request.form["_start_time"]
            _end_time = request.form["_end_time"]

            _testing_site = check_none(_testing_site)
            _start_date = check_none(_start_date)
            _end_date = check_none(_end_date)
            _start_time = check_none(_start_time)
            _end_time = check_none(_end_time)
            flag = 1
            if request.form.get("clickIn") is not None:
                sql = "select count(*) from test;"
                cursor.execute(sql)
                count_test = cursor.fetchone()
                row = request.form["clickIn"]
                row = row.split(',')
                _appt_date = str(row[0])
                _appt_time = str(row[1])
                _site_name = str(row[3])
                cursor.execute("select max(test_id) from test;")
                test_id=cursor.fetchone()
                _test_id=str(int(test_id[0])+1)
                #_test_id = str(100060 + int(random.uniform(1, 1000)))
                cursor.callproc('test_sign_up', (_username, _site_name, _appt_date, _appt_time, _test_id,))
                # cursor.callproc('test_sign_up',('mgeller3','Bobby Dodd Stadium','2020-09-16', '12:00:00','100061',))
                # cursor.callproc('mgeller3', 'Bobby Dodd Stadium', '2020-10-01', '11:00:00',))
                conn.commit()
                cursor.execute(sql)
                count_test_update = cursor.fetchone()
                if count_test_update[0] > count_test[0]:
                    message = 'Successfully signed up for an appointment!' + '  Test ID:' + _test_id + '  Date:' + _appt_date + '  Time:' + _appt_time + '  Site:' + _site_name
                else:
                    error = "You already have one upcoming appointment!"
            else:
                error = "Please choose one bullect point to sign up for an appointment!"

    elif request.method == "GET":
        _testing_site, _start_date, _end_date, _start_time, _end_time, flag = None, None, None, None, None, 0
    cursor.callproc('test_sign_up_filter', (_username, _testing_site, _start_date, _end_date, _start_time, _end_time))
    cursor.execute("select * from test_sign_up_filter_result;")
    data = cursor.fetchall()   
    return render_template('signup_for_a_test.html', data=data, site=site, error=error, flag=flag,message=message)


# screen 8: connect to screen 3: labtech home
@app.route("/labtech_home/lab_tech_tests_processed", methods=("GET", "POST"))
def lab_tech_tests_processed():
    
    error = None
    _lab_tech_username = session['user_id']
    _is_labtech, _ = is_labtech(_lab_tech_username)
    if not _is_labtech:
        error = 'You do not have access to this page.'
        return render_template('login.html', error=error)

    if request.method == "POST":
        _instr = request.form['submit_button']

        if _instr == 'Back(Home)':
            return redirect(url_for("labtech_home"))

        elif _instr == "Filter":
            _test_status = request.form.get("_test_status")
            _start_date = request.form["_start_date"]
            _end_date = request.form["_end_date"]

            _test_status = check_none(_test_status)
            _start_date = check_none(_start_date)
            _end_date = check_none(_end_date)
            flag = 1

        elif _instr == "Reset":
            _test_status, _start_date, _end_date, flag = None, None, None, 0

    elif request.method == "GET":
        _test_status, _start_date, _end_date, flag = None, None, None, 0

    cursor.callproc('tests_processed', (_start_date, _end_date, _test_status, _lab_tech_username,))
    cursor.execute("select * from tests_processed_result;")
    data = cursor.fetchall()
    return render_template('lab_tech_tests_processed.html', data=data, flag=flag)


# screen 9: View Pools (connect to screen 3)
@app.route("/view_pools", methods=("GET", "POST"))
def view_pools():
    """
    view_pools
    """
    
    error = None
    _lab_tech_username = session['user_id']
    _is_labtech, _ = is_labtech(_lab_tech_username)
    if not _is_labtech:
        error = 'You do not have access to this page.'
        return render_template('login.html', error=error)
    
    status_list = ("ALL", "Positive", "Negative", "Pending")
    error = None
    data = (())
    flag = 0
    if request.method == "POST":
        _instr = request.form['submit_button']

        if _instr == 'Back(Home)':
            return redirect(url_for("back_home"))

        elif _instr == "Filter":
            if str(request.form['begin_process_date']) == '':
                _begin_process_date = None
            else:
                _begin_process_date = request.form['begin_process_date']

            if str(request.form['end_process_date']) == '':
                _end_process_date = None
            else:
                _end_process_date = request.form['end_process_date']

            if str(request.form.get('stypes')) == 'ALL':
                _pool_status = None
            elif str(request.form.get('stypes')) == 'Positive':
                _pool_status = 'positive'
            elif str(request.form.get('stypes')) == 'Pending':
                _pool_status = 'pending'
            else:
                _pool_status = 'negative'

            if str(request.form['processed_by']) == '':
                _processed_by = None
            else:
                _processed_by = request.form['processed_by']

            if str(request.form['begin_process_date']) != '' and str(request.form['end_process_date']) != '':
                if request.form['begin_process_date'] > request.form['end_process_date']:
                    error = "The end date cannot be before the start date."
                else:
                    cursor.callproc('view_pools', (_begin_process_date, _end_process_date, _pool_status, _processed_by,))
                    conn.commit()
                    cursor.execute('select * from view_pools_result; ')
                    data = cursor.fetchall()
            else:
                cursor.callproc('view_pools', (_begin_process_date, _end_process_date, _pool_status, _processed_by,))
                conn.commit()
                cursor.execute('select * from view_pools_result; ')
                data = cursor.fetchall()

            flag = 1

        elif _instr == "Reset":
            _begin_process_date, _end_process_date, _pool_status, _processed_by, flag = None, None, None, None, 0

    elif request.method == "GET":
        _begin_process_date, _end_process_date, _pool_status, _processed_by, flag = None, None, None, None, 0

    return render_template('view_pools.html', error=error, data=data, flag=flag, status_list=status_list)



# screen 10: Create a Pool
@app.route("/create_pool", methods=("GET", "POST"))
def create_pool():
    error = None
    message = None
    _username = session['user_id']
    _is_labtech, _ = is_labtech(_username)
    if not _is_labtech:
        error = 'You do not have access to this page.'
        return render_template('login.html', error=error)
    
    cursor.execute("select test_id, appt_date from test where pool_id is null;")
    data = cursor.fetchall()
    if request.method == "POST":
        _instr = request.form['submit_button']

        if _instr == 'Back(Home)':
            return redirect(url_for("back_home"))

        if _instr == "Create Pool":
            _pool_id = request.form["pool_id"]

            if str(_pool_id) == '':
                error = "Please enter pool id to create a pool!"
            else:
                cursor.execute("select pool_id from pool where pool_id = %s", (_pool_id,))
                temp = cursor.fetchall()
                if temp != (()):
                    error = "This pool has been created. Please enter another pool id!"
                else:
                    num = 0
                    for test in data:
                        if request.form.get(test[0]) is not None:
                            row = request.form[test[0]]
                            row_split = row.split(',')
                            _test_id = str(row_split[0])
                            if num == 0:
                                cursor.callproc('create_pool', (_pool_id, _test_id,))
                                conn.commit()
                            else:
                                cursor.callproc('assign_test_to_pool', (_pool_id, _test_id,))
                                conn.commit()
                            num += 1
                        else:
                            pass
                    if num == 0:
                        error = "Please select at least one test into the pool!"
                    else:
                        message = "Create a pool successfully!"
    elif request.method == "GET":
        pass

    cursor.execute("select test_id, appt_date from test where pool_id is null;")
    data = cursor.fetchall()

    return render_template('create_pool.html', data=data, error=error, message=message)

# screen 11 View Pool - Process Pool (connect to screen 9)
prev = None
@app.route("/labtech/processpool/<id>", methods=("GET", "POST"))
def labtech_processpool(id):
    """
    This screen allows the user to process pool.
    """

    _is_labtech, _ = is_labtech(session['user_id'])
    if not _is_labtech:
        error = 'You do not have access to this page.'
        return render_template('login.html', error=error)

    _processed_by = session['user_id']
    _pool_id = id
    flag = 0
    error = None
    message = None
    data = (())
    _pool_status = 'pending'
    global prev

    if request.method == "POST":
        _instr = request.form['submit_button']
        if _instr == 'Back(Home)':
            return redirect(url_for("back_home"))

        if _instr == 'Positive':
            _pool_status = 'positive'
            _process_date = request.form['process_date']
            cursor.execute("select test_id, appt_date, test_status from test where pool_id = %s", (_pool_id,))
            data = cursor.fetchall()
            flag = 1

        elif _instr == 'Negative':
            _pool_status = "negative"
            _process_date = request.form['process_date']
            cursor.execute("select test_id, appt_date, test_status from test where pool_id = %s", (_pool_id,))
            data = cursor.fetchall()
            flag = 1

        if _instr == "Process Pool":
            _process_date = request.form['process_date']
            cursor.execute("select max(appt_date) from test where pool_id = %s", (_pool_id,))
            this_data = cursor.fetchall()
            max_date = this_data[0][0]
            print(_process_date)
            print(max_date)
            if str(_process_date) == '':
                error = "Please enter the process date!"
            elif str(_process_date) <= str(max_date):
                error = "The processed date of the pool must be after the latest timeslot date of the tests within the pool!"
            elif prev != 'Negative' and prev != 'Positive':
                error = "Please select the pool status!"
            elif prev == 'Positive':
                _pool_status = "positive"
                cursor.callproc('process_pool', (_pool_id, 'positive', _process_date, _processed_by,))
                conn.commit()
                cursor.execute("select test_id from test where pool_id = %s", (_pool_id,))
                test_id_list = cursor.fetchall()
                for test in test_id_list:
                    if str(request.form.get(test[0])) == 'Positive':
                        cursor.callproc('process_test', (test[0], 'positive',))
                        conn.commit()
                    else:
                        cursor.callproc('process_test', (test[0], 'negative',))
                        conn.commit()
                cursor.execute("select test_id, appt_date, test_status from test where pool_id = %s", (_pool_id,))
                data = cursor.fetchall()
                message = "Process the pool successfully!"
            else:
                _pool_status = "negative"
                cursor.callproc('process_pool', (_pool_id, 'negative', _process_date, _processed_by,))
                conn.commit()
                cursor.execute("select test_id from test where pool_id = %s", (_pool_id,))
                test_id_list = cursor.fetchall()
                for test in test_id_list:
                    cursor.callproc('process_test', (test[0], 'negative',))
                    conn.commit()
                cursor.execute("select test_id, appt_date, test_status from test where pool_id = %s", (_pool_id,))
                data = cursor.fetchall()
                message = "Process the pool successfully!"
            flag = 1
        prev = _instr
    elif request.method == "GET":
        pass

    return render_template("labtech_processpool.html", _pool_id=_pool_id, flag=flag, data=data, error=error, _pool_status=_pool_status, message=message)

# screen 10 and 11: view pending pool
@app.route("/view_process_pools", methods=("GET", "POST"))
def view_process_pools():
    error = None
    
    _is_labtech, _ = is_labtech(session['user_id'])
    if not _is_labtech:
        error = 'You do not have access to this page.'
        return render_template('login.html', error=error)
    
    data = (())
    if request.method == "POST":
        _instr = request.form['submit_button']

        if _instr == 'Back(Home)':
            return redirect(url_for("back_home"))

    elif request.method == "GET":
        _begin_process_date = None
        _end_process_date = None
        _pool_status = 'pending'
        _processed_by = None
        cursor.callproc('view_pools', (_begin_process_date, _end_process_date, _pool_status, _processed_by,))
        conn.commit()
        cursor.execute('select * from view_pools_result; ')
        data = cursor.fetchall()

    return render_template('view_process_pools.html', error=error, data=data, )


# screen 12: Create an Appointment
@app.route("/create_appointment", methods=("GET", "POST"))
def create_appointment():
    site = get_testing_site()
    error = None
    message = None
    _username = session['user_id']
    _is_admin, _ = is_admin(session['user_id'])
    _is_tester, _ = is_tester(session['user_id'])

    if not _is_admin and not _is_tester:
        error = 'You do not have access to this page.'
        return render_template('login.html', error=error)

    if request.method == "POST":
        _instr = request.form['submit_button']

        if _instr == 'Back(Home)':
            return redirect(url_for("back_home"))

        elif _instr == "Create Appointment":
            _site_name = request.form.get("site_name")
            _appt_date = request.form["appt_date"]
            _appt_time = request.form["appt_time"]
            if str(_site_name) == '':
                error = 'Please select the stie name!'
            elif str(_appt_date) == '':
                error = 'Please enter the appointment date!'
            elif str(_appt_time) == '':
                error = 'Please enter the appointment time!'
            else:
                cursor.execute("select exists (select * from appointment where site_name = %s and appt_date = %s and appt_time = %s)", (_site_name, _appt_date, _appt_time,))
                result = cursor.fetchall()
                if result[0][0] != 0:
                    error = "This time slot is occupied! Please try another one."
                else:
                    if _is_admin:
                        cursor.callproc('create_appointment', (_site_name, _appt_date, _appt_time,))
                        conn.commit()
                        message = "Create an appointment successfully!"
                    else:
                        cursor.execute("select site from working_at where username = %s", (_username,))
                        site_work_at = cursor.fetchall()
                        site_all = []
                        for site_x in site_work_at:
                            site_all.append(site_x[0])
                        if _site_name not in site_all:
                            error = 'You cannot create appointments for the site you do not work at.'
                        else:
                            cursor.callproc('create_appointment', (_site_name, _appt_date, _appt_time,))
                            conn.commit()
                            message = "Create an appointment successfully!"

    elif request.method == "GET":
        pass

    return render_template("create_appointment.html", site=site, error=error, message=message)

# screen 13: View Appointments
@app.route("/view_appointments", methods=("GET", "POST"))
def view_appointments():
    site = get_testing_site()
    error = None

    _is_admin, _ = is_admin(session['user_id'])
    _is_tester, _ = is_tester(session['user_id'])
    data = (())
    flag = 0
    flag1 = 0
    _F = None

    if not _is_admin and not _is_tester:
        error = 'You do not have access to this page.'
        return render_template('login.html', error=error)

    if request.method == "POST":
        _instr = request.form['submit_button']

        if _instr == 'Back(Home)':
            return redirect(url_for("back_home"))

        elif _instr == "Filter":
            if str(request.form['begin_appt_date']) == '':
                _begin_appt_date = None
            else:
                _begin_appt_date = request.form['begin_appt_date']

            if str(request.form['end_appt_date']) == '':
                _end_appt_date = None
            else:
                _end_appt_date = request.form['end_appt_date']

            if str(request.form['begin_appt_time']) == '':
                _begin_appt_time = None
            else:
                _begin_appt_time = request.form['begin_appt_time']

            if str(request.form['end_appt_time']) == '':
                _end_appt_time = None
            else:
                _end_appt_time = request.form['end_appt_time']

            if str(request.form.get('testing_site')) == 'ALL':
                _site_name = None
            else:
                _site_name = request.form.get('testing_site')

            if (str(request.form['begin_appt_date']) != '' and str(request.form['end_appt_date']) != '') and (str(request.form['begin_appt_time']) == '' or  str(request.form['end_appt_time']) == ''):
                if str(request.form['begin_appt_date']) > str(request.form['end_appt_date']):
                    error = "The end appointment date cannot be before the start appointment date."
                else:
                    if request.form.get("clickon") is not None:
                        ava = request.form["clickon"]
                        if ava == "booked":
                            _F = 0
                            flag1 = 1
                        elif ava == "available":
                            _F = 1
                            flag1 = 2
                        else:
                            _F = None
                            flag1 = 3
                        cursor.callproc('view_appointments', (
                            _site_name, _begin_appt_date, _end_appt_date, _begin_appt_time, _end_appt_time, _F,))
                        conn.commit()
                        cursor.execute('select * from view_appointments_result; ')
                        data = cursor.fetchall()
                        flag = 1
                    else:
                        error = "Please select the availability condition!"

            elif (str(request.form['begin_appt_date']) == '' or str(request.form['end_appt_date']) == '') and (str(request.form['begin_appt_time']) != '' and  str(request.form['end_appt_time']) != ''):
                if str(request.form['begin_appt_time']) > str(request.form['end_appt_time']):
                    error = "The end appointment time cannot be before the start appointment time."
                else:
                    if request.form.get("clickon") is not None:
                        ava = request.form["clickon"]
                        if ava == "booked":
                            _F = 0
                            flag1 = 1
                        elif ava == "available":
                            _F = 1
                            flag1 = 2
                        else:
                            _F = None
                            flag1 = 3
                        cursor.callproc('view_appointments', (
                        _site_name, _begin_appt_date, _end_appt_date, _begin_appt_time, _end_appt_time, _F,))
                        conn.commit()
                        cursor.execute('select * from view_appointments_result; ')
                        data = cursor.fetchall()
                        flag = 1
                    else:
                        error = "Please select the availability condition!"

            elif (str(request.form['begin_appt_date']) != '' and str(request.form['end_appt_date']) != '') and (str(request.form['begin_appt_time']) != '' and  str(request.form['end_appt_time']) != ''):
                if str(request.form['begin_appt_date']) > str(request.form['end_appt_date']) and str(request.form['begin_appt_time']) > str(request.form['end_appt_time']):
                    error = "The end appointment date/time cannot be before the start appointment date/time."
                elif str(request.form['begin_appt_date']) > str(request.form['end_appt_date']):
                    error = "The end appointment date cannot be before the start appointment date."
                elif str(request.form['begin_appt_time']) > str(request.form['end_appt_time']):
                    error = "The end appointment time cannot be before the start appointment time."
                else:
                    if request.form.get("clickon") is not None:
                        ava = request.form["clickon"]
                        if ava == "booked":
                            _F = 0
                            flag1 = 1
                        elif ava == "available":
                            _F = 1
                            flag1 = 2
                        else:
                            _F = None
                            flag1 = 3
                        cursor.callproc('view_appointments', (
                            _site_name, _begin_appt_date, _end_appt_date, _begin_appt_time, _end_appt_time, _F,))
                        conn.commit()
                        cursor.execute('select * from view_appointments_result; ')
                        data = cursor.fetchall()
                        flag = 1
                    else:
                        error = "Please select the availability condition!"
            else:
                if request.form.get("clickon") is not None:
                    ava = request.form["clickon"]
                    if ava == "booked":
                        _F = 0
                        flag1 = 1
                    elif ava == "available":
                        _F = 1
                        flag1 = 2
                    else:
                        _F = None
                        flag1 = 3
                    cursor.callproc('view_appointments', (
                        _site_name, _begin_appt_date, _end_appt_date, _begin_appt_time, _end_appt_time, _F,))
                    conn.commit()
                    cursor.execute('select * from view_appointments_result; ')
                    data = cursor.fetchall()
                    flag = 1
                else:
                    error = "Please select the availability condition!"
        elif _instr == "Reset":
            _site_name, _begin_appt_date, _end_appt_date, _begin_appt_time, _end_appt_time, flag, flag1 = None, None, None, None, None, 0, 0


    elif request.method == "GET":
        pass

    return render_template("view_appointments.html", site=site, error=error, data=data, flag=flag, flag1=flag1, )


# screen 14
@app.route("/admin/reassign", methods=("GET", "POST"))
def admin_reassign():
    """
    This screen is for an Admin to assign or reassign testers to testing sites.
    """
    error = None
    _is_admin, _ = is_admin(session['user_id'])
    if not _is_admin:
        error = 'You do not have access to this page.'
        return render_template('login.html', error=error)

    cursor.execute('select * from sitetester ')
    testers = cursor.fetchall()
    tester_id = list(itertools.chain(*testers))

    all_sites = get_testing_site()

    testers_info = dict()
    add_option_names = []

    for tester in tester_id:
        testers_info[tester] = []
        testers_info[tester].append(tester)

        cursor.execute('select concat(fname, " ",lname) from user where username = %s', (tester,))
        name = cursor.fetchone()
        testers_info[tester].append(name[0])

        cursor.execute('select phone_num from employee where emp_username = %s', (tester,))
        num = cursor.fetchone()
        testers_info[tester].append(num[0])

        cursor.callproc('tester_assigned_sites', (tester,))
        cursor.execute('select * from tester_assigned_sites_result')
        current_sites = cursor.fetchall()

        site_name = list(itertools.chain(*current_sites))
        diff_sites = set(all_sites) - set(site_name)

        testers_info[tester].append(current_sites)
        testers_info[tester].append(diff_sites)
        
        newsites_name = "newsites"+tester
        testers_info[tester].append(newsites_name)
        add_option_names.append(newsites_name)

    if request.method == "POST":
        
        _instr = request.form['submit_button']

        if _instr == 'Back(Home)':
            return redirect(url_for("back_home"))
        
        _delete_option = request.form.get('options')
        
        _add_list = []
        for name in add_option_names:
        #addoption 只能返回第一个下拉菜单的数据
            _add_option = str(request.form.get(name))
            if _add_option != 'select1':
                _add_list.append(_add_option)

        if _delete_option is not None and _add_list != []:
            temp1 = _delete_option[1:-1].split(',')
            tester = temp1[0][1:-1]
            tester_name = testers_info[tester][1]
            try:
                cursor.callproc('unassign_tester', (tester, temp1[1][2:-1]))
                conn.commit()
                message = "You have successfully deleted {} from the site '{}'.".format(tester_name, temp1[1][2:-1])
                flash(message)
            except Exception as e:
                error = str(e)
                return render_template("admin_reassign.html", error=error, testers=testers_info, usernames=tester_id)
            
            for add in _add_list:
                temp2 = add[1:-1].split(",")
                tester = temp2[0][1:-1]
                tester_name = testers_info[tester][1]
                try:
                    cursor.callproc('assign_tester', (tester, temp2[1][2:-1]))
                    conn.commit()
                    message = "You have successfully added {} to the site '{}'.".format(tester_name, temp2[1][2:-1])
                    flash(message)
                except Exception as e:
                    error = str(e)
                    return render_template("admin_reassign.html", error=error, testers=testers_info, usernames=tester_id)
            return redirect(url_for('admin_reassign'))

        elif _delete_option is not None and _add_list == []:
            temp = _delete_option[1:-1].split(',')
            tester = temp[0][1:-1]
            tester_name = testers_info[tester][1]
            try:
                cursor.callproc('unassign_tester', (tester, temp[1][2:-1]))
                conn.commit()
                message = "You have successfully deleted {} from the site '{}'.".format(tester_name, temp[1][2:-1])
                flash(message)
                return redirect(url_for('admin_reassign'))
            except Exception as e:
                error = str(e)
                return render_template("admin_reassign.html", error=error, testers=testers_info, usernames=tester_id)

        elif _add_list != [] and _delete_option is None:
            for add in _add_list:
                temp = add[1:-1].split(",")
                tester = temp[0][1:-1]
                tester_name = testers_info[tester][1]
                try:
                    cursor.callproc('assign_tester', (tester, temp[1][2:-1]))
                    conn.commit()
                    message = "You have successfully added {} to the site '{}'.".format(tester_name, temp[1][2:-1])
                    flash(message)
                except Exception as e:
                    error = str(e)
                    return render_template("admin_reassign.html", error=error, testers=testers_info, usernames=tester_id)
            return redirect(url_for('admin_reassign'))
        
        else:
            error = "You haven't update anything."
            return render_template("admin_reassign.html", error=error, testers=testers_info, usernames=tester_id)
            
    return render_template("admin_reassign.html", error=error, testers=testers_info, usernames=tester_id)


# screen 15
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
        return render_template('login.html', error=error)

    if request.method == "POST":
        
        _instr = request.form['submit_button']

        if _instr == 'Back(Home)':
            return redirect(url_for("back_home"))
        
        _site_name = request.form["name"]
        _street = request.form["street"]
        _city = request.form['city']
        _state = request.form.get('state')
        _zip = request.form['zip']
        _location = str(request.form.get('location'))
        _tester = str(request.form.get('tester'))

        if not _site_name or not _street or not _city or not _zip:
            error = "All field are required."
            return render_template("admin_createsite.html", error=error,
                           tester_list=testers,
                           state_list=states,
                           location_list=locations)
            
        elif _state == 'select1':
            error = "State is required."
            return render_template("admin_createsite.html", error=error,
                           tester_list=testers,
                           state_list=states,
                           location_list=locations)
        elif _location == 'select2':
            error = "Location is required."
            return render_template("admin_createsite.html", error=error,
                           tester_list=testers,
                           state_list=states,
                           location_list=locations)
        elif _tester == 'select3':
            error = "A site cannot be created without at least one tester."
            return render_template("admin_createsite.html", error=error,
                           tester_list=testers,
                           state_list=states,
                           location_list=locations)

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
                message = "You have successfully created the site {}".format(_site_name)
                flash(message)
                return redirect(url_for('admin_createsite'))

            except Exception as e:
                error = str(e)
                return render_template("admin_createsite.html", error=_tester,
                           tester_list=testers,
                           state_list=states,
                           location_list=locations)

    return render_template("admin_createsite.html", error=error,
                           tester_list=testers,
                           state_list=states,
                           location_list=locations)


# screen 16 (和screen 9连接)
@app.route("/labtech/viewpool/<id>", methods=("GET", "POST"))
def labtech_viewpool(id):
    """
    This screen allows the user to look into an already processed pool.
    """
    _is_labtech, _ = is_labtech(session['user_id'])
    if not _is_labtech:
        error = 'You do not have access to this page.'
        return render_template('login.html', error=error)

    _pool_id = id
    cursor.callproc('pool_metadata', (_pool_id,))
    cursor.execute('select * from pool_metadata_result')
    pool_data = cursor.fetchone()

    cursor.callproc('tests_in_pool', (_pool_id,))
    cursor.execute('select * from tests_in_pool_result')
    tests_data = cursor.fetchall()
    
    if request.method == "POST":
        return redirect(url_for("view_pools"))
    return render_template("labtech_viewpool.html", pool=pool_data, tests=tests_data)


# screen 17
@app.route("/tester/changesite/<id>", methods=("GET", "POST"))
def tester_changesite(id):
    """
    Testers can use this screen to change their testing site.
    """

    error = None
    message = None

    _is_tester, _ = is_tester(session['user_id'])
    if not _is_tester:
        error = 'You do not have access to this page.'
        return render_template('login.html', error=error)

    username = id
    cursor.execute('select concat(fname, " ",lname) from user where username = %s', (username,))
    full_name = cursor.fetchone()

    cursor.execute('select site from working_at where username = %s', (username,))
    sites = cursor.fetchall()

    site_name = list(itertools.chain(*sites))
    all_sites = get_testing_site()

    diff_sites = set(all_sites) - set(site_name)

    if request.method == "POST":
        
        _instr = request.form['submit_button']

        if _instr == 'Back(Home)':
            return redirect(url_for("back_home"))
        
        _delete_option = request.form.get('options')
        _add_option = str(request.form.get('newsites'))

        if _delete_option is not None and not _add_option == 'select1':
            try:
                cursor.callproc('unassign_tester', (username, _delete_option))
                conn.commit()
                cursor.callproc('assign_tester', (username, _add_option))
                conn.commit()
                message = "You have successfully deleted the site '{}' and added to the site '{}'.".format(_delete_option, _add_option)
                flash(message)
                return redirect(url_for('tester_changesite', id = username))
            
            except Exception as e:
                error = str(e)
                return render_template("tester_changesite.html", error=error,message = message,
                                       username=username,
                                       fullname=full_name,
                                       sites=sites,
                                       reset_sites=diff_sites)
        elif _delete_option is not None and _add_option == 'select1':
            try:
                cursor.callproc('unassign_tester', (username, _delete_option))
                conn.commit()
                message = "You have successfully deleted the site '{}'.".format(_delete_option)
                flash(message)
                return redirect(url_for('tester_changesite', id = username))
            
            except Exception as e:
                error = str(e)
                return render_template("tester_changesite.html", error=error,message = message,
                                       username=username,
                                       fullname=full_name,
                                       sites=sites,
                                       reset_sites=diff_sites)
        elif _delete_option is None and not _add_option == 'select1':
            try:
                cursor.callproc('assign_tester', (username, _add_option))
                conn.commit()
                message = "You have successfully added to the site '{}'.".format(_add_option)
                flash(message)
                return redirect(url_for('tester_changesite', id = username))
            
            except Exception as e:
                error = str(e)
                return render_template("tester_changesite.html", error=error,message = message,
                                       username=username,
                                       fullname=full_name,
                                       sites=sites,
                                       reset_sites=diff_sites)
        else:
            error = "You haven't update anything."
            return render_template("tester_changesite.html", error=error,
                                   username=username,
                                   fullname=full_name,
                                   sites=sites,
                                   reset_sites=diff_sites)
            

    return render_template("tester_changesite.html", error=error,
                           username=username,
                           fullname=full_name,
                           sites=sites,
                           reset_sites=diff_sites)


# screen 18
@app.route("/daily", methods=("GET", "POST"))
def daily():
    """
    This screen shows testing statistics grouped by processing date
    """
    user_judge()
    cursor.callproc('daily_results')
    cursor.execute('select * from daily_results_result')
    daily_data = cursor.fetchall()
    
    if request.method == 'POST':
        return redirect(url_for('back_home'))
    
    return render_template("daily.html", results=daily_data)


if __name__ == '__main__':
    app.run(debug=True)
