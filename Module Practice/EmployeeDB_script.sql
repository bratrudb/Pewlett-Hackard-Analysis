departments
-
dept_no varchar pk fk
dept_name varchar

dept_emp
-
emp_no integer pk fk - employees.emp_no
dept_no varchar fk - departments.dept_no
from_date date
to_date date

dept_manager
-
dept_no varchar pk fk - departments.dept_no
emp_no integer pk fk - employees.emp_no
from_date date
to_date date

employees
-
emp_no integer pk
birth_date date
first_name varchar
last_name varchar
gender varchar
hire_date date

saleries
-
emp_no integer pk fk - employees.emp_no
salary integer
from_date date
to_date date

titles
-
emp_no integer pk fk - employees.emp_no
title varchar
from_date date
to_date date