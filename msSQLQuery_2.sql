--Question: Find Dept Where none of the employees has salary greater than manager's salary
Select Distinct(DeptID) from Employees Emp 
WHERE DeptID NOT IN (
    Select Emp.DeptID FROM Employees Emp
    INNER JOIN Employees Mgr
        ON Emp.ManagerID = Mgr.EmployeeID
    AND Emp.Salary > Mgr.Salary
)

--Question: Find the difference between employee salary and avg salary of dept
Select EmployeeID, Salary, DeptID,
    AVG(Salary) OVER (Partition by DeptID) as AvgSal_Dept,
    Salary - (Avg(salary) OVER (Partition by DeptID)) As salary_diff
From Employees

--Question: Find employees whose salary is in top 2 percentile in the dept
Select EmployeeID, FullName, DeptID, Salary 
From (Select EmployeeID, FullName, DeptID, Salary,
        PERCENT_RANK()Over (Partition by DeptID Order by Salary desc)
        as Percentile 
    from Employees) as Emp 
Where Emp.Percentile >= .98
    
--Question: Find employees who earn more than every employee in dept 2
--Method 1:
    --1) List Salaries of all employees in the department
    --2) Use ALL to compare employee salary with all values from above
Select * from Employees 
where salary > ALL(Select Salary from Employees where DeptID = 2)
-- Method 2:
    --1) Find max salary in each dept
    --2) Filter records where employee salary > max salary from above
Select * from employees where salary > (select max(salary) from employees where deptid=2)

--Question: Find dept names with at least 2 employees whose salary is greater than...
    --... 90% of respective dept avg salary
select * from (
    select DeptID, EmployeeID, 
        sum(case when salary > avg_dept_sal * 0.9 then 1 else 0 end)
        over (partition by deptID) as empcnt 
    from (
        select e.deptid, e.employeeid, e.salary,
        avg(salary) over (partition by e.deptid) as avg_dept_sal
    from employees e
    ) t1
) t2
where empcnt >= 2

--Question: Select top 3 departments with at least 2 employees...
    --... and rank them according to percentage of their employees making over 100k 
    --1) Count employees making over 100k salary
    --2) Calculate percentage by dividing by total number of employees in relative dept
    --3) Order by percentage calculated in step 2
    --4) Use TOP to filter top 2 dept's
Select 
    deptid, 
    SUM(CASE WHEN salary > 100000 THEN 1 Else 0
    END)/COUNT(employeeid) as EmpOver100k,
    COUNT(employeeid) as EmpCount
FROM Employees
    GROUP BY DeptID
    HAVING COUNT(*) > 2
ORDER BY 2 DESC
