CREATE DATABASE IF NOT EXISTS week05;

-- Copy the code of last week(s):
-- Department Table
-- Employees Table

-- Activate the week05 database:
USE week05;

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
    -- Links the 'employees' table to the 'departments' table    
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
-- Insert a new department into the 'departments' table:
INSERT INTO departments (department_name)
VALUES ('Human Resources');
-- Remember that We only need to provide the 'department_name' since 'department_id' auto-increment

-- Insert a new employee into the 'employees' table
INSERT INTO employees (first_name, middle_name, last_name, job_title, department_id)
VALUES ('James', 'Dean', 'Smith', 'Manager', 1);
-- Inserting a new employee. The department_id links to an existing department in the 'departments' table
-- 'hire_date' will use the default value (current date), 'is_active' will default to 1 (active)


/* 
2. UPDATE Statement – Modifying Data
The UPDATE statement is used to modify existing records in a table.
*/
-- Update an employee's job title in the 'employees' table
UPDATE employees
SET job_title = 'Senior Manager'
WHERE emp_id = 1;
-- Changing the job title of the employee with emp_id = 1 to 'Senior Manager'


-- Update an employee's department in the 'employees' table
UPDATE employees
SET department_id = 2
WHERE emp_id = 1;
-- Changing the department of the employee with emp_id = 1 to department with department_id = 2

/* 
3. DELETE Statement – Removing Data
The DELETE statement is used to remove records from a table
*/
-- Delete an employee from the 'employees' table
DELETE FROM employees
WHERE emp_id = 2;
-- Deleting the employee with emp_id = 2 from the 'employees' table

-- Delete a department from the 'departments' table
DELETE FROM departments
WHERE department_id = 3;
-- Deleting the department with department_id = 3 from the 'departments' table
/* 
NOTE:
Due to the foreign key constraint (ON DELETE SET NULL), 
employees assigned to this department will have their department_id set to NULL
*/

/* 
To recap the "Data Manipulation":

1) INSERT: Adding new records into the table
Example: Adding a new employee or department

2) UPDATE: Modifying existing records
Example: Changing an employee's job title or department

3) DELETE: Removing records from the table
Example: Deleting an employee or department
*/