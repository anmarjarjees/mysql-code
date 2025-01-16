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

-- Step 1: Create the 'departments' table
-- This table contains basic information about departments, including a unique department ID

CREATE TABLE departments (
    -- Unique ID for the department (AUTO_INCREMENT makes it automatic):
    department_id INT PRIMARY KEY AUTO_INCREMENT,   
    -- Name of the department (required field):
    department_name VARCHAR(100) NOT NULL           
);


-- Step 2: Create the 'employees' table
-- This table contains employees details, with several constraints applied.

CREATE TABLE employees (
    -- emp_id as Primary Key with Auto Increment (unique identifier for each employee):
    emp_id INT AUTO_INCREMENT PRIMARY KEY,
     -- First name is required (NOT NULL constraint):          
    first_name VARCHAR(50) NOT NULL,  
    -- Middle name is optional (can be NULL):              
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
    
    -- Creating The Foreign Key constraint:
    -- Links the 'employees' table to the 'departments' table    
    CONSTRAINT fk_department  -- Giving the foreign key a name                        
        FOREIGN KEY (department_id) REFERENCES departments(department_id)
        -- If a department is deleted, set the department_id to NULL for employees:
        ON DELETE SET NULL,                          
    CONSTRAINT chk_job_title CHECK (job_title <> ''),  
    -- CHECK (job_title <> '') => Ensures that job title is not empty
    CONSTRAINT unique_employee UNIQUE (first_name, last_name)  
    -- UNIQUE (first_name, last_name) => Ensures unique combinations of first and last name
);

/* 
IMPORTANT NOTES:
================
First:
******
In this example, we are naming the constraints like foreign keys, checks, and unique.

It's not mandatory to give a name to a foreign key constraint in MySQL,
If we don't specify a name, MySQL will automatically generate a name for us,
but it's considered a best practice to do so (as explained below)

Second:
*******
Also notice that "ON DELETE SET NULL" is not mandatory 
when defining a foreign key constraint in MySQL! (as explained below)


Notice that the naming conventions like: fk_, pk_, chk_, unique_
are often used in database design to clearly identify the type or purpose of a constraint
also:
- idx_ for "Index"
- trg_ for "Trigger"

Summary:
********
fk_: Foreign Key Constraint
pk_: Primary Key Constraint
chk_: Check Constraint
unique_: Unique Constraint
idx_: Index
    > like a table of contents in a book
    > it helps speed up searches in a database by allowing the system to quickly find the data without scanning the entire table
    > is helpful when you frequently search, filter, or sort data in large tables
trg_: Trigger
    >  automatic action that the database performs when something happens like inserting a new record

Notice that "fk_department" => refers to a single entity from the referenced table,
So it's more common to use the singular form for the name of the foreign key, 
even though the table name is plural

Link: https://www.w3schools.com/sql/sql_foreignkey.asp
Link: https://dev.mysql.com/doc/refman/8.4/en/create-table-foreign-keys.html
Link: https://dev.mysql.com/doc/refman/8.4/en/example-foreign-keys.html
Link: https://dev.mysql.com/doc/refman/8.4/en/trigger-syntax.html
*/

-- Simple Examples of "INDEX":
/*
Let's assume that we want create an index on the last_name column
to speed up searches based on the last name:
*/
-- Create an index to speed up searches on the 'last_name' column
CREATE INDEX idx_last_name ON employees(last_name);
/* 
Notice that:
- This will create an index called "idx_last_name" on the last_name column of the employees table
- If we search for employees by their last name, the database can find them faster
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
-- Foreign Key Review:
# Our Example with a name:
-- CONSTRAINT fk_department FOREIGN KEY (department_id) REFERENCES departments(department_id)
# Check this example when we omit the name (will also works):
-- FOREIGN KEY (department_id) REFERENCES departments(department_id)

/*
Naming the Check and Unique Constraints:
****************************************
Also, it's not strictly necessary to assign names to these constraints!
But for the same reasons:
- For Clarity: 
A meaningful name like "chk_job_title" makes it clear that the constraint checks the job_title field for non-empty values
- For Maintenance Purposes:
When modifying or troubleshooting the table, it's much easier to refer to constraints with descriptive names rather than the default auto-generated long names
*/

-- job_title review:
# Our Example with a name: 
-- CONSTRAINT chk_job_title CHECK (job_title <> ''), 
# Without a name:
-- CHECK (job_title <> '')

/* 
To recap:
- If you don't name the constraints, MySQL will automatically generate names for them
- Auto-generated names might be non-descriptive like as the name we pick :-)
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


/* 
Database Table Relationship:
****************************
In this example of Employees and departments, we have "one-to-many relationship":
- The parent table "departments" contains the main data (departments), 
with each department having a unique identifier => a primary key "department_id"
- The child table "employees" contains records that reference the parent table’s primary key. Each employee has a department_id that associates them with a department
*/

-- ===================================
-- Step 3: Insert sample data into the 'employees' table

-- Insert a new employee into the 'employees' table
INSERT INTO employees (first_name, middle_name, last_name, job_title, department_id)
VALUES ('John', 'A.', 'Doe', 'Software Developer', 1);

-- Insert a new employee with a custom hire date and status
INSERT INTO employees (first_name, middle_name, last_name, job_title, hire_date, is_active, department_id)
VALUES ('Jane', 'B.', 'Smith', 'Project Manager', '2025-01-01', 0, 2);

-- Insert a new employee with only required fields (defaults will be applied)
INSERT INTO employees (first_name, last_name, job_title, department_id)
VALUES ('Alice', 'Johnson', 'HR Manager', 3);


/* 
Modifying Table Structure:
**************************
 */
-- Step 4: Modify the 'employees' table using the ALTER statement
-- Adding new fields (columns) and constraints to an existing table:

-- Add an 'email' column to the 'employees' table
ALTER TABLE employees
ADD COLUMN email VARCHAR(100) NOT NULL UNIQUE;  
-- Enforce uniqueness and NOT NULL constraint for email

-- Add a CHECK constraint to ensure the email is in a valid format (simple example)
ALTER TABLE employees
ADD CONSTRAINT chk_email CHECK (email LIKE '%@%.%'); 
/* 
 CHECK: Enforces conditions: => :
    > "email" cannot be empty
    > "email" must follow a basic pattern
    > "email" must contain contains '@' and '.'
*/ 

/*
MySQL Wildcards:
****************
- Are special characters that represent one or more characters in a string
- They are used with the LIKE operator to create flexible search patterns

- % (percent symbol) => Represents zero or more characters
- _ (underscore): Represents exactly one character

Notice that:
> "_" in MySQL is exactly the same as "?" in Microsoft Access
> "%" in MySQL is exactly the same as "*" in Microsoft Access

"LIKE" and "WHERE":
- LIKE operator => is used to search for a specified pattern in a column
- WHERE clause => to filter records (rows) based on a pattern match in string data
*/


/* 
Removing a Table:
*****************
*/
-- Step 5: Drop the 'employees' and 'departments' tables
-- Deleting table(s) from the database:

-- Drop the 'employees' table (removes both the data and the structure)
DROP TABLE IF EXISTS employees;

-- Drop the 'departments' table
DROP TABLE IF EXISTS departments;