--Tables Structure:
create table _Users
(
user_id int primary key,
user_name varchar(30) not null,
email varchar(50));

insert into _Users values
(1, 'Sumit', 'sumit@gmail.com'),
(2, 'Reshma', 'reshma@gmail.com'),
(3, 'Farhana', 'farhana@gmail.com'),
(4, 'Robin', 'robin@gmail.com'),
(5, 'Robin', 'robin@gmail.com');

Insert into _users (user_id, user_name, email)
Values (6, 'Reshma', 'reshma@gmail.com')

select * from _users

-- Query 1:
--Write a SQL query to fetch all the duplicate records from a table.
select user_id, user_name, email 
from ( 
    select *, 
    row_number() over (partition by user_name order by user_id) as rn
    from _users ) x 
where x.rn > 1
order by user_id
 

--Table 2 Structure:

create table doctors
(
id int primary key,
name varchar(50) not null,
speciality varchar(100),
hospital varchar(50),
city varchar(50),
consultation_fee int
);

insert into doctors values
(1, 'Dr. Shashank', 'Ayurveda', 'Apollo Hospital', 'Bangalore', 2500),
(2, 'Dr. Abdul', 'Homeopathy', 'Fortis Hospital', 'Bangalore', 2000),
(3, 'Dr. Shwetha', 'Homeopathy', 'KMC Hospital', 'Manipal', 1000),
(4, 'Dr. Murphy', 'Dermatology', 'KMC Hospital', 'Manipal', 1500),
(5, 'Dr. Farhana', 'Physician', 'Gleneagles Hospital', 'Bangalore', 1700),
(6, 'Dr. Maryam', 'Physician', 'Gleneagles Hospital', 'Bangalore', 1500);

select * from doctors;
-- Query 4:
--From the doctors table, fetch the details of doctors who work in the same hospital 
    --..but are in different speciality.
select user_id, user_name, email 
from ( 
    select *, 
    row_number() over (partition by user_name order by user_id) as rn
    from _users ) x 
where x.rn > 1
order by user_id

Select d1.id, d1.name, d1.speciality, d1.hospital
from doctors d1
inner join doctors d2
    on d1.id <> d2.id --do not match same doctors from d1 and d2
    And d1.hospital = d2.hospital --find doctors from same hospital
    And d1.speciality <> d2.speciality --do not find from same speciality
  
create table login_details(
login_id int primary key,
user_name varchar(50) not null,
login_date date);

insert into login_details values
(101, 'Michael', GETDATE()),
(102, 'James', GETDATE()),
(103, 'Stewart', GETDATE()+1),
(104, 'Stewart', GETDATE()+1),
(105, 'Stewart', GETDATE()+1),
(106, 'Michael', GETDATE()+2),
(107, 'Michael', GETDATE()+2),
(108, 'Stewart', GETDATE()+3),
(109, 'Stewart', GETDATE()+3),
(110, 'James', GETDATE()+4),
(111, 'James', GETDATE()+4),
(112, 'James', GETDATE()+5),
(113, 'James', GETDATE()+6);
-- Query 5:
-- From the login_details table, fetch the users who logged in consecutively 3 
    -- or more times.
    -- Case statement will be needed
select * from login_details;

select distinct(user_name)
from (
    select *,
    case when user_name = lead(user_name) over(order by login_id)
            and user_name = lead(user_name, 2) over(order by login_id)
        then user_name 
        else null
    end as repeated_users
    from login_details) x 
where x.repeated_users is not null

create table weather
(
id int,
city varchar(50),
temperature int,
day date
);

insert into weather values
(1, 'London', -1, '2021-01-01'),
(2, 'London', -2, '2021-01-02'),
(3, 'London', 4, '2021-01-03'),
(4, 'London', 1, '2021-01-04'),
(5, 'London', -2, '2021-01-05'),
(6, 'London', -5, '2021-01-06'),
(7, 'London', -7, '2021-01-07'),
(8, 'London', 5, '2021-01-08');

select * from weather;

select distinct(user_name)
from (
    select *,
    case when user_name = lead(user_name) over(order by login_id)
            and user_name = lead(user_name, 2) over(order by login_id)
        then user_name 
        else null
    end as repeated_users
    from login_details) x 
where x.repeated_users is not null

select id, city, temperature, day 
from (select *,
    case when temperature < 0
        and lead(temperature) over (order by id) < 0
        and lead(temperature, 2) over (order by id) < 0
    then 'Yes'
    when temperature < 0
        and lag(temperature) over (order by id) < 0
        and lead(temperature) over (order by id) < 0
    then 'Yes'
     when temperature < 0
        and lag(temperature) over (order by id) < 0
        and lag(temperature, 2) over (order by id) < 0
    then 'Yes' 
    else null
    end as flag
from weather) x 
where x.flag is not null

--Table Structure:
create table patient_logs
(
  account_id int,
  date date,
  patient_id int
);

insert into patient_logs values (1, '2020-01-02', 100);
insert into patient_logs values (1, '2020-01-27', 200);
insert into patient_logs values (2, '2020-01-01', 300);
insert into patient_logs values (2, '2020-01-21', 400);
insert into patient_logs values (2, '2020-01-01', 300);
insert into patient_logs values (2, '2020-01-01', 500);
insert into patient_logs values (3, '2020-01-20', 400);
insert into patient_logs values (1, '2020-03-04', 500);
insert into patient_logs values (3, '2020-01-20', 450);

select * from patient_logs;

-- Query 9:
--Find the top 2 accounts with the maximum number of unique patients on a monthly basis.
--Note: Prefer the account if with the least value in case of same number of unique patients

month  account  no_of_patients  unique_patients
jan    1        2               2            --> YES
jan    2        4               3            --> YES
jan    3        2               2            --> NO
mar    1        1               1            --> YES

select month, account_id, no_of_patients 
from (
    select *,
    rank() over (partition by month order by no_of_patients desc, account_id) as rnk
    from (
        select month, account_id, count(1) as no_of_patients
        from (
            select distinct MONTH(date) as month, account_id, patient_id 
            from patient_logs) pl
        group by month, account_id) x 
) temp
where temp.rnk in (1,2);
