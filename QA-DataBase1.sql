
-- 1. Find the total number of employees in each department and list only those departments with more than 5 employees.
select department_id, count(*) as employee_count from employees
group by department_id
having count(*) > 5;

-- 2. Calculate the average salary for each job title, but only include job titles where the average salary is greater than 6000.
-- Here, we eliminate each salary that is lower than 6000 BEFORE finding avg.
select job_id, avg(salary) from employees
where salary > 6000
group by job_id
order by job_id;

-- Here, we find the average salary, then eliminate the ones less than 6000k.
select job_id, avg(salary) from employees
group by job_id;
having avg(salary) > 6000
order by job_id;

-- 3. Find the highest salary in each department and list only those departments where the highest salary is less than 10000.
select department_id, max(salary) highest_salary from employees
group by department_id
having max(salary) < 10000
order by department_id;

/*
4. For each department, calculate the total salary paid. Only include
departments where the total salary is more than 50000, and order the
result by total salary in descending order.
*/
select department_id, sum(salary) total_salary from employees
group by department_id
having sum(salary) > 50000 and department_id is not null
order by total_salary;

-- 5. Find the total number of employees for each job title and list only those job titles that have more than 3 employees.
select job_id, count(*) from employees
group by job_id
having count(*) > 3;

-- 6. Calculate the sum of the salaries for each department and only display those where the sum is between 20000 and 50000.
select department_id, sum(salary) from employees
group by department_id
having sum(salary) between 20000 and 50000;


-- 12/9/2023 Recap + SubQuery Distinct --
/*
Find maximum commission percentage for each department.
Only include departments where the total salary is greater than 80000.
Order the result by average salary in descending order. (employees)
*/
-- Find maximum commission percentage for each department.
select department_id, max(commission_pct) from employees
-- Only include departments where the total salary is less than 80000.
group by department_id 
having sum(salary) > 80000
-- Order the result by average salary in descending order. (employees)
order by avg(salary) desc;


-- DISTINCT
select distinct(job_id) from employees;

-- Write a query to count all unique region ids under the countries table.
select distinct(country_id) from countries;

-- SubQuery
select first_name from employees
where salary = (select max(salary) from employees);

-- Salary can change, so you should not hardcode it.
select first_name from employees
where salary = 50000;

/*
1. Write a query to get employees first_name and salary who makes more than employee
who has employee_id 121 and then order by salary ascending
*/
select first_name, salary from employees
where salary > (select salary from employees
                where employee_id = 121)
order by salary;

/*
2. Write a query to get employees first_name, department_id who works in same
department with employee who has employee_id 150.
*/
select first_name, department_id from employees
where department_id = (select department_id from employees
                       where employee_id = 150);

-- 3. Write a query to find second largest salary.
select max(salary) as second_largest from employees
where salary != (select max(salary) from employees);

-- 4. Write a query to get name of employees who is making second largest salary.
select first_name
from employees
where salary = (select max(salary) as second_largest
                from employees
                where salary != (select max(salary)
                                from employees));

-- 5. Write a query to get number of postal code under same countries from locations table.
select country_id, count(postal_code) from locations
group by country_id;

-- 6. Write a query to get number of postal code under same countries from locations table if their count is more than 1.
select country_id, count(distinct(postal_code)) from locations
group by country_id
having count(distinct(postal_code)) > 1;

-- 7. Write a query to get all employees who is making more than average salary and order by salary.
select * from employees
where salary > (select avg(salary) from employees)
order by salary desc;

-- 8. Write a query to get all cities which have same state with Toronto from locations table.
select city from locations
where state_province = (select state_province from locations
                        where city = 'Toronto');

-- 9. Write a query to find the employee who is making second lowest salary.
select first_name
from employees
where salary = (select min(salary) as second_lowest
                from employees
                where salary != (select min(salary)
                                from employees));


-- ROWNUM
select first_name, salary from employees
where rownum <= 10;

select first_name, salary from employees
order by salary desc;

select distinct(salary) from employees
order by salary desc;

-- Write a query to get all employee details who has the 4th and 5th lowest/max salary?
SELECT * FROM employees
where salary in( 
(SELECT min(salary) FROM
(select distinct(salary) from employees
order by salary desc)
where rownum <= 4),
(SELECT min(salary) FROM
(select distinct(salary) from employees
order by salary desc)
where rownum <= 5));

-- employees = (select * from employees);
select * from (select * from (select * from (select * from employees where employee_id < 150)));
select * from employees where employee_id < 150;


-- Write a query to get all employee details who has the 6th highest salary?
select * from employees
where salary = 
(select min(salary) from
(select distinct(salary)
from employees
order by salary desc)
where rownum <= 6);


-- 12/10/2023 JOINs --
select * from regions
join countries
on regions.region_id = countries.region_id;

-- Same query above with alias
select * from regions r
join countries c
on r.region_id = c.region_id;


-- Create a join table with first_name, department_id, department_name
SELECT e.first_name, d.department_id, d.department_name
FROM employees e
join departments d
on e.department_id = d.department_id;


-- 1. Write the query to the print country name, country id, and region name for each country.
select c.country_name, c.country_id, r.region_name
from countries c
join regions r
on c.region_id = r.region_id;

-- 2. Write the query to print the last name, email, and job title for each employee.
select e.last_name, e.email, j.job_title
from employees e
join jobs j
on e.job_id = j.job_id;


-- JOIN Types --
-- Inner join
SELECT e.first_name, d.department_id, d.department_name
FROM employees e
inner join departments d
on e.department_id = d.department_id;

-- left outer join
SELECT e.first_name, d.department_id, d.department_name
FROM employees e
left join departments d
on e.department_id = d.department_id;

-- right outer join
SELECT e.first_name, d.department_id, d.department_name
FROM employees e
right join departments d
on e.department_id = d.department_id;

-- full outer join
SELECT e.first_name, d.department_id, d.department_name
FROM employees e
full join departments d
on e.department_id = d.department_id;

-- Create join with 3 tables
select d.department_name, l.postal_code, c.country_name
from departments d
full join locations l
on d.location_id = l.location_id
full join countries c
on l.country_id = c.country_id;

-- Self join
select e.first_name as employee, m.first_name as manager
from employees e
join employees m
on e.manager_id = m.employee_id;

-- Write a query to get count of employees for each manager and order by count of employees.
select m.first_name, count(*)
from employees e
join employees m
on e.manager_id = m.employee_id
group by m.employee_id, m.first_name
order by count(*) desc;

-- Find the employees with the salary more than their managers salary (Interview question)
select e.first_name, e.salary
from employees e
join employees m
on e.manager_id = m.employee_id
where e.salary > m.salary;


-- Set Operators --
-- Union
select manager_id from employees
union
select manager_id from departments;

-- Write a query to get not duplicated employees� first_name, hire_date, and salary where
-- salary range is 4000 to 7000 and 6000 to 9000 and then order by salary.
-- 1st way
SELECT first_name, hire_date, salary
FROM employees
WHERE salary BETWEEN 4000 AND 7000 
   or salary BETWEEN 6000 AND 9000
ORDER BY salary;

-- 2nd way
SELECT first_name, hire_date, salary
FROM employees
WHERE salary BETWEEN 4000 AND 7000 
UNION
SELECT first_name, hire_date, salary
FROM employees
WHERE salary BETWEEN 6000 AND 9000;

-- Union All -- With union all, we got duplicated employees of salary between 6000 and 7000
SELECT first_name, hire_date, salary
FROM employees
WHERE salary BETWEEN 4000 AND 7000 
UNION ALL
SELECT first_name, hire_date, salary
FROM employees
WHERE salary BETWEEN 6000 AND 9000;

-- Intersect
Select first_name, last_name, employee_id from employees where employee_id between 100 and 150
intersect
Select first_name, last_name, employee_id from employees where employee_id between 140 and 180
order by employee_id;


--Homework

-- 1.	Write a query to display the employee id, employee name (first name and last name) for all employees who earn more than the average salary. 

SELECT employee_id, concat(first_name, last_name)
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

--2.	Write a query to display the employee name (first name and last name), employee id, and salary of all employees who report to Payam

SELECT first_name, last_name, employee_id, salary
FROM employees 
WHERE manager_id =(SELECT employee_id FROM employees WHERE first_name = 'Payam');

--3.	Write a query to display the department number, name (first name and last name), job_id and department name for all employees in the Finance department.

SELECT e.department_id, e.first_name, e.last_name, e.job_id, d.department_name as deparment
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE d.department_name = 'Finance';

--4.	Write a query to display all the information of the employees whose salary is within the range of the smallest salary and 2500.
SELECT *
from employees
where salary BETWEEN (select min(salary)from employees) and 2500;

--5.	Write a SQL query to find the first name, last name, department, city, and state province for each employee.
SELECT  e.first_name, e.last_name, d.department_name AS department, l.city, l.state_province
FROM  employees e
JOIN departments d 
ON e.department_id = d.department_id
JOIN  locations l 
ON d.location_id = l.location_id;

--6.	Write a SQL query to find all those employees who work in department ID 80 or 40. Return first name, last name, department number, and department name.
SELECT e.first_name, e.last_name, e.department_id, d.department_name as department
FROM employees e
JOIN departments d
ON e.department_id = d.department_id
WHERE e.department_id IN(40, 80);

--7.	 Write a query to display the employee name (first name and last name) and hire date for all employees in the same department as Clara. Exclude Clara.
SELECT e.first_name, e.last_name, e.hire_date
FROM employees e
WHERE e.department_id = (SELECT department_id FROM employees WHERE first_name = 'Clara')
and e.first_name != 'Clara';

--8.	Write a query to display the employee number, name (first name and last name), and salary for all employees who earn more than the average salary and who work in a department with any employee with a J in their name.
SELECT employee_id, first_name, last_name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

--9.	Write a SQL query to find those employees whose first name contains the letter �z�. Return first name, last name, department, city, and state province.
SELECT e.first_name, e.last_name, e.department_id, d.department_name as department
FROM employees e
JOIN departments d
ON e.department_id = d.department_id
WHERE e.first_name LIKE '%z%';

--10.	Write a SQL query to find all departments, including those without employees. Return first name, last name, department ID, department name.
SElECT e.first_name, e.last_name, d.department_id, d.department_name as department
FROM departments d
JOIN employees e
ON d.department_id = e.department_id;

-- 11.	Write a query to display the employee number, name (first name and last name) and job title for all employees whose salary is smaller than any salary of those employees whose job title is MK_MAN.
SELECT e.first_name, e.last_name, e.job_id as "JOB TITLE"
FROM employees e
WHERE salary < (SELECT MIN(salary) FROM employees WHERE job_id = 'MK_MAN');

--12.	Write a query to display the employee number, name (first name and last name) and job title for all employees whose salary is more than any salary of those employees whose job title is PU_MAN. Exclude job title PU_MAN.
SELECT e.employee_id, e.first_name, e.last_name, e.job_id as "JOB TITLE"
FROM employees e
WHERE salary > (SELECT MAX(salary) FROM employees WHERE job_id = 'PU_MAN')
AND job_id != 'PU_MAN';

--13.	Write a query to display the employee number, name (first name and last name) and job title for all employees whose salary is more than any average salary of any department.
SELECT employee_id, first_name, last_name, job_id as "JOB TITLE"
FROM employees 
WHERE salary > ANY (SELECT AVG(salary) FROM employees GROUP BY department_id);

--14.	Write a query to display the department id and the total salary for those departments which contains at least one employee.
SELECT department_id, SUM(salary) as "TOTAL SALARY"
FROM employees
GROUP BY department_id
HAVING COUNT(employee_id) > 0;

--15.	Write a SQL query to find the employees who earn less than the employee of ID 182. Return first name, last name and salary.
SELECT first_name, last_name, salary
FROM employees
WHERE salary < ANY(SELECT salary FROM employees WHERE employee_id = 182);

--16.	Write a SQL query to find the employees and their managers. Return the first name of the employee and manager.
SELECT e.first_name as "FIRST NAME", m.first_name as "MANAGER NAME"
FROM employees e
JOIN employees m
ON e.manager_id = m.manager_id;

--17.	Write a SQL query to display the department name, city, and state province for each department.
SELECT d.department_name AS "DEPARTMENT NAME", l.city, l.state_province
FROM  employees e
JOIN departments d 
ON e.department_id = d.department_id
JOIN  locations l 
ON d.location_id = l.location_id;

--18.	Write a query to identify all the employees who earn more than the average and who work in any of the IT departments.
SELECT e.first_name, e.last_name FROM employees e
JOIN departments d
ON e.department_id = d.department_id
WHERE e.salary > (select avg(salary) from employees) 
AND d.department_name LIKE 'IT%';

--19.	Write a SQL query to find out which employees have or do not have a department. Return first name, last name, department ID, department name.
SELECT e.first_name, e.last_name, e.department_id, d.department_name as "DEPARTMENT NAME"
FROM employees e
JOIN departments d
ON e.department_id = d.department_id;

--20.	Write a SQL query to find the employees and their managers. Those managers do not work under any manager also appear in the list. Return the first name of the employee and manager.
SELECT e.first_name, m.first_name as "MANAGER NAME" 
FROM employees e
JOIN employees m
ON e.manager_id = m.manager_id;

-- 21.	Write a query to display the name (first name and last name) for those employees who gets more salary than the employee whose ID is 163.
SELECT first_name, last_name
FROM employees 
WHERE salary > (SELECT salary FROM employees WHERE employee_id = 163);

-- 22  Write a query to display the name (first name and last name), salary, department id, job id for those employees who works in the same designation as the employee works whose id is 169.
SELECT e.first_name, e.last_name, e.salary, e.department_id as department, e.job_id
FROM employees e
WHERE job_id = (SELECT job_id FROM employees WHERE employee_id = 169);

--23.	Write a SQL query to find the employees who work in the same department as the employee with the last name Taylor. Return first name, last name and department ID.
SELECT first_name, last_name, department_id
FROM employees 
WHERE department_id IN (SELECT department_id FROM employees WHERE last_name = 'Taylor'); 
-- Because there are multiple employees with last name Taylor in different department i use (IN} other wise i will get an error because the query return more than one row

--24.	Write a SQL query to find the department name and the full name (first and last name) of the manager.
SELECT d.department_name, m.first_name, m.last_name 
FROM departments d
JOIN employees m
ON d.manager_id = m.manager_id;

--25.	Write a SQL query to find the employees who earn $12000 or more. Return employee ID, starting date, end date, job ID and department ID.
SELECT e.employee_id, j.start_date, j.end_date, j.job_id, j.department_id
FROM employees e 
JOIN job_history j
ON e.job_id = j.job_id
WHERE salary > 12000;

--26.	Write a query to display the name (first name and last name), salary, department id for those employees who earn such amount of salary which is the smallest salary of any of the departments.
SELECT first_name, last_name, salary, department_id
FROM employees e
WHERE salary = (SELECT MIN(salary) FROM employees WHERE department_id = e.department_id);

--27.	Write a query to display all the information of an employee whose salary and reporting person id is 3000 and 121, respectively.
SELECT *
FROM employees
WHERE salary = 3000
AND manager_id = 121;

--28.	Display the employee name (first name and last name), employee id, and job title for all employees whose department location is Toronto.
SELECT e.first_name, e.last_name, l.city
FROM  employees e
JOIN departments d 
ON e.department_id = d.department_id
JOIN  locations l 
ON d.location_id = l.location_id
WHERE l.city = 'Toronto';

--29.	Write a query to display the employee name( first name and last name ) and department for all employees for any existence of those employees whose salary is more than 3700.
SELECT e.first_name, e.last_name, d.department_name 
FROM employees e
join departments d
on e.department_id = d.department_id 
WHERE salary > 3700;

-- I'm not understing properly ( "any existence" ) that't means that the employees is active and end_date is null??

--30.	 Write a query to determine who earns more than employee with the last name 'Russell'.
SELECT first_name, last_name
FROM employees
WHERE salary > (SELECT salary from employees where last_name = 'Russell');

--31.	Write a query to display the names of employees who don't have a manager.
SELECT first_name, last_name
FROM employees
WHERE manager_id is null;

--32.	Write a query to display the names of the departments and the number of employees in each department.

SELECT d.department_name, COUNT(e.employee_id) AS "EMPLOYEES AMOUNT"
FROM departments d
JOIN employees e 
ON d.department_id = e.department_id
GROUP BY d.department_name, d.department_id;

-- 33.	Write a query to display the last name of employees and the city where they are located.
SELECT e.last_name, l.city
FROM employees e
JOIN departments d 
ON e.department_id = d.department_id
JOIN locations l
ON d.location_id = l.location_id;

--34.	Write a query to display the job titles and the average salary of employees for each job title.
SELECT job_id, AVG(salary)
FROM employees
GROUP BY job_id;

--35.	Write a query to display the employee's name, department name, and the city of the department.
SELECT e.first_name, d.department_name, l.city
FROM employees e
JOIN departments d
ON e.department_id = d.department_id
JOIN locations l
ON d.location_id = l.location_id;

--36.	Write a query to display the names of employees who do not have a department assigned to them.
SELECT first_name, last_name
FROM employees
WHERE department_id is null;

--37.	Write a query to display the names of all departments and the number of employees in them, even if there are no employees in the department.
SELECT d.department_name, COUNT(e.employee_id) AS "EMPLOYEES AMOUNT"
FROM departments d
JOIN employees e 
ON d.department_id = e.department_id
GROUP BY d.department_name, d.department_id;

















