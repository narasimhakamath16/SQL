--Assignment 2:
--select * from professors

--Write a query against the professors table that can output the following in the result: "Chong works in the Science department"
SELECT  last_name ||' works in the '||department||' department'
FROM professors

--Write a SQL query against the professors table that would return the following result:
SELECT 'It is '||(salary>95000)||' that professor '||last_name||' is highly paid'
FROM professors

--Write a query that returns all of the records and columns from the professors table but shortens the department names to only the first three characters in upper case.
SELECT last_name,
UPPER(SUBSTRING(department,1,3)) as department,
salary, hire_date
FROM professors

--Write a query that returns the highest and lowest salary from the professors table excluding the professor named 'Wilson'.
SELECT MAX(salary) as highest_salary,
MIN(salary) as lowest_salary
FROM professors
WHERE last_name != 'Wilson'

--Write a query that will display the hire date of the professor that has been teaching the longest.
SELECT MIN(hire_date)
FROM professors

--Assignment 4
CREATE TABLE fruit_imports
(
	id integer,
	name varchar(20),
	season varchar(10),
	state varchar(20),
	supply integer,
	cost_per_unit decimal
);

insert into fruit_imports values(1, 'Apple', 'All Year', 'Kansas', 32900, 0.22);
insert into fruit_imports values(2, 'Avocado', 'All Year', 'Nebraska', 27000, 0.15);
insert into fruit_imports values(3, 'Coconut', 'All Year', 'California', 15200, 0.75);
insert into fruit_imports values(4, 'Orange', 'Winter', 'California', 17000, 0.22);
insert into fruit_imports values(5, 'Pear', 'Winter', 'Iowa', 37250, 0.17);
insert into fruit_imports values(6, 'Lime', 'Spring', 'Indiana', 40400, 0.15);
insert into fruit_imports values(7, 'Mango', 'Spring', 'Texas', 13650, 0.60);
insert into fruit_imports values(8, 'Orange', 'Spring', 'Iowa', 18000, 0.26);
insert into fruit_imports values(9, 'Apricot', 'Spring', 'Indiana', 55000, 0.20);
insert into fruit_imports values(10, 'Cherry', 'Summer', 'Texas', 62150, 0.02);
insert into fruit_imports values(11, 'Cantaloupe', 'Summer', 'Texas', 8000, 0.49);
insert into fruit_imports values(12, 'Apricot', 'Summer', 'Kansas', 14500, 0.20);
insert into fruit_imports values(13, 'Mango', 'Summer', 'Texas', 17000, 0.68);
insert into fruit_imports values(14, 'Pear', 'Fall', 'Nebraska', 30500, 0.12);
insert into fruit_imports values(15, 'Grape', 'Fall', 'Illinois', 72500, 0.35);

select * from fruit_imports
-- 1. Write a query that displays only the state with the largest amount of fruit supply.
SELECT state, SUM(supply)
FROM fruit_imports
GROUP BY state
ORDER BY SUM(supply) desc
LIMIT 1

--2. Write a query that returns the most expensive cost_per_unit of every season. The query should display 2 columns, the season and the cost_per_unit
SELECT season, MAX(cost_per_unit)
FROM fruit_imports
GROUP BY season

--3. Write a query that returns the state that has more than 1 import of the same fruit.
SELECT state, name, count(name)
FROM fruit_imports
GROUP BY state, name
HAVING count(name)>1

--4. Write a query that returns the seasons that produce either 3 fruits or 4 fruits.
SELECT season, count(name)
FROM fruit_imports
GROUP BY season
HAVING count(name) IN (3,4)

--or

SELECT season, COUNT(name)
FROM fruit_imports
GROUP BY season
HAVING count(name) = 3 OR count(name) = 4

--5. Write a query that takes into consideration the supply and cost_per_unit columns for determining the total cost and returns the most expensive state with the total cost.

SELECT state, SUM(supply*cost_per_unit) as total_cost
FROM fruit_imports
GROUP BY state
ORDER BY total_cost desc
LIMIT 1

--6. Execute the below SQL script and answer the question that follows:
CREATE table fruits (fruit_name varchar(10));
INSERT INTO fruits VALUES ('Orange');
INSERT INTO fruits VALUES ('Apple');
INSERT INTO fruits VALUES (NULL);
INSERT INTO fruits VALUES (NULL);

SELECT COUNT(COALESCE(fruit_name,'SOMEVALUE'))
FROM fruits;

--Assignment 5

--1. Is the students table directly related to the courses table? Why or why not?
--The students table is not directly related to the courses table. The students table just contains student details. The courses table just contains courses information. The table that relates both the students table and courses table is the student_enrollment table. What student is enrolled in what course is captured in the student_enrollment table.

--2. Using subqueries only, write a SQL statement that returns the names of those students that are taking the courses Physics and US History.
--NOTE: Do not jump ahead and use joins. I want you to solve this problem using only what you've learned in this section.

SELECT student_name FROM students
WHERE student_no IN (SELECT student_no FROM student_enrollment
				   WHERE course_no IN (SELECT course_no FROM courses 
									   WHERE course_title IN ('Physics', 'US History'))
					 )
					 
--3. Using subqueries only, write a query that returns the name of the student that is taking the highest number of courses.
--NOTE: Do not jump ahead and use joins. I want you to solve this problem using only what you've learned in this section.				 
					 
SELECT student_name FROM students WHERE student_no IN 
(SELECT student_no FROM (SELECT student_no, COUNT(course_no) course_cnt         
						 FROM STUDENT_ENROLLMENT         
						 GROUP BY student_no         
						 ORDER BY course_cnt desc         
						 LIMIT 1     
						)a )

--4. Answer TRUE or FALSE for the following statement:
--Subqueries can be used in the FROM clause and the WHERE clause but cannot be used in the SELECT Clause.
-- FALSE. Subqueries can be used in the FROM, WHERE, SELECT and even the HAVING clause.

--5. Write a query to find the student that is the oldest. You are not allowed to use LIMIT or the ORDER BY clause to solve this problem.
SELECT student_name, age FROM students
WHERE age IN (SELECT max(age) FROM students)

--OR

SELECT *
FROM students
WHERE age = (SELECT MAX(age) FROM students)

--Assignment 6: Practice Using Case and Transposing Data

--This assignment involves using the table you created in Assignment 4. We'll be getting practice using the CASE statement in interesting ways and transposing data.

--1. Write a query that displays 3 columns. The query should display the fruit and it's total supply along with a category of either LOW, ENOUGH or FULL. Low category means that the total supply of the fruit is less than 20,000. The enough category means that the total supply is between 20,000 and 50,000. If the total supply is greater than 50,000 then that fruit falls in the full category.
--SELECT * FROM fruit_imports

SELECT name, SUM(supply) as total_supply,
(CASE 
 WHEN SUM(supply) < 20000 THEN 'LOW'
 WHEN SUM(supply) >= 20000 AND SUM(supply) < 50000 THEN 'ENOUGH'
 WHEN SUM(supply) >= 50000 THEN 'FULL'
 END
) category
FROM fruit_imports
GROUP BY name

--OR


SELECT name, total_supply,
CASE WHEN total_supply < 20000 THEN 'LOW'
     WHEN total_supply >= 20000 AND total_supply <= 50000 THEN 'ENOUGH'
     WHEN total_supply > 50000 THEN 'FULL'
END as category
FROM (
SELECT name, sum(supply) total_supply
FROM fruit_imports
GROUP BY name
    ) a
	

--2. Taking into consideration the supply column and the cost_per_unit column, you should be able to tabulate the total cost to import fruits by each season. The result will look something like this:

--"Winter" "10072.50"
--"Summer" "19623.00"
--"All Year" "22688.00"
--"Spring" "29930.00"
--"Fall" "29035.00"

--Write a query that would transpose this data so that the seasons become columns and the total cost for each season fills the first row?
SELECT SUM(CASE WHEN season = 'Winter' THEN total_cost end) as Winter_total,
SUM(CASE WHEN season = 'Summer' THEN total_cost end) as Summer_total,
SUM(CASE WHEN season = 'Spring' THEN total_cost end) as Spring_total,
SUM(CASE WHEN season = 'Fall' THEN total_cost end) as Spring_total,
SUM(CASE WHEN season = 'All Year' THEN total_cost end) as Spring_total
FROM (
select season, sum(supply * cost_per_unit) total_cost
from fruit_imports
group by season
) a

