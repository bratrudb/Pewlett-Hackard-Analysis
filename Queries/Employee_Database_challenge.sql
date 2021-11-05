--Pull employee name, number, title, and timeline of title into retirement_titles
SELECT e.emp_no, 
	e.first_name, 
	e.last_name,
	ti.title,
	ti.from_date,
	ti.to_date
INTO retirement_titles
FROM employees as e
LEFT JOIN titles as ti
ON e.emp_no = ti.emp_no
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no;

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) 
	emp_no,
	first_name,
	last_name,
	title
INTO unique_titles
FROM retirement_titles
ORDER BY emp_no, to_date DESC;

--Table with count of each number of positions retiring
SELECT COUNT(ut.title), ut.title
INTO retiring_titles
FROM unique_titles as ut
GROUP BY ut.title
ORDER BY COUNT(ut.title) DESC;

--Pull employee name, number, birth date, to and from dates, and title into mentorship eligibility file
SELECT DISTINCT ON (e.emp_no) 
	e.emp_no,
	e.first_name, 
	e.last_name,
	e.birth_date,
	de.from_date,
	de.to_date,
	ti.title
INTO mentorship_eligibility
FROM employees as e
LEFT JOIN dept_emp as de
	ON (e.emp_no = de.emp_no)
LEFT JOIN titles as ti
	ON (e.emp_no = ti.emp_no)
WHERE (de.to_date = '9999-01-01')
	AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY e.emp_no;



--How many roles will need to be filled as the "silver tsunami" begins to make an impact?
--Find Begining of Silver Tsunami
SELECT DISTINCT ON (e.emp_no)
	e.first_name, 
	e.last_name,
	ti.title,
	ti.from_date,
	ti.to_date
INTO silver_wave_start
FROM employees as e
LEFT JOIN titles as ti
ON e.emp_no = ti.emp_no
WHERE (birth_date BETWEEN '1952-01-01' AND '1952-12-31')
ORDER BY e.emp_no;

--Select 1952 positions retiring
SELECT COUNT(sw.title), sw.title
INTO silver_wave_titles
FROM silver_wave_start as sw
GROUP BY sw.title
ORDER BY COUNT(sw.title) DESC;

SELECT SUM(count) FROM silver_wave_titles;

--Are there enough qualified, retirement-ready employees in the departments to mentor the next generation of Pewlett Hackard employees?
--Pull employee name, number, and department into retirement department
SELECT DISTINCT ON (e.emp_no)
	e.emp_no,
	e.first_name, 
	e.last_name,
	de.dept_no,
	d.dept_name
INTO retirement_departments
FROM employees as e
LEFT JOIN dept_emp as de
	ON e.emp_no = de.emp_no
LEFT JOIN departments as d
	On de.dept_no = d.dept_no
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no;

--Sort by departments
SELECT COUNT(rd.dept_name) as "retiree_count", 
	rd.dept_name
INTO  retiring_departments
FROM retirement_departments as rd
GROUP BY rd.dept_name;

--Pull in mentee department
SELECT COUNT(me.emp_no) as "mentee_count",
	d.dept_name
INTO mentee_departments
FROM mentorship_eligibility as me
LEFT JOIN dept_emp as de
	ON me.emp_no = de.emp_no
LEFT JOIN departments as d
	On de.dept_no = d.dept_no
GROUP BY d.dept_name;

--Merge mentee and retiree department counts
SELECT 
	rd.dept_name,
	rd.retiree_count,
	md.mentee_count
INTO mentorship_comparison
FROM retiring_departments as rd
LEFT JOIN mentee_departments as md
ON rd.dept_name = md.dept_name
ORDER BY dept_name;