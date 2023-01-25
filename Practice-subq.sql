-- W3 Practice- JOINS

-- 1) From the following tables write a SQL query to find the salesperson 
--    and customer who reside in the same city. 
--    Return Salesman, cust_name and city.

--SELECT salesman.name as Sales, customer.cust_name as Cust, city
--FROM salesman
--JOIN customer ON salesman.city = customer.city

-- 2) Find orders where order amount exists between 500 and 3000. 

-- SELECT customer_id, o.ord_no, o.purch_amt, c.cust_name, c.city
-- FROM orders o
-- JOIN customer c
-- ON o.customer_id = c.customer_id
-- WHERE o.purch_amt BETWEEN 500 and 2000

-- 3) Find salesperson(s) and the customer(s) he represents. 

-- SELECT a.cust_name AS "Customer Name", 
-- a.city, b.name AS "Salesman", b.commission 
-- FROM customer a 
-- INNER JOIN salesman b 
-- ON a.salesman_id=b.salesman_id;

-- 4) Write query to find salespeople who received commissions of >12%.
-- 5) and find this for salespeople city =/= customer city

-- SELECT a.cust_name AS "Customer Name", 
-- a.city, b.name AS "Salesman", b.city, b.commission 
-- FROM customer a 
-- INNER JOIN salesman b 
-- ON a.salesman_id=b.salesman_id
-- WHERE b.commission > 0.12; (next line is for 5 which includes whole stmt)
-- AND a.city <> b.city; 

-- 6) Write query to find details of an order.
-- SELECT a.ord_no,va.ord_date, a.purch_amt,
-- b.cust_name AS "Customer Name", b.grade, 
-- c.name AS "Salesman", c.commission 
-- FROM orders a 
-- INNER JOIN customer b 
-- ON a.customer_id=b.customer_id 
-- INNER JOIN salesman c 
-- ON a.salesman_id=c.salesman_id;