-- EXAMPLE#3: employees table (Another advanced version):
-- ******************************************************
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
    
    -- The Foreign Key Constraint:
    CONSTRAINT fk_department                         
        FOREIGN KEY (department_id) REFERENCES departments(department_id)
        -- If a department is deleted, set the department_id to NULL for employees:
        ON DELETE SET NULL, 

    -- Giving the CHECK() function a constraint name "chk_job_title"                                  
    CONSTRAINT chk_job_title CHECK (job_title <> ''),  
    -- CHECK (job_title <> '') => Ensures that job title is not empty

    -- Giving the UNIQUE() function a constraint name "unique_employee" 
    CONSTRAINT unique_employee UNIQUE (first_name, last_name)  
    -- UNIQUE (first_name, last_name) => Ensures unique combinations of first and last name
);

/* 
To review:
In this example, we are also naming the constraints like: checks, and unique.

It's not mandatory to give a name to a constraint in MySQL,
but it's considered a best practice to do so (as explained below)

Notice that the naming conventions like: pk_, chk_, unique_
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
We can insert multiple rows in one insert statement:
*/
INSERT INTO employees (first_name, middle_name, last_name, job_title, hire_date, is_active, department_id)
VALUES 
    ('Steve', 'Almond.', 'Warner', 'Software Developer', NULL, 1, 1),
    ('Martin', 'Bolder', 'Smith', 'Project Manager', '2024-08-22', 0, 2),
    ('Martin', NULL, 'Smith', 'HR Manager', NULL, 1, 3);

/* 
Modifying Table Structure:
**************************
 */
-- Step 4: Modify the 'employees' table using the ALTER statement
-- Adding new fields (columns) and constraints to an existing table:

-- Add an 'email' column to the 'employees' table
-- First Approach: Adding the email Column with "NOT NULL" and "UNIQUE"
-----------------------------------------------------------------------
ALTER TABLE employees
ADD COLUMN email VARCHAR(100) NOT NULL UNIQUE;  
-- Enforce uniqueness and NOT NULL constraint for email

/* 
IMPORTANT NOTE TO CONSIDER:
- Adding a "NOT NULL" constraint to the email column will fail if the table already contains data.
- This is because MySQL will try to insert a "NULL" value into the new email field for the existing rows, 
  violating the NOT NULL constraint.
- To avoid this error, we need to handle the existing rows before enforcing the "NOT NULL" constraint.
*/

-- Second Approach: Safer and Step-by-Step handling Existing Rows with "NULL"
-----------------------------------------------------------------------------
-- Step 1: Add the email column with NULL allowed:
ALTER TABLE employees
-- This allows existing rows to have "NULL" values in the email column:
ADD COLUMN email VARCHAR(100) NULL;

-- Step 2 (optional for later): After populating the email column, you can enforce the "NOT NULL" and "UNIQUE" constraints
-- Now you can safely enforce the "NOT NULL" constraint (after populating the email field):
ALTER TABLE employees
MODIFY COLUMN email VARCHAR(100) NOT NULL;

-- Step 3: Add the UNIQUE constraint (if needed) to ensure no duplicate email addresses:
ALTER TABLE employees
ADD CONSTRAINT unique_email UNIQUE (email);

-- Add a CHECK constraint to ensure the email is in a valid format (simple example)
ALTER TABLE employees
ADD CONSTRAINT chk_email CHECK (email LIKE '%@%.%'); 
/* 
 CHECK: Enforces conditions:
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
--NOTE: If the table exists, it will be dropped; if not, no error is thrown because of "IF EXISTS"

/* 
Notice the phrase "IF EXISTS" to avoid errors if the table does not exist.
This is a safety measure to ensure no error is thrown when attempting to drop a non-existent table.
*/

-- Drop the 'departments' table (removes both the data and the structure)
DROP TABLE IF EXISTS departments;

-- IMPORTANT NOTE:
-- Once a table is dropped, it is permanently removed from the database, including its data and structure.
-- Be sure to have a backup if you want to recover the table later.