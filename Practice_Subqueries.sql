-- W3 Practice- Subqueries

-- 1) Find employees who receive a higher salary than the employee with ID 163.

-- SELECT first_name,last_name 
-- FROM employees 
-- WHERE salary > 
--     (SELECT salary 
--      FROM employees WHERE employee_id = 163)


-- 2) Find employees who have same job_ID as employee whose empID is 169.

-- SELECT first_name, last_name, 
--  salary, department_id, job_id
-- FROM employees 
-- WHERE job_id = (select job_id 
--                 from employees where employee_id = 169)


-- 3) Find employees whose salary matches lowest salary of any of the departments.

-- SELECT first_name, last_name, department_id
-- FROM employees 
-- WHERE salary IN 
--        (select MIN(salary) 
--         FROM employees 
--         GROUP BY department_id)


-- 4) Find employees who earn more than the average salary.

-- SELECT employee_id, first_name, last_name   
-- FROM employees 
-- WHERE salary > 
--          (SELECT AVG(salary) 
--           FROM employees)


-- 5) Find employees where manager's first name is 'Payam'.

-- SELECT first_name, last_name, employee_ID, salary 
-- FROM employees 
-- WHERE manager_id = 
--           (SELECT employee_ID 
--            FROM employees 
--            WHERE first_name = 'Payam')


-- 6) Find employees who work in Finance dept

-- SELECT a.department_ID, a.first_name, a.job_id, b.department_name
-- FROM employees a 
--   JOIN departments b
--   ON a.department_id = b.department_id 
-- WHERE b.department_id =
--      (Select department_id from departments where department_name = 'Finance')


-- 8) Find employees whose id is (134, 159, and 183)
-- SELECT * from employees where employee_id IN (134,159,183);


-- 9) Find employees whose salary is in the range of 1000 and 3000. 
-- SELECT * from employees where salary BETWEEN 1000 and 3000;


-- 10) Find employees whose salary is within range of smallest salary and 2500
-- SELECT * from employees WHERE salary BETWEEN (select Min(salary) from employees)
--      and 2500;


-- 11) Find employees who do not work in departments where ID's betweeen 100 and 200

-- SELECT * from employees 
-- WHERE department_id NOT IN 
--      (SELECT department_id 
--       FROM departments 
--       WHERE manager_id BETWEEN 100 and 200)


-- 12) Find employees who get the second-highest salary.

-- SELECT * FROM employees 
-- WHERE employee_id IN 
--      (SELECT employee_id FROM employees 
--       WHERE salary = 
--          (SELECT MAX(salary) FROM employees 
--           WHERE salary < 
--             (SELECT MAX(salary) FROM employees)))


-- 13) Find employees who work in same department as Clara, but do not include Clara.

-- SELECT first_name, last_name, hire_date 
-- FROM employees
-- WHERE department_id = 
--    (SELECT department_id FROM employees WHERE first_name = 'Clara')
-- AND first_name <> 'Clara';


-- 14) Find employees who work in department where employee's first name contains 'T'.

-- SELECT employee_ID, first_name, last_name FROM employees 
-- WHERE department_ID IN (select department_ID from employees WHERE first_name LIKE '%t%')


-- 15) Find employees who earn more than average salary and work in same dept as 
--     an employee whose first name contains 'J'.

-- SELECT employee_ID, first_name, salary FROM employees 
-- WHERE salary > (SELECT AVG(SALARY) from employees)
-- AND department_ID IN (select department_ID from employees where first_name LIKE '%J%')


-- 16) Find employees whose department is located at 'Toronto'. 

-- SELECT first_name, last_name, employee_ID, job_ID
-- from employees where department_ID = 
--   (select department_ID from departments where location_id =
--      (select location_id from locations where city = 'Toronto'))


-- 17) Find employees whose salary is lower than employees 
--     whose job title is 'MK-Man'.

-- SELECT employee_ID, first_name, last_name, job_ID FROM employees 
-- WHERE salary < ANY (select salary from employees where job_ID = 'MK_MAN')


-- 18) Find employees whose salary is lower than employees whose job title is 'MK-Man.'
--      Exclude employees with job title 'MK_MAN'.

-- SELECT employee_ID, first_name, last_name, job_ID 
-- FROM employees WHERE salary < ANY (Select salary FROM employees WHERE job_ID = 'MK_MAN')
-- AND job_ID <> 'MK_MAN'


-- 20) Find employees whose salaries are higher than average for all departments.

-- SELECT employee_ID, first_name, last_name, job_ID
-- FROM employees WHERE salary > 
--             ALL (select avg(salary) FROM employees GROUP BY department_id);
--             ** ALL : greater than the biggest value


-- 21) Check if there are any employees with salaries exceeding 3700.
-- ** Use the 'EXISTS' clause to return values if true (aka checking values):

--  SELECT first_name, last_name, department_ID FROM employees
--  WHERE EXISTS (select * from employees where salary > 3700);


-- 22) Calculate total salary of departments where at least one employee works.

-- SELECT departments.department_id, result1.total_amt 
-- FROM departments,  
--  (SELECT employees.department_id, SUM(employees.salary) total_amt  
--   FROM employees  
--   GROUP BY department_id) result1 
-- WHERE result1.department_id = departments.department_id;

-- ** for 22: also try-
-- SELECT departments.department_id, result1.total_amt 
-- FROM departments  
-- JOIN (SELECT employees.department_id, SUM(employees.salary) total_amt  
--        FROM employees  
--        GROUP BY department_id) result1 
-- ON result1.department_id = departments.department_id;


-- 23) Display employee ID, first/last names, job ID with modified title Salesman
--     for those employees whose job title is ST_Man and developer 
--     for whose job title is IT_PROG.

--SELECT  employee_id,  first_name, last_name,  
--CASE job_id  
--  WHEN 'ST_MAN' THEN 'SALESMAN'  
--  WHEN 'IT_PROG' THEN 'DEVELOPER'  
--  ELSE job_id  
-- END AS designation,  salary 
-- FROM employees;


-- 24) Display employee id, name, salary and SalaryStatus column with a title HIGH and LOW
--      respective for those employees whose salary is more than and less than
--      the average salary of all employees.

SELECT employee_id, first_name, last_name, salary,
CASE salary
	WHEN salary >= 
		(SELECT AVG(Salary) FROM employees) THEN ‘HIGH’
	ELSE ‘LOW’
END AS SalaryStatus
FROM Employees;

-- 26) Find all departments where at least one employee is employed.

-- SELECT departments.department_name, 
-- FROM departments,
--  (SELECT COUNT(DISTINCT employees) as Count FROM employees GROUP BY e.department_ID ) e
-- WHERE departments.department_id = e.department_id
-- AND e.Count >= 1;
--  ** W3 answer:
-- SELECT  department_name 
-- FROM departments 
-- WHERE department_id IN 
-- (SELECT DISTINCT(department_id) 
-- FROM employees);

-- 34) 
-- SELECT a.employee_id, a.first_name, a.last_name, a.salary, b.department_name, c.city  
-- employees a, departments b, locations c  
-- WHERE a.salary =  
-- (SELECT MAX(salary) 
-- FROM employees 
-- WHERE hire_date BETWEEN '01/01/2002' AND '12/31/2003') 
-- AND a.department_id=b.department_id 
-- AND b.location_id=c.location_id;

-- 48) 
SELECT *
FROM departments
WHERE DEPARTMENT_ID IN
    (SELECT DEPARTMENT_ID
     FROM employees
     WHERE EMPLOYEE_ID IN
         (SELECT EMPLOYEE_ID
          FROM job_history
          GROUP BY EMPLOYEE_ID
          HAVING COUNT(EMPLOYEE_ID) > 1)
     GROUP BY DEPARTMENT_ID
     HAVING MAX(SALARY) > 7000);