CREATE TABLE IF NOT EXISTS departments (
    -- Unique ID for the department (AUTO_INCREMENT makes it automatically increment starting from 1):
    department_id INT PRIMARY KEY AUTO_INCREMENT,   
    -- Name of the department (NOT NULL => required field):
    department_name VARCHAR(100) NOT NULL           
);

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

-- Foreign Key Review:
-- *******************
--- Our Example with a name:
-- CONSTRAINT fk_department FOREIGN KEY (department_id) REFERENCES departments(department_id)
--- Check this example when we omit the name (will also works):
-- FOREIGN KEY (department_id) REFERENCES departments(department_id)

-- Simple Examples of "INDEX":
/*
Let's assume that we want create an index on the last_name column
to speed up searches based on the last name.

Indexes help speed up search queries that involve the 'last_name' column.

NOTE TO CONSIDER:
While indexes make read operations faster, 
they can slow down write operations (like INSERT, UPDATE, and DELETE) 
because the index also needs to be updated.
*/
*/
-- Create an index to speed up searches on the 'last_name' column
CREATE INDEX idx_last_name ON employees(last_name);
/* 
Notice that:
- This will create an index called "idx_last_name" on the last_name column of the employees table
- If we search for employees by their last name, the database can find them faster
*/

/* 
Reviewing naming convention:
****************************
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

To summarize:
************
When adding a new column with a constraint like "NOT NULL",
MySQL may not be able to apply the constraint to existing rows that have NULL values in that column!
It's often safer to add a column with NULL allowed first, 
then update the existing rows, and finally apply the NOT NULL constraint.
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

Example usage of "LIKE" with wildcards:
SELECT * FROM employees WHERE last_name LIKE 'Smi%'; 
-- This will find all employees whose last name starts with 'Smi'
Ex: 'Smith', 'Smiley'

SELECT * FROM employees WHERE first_name LIKE '_a%'; 
-- This will find all employees whose first name starts with any character followed by 'a' 
Ex: 'Kate', 'Sam'
*/

