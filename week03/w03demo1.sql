/*
 Introducing the concept of relations using "PRIMARY KEY" with "FOREIGN KEY" fields:
 ===================================================================================
 - Creating two tables: 'employees' and 'departments'
    > 'departments' table is the parent table
    > 'employees' table is the child table
 - Adding various constraints (PRIMARY KEY, FOREIGN KEY, NOT NULL, UNIQUE, CHECK, DEFAULT)
 - Including examples of how to:
    > insert data
    > modify tables
    > drop them
*/

-- CREATE DATABASE IF NOT EXISTS comp2003;
USE comp2003;

-- Or creating a new database "week03"
CREATE DATABASE IF NOT EXISTS week03;
-- Optioanl => IF NOT EXISTS
-- Primary Key => id 
-- field (columns) => data type 

-- Select the database that we want to interact with?
USE week03;

-- Step 1: Create the 'departments' table
-- This table contains basic information about departments, including a unique department ID
-- Notice "IF NOT EXISTS" to avoid the error if this table is already exists:
CREATE TABLE IF NOT EXISTS departments (
    -- Unique ID for the department (AUTO_INCREMENT makes it automatically increment starting from 1):
    department_id INT PRIMARY KEY AUTO_INCREMENT,   
    -- Name of the department (NOT NULL => required field):
    department_name VARCHAR(100) NOT NULL           
);

/*
To review:
- Datatype => are required (cannot be ignored)
- constraints  => are extra rules that we should add
*/

/*
- PK <==> FK 
*/

-- Step 2: Create the 'employees' table
-- This table contains employees details, with several constraints applied.

-- EXAMPLE#1: employees table (simplified version):
-- ************************************************
CREATE TABLE IF NOT EXISTS employees (
    -- emp_id as Primary Key with Auto Increment (unique identifier for each employee):
    emp_id INT AUTO_INCREMENT PRIMARY KEY,
     -- First name is required (NOT NULL constraint):          
    first_name VARCHAR(50) NOT NULL,  
    -- Middle name is optional (Optional => can be NULL):              
    middle_name VARCHAR(50), 
    -- Last name is required (NOT NULL constraint)                        
    last_name VARCHAR(50) NOT NULL,  
    -- Job title is required (NOT NULL constraint):                
    job_title VARCHAR(50) NOT NULL,                  
    hire_date DATE DEFAULT CURRENT_DATE, 
    -- Default value is the current date (DEFAULT constraint):            
    is_active TINYINT(1) DEFAULT 1, 
    -- Using TINYINT(1) for boolean values (1 for TRUE, 0 for FALSE):                 
    department_id INT,                               
    -- Notice that "department_id" is a "Foreign Key" referencing the 'departments' table
    
    -- The Foreign Key constraint:
    -- Links the 'employees' table to the 'departments' table 
    -- one line to set the FK and make the connection with PK of other table   
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- Dropping the table "employees" to create it again with more advanced statement
DROP TABLE IF EXISTS employees;

-- EXAMPLE#2: employees table (advanced version):
-- **********************************************
-- using CHECK constraints and the UNIQUE constraint:
CREATE TABLE employees (
    emp_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,  
    middle_name VARCHAR(50), 
    last_name VARCHAR(50) NOT NULL,  
    job_title VARCHAR(50) NOT NULL,                  
    hire_date DATE DEFAULT CURRENT_DATE, 
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
IMPORTANT NOTES:
================
First:
******
In this example, we are naming the constraints like foreign key: "fk_department"

It's not mandatory to give a name to a foreign key constraint in MySQL,
If we don't specify a name, MySQL will automatically generate a name for us,
but it's considered a best practice to do so (as explained below)

Second:
*******
Also notice that "ON DELETE SET NULL" is not mandatory 
when defining a foreign key constraint in MySQL! (as explained below)


Notice that the naming conventions like: fk_, pk_

Summary:
********
fk_: Foreign Key Constraint
pk_: Primary Key Constraint

Notice that "fk_department" => refers to a single entity from the referenced table,
So it's more common to use the singular form for the name of the foreign key, 
even though the table name is plural

Link: https://www.w3schools.com/sql/sql_foreignkey.asp
Link: https://dev.mysql.com/doc/refman/8.4/en/create-table-foreign-keys.html
Link: https://dev.mysql.com/doc/refman/8.4/en/example-foreign-keys.html
*/

/*
Naming the Foreign Key:
***********************
Naming foreign keys (and other constraints) is considered a best practice:
- For Clarity: 
Giving meaningful names to constraints makes our schema more readable and easier to understand
- For Maintenance Purposes:
If we need to modify or drop a constraint later, will be much easier to refer to the constraint by its meaningful name that we created rather than relying on the automatically generated name (could be a long random string!)
*/

/* 
Explanation of "ON DELETE":
***************************
When you define a "Foreign Key" constraint between two tables, 
we have the options for how to handle the deletion of a record in the parent table
(in our case, the "departments" table) that is being referenced by records 
in the child table (the "employees" table):

- ON DELETE CASCADE:
CASCADE: Delete or update the row from the parent table and automatically delete or update the matching rows in the child table. all related records in the child table will be deleted when the referenced record in the parent table is deleted

- ON DELETE RESTRICT => "default if not specified":
RESTRICT: Rejects the delete or update operation for the parent table. Specifying RESTRICT (or NO ACTION) is the same as omitting the ON DELETE or ON UPDATE clause. It will restrict the deletion of a parent record if it is still referenced by any child records

- ON DELETE NO ACTION
NO ACTION: A keyword from standard SQL. For InnoDB, this is equivalent to RESTRICT; the delete or update operation for the parent table is immediately rejected if there is a related foreign key value in the referenced table. It means no action will be taken, and if there are dependent child records, the delete operation will be blocked

MySQL Docs "Referential Actions":
Link: https://dev.mysql.com/doc/refman/8.4/en/create-table-foreign-keys.html#foreign-key-referential-actions
*/

-- ===================================
-- Step 3: Insert sample data into 'department' table and 'employees' table

-- inserting/adding two departments
INSERT INTO departments (department_name)
VALUES ('IT'); -- with id 1 (auto-increment)
INSERT INTO departments (department_name)
VALUES ('HR'); -- with id 2 (auto-increment)

-- Insert a new employee into the 'employees' table
-- inserting/adding 1 employee:
INSERT INTO employees (first_name, last_name, job_title, department_id)
VALUES ('Alex', 'Chow', 'Software Developer', 1);

-- Insert a new employee with a custom hire date and status
INSERT INTO employees (first_name, middle_name, last_name, job_title, hire_date, is_active, department_id)
VALUES ('Kate', 'Bean', 'Wilson', 'Project Manager', '2025-01-01', 0, 1);

-- Insert a new employee with only required fields (defaults will be applied)
INSERT INTO employees (first_name, last_name, job_title, department_id)
VALUES ('James', 'Dean', 'HR Manager', 2);

-- inserting/adding multiple employees (records/rows):
INSERT INTO employees (first_name, middle_name, last_name, job_title, department_id)
VALUES 
('Alba', NULL, 'Chows', 'Software Developer', 1),
('Sam', NULL, 'Simpson', 'HR Manager', 2),
('Sara', 'James','Grays', 'Network Admin', 1);
/* 
 If we want to use the default value (like hire_date or is_active) or for optional fields:
 > we can use "NULL" or omit the column 
 But notice that in the example above, we kept all the column names to show what values we are inserting.
*/

/* 
Database Table Relationship:
****************************
In this example of Employees and departments, we have "one-to-many relationship":
- The parent table "departments" contains the main data (departments), 
with each department having a unique identifier => a primary key "department_id"
- The child table "employees" contains records that reference the parent table’s primary key. Each employee has a department_id that associates them with a department
*/
SELECT * FROM departments;
SELECT * FROM employees;
