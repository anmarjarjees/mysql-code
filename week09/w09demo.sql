-- First, create the database (if it does not exist) before creating tables
CREATE DATABASE IF NOT EXISTS story_club;
USE story_club;

-- Creating the authors table
CREATE TABLE IF NOT EXISTS authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY, -- Unique ID for each author
    first_name VARCHAR(40) NOT NULL, -- First name cannot be NULL
    last_name VARCHAR(40) NOT NULL,  -- Last name cannot be NULL
    email VARCHAR(70) UNIQUE, -- Email must be unique
    password VARCHAR(100), -- Suitable length for hashed passwords
    phone VARCHAR(20), -- Text format for phone numbers
    is_admin TINYINT DEFAULT 0, -- 0 for regular users, 1 for admins
    city VARCHAR(30),  -- City name
    province VARCHAR(30) DEFAULT 'ON', -- Default province is Ontario (ON)
    join_date DATETIME DEFAULT CURRENT_TIMESTAMP, -- Defaults to current time if not provided
    birth_date DATE -- New column to store author's birth date
);

-- Creating the stories table
CREATE TABLE IF NOT EXISTS stories (
    story_id INT AUTO_INCREMENT PRIMARY KEY, -- Unique ID for each story
    author_id INT, -- Foreign key referencing authors
    title VARCHAR(70) NOT NULL, -- Story title cannot be NULL
    content TEXT NOT NULL, -- Story content cannot be NULL
    genre VARCHAR(50), -- Genre of the story
    published_date DATETIME DEFAULT CURRENT_TIMESTAMP, -- Defaults to current timestamp
    FOREIGN KEY (author_id) REFERENCES authors(author_id) ON DELETE CASCADE -- If an author is deleted, their stories will also be deleted automatically
);

-- Link: https://en.wikipedia.org/wiki/List_of_writing_genres
/*  
List of writing genres:
- Action and adventure
- Comedy
- Crime and mystery
- Speculative fiction
- Fantasy
- Horror
- Science fiction
- Romance
*/

-- INSERT DATA into the table "stories"
INSERT INTO stories (author_id, title, content, genre) VALUES 
(1, 'How did you do that', 'Video provides a powerful way to help you prove your point. When you click Online Video, you can paste in the embed code for the video you want to add. You can also type a keyword to search online for the video that best fits your document.', 'Comedy'),
(2, 'Learn More', 'Video provides a powerful way to help you prove your point. When you click Online Video, you can paste in the embed code for the video you want to add. You can also type a keyword to search online for the video that best fits your document.', 'Fantasy'),
(3, 'Do your best', 'Video provides a powerful way to help you prove your point. When you click Online Video, you can paste in the embed code for the video you want to add. You can also type a keyword to search online for the video that best fits your document.', 'Horror'),
(3, 'Where to go', 'Video provides a powerful way to help you prove your point. When you click Online Video, you can paste in the embed code for the video you want to add. You can also type a keyword to search online for the video that best fits your document.', 'Science fiction'),
(4, 'Time to escape', 'Video provides a powerful way to help you prove your point. When you click Online Video, you can paste in the embed code for the video you want to add. You can also type a keyword to search online for the video that best fits your document.', 'Romance'),
(4, 'It is ok to speak', 'Video provides a powerful way to help you prove your point. When you click Online Video, you can paste in the embed code for the video you want to add. You can also type a keyword to search online for the video that best fits your document.', 'Romance'),
(5, 'Time to study', 'Video provides a powerful way to help you prove your point. When you click Online Video, you can paste in the embed code for the video you want to add. You can also type a keyword to search online for the video that best fits your document.', 'Horror');

-- Aggregate Function Queries
-- Link: https://dev.mysql.com/doc/refman/8.0/en/aggregate-functions.html
-- Link: https://www.w3schools.com/sql/sql_count_avg_sum.asp

-- Count how many authors are in the database
SELECT COUNT(author_id) FROM authors;

-- Alternative way to count rows in the table:
SELECT COUNT(*) FROM authors;

-- Count authors from a specific city (e.g., Toronto)
SELECT city, COUNT(city) FROM authors WHERE city = 'Toronto';

-- Using an alias for better readability:
SELECT city, COUNT(city) AS Total FROM authors WHERE city = 'Toronto';

-- Get the highest rating from stories (if ratings are added in the future)
-- SELECT MAX(rate) FROM stories;

-- Get the lowest rating from stories
-- SELECT MIN(rate) FROM stories;

-- Get the total sum of all ratings (if applicable)
-- SELECT SUM(rate) FROM stories;

-- Convert first name and last name to uppercase, and city to lowercase
SELECT UCASE(first_name), UCASE(last_name), LCASE(city) FROM authors;

-- Grouping authors by city and counting how many authors belong to each city
SELECT city, COUNT(city) FROM authors GROUP BY city;

-- Counting how many stories belong to each genre
SELECT genre, COUNT(*) FROM stories GROUP BY genre;

-- Update the authors table to add a new column 'birth_date'
ALTER TABLE authors ADD COLUMN birth_date DATE;

-- What is the date of birth of our oldest author?
SELECT first_name, last_name, birth_date FROM authors ORDER BY birth_date LIMIT 1;

-- Alternative using MIN()
SELECT MIN(birth_date) AS 'Oldest Author' FROM authors;

-- What is the most recent published story?
SELECT MAX(published_date) AS 'Most Recent Story' FROM stories;

-- Average story content length
SELECT AVG(CHAR_LENGTH(content)) AS Average_Content_Length FROM stories;

-- Maximum and Minimum Story Title Length
SELECT MAX(CHAR_LENGTH(title)) AS Longest_Title, MIN(CHAR_LENGTH(title)) AS Shortest_Title FROM stories;

-- Total Number of Stories Written by Each Author
SELECT author_id, COUNT(*) AS Total_Stories FROM stories GROUP BY author_id;

/* 
More Examples with Invoice
*/

-- Step 1: Create the "invoices" table
-- This table will have two columns: invoice_id (the unique ID for each invoice) and total (the total amount of each invoice)
CREATE TABLE invoices (
    invoice_id INT PRIMARY KEY, -- invoice_id is an integer and will be the unique identifier for each invoice
    total DECIMAL(10, 2) -- total is a decimal with two digits after the decimal point to represent the invoice amount
);

-- Step 2: Insert sample data into the "invoices" table
-- These are example invoices with different total amounts
INSERT INTO invoices (invoice_id, total) VALUES
(1, 131.50),  -- Invoice 1 with a total of 131.50
(2, 207.75),  
(3, 152.25),  
(4, 320.40),  
(5, 215.30);  

-- Step 3: Query 1 - Calculate the average of all the invoice totals
-- The AVG() function calculates the average of the values in the "total" column
-- The average of the total for all invoices without alias name
SELECT AVG(Total) FROM Invoices;

-- The average of the total for all invoices with alias name
SELECT AVG(total) AS average_total FROM invoices; 

-- Step 4: Query 2 - Calculate the rounded average total to two decimal places

-- The ROUND function to round the average total to two decimal places without alias name
SELECT ROUND(AVG(Total),2) FROM Invoices;

-- The ROUND() function rounds the average to two decimal places with alias name
SELECT ROUND(AVG(total), 2) AS rounded_average_total FROM invoices;