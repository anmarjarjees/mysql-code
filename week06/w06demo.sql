CREATE DATABASE IF NOT EXISTS week06;

-- Copy the code of last week(s):
-- Department Table
-- Employees Table

-- Activate the week05 database:
USE week06;

-- Parent table:
CREATE TABLE IF NOT EXISTS departments (
    -- Unique ID for the department (AUTO_INCREMENT makes it automatically increment starting from 1):
    department_id INT PRIMARY KEY AUTO_INCREMENT,   
    -- Name of the department (NOT NULL => required field):
    department_name VARCHAR(100) NOT NULL           
);

-- Child table:
CREATE TABLE employees (
    emp_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,  
    middle_name VARCHAR(50), 
    last_name VARCHAR(50) NOT NULL,  
    job_title VARCHAR(50) NOT NULL,                  
    hire_date DATE DEFAULT CURRENT_TIMESTAMP, 
    is_active TINYINT(1) DEFAULT 1, 
    department_id INT,                               
    
    -- Creating The Foreign Key constraint:
    -- Links the "employees" table to the "departments" table    
    -- Giving the foreign key a constraint name "k_department"
	CONSTRAINT fk_department
        FOREIGN KEY (department_id) REFERENCES departments(department_id)
        -- If a department is deleted, set the department_id to NULL for employees:
	ON DELETE SET NULL
);


/* 
1. INSERT Statement – Adding Data to Tables
The INSERT statement is used to add new records (rows) into a table
*/
-- Insert a new department into the "departments" table:
INSERT INTO departments (department_name)
VALUES ('Human Resources');
-- Remember that We only need to provide the "department_name" since "department_id" auto-increment

-- Insert a new employee into the "employees" table
INSERT INTO employees (first_name, middle_name, last_name, job_title, department_id)
VALUES
('Steve', 'Almond', 'Warner', 'Manager', 1),          
('Martin', 'Bolder', 'Smith', 'Developer', 2),         
('Martin', NULL, 'Smith', 'Sales Rep', 3),              
('Sarah', NULL, 'Grays', 'Sales Rep', 3),            
('Alex', NULL, 'Chow', 'Manager', 2),                 
('Kate', NULL, 'Wilson', 'Developer', 2),             
('Sam', 'Son', 'Simpson', 'Developer', 1),              
('Dean', NULL, 'Martin', 'Manager', 2);                 

/* 
Reviewing the select statement with more new and advanced options:
*/
-- SELECT Statement – Retrieving All Data from a Table
-- This query retrieves all columns from the "employees" table.
-- It shows every employee's details.
SELECT * 
FROM employees;

-- SELECT Statement with WHERE Clause – Filtering Data
-- This query filters employees who belong to the "Human Resources" department (department_id = 1).
SELECT first_name, last_name, job_title 
FROM employees 
WHERE department_id = 1;

-- Using Wildcards – The LIKE Operator
-- This query finds all employees whose last name starts with "S".
-- The "%" symbol is a wildcard that represents any sequence of characters.
SELECT first_name, last_name, job_title 
FROM employees
WHERE last_name LIKE 'S%';

-- Using Logical Operators (AND, OR)
-- This query retrieves employees who either work in "Human Resources" (department_id = 1)
-- or have the job title "Manager".
SELECT first_name, last_name, job_title 
FROM employees
WHERE department_id = 1 OR job_title = 'Manager';

-- Combining AND with OR
-- This query retrieves employees who either work in "Human Resources" and are active 
-- (is_active = 1), or have the job title "Manager" and are active.
SELECT first_name, last_name, job_title
FROM employees
WHERE (department_id = 1 AND is_active = 1)
OR (job_title = 'Manager' AND is_active = 1);

-- Using NOT with WHERE Clause – Negation
-- This query retrieves employees who are NOT in "Human Resources" (department_id != 1).
SELECT first_name, last_name, job_title
FROM employees
WHERE department_id != 1;

-- Selecting a specific employee by last name
SELECT * FROM employees WHERE last_name = 'Smith';

-- SELECT with "BETWEEN" – Range Filtering
-- This query finds employees hired between 2020-01-01 and 2021-12-31.
SELECT first_name, last_name, hire_date 
FROM employees
WHERE hire_date BETWEEN '2020-01-01' AND '2021-12-31';

-- Using "IN" to Filter Multiple Values
-- This query retrieves employees whose department_id is either 1 or 2 (can be modified for other departments).
SELECT first_name, last_name, department_id 
FROM employees
WHERE department_id IN (1, 2);

-- SELECT with "ORDER BY" – Sorting Data
-- This query sorts employees by their last name in ascending order.
SELECT first_name, last_name, department_id 
FROM employees
ORDER BY last_name ASC;

-- SELECT with "ORDER BY" – Sorting Data in Descending Order
-- This query sorts employees by hire_date in descending order (most recent hires first).
SELECT first_name, last_name, hire_date 
FROM employees
ORDER BY hire_date DESC;

-- COUNT() Function – Counting Records
-- This query counts how many employees are there in each department (grouped by department_id).

SELECT department_id, COUNT(*) AS employee_count
FROM employees
GROUP BY department_id;

-- UPDATE Statement – Modifying Data
-- This query updates the job title of employee with emp_id = 1 to "Senior Manager".
UPDATE employees
SET job_title = 'Senior Manager'
WHERE emp_id = 1;

-- DELETE Statement – Deleting Data
-- This query deletes the employee with emp_id = 1 from the "employees" table.
DELETE FROM employees
WHERE emp_id = 1;

-- SELECT with "IS NULL"
-- This query retrieves all employees who do not belong to any department (department_id is NULL).
SELECT first_name, last_name, job_title
FROM employees
WHERE department_id IS NULL;

-- -----------------------------------
-- The demonstrate different types of joins.

-- INNER JOIN Example:
-- The INNER JOIN returns only the rows where there is a match in both tables.
-- If there is no match, those rows are excluded from the result set.
-- In this case, we are joining the "employees" table with the "departments" table on the "department_id".
-- Only employees who are assigned to a department will appear in the result.

-- Using INNER JOIN to combine employees with their department names
SELECT e.first_name, e.last_name, d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id;

-- JOIN Query with WHERE Clause
-- This query retrieves employees who work in "Human Resources" and shows their department name.
SELECT e.first_name, e.last_name, d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE d.department_name = 'Human Resources';

-- LEFT JOIN Example:
-- The LEFT JOIN returns all rows from the left table (employees), and matching rows from the right table (departments).
-- If an employee does not have a matching department, the department columns will contain NULL values.
-- This is useful when you want to retrieve all employees, even those who might not belong to any department.

-- Using LEFT JOIN to combine employees with their department names (including employees without a department)
SELECT e.first_name, e.last_name, d.department_name
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id;

-- RIGHT JOIN Example:
-- The RIGHT JOIN returns all rows from the right table (departments), and matching rows from the left table (employees).
-- If a department does not have any employees, the employee columns will contain NULL values.
-- This is useful when you want to ensure you retrieve all departments, even those without any employees.

-- Using RIGHT JOIN to combine employees with their department names (including departments without any employees)
SELECT e.first_name, e.last_name, d.department_name
FROM employees e
RIGHT JOIN departments d ON e.department_id = d.department_id;

-- FULL OUTER JOIN Example:
-- The FULL OUTER JOIN returns all rows from both tables.
-- Where there is no match, NULL values will be shown for the columns of the table without a match.
-- FULL OUTER JOIN is not supported in MySQL, but you can simulate it by combining LEFT JOIN and RIGHT JOIN with UNION.

-- Using FULL OUTER JOIN to combine employees with departments (including all employees and departments)
-- This is simulated in MySQL by using LEFT JOIN and RIGHT JOIN together with UNION.
SELECT e.first_name, e.last_name, d.department_name
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id
UNION
SELECT e.first_name, e.last_name, d.department_name
FROM employees e
RIGHT JOIN departments d ON e.department_id = d.department_id;

-- -----------------------
-- Summary of JOIN Types:

-- INNER JOIN: 
-- - Returns only the rows where there is a match in both tables.
-- - Example: Combining employees with their departments (only showing employees assigned to departments).

-- LEFT JOIN:
-- - Returns all rows from the left table and matching rows from the right table.
-- - If no match is found, the right table's columns contain NULL values.
-- - Example: Including all employees, even if they don't belong to a department.

-- RIGHT JOIN:
-- - Returns all rows from the right table and matching rows from the left table.
-- - If no match is found, the left table's columns contain NULL values.
-- - Example: Including all departments, even if they have no employees.

-- FULL OUTER JOIN:
-- - Returns all rows from both tables, including those without matches.
-- - If no match is found in one table, the corresponding columns will contain NULL values.
-- - In MySQL, we can simulate it by using a combination of LEFT JOIN and RIGHT JOIN with UNION.