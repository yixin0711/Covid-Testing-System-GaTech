# Georgia Tech COVID-19 Testing System
### i.Instructions to setup app


### ii.Instructions to run app


### iii.Brief Explanation of Technologies
Technology Stack: `Python 3.7` + `Flask` + `MySQ`L + `HTML` + `CSS`
Our project is based on `Flask` framework. The program can interact with the `MySQL` database in `Python` via `PyMySQL` library. 
In the front end, `HTML` and `CSS` files are required to design layouts and contents that are shown on the website. In the back end, we design many interfaces in `main.py` files based on `Flask`.
There are some key modules to realize the interaction between the front end and the back end. 
1. `<a href="{{url_for()}}"></a>`: It can pass the parameters and data to the back end through the route.
2. `<form action="" method="POST / GET ">`: It enables the POST and GET method to pass data from the front end to the back end. Once the user makes some changes on the page, the corresponding data can reach to the back end.
3. `return render_template('.html', data=data)`: This function is used to return static pages and pass parameters and data from the back end to the front end. It can automatically find the html files under the templates folder. 
4. `redirect` module can realize the function of relocating to another URL address.
5. `request` module enables the back end to get the request parameters sent from the front end. 

### iv.	Work Distribution
Xin Yi: Build screen 1, 2, 3, 14, 15, 16, 17, 18.
Qingyuan Deng: Build Screen 3, 4, 5, 6, 7, 8.
Runze Yang: Build screen 9, 10, 11, 12, 13.

