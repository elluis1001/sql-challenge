-----Data Engineering-----
----Drop tables----:
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS dept_emp;
DROP TABLE IF EXISTS dept_manager;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS salaries;
DROP TABLE IF EXISTS titles;

-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/lHnFr7
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


CREATE TABLE "departments" (
    "dept_no" VARCHAR   NOT NULL,
    "dept_name" VARCHAR   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "dept_emp" (
    "emp_no" int   NOT NULL,
    "dept_no" VARCHAR   NOT NULL
);

CREATE TABLE "dept_manager" (
    "dept_no" VARCHAR   NOT NULL,
    "emp_no" int   NOT NULL
);

CREATE TABLE "employees" (
    "emp_no" int   NOT NULL,
    "enp_title_id" VARCHAR   NOT NULL,
    "birth_date" date   NOT NULL,
    "first_name" VARCHAR   NOT NULL,
    "last_name" VARCHAR   NOT NULL,
    "sex" VARCHAR   NOT NULL,
    "hire_date" date   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "salaries" (
    "emp_no" int   NOT NULL,
    "salary" int   NOT NULL
);

CREATE TABLE "titles" (
    "title_id" VARCHAR   NOT NULL,
    "title" VARCHAR   NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "title_id"
     )
);

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_enp_title_id" FOREIGN KEY("enp_title_id")
REFERENCES "titles" ("title_id");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");


-----Data Analysis-----
---1. List the employee number, last name, first name, sex, and salary of each employee.
SELECT 
	employees.emp_no, 
	employees.last_name, 
	employees.first_name, 
	employees.sex, 
	salaries.salary
FROM 
	employees
JOIN 
	salaries
ON 
	employees.emp_no = salaries.emp_no;

---2. List the first name, last name, and hire date for the employees who were hired in 1986.
SELECT last_name, first_name, hire_date
FROM employees
WHERE hire_date BETWEEN '1/1/1986' AND '12/31/1986'
ORDER BY hire_date;

---3.  List the manager of each department along with their department number, department name, employee number, last name, and first name.
SELECT 
	departments.dept_no, 
	departments.dept_name, 
	dept_manager.emp_no, 
	employees.last_name, 
	employees.first_name
FROM departments
JOIN dept_manager
ON 
	departments.dept_no = dept_manager.dept_no
JOIN employees
ON 
	dept_manager.emp_no = employees.emp_no;

---4. List the department number for each employee along with that employee’s employee number, last name, first name, and department name. 
SELECT 
	dept_emp.emp_no, 
	employees.last_name, 
	employees.first_name, 
	departments.dept_name
FROM 
	dept_emp
JOIN 
	employees
ON 
	dept_emp.emp_no = employees.emp_no
JOIN 
	departments
ON 
	dept_emp.dept_no = departments.dept_no;

---5. List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.
SELECT 
	employees.first_name, 
	employees.last_name, 
	employees.sex
FROM 
	employees
WHERE 
	first_name = 'Hercules' AND last_name LIKE 'B%';
	
---6. List each employee in the Sales department, including their employee number, last name, and first name.
SELECT 
	departments.dept_name, 
	employees.emp_no, 
	employees.last_name, 
	employees.first_name
FROM
	dept_emp
JOIN
	employees
ON
	dept_emp.emp_no = employees.emp_no
JOIN
	departments
ON 
	dept_emp.dept_no = departments.dept_no
WHERE
	departments.dept_name = 'Sales';

---7. List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name. 
SELECT 
	departments.dept_name, 
	employees.emp_no, 
	employees.last_name, 
	employees.first_name
FROM
	dept_emp
JOIN
	employees
ON
	dept_emp.emp_no = employees.emp_no
JOIN
	departments
ON 
	dept_emp.dept_no = departments.dept_no
WHERE
	departments.dept_name IN ('Sales', 'Development');

---8.  List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).
SELECT
	last_name,
		COUNT
			(last_name) AS "frequency"
FROM
	employees
GROUP BY
	last_name
ORDER BY
	COUNT
		(last_name) DESC;