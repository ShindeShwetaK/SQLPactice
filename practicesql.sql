1. Find the top 3 cities with the highest sales per month. 
(sales_table):
| sale_id | city   | sale_date | amount | 
|---------|----------|------------|--------
| 1    | Mumbai  | 2024-01-10 | 5000 
| 2    | Delhi  | 2024-01-15 | 7000 
| 3    | Bangalore| 2024-01-20 | 10000
| 4    | Chennai | 2024-02-05 | 3000 
| 5    | Mumbai  | 2024-02-08 | 9000 

--Query
  select month, city, sales
  from (
  select date_format(sale_date,'%Y-%m') as month,
  city,
  sum(amount),
  RANK() over (Partitation by date_format(sale_date,'%Y-%m'), order by sum(amount) desc) as rank
  from sales
  group by month,city ) as ranked_city
  where rank < 3 ;
  
______________________________________________________________________________________________________  

2. Write an SQL query to calculate the running total of sales for each city. 
 (sales_data):
| sale_id | city   | sale_date | amount
|---------|---------|------------|-------
| 1    | Mumbai | 2024-01-10 | 5000 
| 2    | Delhi  | 2024-01-15 | 7000 
| 3    | Mumbai | 2024-01-20 | 3000 
| 4    | Delhi  | 2024-02-05 | 6000 
| 5    | Mumbai | 2024-02-08 | 8000 

--Query
  select city, 
  sales_date,
  amount,
  sum(amount) over (partation by city order by sales date) as running total
  from sales
  order by sales_date, city;
________________________________________________________________________________________________________

 3. Find the second highest salary of employees. 
 (employees):
| emp_id | emp_name | salary | department | 
|--------|---------|---------|------------| 
| 1   | Ravi  | 70000  | HR     | 
| 2   | Priya  | 90000  | IT     | 
| 3   | Kunal  | 85000  | Finance  | 
| 4   | Aisha  | 60000  | IT     | 
| 5   | Rahul  | 95000  | HR     | 

   query
   select max(salary) from employee where salary < (select max(salary) from employee)

   with sal as (
   select salary,
   rank() over (order by salary desc) as sal_rank
   from employee ) 
   select salary from sal where sal_rank = 2;
   ___________________________________________________________________________________________________
   

 4. Find employees who have the same salary as someone in the same department. 
 (employee_salary):
| emp_id | emp_name | salary | department | 
|--------|---------|---------|------------| 
| 1   | Neha  | 50000  | HR     | 
| 2   | Ravi  | 70000  | IT     | 
| 3   | Aman  | 50000  | HR     | 
| 4   | Pooja  | 90000  | IT     | 
| 5   | Karan  | 70000  | IT     | 

   Query
   select emp_name , salary, department from 
   employee_salary e1 join 
   employee_salary e2 on 
   e1.salary = e2.salary
   where e1.emp_id <> e2.emp_id and
   e1.department = e2.department

____________________________________________________________________________________________

5. Write an SQL query to find duplicate records in a table. 
 (users):
| user_id | user_name | email 
|---------|----------|-----------------
| 1    | Sameer  | sameer@gmail.com
| 2    | Anjali  | anjali@gmail.com 
| 3    | Sameer  | sameer@gmail.com
| 4    | Rohan  | rohan@gmail.com 
| 5    | Rohan  | rohan@gmail.com 

SELECT user_name, email, COUNT(*) AS count
FROM users
GROUP BY user_name, email
HAVING COUNT(*) > 1;

________________________________________________________________________________________

 6. Write an SQL query to delete duplicate rows while keeping only one unique record. 
(Same sample data as Question 5)

WITH CTE AS (
    SELECT 
        user_id,
        user_name,
        email,
        ROW_NUMBER() OVER (PARTITION BY user_name, email ORDER BY user_id) AS rn
    FROM users
)
DELETE FROM users
WHERE user_id IN (
    SELECT user_id
    FROM CTE
    WHERE rn > 1
);

____________________________________________________________________________________


   
 7. Write an SQL query to pivot a table by months. 
Sample Data (sales_data):
| sale_id | city   | sale_date | amount | 
|---------|---------|------------|--------
| 1    | Mumbai | 2024-01-10 | 5000 
| 2    | Delhi  | 2024-02-15 | 7000 
| 3    | Mumbai | 2024-01-20 | 3000 
| 4    | Delhi  | 2024-03-05 | 6000 
| 5    | Mumbai | 2024-02-08 | 8000

   SELECT 
    city,
    SUM(CASE WHEN EXTRACT(MONTH FROM sale_date) = 1 THEN amount END) AS Jan,
    SUM(CASE WHEN EXTRACT(MONTH FROM sale_date) = 2 THEN amount END) AS Feb,
    SUM(CASE WHEN EXTRACT(MONTH FROM sale_date) = 3 THEN amount END) AS Mar,
    SUM(CASE WHEN EXTRACT(MONTH FROM sale_date) = 4 THEN amount END) AS Apr,
    SUM(CASE WHEN EXTRACT(MONTH FROM sale_date) = 5 THEN amount END) AS May,
    SUM(CASE WHEN EXTRACT(MONTH FROM sale_date) = 6 THEN amount END) AS Jun,
    SUM(CASE WHEN EXTRACT(MONTH FROM sale_date) = 7 THEN amount END) AS Jul,
    SUM(CASE WHEN EXTRACT(MONTH FROM sale_date) = 8 THEN amount END) AS Aug,
    SUM(CASE WHEN EXTRACT(MONTH FROM sale_date) = 9 THEN amount END) AS Sep,
    SUM(CASE WHEN EXTRACT(MONTH FROM sale_date) = 10 THEN amount END) AS Oct,
    SUM(CASE WHEN EXTRACT(MONTH FROM sale_date) = 11 THEN amount END) AS Nov,
    SUM(CASE WHEN EXTRACT(MONTH FROM sale_date) = 12 THEN amount END) AS Dec
FROM sales_data
GROUP BY city;   

________________________________________________________________

8. Find customers who placed at least 3 orders in the last 6 months. 
Sample Data (orders):
| order_id | customer_id | order_date | amount | 
|---------|------------|------------|--------| 
| 1    | 101    | 2024-01-10 | 1000 
| 2    | 102    | 2024-02-15 | 2000 
| 3    | 101    | 2024-03-20 | 1500 
| 4    | 103    | 2024-04-05 | 2500 
| 5    | 101    | 2024-05-08 | 3000 

  SELECT customer_id
FROM orders
WHERE order_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY customer_id
HAVING COUNT(*) >= 3;

__________________________________________________________________


  

9. Normalization vs. Denormalization – What are they, and when should each be used in a data pipeline? 
A:
Normalization is the process of organizing data into multiple related tables to reduce data redundancy and improve data integrity. It ensures that updates and inserts are efficient and consistent. 
 It's commonly used in transactional systems (OLTP), like customer management or order processing databases, where data consistency is critical.
On the other hand, Denormalization combines related tables into a single table to reduce joins and improve read performance. This is typically used in data pipelines or analytics systems (OLAP), 
 like dashboards or reports, where fast query performance is more important than saving storage.
In a data pipeline, I would use normalization during data ingestion or storage stages to maintain clean, consistent data. Then, 
  I might use denormalization when preparing data for analysis or loading into a data warehouse to make queries faster and simpler.

  --------------------------------------------------------------------------------------------------------------------
  
10. Indexing in SQL – Explain clustered vs. non-clustered indexes. How do they impact query performance?
  Indexing in SQL is a technique used to improve the speed of data retrieval operations. It works like an index in a book — instead of scanning every row, 
  the database engine can quickly locate the data using the index.
A clustered index sorts and stores the actual table data according to the index. So, the table itself is organized based on this index. 
  There can only be one clustered index per table because data can be physically sorted in only one way. It's typically created on the primary key.
A non-clustered index, on the other hand, creates a separate structure that stores the indexed column and a pointer to the actual row in the table.
  A table can have multiple non-clustered indexes, and they’re useful for improving performance on frequently filtered, joined, or sorted columns.
In terms of query performance, indexes help reduce the time needed for SELECT queries, especially on large tables. 
  However, they can slightly slow down INSERT, UPDATE, and DELETE operations because the indexes must be updated as well.
In short, clustered indexes are best for range-based or primary key queries, while non-clustered indexes are ideal for optimizing search on other frequently queried fields.
  
