-- Creating the database "comp2003" ONLY if not exists:
CREATE DATABASE IF NOT EXISTS comp2003;

/* 
NOTE:
Before start running and statement against any database,
we have to active it first (select it and put it in use).
Using the command:
USE database_name
*/

-- Select/Use/Activate the wanted database:
USE comp2003;

-- For removing (dropping) a database table ONLY if exists:
-- Drop the 'students' table (removes both the data and the structure
DROP TABLE IF EXISTS students;

/*
Creating Tables:
================
- How to create a simple table named 'students'
- The basic concepts of table structure such as:
    > column definitions
    > constraints
- Inserting data into a table without relationships
*/

/* 
Creating the Table with the following fields (columns):
(Refer to my PDF file for full details about the data types in SQL):

- student_id: 
    > The primary key of the table 
    > is set to auto-increment => will automatically generate a unique ID each time a new student is inserted into the table
- first_name and last_name: 
    > These two fields (columns) are required => using "NOT NULL" constraint to make sure these columns can't be left empty
- birthdate: Student's birthdate field (column) is also a required field (NOT NULL)
- email: The email is required and must be "unique" across all students => using "UNIQUE" constraint
- enrollment_date: This column is set to default to the current date => using "DEFAULT CURRENT_DATE" constraint

List of Constraints:
********************
- Primary Key: Ensures that student_id is unique for each student
- Not Null: Ensures certain fields like first_name, last_name, birthdate, and email can't be left empty
- Unique: Ensures no two students have the same email address
- Default: Ensures that if no enrollment_date is provided, the current date is used by default

Link: https://www.w3schools.com/sql/sql_constraints.asp
Link: https://www.w3schools.com/sql/sql_primarykey.asp
*/


-- Step 1: Create the 'students' table (using plural name by convention)
-- This table contains student information with basic constraints

-- "Constraints":
-- PRIMARY KEY => CANNOT BE EMPTY + UNIQUE
-- NOT NULL => Required field
CREATE TABLE students (
    -- student_id: Primary Key with Auto Increment (unique identifier for each student):
    student_id INT AUTO_INCREMENT PRIMARY KEY,         
    -- first_name is required (NOT NULL constraint):
    first_name VARCHAR(50) NOT NULL,                    
    -- last_name is required (NOT NULL constraint):
    last_name VARCHAR(50) NOT NULL,                     
    -- birthdate is required (NOT NULL constraint):
    birthdate DATE NOT NULL,                            
    -- email is required and must be unique (UNIQUE constraint):
    email VARCHAR(100) UNIQUE NOT NULL,               
    -- enrollment_date defaults to the current date (DEFAULT constraint):
    enrollment_date DATE DEFAULT (CURRENT_DATE)  
    -- Using parentheses with CURRENT_DATE function
    -- enrollment_date DATE DEFAULT CURRENT_DATE -- Check Note!           
);

/*
 Explanation of table structure and constraints:
 ***********************************************
 1. student_id: 
    - An auto-incremented integer used as the primary key to uniquely identify each student
 2. first_name:
    - The student's first name (required field, NOT NULL constraint)
 3. last_name:
    - The student's last name (required field, NOT NULL constraint)
 4. birthdate:
    - The student's date of birth (required field, NOT NULL constraint)
 5. email:
    - The student's email address (required, must be unique, and cannot be NULL)
 6. enrollment_date:
    - The date the student enrolled. Defaults to the current date if not specified

 Constraints Used:
 *****************
 - PRIMARY KEY: student_id uniquely identifies each student
 - NOT NULL: Ensures that certain columns (first_name, last_name, birthdate, and email) must always have a value
 - UNIQUE: Ensures the email address is unique across all students
 - DEFAULT: The enrollment_date automatically defaults to the current date if no value is specified
*/

/* 
IMPORTANT NOTE ABOUT XAMPP MariaDB and MySQL Workbench:
*******************************************************
- MariaDB of XAMPP is a fork of MySQL. Usually, it has slightly different behavior and more lenient syntax in some cases. So it's more fixable so it allows CURRENT_DATE to be used directly without parentheses for default values
-MariaDB is highly compatible with MySQL
- MariaDB Was created by the original developers of MySQL after Oracle acquired MySQL in 2008
- The name "MariaDB" was chosen in honor of Maria Widenius, the daughter of Monty Widenius, one of the original developers of MySQL

Coding in Workbench:
Running the same code with MySQL Workbench will generate error (more strict),
because we skipped the ( ). To ensure compatibility with all versions of MySQL, we need to use parentheses with function calls like CURRENT_DATE

When calling an SQL function like CURRENT_DATE,
we should use parentheses ( ) to surround the function name to avoid any errors. So function needs to be  invoked with parentheses, even though it doesn't take any arguments

By the way, to check the MySQL version:
> SELECT VERSION();
*/

/* 
"ENGINE=INNODB" in MySQL Docs?
- Just to specify which storage engine should be used for the table
- The storage engine determines how data is stored, how it is indexed, and how it is managed within the database
- InnoDB is the most commonly used storage engine in MySQL
- MySQL newer versions (from 5.5 and later) => The default storage engine is "InnoDB" 
- "INNODB" Storage Engine:
    > Support for Foreign Keys
    > ACID Implementation 
Link: https://dev.mysql.com/doc/refman/8.4/en/mysql-acid.html
*/

-- Step 2: Insert sample data into the 'students' table
-- Insert data while respecting the constraints of each field (column)

-- Insert a new student into the 'students' table
INSERT INTO students (first_name, last_name, birthdate, email)
VALUES ('Alex', 'Chow', '2000-06-10', 'alex.chow@mysqldemo.com'); 
/*  
Notice the following 2 important notes:
First:
******
We skipped the "enrollment_date" field,
so it will default to the current date based on its constraint (CURRENT_DATE will be used)

All the required fields (first_name, last_name, birthdate, and email) are provided, 
and the enrollment_date will automatically default to the current date

Second:
*******
- The UNIQUE constraint on the email field will prevent any two students from having the same email address
- If we attempt to insert another student with the same email as an existing one, MySQL will throw an error
*/

-- Insert another new student with the default enrollment date (CURRENT_DATE will be used)
INSERT INTO students (first_name, last_name, birthdate, email)
VALUES ('Sam', 'Simpson', '2001-08-21', 'sam.simpson@mysqldemo.com');
/* 
Again, the enrollment_date will be set to the current date
Only the required fields are provided, 
MySQL will set the enrollment_date to the current date
*/

-- Insert another student with required fields only (enrollment_date will be set to the current date by default)
INSERT INTO students (first_name, last_name, birthdate, email)
VALUES ('Kate', 'Wilson', '1999-04-11', 'kate.wilson@mysqldemo.com');
/* 
No need to explicitly insert the enrollment_date as it will be set by default
we only provide the required fields, and the enrollment_date will be automatically assigned the current date
*/

-- Insert a student with required fields only (enrollment_date will be set to the current date by default)
INSERT INTO students (first_name, last_name, birthdate, email)
VALUES ('Martin', 'Smith', '1998-12-04', 'martin.smith@mysqldemo.com');
-- Once again, enrollment_date will be set to the current date by default.

