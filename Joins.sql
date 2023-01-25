# Practice Joins #

# Inner Join #
SELECT * from SQLtutorial.employeeDemographics
INNER JOIN SQLtutorial.employeeSalary
	ON employeeDemographics.employeeID = employeeSalary.employeeID
# This will look at the common data between tables #

# Full Outer Join #
SELECT * from SQLtutorial.employeeDemographics
FULL OUTER JOIN SQLtutorial.employeeSalary
	ON employeeDemographics.employeeID = employeeSalary.employeeID
# Will look at all data from both tables. If there is no match between tables, it will just show as null. #

# Left Outer Join #
SELECT * from SQLtutorial.employeeDemographics
LEFT OUTER JOIN SQLtutorial.employeeSalary
	ON employeeDemographics.employeeID = employeeSalary.employeeID
# Will show data from left table, the overlapping data with right table, but not data that is only in right table. #

# Right Outer Join #
SELECT * from SQLtutorial.employeeDemographics
RIGHT OUTER JOIN SQLtutorial.employeeSalary
	ON employeeDemographics.employeeID = employeeSalary.employeeID
# Will show data from right table, the overlapping data with left table, but not data that is only in left table. #

# Select Columns with Joins #
SELECT employeeDemographics.employeeID, FirstName, LastName, JobTitle
FROM SQLTutorial.employeeDemographics 
INNER JOIN SQLTutorial.employeeSalary 
	ON employeeDemographics.employeeID = employeeSalary.employeeID
    
SELECT employeeSalary.employeeID, FirstName, LastName, JobTitle
FROM SQLTutorial.employeeDemographics 
RIGHT OUTER JOIN SQLTutorial.employeeSalary 
	ON employeeDemographics.employeeID = employeeSalary.employeeID
    
# Query from Joins #
SELECT employeeDemographics.employeeID, FirstName, LastName, Salary
from SQLtutorial.employeeDemographics
Inner Join SQLtutorial.employeeSalary
	ON employeeDemographics.employeeID = employeeSalary.employeeID
WHERE FirstName <> 'Michael'
ORDER BY Salary DESC

SELECT JobTitle, AVG(Salary)
from SQLtutorial.employeeDemographics
Inner Join SQLtutorial.employeeSalary
	ON employeeDemographics.employeeID = employeeSalary.employeeID
WHERE JobTitle = 'Salesman'
Group by Jobtitle



