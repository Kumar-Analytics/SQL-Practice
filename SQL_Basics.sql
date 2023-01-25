# SQL Basics Review #

# Creating a table, inserting values, updating a value in a row, adding a column 
Create table awards (
	id Integer PRIMARY KEY, # PRIMARY KEY columns can be used to uniquely identify the row. 
    name Varchar(255) UNIQUE, # UNIQUE columns have a different value for every row. Can have many UNIQUE columns. 
    date_of_birth Varchar(255) NOT NULL, # NOT NULL columns must have a value. 
    award_name TEXT #Default 'Grammy' # DEFAULT columns take an additional argument that..
);								     # .. will be the assumed value for an inserted row if the 
                                     # .. new row does not specify a value for that column. 
                                     
INSERT INTO awards (id, name, date_of_birth)
VALUES (1, 'Nolan', 'January');

UPDATE awards
Set award_name = 'Emmy'
WHERE id = 1;

Select * from awards;

ALTER Table awards
ADD column email TEXT;

# Wildcard operators # 
# Use 'like' to compare similar values 
Select * from awards
WHERE name LIKE 'N_lan';

# 'x%' shows values beginning with 'x' 
# '%x' shows values ending with 'x' 
# '%x%' shows all values that have 'x' within its string
Select * from awards WHERE name LIKE 'n%';
Select * from awards where name LIKE '%n';
Select * from awards WHERE name LIKE '%n%';

# The BETWEEN operator is used in a WHERE clause to filter the result set within a certain range. 
		# .. It accepts two values that are either numbers, text or dates.
# Following statement filters result to show movies within 1990 up to & including 1999. #
Select * from movies where year BETWEEN 1990 AND 1999;

# When the values are text, BETWEEN filters the result set for within the alphabetical range.
# Following statement filiters result set to only include movies with names that..
	# ..begin with the letter ‘A’, up to BUT not including ones that begin with ‘J’. 
Select * from movies WHERE name BETWEEN 'A' and 'J';
	# However, if a movie has a name of simply ‘J’, it would actually match. 
		# This is because BETWEEN goes up to the second value — up to ‘J’. 
		# So the movie named ‘J’ would be included in the result set but not ‘Jaws’.

# Example of Case statement #
Select name,
	CASE
		WHEN imdb_rating > 8 THEN 'Fantastic'
        WHEN imdb_rating BETWEEN 5 AND 7 THEN 'Okay'
        ELSE 'Avoid'
	END AS 'Review' # This will be a column that populates Case results #
FROM movies;

# Aggregate functions - Following example rounds average price to 2 decimal places #
SELECT ROUND(AVG(price), 2) FROM fake_apps;

# GROUP BY is used with aggregate functions and arranges identical data into groups.
	# GROUP BY comes after WHERE statements, but before ORDER BY or LIMIT. 
# The following query's result contains the total number of apps for each price. #
SELECT price, COUNT(*) 
FROM fake_apps 
GROUP BY price; 

# Show average rating by year #
Select year, AVG(imdb_rating) 
FROM movies
GROUP BY year
ORDER BY year;

# GROUP BY Calculations On Columns #
# Column references in GROUP BY: 1 is first column selected, 2 is second column selected, etc. #
# Following query shows how many movies have ratings that round to 1,2,3,4,5, etc. #
SELECT ROUND(imdb_rating), COUNT(name)
FROM movies
GROUP BY 1 # This groups by the first column #
ORDER BY 1; # Orders by the first column #

#Use HAVING to filter groups. This lets you limit results of a query based on an aggregate property
	# Whereas WHERE is used to filter rows. This lets you limit results of a query based on values of individual rows. 
# Example of using HAVING to filter results by name count: 
SELECT year, genre, COUNT(name)
FROM movies
GROUP BY 1,2
HAVING COUNT(name) > 10;
	# HAVING always comes after GROUP BY, but before ORDER BY and LIMIT #
    
# Example of query returning avg downloads (rounded) and number of apps at each price point (of > 10 apps).
	# We are looking at price points with more than 10 apps for meaningful averages. 
SELECT price, ROUND(AVG(downloads)), COUNT(*) 
FROM fake_apps
GROUP BY price
HAVING COUNT(*) > 10;

# Subquery / Nested Query #
SELECT EmployeeID, JobTitle, Salary
FROM EmployeeSalary
WHERE EmployeeID in (
	Select EmployeeID
    From EmployeeDemographics
    Where Age > 30);