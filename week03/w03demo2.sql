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


    -- CHECK constraint ensures that the 'job_title' is not empty:
    -- This prevents employees from being assigned a job title with an empty string value.
    -- Giving the CHECK() function a constraint name "chk_job_title"                                  
    CONSTRAINT chk_job_title CHECK (job_title <> ''),  
    -- CHECK (job_title <> '') => Ensures that job title is not empty

    -- UNIQUE constraint ensures that the combination of first and last name is unique
    -- This means no two employees can have the exact same first and last name.
    -- Giving the UNIQUE() function a constraint name "unique_employee" 
    CONSTRAINT unique_employee UNIQUE (first_name, last_name)  
    -- UNIQUE (first_name, last_name) => Ensures unique combinations of first and last name
);

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
--# Our Example with a name: 
-- CONSTRAINT chk_job_title CHECK (job_title <> ''), 
--# Without a name:
-- CHECK (job_title <> '')

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

/* 
To recap:
- If you don't name the constraints, MySQL will automatically generate names for them
- Auto-generated names might be non-descriptive like as the name we pick :-)
*/

/* 
To review "Inserting multiple rows at once": 
> You can insert several rows in a single statement to save time.
> Notice that some fields are set to "NULL" ('hire_date'), 
which will use the default value (CURRENT_DATE).
> Also, we can omit optional fields (like middle_name) when inserting data.
*/
INSERT INTO employees (first_name, middle_name, last_name, job_title, hire_date, is_active, department_id)
VALUES 
    ('Steve', 'Almond.', 'Warner', 'Software Developer', NULL, 1, 1),
    ('Martin', 'Bolder', 'Smith', 'Project Manager', '2024-08-22', 0, 2),
    ('Martin', NULL, 'Smith', 'HR Manager', NULL, 1, 3);


-- Drop the 'employees' and 'departments' tables
-- Drop the 'employees' table (removes both the data and the structure)
DROP TABLE IF EXISTS employees;  
-- Remember: If the table exists, it will be dropped; if not, no error is thrown because of "IF EXISTS"

-- Drop the 'departments' table (removes both the data and the structure)
DROP TABLE IF EXISTS departments;