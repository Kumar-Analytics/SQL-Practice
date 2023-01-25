Set IDENTITY_INSERT [dbo].[Employees] ON;

Select * from [dbo].[Employees];

CREATE TABLE [dbo].[Employees](

	[EmployeeID] [int] IDENTITY(1,1) NOT NULL,

	[FullName] [nvarchar](250) NOT NULL,

	[DeptID] [int] NULL,

	[Salary] [int] NULL,

	[HireDate] [date] NULL,

	[ManagerID] [int] NULL

) ;

INSERT [dbo].[Employees] ([EmployeeID], [FullName], [DeptID], [Salary], [HireDate], [ManagerID]) VALUES (1, 'Owens, Kristy', 1, 35000, '2018-01-22' , 3);

INSERT [dbo].[Employees] ([EmployeeID], [FullName], [DeptID], [Salary], [HireDate], [ManagerID]) VALUES (2, 'Adams, Jennifer', 1, 55000, '2017-10-25' , 5);

INSERT [dbo].[Employees] ([EmployeeID], [FullName], [DeptID], [Salary], [HireDate], [ManagerID]) VALUES (3, 'Smith, Brad', 1, 110000, '2015-02-02' , 7);

INSERT [dbo].[Employees] ([EmployeeID], [FullName], [DeptID], [Salary], [HireDate], [ManagerID]) VALUES (4, 'Ford, Julia', 2, 75000, '2019-08-30' , 5);

INSERT [dbo].[Employees] ([EmployeeID], [FullName], [DeptID], [Salary], [HireDate], [ManagerID]) VALUES (5, 'Lee, Tom', 2, 110000, '2018-10-11' , 7);

INSERT [dbo].[Employees] ([EmployeeID], [FullName], [DeptID], [Salary], [HireDate], [ManagerID]) VALUES (6, 'Jones, David', 3, 85000, '2012-03-15' , 5);

INSERT [dbo].[Employees] ([EmployeeID], [FullName], [DeptID], [Salary], [HireDate], [ManagerID]) VALUES (7, 'Miller, Bruce', 1, 100000, '2014-11-08' , NULL);

INSERT [dbo].[Employees] ([EmployeeID], [FullName], [DeptID], [Salary], [HireDate], [ManagerID]) VALUES (9, 'Peters, Joe', 3, 11000, '2020-03-09' , 5);

INSERT [dbo].[Employees] ([EmployeeID], [FullName], [DeptID], [Salary], [HireDate], [ManagerID]) VALUES (10, 'Joe, Alan', 3, 11500, '2020-03-09' , 5);

INSERT [dbo].[Employees] ([EmployeeID], [FullName], [DeptID], [Salary], [HireDate], [ManagerID]) VALUES (11, 'Clark, Kelly', 2, 11500, '2020-03-09' , 5);

-- Question: Find employees with highest salary in a department. 
-- Method 1:
    -- 1) Find maximum salary in each department and then find the employee whose salary is equal to the maximum salary.
    -- 2) Use of sub-query and Inner Join
Select EmployeeID, FullName, Emp.DeptID, Salary 
from Employees as Emp --Find employee whose salary is...
Inner Join (
    Select DeptID, Max(salary) as MaxSalary from Employees
    group by DeptID --Max Salary from each dept
) as MaxSalEmp 
ON Emp.DeptID = MaxSalEmp.DeptID 
AND Emp.Salary = MaxSalEmp.MaxSalary --..equal to max salary

--Method 2:
    -- 1) Use aggregate functions to rank the employees in order of their salary.
    -- 2) Filter on the salary with the highest rank. 
SELECT 
    EmployeeID, FullName, 
    DeptID, Salary  FROM 
    (SELECT EmployeeID, FullName, DeptID, Salary ,
    rank() OVER (
        PARTITION by DeptID Order BY Salary DESC) 
        AS MaxSal -- Rank employees with aggregate functions
FROM dbo.Employees ) AS Emp 
WHERE Emp.MaxSal  = 1  -- Filter on salary with highest rank

-- Question: Find employees with salary lesser than the dept average.
Select 
    EmployeeID, FullName, 
    Emp.DeptID, Salary 
from Employees as Emp
Inner Join (
    Select DeptID, Avg(salary) as AvgSalary from Employees
    group by DeptID
) as AvgSalEmp
ON Emp.DeptID = AvgSalEmp.DeptID 
AND Emp.Salary < AvgSalEmp.AvgSalary

--Question: Find employees with less than avg salary in their dept but more than avg of any other dept.
SELECT 
    EmployeeID, FullName, Emp.DeptID, Salary 
FROM Employees AS Emp
INNER JOIN (
    SELECT DeptID, Avg(salary) AS AvgSalary FROM Employees
    GROUP BY DeptID
) AS AvgSalEmp
ON Emp.DeptID = AvgSalEmp.DeptID 
AND Emp.Salary < AvgSalEmp.AvgSalary
WHERE Emp.Salary > ANY (
    SELECT Avg(salary) FROM Employees
    GROUP BY DeptID)

--Question: Find employees with same salary
Select s1.EmployeeID, s1.Salary
FROM Employees s1
    INNER JOIN Employees s2
ON s1.Salary = s2.Salary
AND s1.EmployeeID <> s2.EmployeeID 