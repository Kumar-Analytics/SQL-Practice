# String Functions 
	# TRIM, RTRIM, REPLACE, SUBSTRING, Upper, Lower
# Example - A Table has been created with multiple errors #
Insert into EmployeeErrors Values
('1001 ', 'Jimbo', 'Halbert'),
(' 1002', 'Pamela', 'Beasely'),
('1005', 'TOby', 'Flenderson - Fired');

# Using Trim, LTRIM, RTRIM #
	# TRIM FIXES SPACES FROM BOTH SIDES
Select EmployeeID, TRIM(EmployeeID) as IDTRIM
FROM EmployeeErrors;
	# LTRIM FIXES SPACES FROM LEFT SIDE ONLY
Select EmployeeID, LTRIM(EmployeeID) as IDTRIM
FROM EmployeeErrors;
	# RTRIM FIXES SPACES FROM RIGHT SIDE ONLY
Select EmployeeID, RTRIM(EmployeeID) as IDTRIM
FROM EmployeeErrors;

# Using REPLACE #
Select LastName, REPLACE(LastName, '- Fired','') as LastNameFixed
FROM EmployeeErrors;

# Using Substring - specify place you want to start from (number or letter), and where you want to go to. #
Select SUBSTRING(FirstName,1,3) # Start from first letter and then forward 3 spots #
FROM EmployeeErrors;

# Fuzzy matching - if two tables have different versions of a name (Alex, Alexander), Fuzzy Matching will match them together 
	# Can work most of the time, but not every time
Select SUBSTRING(err.FirstName,1,3), SUBSTRING(dem.FirstName,1,3)
From EmployeeErrors err
JOIN EmployeeDemographics dem
	ON SUBSTRING(err.FirstName,1,3) = SUBSTRING(dem.FirstName,1,3);
	# Fuzzy Match is usually done for Gender, LastName, Age, DOB instead of simply first names 
		# (for ex, if you didn't have an employee ID available)

# Using UPPER and lower #
Select FirstName, LOWER(FirstName) From EmployeeErrors; # Makes column's characters all lowercase #
Select FirstName, UPPER(FirstName) From EmployeeErrors  # Makes column's characters all uppercase #

