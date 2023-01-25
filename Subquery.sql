# Subqueries + Correllated Subqueries #
# Tutorial is based on PostgreSQL 12 syntax #

# Q: Find the employees whose salary is higher than the average salary earned by all employees. #
	# 1) Find Average Salary
    # 2) Filter the employees based on the above result
Select avg(salary) from employee; # 5791.667
Select * from employee
Where salary > 5791.667; # This query needs to be more dynamic because the average will change

Select * from employee # Outer query / main query
Where salary > (select avg(salary) from employee); # Subquery / inner query

# 3 types of subqueries - Scalar, Multiple Row, Correlated #

# Scalar subquery - will return one row and one column 
Select * from employee e
join (select avg(salary) sal from employee) avg_sal # When joining a subquery, its output is treated as a table #
	on e.salary > avg_sal.sal;
    
# Multiple Row Subquery
	# 1st type - multiple columns and multiple rows
    # 2nd type - one column and multiple rows

# Q: Find employees who earn the highest salary in each department. #
Select dept_name, max(salary) from employee group by dept_name; # This will be the filtering subquery

Select * from employee 
where (dept_name, salary) in (
		Select dept_name, max(salary) 
			from employee group by dept_name);
            
# Single Column, Multiple Row Subquery
	# Question: Find department that has no employees
Select distinct(dept_name) from employee; # Find departments

Select * from department 
	where dept_name not in (
		Select distinct(dept_name) from employee); # One column, many rows

# Correlated Subquery #
	# Question- fomd employees in each dept who earn more than the avg salary in their respective dept
Select avg(salary) from employee where dept_name = 'specific_dept';

Select * from
employee e1 where salary > ( # Outer query will employees w/ salary greater than avg salary for each dept
	select avg(salary) from employee e2 # Subquery will show avg salary for each dept
		where e2.dept_name = e1.dept_name); # The 'where' will check each dept from e1 and e2 tables
        
 # Correlated subqueries are not preferred, where joins can be more useful #

 # Common question that correllated subqueries answer-
	# Find department that has no employees
Select * from department d
	where not exists (
		select 1 from employee e where e.dept_name = d.dept_name);
        # This query will return records in department that do not exist in employee

# Nested Subquery 
	# Subquery inside a subquery 
    
# Question: Find stores whose sales were better than the average sales across all stores
	# 1) Find Total Sales for each store
    # 2) Find average sales for all the stores
    # 3) Compare 1 & 2
select *
from (Select store_name, 
		sum(price) as total_sales
		from sales group by store_name) sales
join (select avg(total_sales) as sales 
		from (Select store_name, 
			sum(price) as total_sales
			from sales group by store_name) x) avg_sales
		on sales.total_sales > avg_sales.sales;
	# This can be rewritten as a 'with clause' (aka CTE)
with sales as 
(Select store_name, 
		sum(price) as total_sales
		from sales group by store_name)
Select *
from sales
join (select avg(total_sales) as sales 
		from sales x) avg_sales
		on sales.total_sales > avg_sales.sales;

# Different clauses where subqueries are used: SELECT, FROM, WHERE. HAVING #
	# Using a subquery in SELECT clause
    # Question: Fetch all employee details and add remarks to employees who earn more than the average pay.
Select * 
, (case when salary > (select avg(salary) from employee)
			then 'Higher than average'
		else null
    end) as remarks
from employee;
	# This can be modified to remove select clause from first subquery and cross join it instead
Select * 
, (case when salary > avg_sal.sal
		then 'Higher than average'
		else null
	end) as remarks
from employee
cross join (select avg(salary) sal from employee) avg_sal;

# Using a subquery in a HAVING clause #
	# Question: Find the stores who have sold more units than the average units sold by all stores
Select store_name, sum(quantity)
from sales
group by store_name
HAVING sum(quantity) > (select avg(quantity) from sales);

# Subqueries can be used in INSERT, UPDATE and DELETE clauses as well #
	# Question: Insert data to employee history table. Make sure to not insert duplicate records. 
insert into employee_history
select e.emp_id, e.emp_name, d.dept_name, e.salary, d.location
from employee e
join department d on d.dept_name = e.dept_name
where not exists (select 1 from employee_history eh where eh.emp_id = e.emp_id);

# Update: Give 10% increment to all employees in x location
	# based on the max salary earned by an emp in each dept.
update employee e 
set salary = (select max(salary) + (max(salary) * 0.1)
	from employee_history eh
    where eh.dept_name = e.dept_name) # this is a correlated subquery
where e.dept_name in (select dept_name
					from department
					where location= 'Bangalore')
and e.emp_id in (select emp_id from employee history); # single column multi row subquery

# Delete- delete all departments who do not have any employees. #
Delete from department
where dept_name in (select dept_name.      
					from department d
					where not exists (select 1 
										from employee e where e.dept_name = d.dept_name)
					);
	