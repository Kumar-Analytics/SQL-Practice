# Intermediate / Advanced SQL #

# Union Operator #
# Select all data from both tables and put it into one stacked output. #
SELECT * FROM SQLTutorial.EmployeeDemographics
UNION # Stacks data from matching columns into one table output. Removes duplicates. #
	SELECT * FROM SQLTutorial.WarehouseEmployeeDemographics;

SELECT EmployeeID, FirstName, Age
FROM SQLTutorial.EmployeeDemographics
UNION # Will still stack data from columns into one table output if datatypes match. #
	Select EmployeeID, JobTitle, Salary
	FROM SQLTutorial.EmployeeSalary
ORDER BY EmployeeID;

# CTE / Common Table Expression- is a named temporary result set.
	# Used to manipulate complex subqueries' data. Only exists within the scope of query.
    # Created in memory, not a temporary db file.
WITH CTE_Employee as (
	SELECT FirstName, LastName, Gender, Salary,
		COUNT(gender) OVER (PARTITION by Gender) as TotalGender,
		AVG(Salary) OVER (PARTITION BY Gender) as AvgSalary
    FROM SQLTutorial.EmployeeDemographics emp
    JOIN SQLTutorial.EmployeeSalary sal
		ON emp.EmployeeID = sal.EmployeeID
	WHERE Salary < '45000'
)
Select FirstName, AvgSalary
FROM CTE_Employee;


# Stored Procedure (SQL SERVER) - Group of SQL Statements Created and Stored in that Database 
	# Accept input parameters - single stored procedure can be used by network's users
	# If it is modified, other users will see the update
# Simple Procedure #
CREATE PROCEDURE TEST AS Select * from EmployeeDemographics;
EXEC TEST;

# More Complex Procedure #
CREATE PROCEDURE Temp_Employee
AS
CREATE TABLE temp_employee (
JobTitle varchar(100),
EmployeesPerJob int,
AvgAge int,
AvgSalary int
)
INSERT INTO temp_employee
SELECT JobTitle, Count(JobTitle), Avg(Age), AVG(salary)
FROM SQLTutorial.EmployeeDemographics emp
JOIN SQLTutorial.EmployeeSalary sal
	ON emp.EmployeeID = sal.EmployeeID
group by JobTitle
Select * from temp_employee;

EXEC Temp_Employee;

# In Procedure, you can Alter Procedure #
ALTER PROCEDURE [dbo].[Temp_Employee]
@JobTitle nvarchar(100)
AS
CREATE TABLE temp_employee (
JobTitle varchar(100),
EmployeesPerJob int,
AvgAge int,
AvgSalary int
)
INSERT INTO temp_employee
SELECT JobTitle, Count(JobTitle), Avg(Age), AVG(salary)
FROM SQLTutorial.EmployeeDemographics emp
JOIN SQLTutorial.EmployeeSalary sal
	ON emp.EmployeeID = sal.EmployeeID
WHERE JobTitle = @JobTitle # Alteration with parameter (JobTitle) #
group by JobTitle
Select * from temp_employee

EXEC Temp_Employee @JobTitle = 'Salesman';
# Output will show query result for this parameter (in this case, row value) #
