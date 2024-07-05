SELECT LENGTH(TRIM('  HI  '))

SELECT first_name ||' '|| last_name full_name, (salary > 140000) is_highly_paid
FROM employees
ORDER BY salary desc

SELECT department, ('Clothing' IN (department, first_name))
FROM employees

SELECT ('Clothing' IN ('clothing', 'house', 'furniture'))

SELECT department, (department like '%oth%')
FROM employees

SELECT 'This is test data' test_data
SELECT SUBSTRING('This is test data' FROM 3) test_data_extracted

SELECT department, REPLACE(department, 'Clothing', 'Attire') modified_data,
department || ' department' "with department"
FROM departments

SELECT POSITION('@' IN email)
FROM employees

SELECT SUBSTRING(email, POSITION('@' IN email)+1) email_domain, email
FROM employees

SELECT COALESCE(email, 'NONE') email_none, email
FROM EMPLOYEES

SELECT UPPER(first_name), LOWER(last_name)
FROM EMPLOYEES

SELECT MAX(salary)
FROM employees

SELECT MIN(salary)
FROM employees

SELECT AVG(salary)
FROM employees

SELECT ROUND(AVG(salary))
FROM employees

SELECT COUNT(employee_id)
FROM employees

SELECT COUNT(*)
FROM employees

SELECT SUM(salary)
FROM employees

SELECT SUM(salary)
FROM employees
WHERE department = 'Clothing'

CREATE TABLE cars(make varchar(10))
SELECT * FROM cars
INSERT INTO cars VALUES('HONDA');
INSERT INTO cars VALUES('HONDA');
INSERT INTO cars VALUES('HONDA');
INSERT INTO cars VALUES('TOYOTA');
INSERT INTO cars VALUES('TOYOTA');
INSERT INTO cars VALUES('NISSAN');

SELECT COUNT(*) FROM cars

SELECT COUNT(*)
FROM cars
GROUP BY make

SELECT COUNT(*), make
FROM cars
GROUP BY make 

--select * from cars

SELECT COUNT(*), make
FROM cars
GROUP BY make

INSERT INTO cars VALUES(NULL);
INSERT INTO cars VALUES(NULL);
INSERT INTO cars VALUES(NULL);
INSERT INTO cars VALUES(NULL);

SELECT make, COUNT(*)
FROM cars
GROUP BY make

SELECT * FROM employees
SELECT SUM(SALARY), department
FROM employees
GROUP BY department

SELECT department, SUM(salary)
FROM employees
WHERE region_id IN (4,5,6,7)
GROUP BY department

SELECT department, COUNT(employees) employee_count, AVG(salary) avg_sal, 
MAX(salary) max_sal, MIN(salary) min_sal
FROM employees
GROUP BY department

SELECT department, COUNT(employees) employee_count, ROUND(AVG(salary)) avg_sal, 
MAX(salary) max_sal, MIN(salary) min_sal
FROM employees
GROUP BY department

SELECT department, COUNT(employees) employee_count, round(AVG(salary)) avg_sal, 
MAX(salary) max_sal, MIN(salary) min_sal
FROM employees
GROUP BY department
ORDER BY employee_count desc

SELECT department, COUNT(employees) employee_count, round(AVG(salary)) avg_sal, 
MAX(salary) max_sal, MIN(salary) min_sal
FROM employees
WHERE salary>70000
GROUP BY department
ORDER BY avg_sal desc

SELECT department, gender, count(*)
FROM employees
GROUP BY department, gender
ORDER BY department desc

SELECT department, count(*)
FROM employees
GROUP BY department
HAVING count(*) > 35
ORDER BY department

SELECT first_name,count(*) 
FROM employees
GROUP BY first_name
HAVING count(*) > 1
ORDER BY count(*) desc


SELECT first_name,count(*) 
FROM employees
GROUP BY first_name
HAVING count(*) > 2
ORDER BY count(*) desc

SELECT DISTINCT department
FROM employees

SELECT department
FROM employees
GROUP BY department

SELECT SUBSTRING(email, POSITION('@' IN email)+1) email_domain, count(*)
FROM employees
GROUP BY email_domain

SELECT SUBSTRING(email, POSITION('@' IN email)+1) email_domain, count(*)
FROM employees
GROUP BY SUBSTRING(email, POSITION('@' IN email)+1)

SELECT SUBSTRING(email, POSITION('@' IN email)+1) email_domain, count(*)
FROM employees
WHERE email IS NOT NULL
GROUP BY email_domain

SELECT SUBSTRING(email, POSITION('@' IN email)+1) email_domain, count(*)
FROM employees
WHERE email IS NOT NULL
GROUP BY email_domain
ORDER BY COUNT(*) desc

SELECT gender, region_id,
MAX(salary) max_salary, MIN(salary) min_salary,
AVG(salary) average_salary
FROM employees
GROUP BY gender, region_id
ORDER BY gender, region_id

SELECT gender, region_id,
MAX(salary) max_salary, MIN(salary) min_salary,
round(AVG(salary)) average_salary
FROM employees
GROUP BY gender, region_id
ORDER BY gender, region_id

SELECT gender, region_id,
MAX(salary) max_salary, MIN(salary) min_salary,
round(AVG(salary)) average_salary
FROM employees
GROUP BY gender, region_id
ORDER BY gender desc, region_id asc

--28. Aliasing sources of data

SELECT first_name, last_name, * 
FROM employees

SELECT departments.department
FROM employees, departments

SELECT d.department
FROM employees e, departments d

--29. Introducing sub-queries

SELECT * FROM employees
WHERE department NOT IN (SELECT department FROM departments)

SELECT *
FROM (SELECT * FROM employees WHERE salary >150000) a

SELECT a.first_name, a.last_name
FROM (SELECT * FROM employees WHERE salary >150000) a

SELECT employee_name, employee_salary
FROM (SELECT first_name employee_name, salary employee_salary FROM employees WHERE salary >150000) a

SELECT b.department_name, employee_salary
FROM (SELECT department department_name, salary employee_salary FROM employees WHERE salary >150000) a,
(SELECT department department_name FROM departments) b

--30. Subqueries continued + excercises
SELECT first_name, last_name, salary, (SELECT first_name FROM employees LIMIT 1)
FROM employees

--In class assignment - Write a query to get all the employees who work in the Electronics division. Use subqueries by referencing the departments table.
SELECT *
FROM employees
WHERE department IN (SELECT department FROM departments 
					 WHERE division = 'Electronics')

--In class assignment - Write a query to get all the employees who work in Asia or Canada and make over a 130000 in salary
SELECT *
FROM employees
WHERE salary >130000 
AND region_id IN (SELECT region_id FROM regions 
				  WHERE region = 'Asia' OR country = 'Canada')

--In class assignment - Write a query to get the first name and department of the employees and how much less than they make than the highest paid employee

SELECT first_name, department, (SELECT MAX(salary) FROM employees) - salary
FROM employees
WHERE region_id IN (SELECT region_id FROM regions 
				  WHERE region = 'Asia' OR country = 'Canada')

--also if required				  
SELECT first_name, department, salary, (SELECT MAX(salary) FROM employees),
(SELECT MAX(salary) FROM employees) - salary
FROM employees
WHERE region_id IN (SELECT region_id FROM regions 
				  WHERE region = 'Asia' OR country = 'Canada')
				  
--31. Subquery with ANY and ALL operators + [Excercises]
SELECT * FROM employees
WHERE region_id > ANY (SELECT region_id FROM regions 
					   WHERE country = 'United States')
					   
SELECT * FROM employees
WHERE region_id > ALL (SELECT region_id FROM regions 
					   WHERE country = 'United States')
					   
--In course assignment - All employees in the kids division and the hire date of all those employees should be greater than the hire dates of those in the maintenance department
SELECT  * FROM employees
WHERE department = ANY (SELECT department 
						FROM departments 
						WHERE division = 'Kids')
AND hire_date > ALL(SELECT hire_date 
					FROM employees 
					WHERE department = 'Maintenance')

-- In course assignment - Highest most frequently occuring salary
SELECT salary FROM (SELECT salary, count(*) 
					FROM employees
					GROUP BY salary
					ORDER BY count(*) desc, salary desc
					LIMIT 1) a
					
--OR also

SELECT salary, count(*)
FROM employees
GROUP BY salary
HAVING count(*) >= ALL (SELECT count(*) FROM employees
					   GROUP BY salary)
ORDER BY salary desc
LIMIT 1

--32. EXERCISES - MORE PRACTICE WITH SUBQUERIES
CREATE TABLE dupes (id integer, name varchar(10));

insert into dupes values(1, 'FRANK');
insert into dupes values(2, 'FRANK');
insert into dupes values(3, 'ROBERT');
insert into dupes values(4, 'ROBERT');
insert into dupes values(5, 'SAM');
insert into dupes values(6, 'FRANK');
insert into dupes values(7, 'PETER');

SELECT * FROM DUPES

--From above table return only unique names with their respective id's

SELECT min(id), name
FROM dupes
GROUP BY name

--or using subquery

SELECT * FROM dupes
WHERE id IN (
SELECT min(id)
FROM dupes
GROUP BY name
)



DELETE FROM dupes
WHERE id NOT IN (
SELECT min(id)
FROM dupes
GROUP BY name
)

DROP table dupes

--Compute average salary of employees by excluding the outliers, i.e. the max and min salaries

SELECT round(AVG(salary)) FROM employees
WHERE salary NOT in ((select MAX(salary) from employees),(
	select MIN(salary) from employees))
	
--34. Conditional expressions using CASE clauses + exercises

SELECT first_name, salary,
CASE 
	WHEN salary < 100000 THEN 'UNDERPAID'
	WHEN salary >= 100000 THEN 'PAID WELL'
END
from employees
ORDER BY salary desc




SELECT first_name, salary,
CASE 
	WHEN salary < 100000 THEN 'UNDERPAID'
	WHEN salary >= 100000 THEN 'PAID WELL'
	ELSE 'UNPAID/UKNOWN'
END
from employees
ORDER BY salary desc




SELECT first_name, salary,
(CASE 
	WHEN salary < 100000 THEN 'UNDERPAID'
	WHEN salary >= 100000 AND salary < 160000 THEN 'PAID WELL'
	ELSE 'EXECUTIVE'
END) sal_category
from employees
ORDER BY salary desc




SELECT first_name, salary,
CASE 
	WHEN salary < 100000 THEN 'UNDERPAID'
	WHEN salary >= 100000 AND salary < 160000 THEN 'PAID WELL'
	WHEN salary >= 160000 THEN 'EXECUTIVE'
	ELSE 'UNPAID'
END as sal_category
from employees
ORDER BY salary desc

--In course assignment - Return only category and count of each category

SELECT a.sal_category, count(a.sal_category)
FROM 
(SELECT first_name, salary,
CASE 
	WHEN salary < 100000 THEN 'UNDERPAID'
	WHEN salary >= 100000 AND salary < 160000 THEN 'PAID WELL'
	WHEN salary >= 160000 THEN 'EXECUTIVE'
 	ELSE 'UNPAID'
END as sal_category
from employees
ORDER BY salary desc) a
GROUP BY a.sal_category




SELECT a.sal_category, count(a.sal_category)
FROM 
(SELECT first_name, salary,
CASE 
	WHEN salary < 100000 THEN 1
	WHEN salary >= 100000 AND salary < 160000 THEN 2
	WHEN salary >= 160000 THEN 3
	ELSE 0
END as sal_category
from employees
ORDER BY salary desc)a
GROUP BY a.sal_category



SELECT SUM(CASE WHEN salary < 100000 THEN 1 ELSE 0 END) as UNDERPAID,
SUM(CASE WHEN salary >= 100000 AND salary <= 150000 THEN 1 ELSE 0 END) as PAID_WELL,
SUM(CASE WHEN salary > 150000  THEN 1 ELSE 0 END) as EXECUTIVE
FROM employees

--35. Transposing data using case clause + exercises

--In course assignment - Get a transposed version of no. of employees in each of the (Sports, tools, clothing, computers) departments from departments table.

SELECT SUM(CASE WHEN department = 'Sports' THEN 1 ELSE 0 END) as Sports,
SUM(CASE WHEN department = 'Tools' THEN 1 ELSE 0 END) as Tools,
SUM(CASE WHEN department = 'Clothing' THEN 1 ELSE 0 END) as Clothing,
SUM(CASE WHEN department = 'Computers' THEN 1 ELSE 0 END) as Computers
FROM employees

--select * from employees
--select * from regions
SELECT first_name,
CASE WHEN region_id = 1 THEN (SELECT country FROM regions WHERE region_id=1) END region_1,
CASE WHEN region_id = 2 THEN (SELECT country FROM regions WHERE region_id=2) END region_2,
CASE WHEN region_id = 3 THEN (SELECT country FROM regions WHERE region_id=3) END region_3,
CASE WHEN region_id = 4 THEN (SELECT country FROM regions WHERE region_id=4) END region_4,
CASE WHEN region_id = 5 THEN (SELECT country FROM regions WHERE region_id=5) END region_5,
CASE WHEN region_id = 6 THEN (SELECT country FROM regions WHERE region_id=6) END region_6,
CASE WHEN region_id = 7 THEN (SELECT country FROM regions WHERE region_id=7) END region_7
FROM employees

--In class assignment - Get number of employees that work in each country, with country as columns
SELECT count(a.region_1) + count(a.region_2) + count(a.region_3) as United_states,
count(a.region_4) + count(a.region_5) as Asia,
count(a.region_6) + count(a.region_7) as Canada
FROM
(SELECT first_name,
CASE WHEN region_id = 1 THEN (SELECT country FROM regions WHERE region_id=1) END region_1,
CASE WHEN region_id = 2 THEN (SELECT country FROM regions WHERE region_id=2) END region_2,
CASE WHEN region_id = 3 THEN (SELECT country FROM regions WHERE region_id=3) END region_3,
CASE WHEN region_id = 4 THEN (SELECT country FROM regions WHERE region_id=4) END region_4,
CASE WHEN region_id = 5 THEN (SELECT country FROM regions WHERE region_id=5) END region_5,
CASE WHEN region_id = 6 THEN (SELECT country FROM regions WHERE region_id=6) END region_6,
CASE WHEN region_id = 7 THEN (SELECT country FROM regions WHERE region_id=7) END region_7
FROM employees) a

SELECT United_states + Asia + Canada
FROM
(SELECT count(a.region_1) + count(a.region_2) + count(a.region_3) as United_states,
count(a.region_4) + count(a.region_5) as Asia,
count(a.region_6) + count(a.region_7) as Canada
FROM
(SELECT first_name,
CASE WHEN region_id = 1 THEN (SELECT country FROM regions WHERE region_id=1) END region_1,
CASE WHEN region_id = 2 THEN (SELECT country FROM regions WHERE region_id=2) END region_2,
CASE WHEN region_id = 3 THEN (SELECT country FROM regions WHERE region_id=3) END region_3,
CASE WHEN region_id = 4 THEN (SELECT country FROM regions WHERE region_id=4) END region_4,
CASE WHEN region_id = 5 THEN (SELECT country FROM regions WHERE region_id=5) END region_5,
CASE WHEN region_id = 6 THEN (SELECT country FROM regions WHERE region_id=6) END region_6,
CASE WHEN region_id = 7 THEN (SELECT country FROM regions WHERE region_id=7) END region_7
FROM employees) a
)b

--37. Understanding correlated subqueries

SELECT first_name, salary
FROM employees
WHERE salary > (select round(avg(salary)) from employees)

SELECT first_name, salary
FROM employees e1
WHERE salary > (select round(avg(salary)) from employees e2
			   WHERE e1.department = e2.department)

SELECT first_name, salary
FROM employees e1
WHERE salary > (select round(avg(salary)) from employees e2
			   WHERE e1.region_id = e2.region_id)

SELECT first_name, salary, (select round(avg(salary)) from employees e2
			   WHERE e1.department = e2.department) as avg_department_sal
FROM employees e1


--In class assignment - Get the names of all the departments that have more than 38 employees


SELECT department
FROM departments
WHERE 38 < (SELECT count(*)
		   FROM employees e
		   WHERE e.department = departments.department)
		   
--OR

SELECT department
FROM departments d
WHERE 38 < (SELECT count(*)
		   FROM employees e
		   WHERE e.department = d.department)
		   
--OR

SELECT department
FROM employees e1
WHERE 38 < (SELECT count(*)
		   FROM employees e2
		   WHERE e1.department = e2.department)


--OR to get distinct names of departments:

SELECT DISTINCT department
FROM employees e1
WHERE 38 < (SELECT count(*)
		   FROM employees e2
		   WHERE e1.department = e2.department)

--OR to also display the count

SELECT department, count(*)
FROM employees e1
WHERE 38 < (SELECT count(*)
		   FROM employees e2
		   WHERE e1.department = e2.department)
GROUP BY department
		   
--In class assignment - Highest salary at each department

SELECT department, (SELECT MAX(salary) FROM employees e
				   WHERE d.department = e.department)
FROM departments d
WHERE 38 < (SELECT count(*)
		   FROM employees e1
		   WHERE d.department = e1.department)
		   
--OR

SELECT department, (SELECT MAX(salary) FROM employees e
				   WHERE department = d.department)
FROM departments d
WHERE 38 < (SELECT count(*)
		   FROM employees e2
		   WHERE e2.department = d.department)
		   
--38. Exercises - Correlated subqueries continued
--select * from departments

--my attempt
SELECT department, first_name, 
(SELECT salary FROM employees e2 WHERE e2.department = e1.department
AND (salary = MAX(SALARY) OR salary = MIN(SALARY)))
FROM employees e1

--refined with the help of chatgpt
SELECT
    department,
    first_name,
    salary
FROM
    employees e1
WHERE
    (salary = (SELECT MAX(salary) FROM employees e2 WHERE e2.department = e1.department)
     OR salary = (SELECT MIN(salary) FROM employees e3 WHERE e3.department = e1.department));

--Solution that I finally came up with the help of chatgpt
SELECT
    department,
    first_name,
    salary as max_or_min_salary,
	(CASE 
	 WHEN salary = (SELECT MAX(salary) FROM employees e2 WHERE e2.department = e1.department) THEN 'Highest salary'
	 WHEN salary = (SELECT MIN(salary) FROM employees e3 WHERE e3.department = e1.department) THEN 'Lowest salary'
	 END) as flag
FROM
    employees e1
WHERE
    (salary = (SELECT MAX(salary) FROM employees e4 WHERE e4.department = e1.department)
     OR salary = (SELECT MIN(salary) FROM employees e5 WHERE e5.department = e1.department))
ORDER BY department


--OR - Imtiaz's solution

SELECT department, first_name, salary,
CASE 
	WHEN salary = max_by_department THEN 'HIGHEST SALARY'
	WHEN salary = min_by_department THEN 'LOWEST SALARY'
END as salary_flag
from
(SELECT department, first_name, salary, 
(select max(salary) from employees e2 where e1.department = e2.department) as max_by_department,
(select min(salary) from employees e2 where e1.department = e2.department) as min_by_department
from employees e1) a
WHERE salary = max_by_department OR salary = min_by_department
ORDER BY department


--39. Introducing table joins

SELECT first_name, country
FROM employees, regions
WHERE employees.region_id = regions.region_id;

--In class assignment - Get first_name, email and division from employees and departments

SELECT first_name, email, division
FROM employees, departments
WHERE employees.department = departments.department AND email IS NOT NULL;


SELECT first_name, email, division, country
FROM employees, departments, regions
WHERE employees.department = departments.department 
AND employees.region_id = regions.region_id
AND email IS NOT NULL;


SELECT first_name, email, employees.department, division, country
FROM employees, departments, regions
WHERE employees.department = departments.department 
AND employees.region_id = regions.region_id
AND email IS NOT NULL;

--OR with aliases

SELECT first_name, email, e.department, division, country
FROM employees e, departments d, regions r
WHERE e.department = d.department 
AND e.region_id = r.region_id
AND email IS NOT NULL;

--In class assignment - Get count of employees by country

SELECT country, count(employee_id) employee_count
FROM regions r, employees e
WHERE r.region_id = e.region_id
GROUP BY country

--40. Inner and outer joins + [Exercises]

SELECT first_name, country
FROM employees INNER JOIN regions
ON employees.region_id = regions.region_id;

SELECT first_name, email, division
FROM employees INNER JOIN departments
ON employees.department = departments.department
WHERE email IS NOT NULL

SELECT first_name, email, division
FROM employees INNER JOIN departments
ON employees.department = departments.department
INNER JOIN regions ON employees.region_id = regions.region_id
WHERE email IS NOT NULL

SELECT DISTINCT department FROM employees
--27 departments

SELECT DISTINCT department FROM departments
--24 departments

SELECT distinct employees.department, departments.department
FROM employees INNER JOIN departments
ON employees.department = departments.department
--23 departments because only common department values between employees and departments tables are returned


SELECT distinct employees.department employees_department, departments.department departments_department
FROM employees LEFT JOIN departments
ON employees.department = departments.department

SELECT distinct employees.department employees_department, departments.department departments_department
FROM employees RIGHT JOIN departments
ON employees.department = departments.department

--In class assignment - Get only those departments that are in the employees table but not in departments table

SELECT distinct employees.department employees_department
FROM employees LEFT JOIN departments
ON employees.department = departments.department
WHERE departments.department IS NULL


SELECT distinct employees.department employees_department, departments.department
FROM employees FULL OUTER JOIN departments
ON employees.department = departments.department

--Not part of the course, but just a query I wrote to help better understand joins
SELECT email, division, employees.department, departments.department
FROM employees right outer JOIN departments
ON employees.department = departments.department
where employees.department = 'Camping'

--41. Using UNION, UNION ALL and EXCEPT Clauses + [EXERCISES]
SELECT department
FROM employees
UNION
SELECT department
FROM departments

--Keeps duplicates
SELECT department
FROM employees
UNION ALL
SELECT department
FROM departments

SELECT DISTINCT department
FROM employees
UNION ALL
SELECT department
FROM departments


SELECT department, first_name
FROM employees
UNION ALL
SELECT department, division
FROM departments


SELECT department
FROM employees
UNION ALL
SELECT department
FROM departments
UNION
SELECT country
FROM regions
ORDER BY department

SELECT department
FROM departments
EXCEPT
select distinct department
from employees

--In class assignment - No. of employees and total no. of employees by department
SELECT department, count(*)
from employees
group by department
union all
select 'TOTAL', count(*)
from employees

--42. Cartesian Product with cross join
select *
from employees, departments

select *
from employees a, employees b

select count(*) from
(
select *
from employees a, employees b
) c
