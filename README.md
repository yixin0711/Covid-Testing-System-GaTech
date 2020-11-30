# Georgia Tech COVID-19 Testing System
## i.Instructions to setup app

### GitHub and Python
1. Locate to any local folder and open the terminal
2. Input in terminal`git clone https://github.com/yixin0711/Covid-Testing-System-GaTech` and you can get a folder named `Covid-Testing-System-GaTech`
3. Change to directory `Covid-Testing-System-GaTech`
4. Input in terminal `pip install virtualenv` to install the virtual environment
5. Input in terminal `python3 -m venv env` to get a local folder for the virtual environment
6. Input in terminal `source env/bin/activate` to activate the virtual environment
7. Input in terminal `pip install Flask` to install the Flask package
8. Input in terminal `pip install flask-mysql` to install the Flask extension that allows you to access a MySQL database.

### MySQL
1. Open MySQL Workbench
2. Open the file `db_init.sql` in the folder `mysql_export` and run it.
3. Open the file `covidtest_fall2020.sql` in the same folder and run it.
4. Close and terminate MySQL Workbench.


## ii.Instructions to run app
When the virtual environment is opened, input in terminal `python main.py`, and then open `127.0.0.1:5000` in any web browser to run the website.


## iii.Brief Explanation of Technologies
Technology Stack: `Python 3.7` + `Flask` + `MySQ`L + `HTML` + `CSS`
Our project is based on `Flask` framework. The program can interact with the `MySQL` database in `Python` via `PyMySQL` library. 
In the front end, `HTML` and `CSS` files are required to design layouts and contents that are shown on the website. In the back end, we design many interfaces in `main.py` files based on `Flask`.
There are some key modules to realize the interaction between the front end and the back end. 
1. `<a href="{{url_for()}}"></a>`: It can pass the parameters and data to the back end through the route.
2. `<form action="" method="POST / GET ">`: It enables the POST and GET method to pass data from the front end to the back end. Once the user makes some changes on the page, the corresponding data can reach to the back end.
3. `return render_template('.html', data=data)`: This function is used to return static pages and pass parameters and data from the back end to the front end. It can automatically find the html files under the templates folder. 
4. `redirect` module can realize the function of relocating to another URL address.
5. `request` module enables the back end to get the request parameters sent from the front end. 

## iv.	Work Distribution
### Xin Yi:
1. Initial setup of the overall working environment, i.e., 
    1. GitHub repository, 
    2. HTML layout for general format,
    3. static CSS file for general style
2. Initial setup of the skeleton code for web development in Python using Flask, MySQL and HTML, i.e., 
    1. basic setup for Flask in Python, 
    2. configuration for MySQL in Python, 
    3. basic syntax/sample code for MySQL execution in Python
3. Responsible for creating functionality and webpage for screens:
    1. Welcome page (index page) 
    2. Screen 1: Login
    3. Screen 2: Register
    4. Screen 3: Home Screen(3)
    5. Screen 14: Reassign Tester
    6. Screen 15: Create a Testing Site
    7. Screen 16: Explore Pool Result
    8. Screen 17: Tester Change Testing Site
    9. Screen 18: View Daily Results
4. Add helper functions that 
    1. checked user security/accessability
    2. get options for dropdown menus (location, housing type, states, etc.)
5. Responsible for reviewing other’s part and run tests

### Qingyuan Deng:
1. Modified the skeleton code for web development in Python, MySQL and HTML, i.e., 
    1. optimization the MySQL procedure for better functionality
    2. improvement of home screen layout
2. Responsible for creating and improving functionality and webpage for screens:
    1. Screen 4: Student View Test Results
    2. Screen 5: Explore Test Result
    3. Screen 6: Aggregate Test Results
    4. Screen 7: Signup for a Test
    5. Screen 8: Lab Tech Tests Processed
    6. Modified home screens for student and lab technicians
3. Improve functionality of helper functions that 
    1. checked user security/accessability
    2. get options for dropdown menus (location, housing type, states, etc.)
    3. additional functionalities that are not required by the project
4. Responsible for reviewing other’s part and run tests

### Runze Yang:
1. Initial setup of the overall working environment, i.e., 
    1. HTML classes for general format (tables, messages, etc.),
    2. static CSS file for general style
2. Improved the skeleton code for web development in Python and HTML, i.e., 
    1. basic configurations for Flask in Python, 
    2. elegent appearance of HTML general layout
3. Responsible for creating and improving functionality and webpage for screens:
    1. Screen 9: View Pools
    2. Screen 10: Create a Pool
    3. Screen 11: View Pool
    4. Screen 12: Create an Appointment
    5. Screen 13: View Appointments
    6. Modified home screens for lab techinicians and site testers. 
4. Modified helper functions that 
    1. checked data accessibility
    2. improved feasibility using the connection of Python and HTML
    3. additional functionalities that are not required by the project
5. Responsible for reviewing other’s part and run tests

All team members participate in weekly meetings on time. 

