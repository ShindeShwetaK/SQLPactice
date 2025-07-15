1 - Return Orders Customer Feedback

Namastekart, an e-commerce company, has observed a notable surge in return orders recently. They suspect that a specific group of customers may
be responsible for a significant portion of these returns. To address this issue, their initial goal is to identify customers who have returned
more than 50% of their orders. This way, they can proactively reach out to these customers to gather feedback.

Write an SQL to find list of customers along with their return percent (Round to 2 decimal places), display the output in ascending order of customer name.

Table: orders (primary key : order_id)
+---------------+-------------+
| COLUMN_NAME   | DATA_TYPE   |
+---------------+-------------+
| customer_name | varchar(10) |
| order_date    | date        |
| order_id      | int         |
| sales         | int         |
+---------------+-------------+

Table: returns (primary key : order_id)
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| order_id    | int       |
| return_date | date      |
+-------------+-----------+

Ans:-
select o.customer_name, round(count(r.order_id)*100/count(*),2)return_percentage
from orders o left join returns r on o.order_id = r.order_id
group by o.customer_name
having return_percentage > 50
order by o.customer_name;

########################################################################################################################
2 - Product Category
You are provided with a table named Products containing information about various products, including their names and prices. 
Write a SQL query to count number of products in each category based on its price into three categories below. Display the output in descending 
order of no of products.

1- "Low Price" for products with a price less than 100
2- "Medium Price" for products with a price between 100 and 500 (inclusive)
3- "High Price" for products with a price greater than 500.
Tables: Products
+--------------+-------------+
| COLUMN_NAME  | DATA_TYPE   |
+--------------+-------------+
| product_id   | int         |
| product_name | varchar(20) |
| price        | int         |
+--------------+-------------+

Ans:-
with cte as (
select product_id, product_name, price,
case 
when price < 100 then 'Low Price'
when price >= 100 and price <= 500 then 'Medium Price'
else 'High Price' 
end as category
from products )
select category, count(*) as no_of_products
from cte 
group by category
order by no_of_products desc;

########################################################################################################################
3- LinkedIn Top Voice
LinkedIn is a professional social networking app. They want to give top voice badge to their best creators to encourage them to create more quality content.
A creator qualifies for the badge if he/she satisfies following criteria.
1- Creator should have more than 50k followers.
2- Creator should have more than 100k impressions on the posts that they published in the month of Dec-2023.
3- Creator should have published atleast 3 posts in Dec-2023.
Write a SQL to get the list of top voice creators name along with no of posts and impressions by them in the month of Dec-2023.
Table: creators(primary key : creator_id)
+--------------+-------------+
| COLUMN_NAME  | DATA_TYPE   |
+--------------+-------------+
| creator_id   | int         |
| creator_name | varchar(20) |
| followers    | int         |
+--------------+-------------+
Table: posts(primary key : post_id)
+--------------+------------+
| COLUMN_NAME  | DATA_TYPE  |
+--------------+------------+
| creator_id   | int        |
| post_id      | varchar(3) |
| publish_date | date       |
| impressions  | int        |
+--------------+------------+

Ans:-
select creator_name, 
count(post_id) as total_post,
sum(impressions) as total_impression 
from creators c
left join posts p
on c.creator_id = p.creator_id
where c.followers > 50000 and
date_format(p.publish_date, '%Y%m') = '202312'
group by  c.creator_name
having 
sum(p.impressions) > 100000
and count(p.post_id) >= 3
;

Or
  
WITH post_summary AS (
    SELECT 
        c.creator_id,
        c.creator_name, 
        COUNT(p.post_id) AS total_post,
        SUM(p.impressions) AS total_impression
    FROM creators c
    LEFT JOIN posts p ON c.creator_id = p.creator_id
    WHERE c.followers > 50000 
      AND DATE_FORMAT(p.publish_date, '%Y%m') = '202312'
    GROUP BY c.creator_id, c.creator_name
)

SELECT *
FROM post_summary
WHERE total_impression > 100000
  AND total_post >= 3;

########################################################################################################################
4- - Premium Customers
An e-commerce company want to start special reward program for their premium customers.  
The customers who have placed a greater number of orders than the average number of orders placed by customers are considered as premium customers.
Write an SQL to find the list of premium customers along with the number of orders placed by each of them, display the results in highest to lowest no of orders.
Table: orders (primary key : order_id)
+---------------+-------------+
| COLUMN_NAME   | DATA_TYPE   |
+---------------+-------------+
| order_id      | int         |
| order_date    | date        |
| customer_name | varchar(20) |
| sales         | int         |
+---------------+-------------+
  Ans:
  WITH customer_order_counts AS (
    SELECT 
        customer_name,
        COUNT(order_id) AS total_orders
    FROM orders
    GROUP BY customer_name
),
average_order_count AS (
    SELECT 
        AVG(total_orders) AS avg_orders
    FROM customer_order_counts
)
SELECT 
    c.customer_name,
    c.total_orders
FROM customer_order_counts c
JOIN average_order_count a
  ON c.total_orders > a.avg_orders
ORDER BY c.total_orders DESC;
########################################################################################################################
5- CIBIL Score
  CIBIL score, often referred to as a credit score, is a numerical representation of an individual's credit worthiness. While the exact formula used by credit bureaus like CIBIL may not be publicly disclosed and can vary slightly between bureaus, the following are some common factors that typically influence the calculation of a credit score:

 

1- Payment History: This accounts for the largest portion of your credit score. 
 It includes factors such as whether you pay your bills on time, any late payments, defaults, bankruptcies, etc.
 Assume this accounts for 70 percent of your credit score.

2- Credit Utilization Ratio: This is the ratio of your credit card balances to your credit limits.
 Keeping this ratio low (ideally below 30%) indicates responsible credit usage. 
 Assume it accounts for 30% of your score and below logic to calculate it: 
 Utilization below 30% = 1
 Utilization between 30% and 50% = 0.7
 Utilization above 50% = 0.5
Assume that we have credit card bills data for March 2023 based on that we need to calculate credit utilization ratio. round the result to 1 decimal place.

 

Final Credit score formula = (on_time_loan_or_bill_payment)/total_bills_and_loans * 70 + Credit Utilization Ratio * 30 
Display the output in ascending order of customer id.

 

Table: customers
+--------------+-----------+
| COLUMN_NAME  | DATA_TYPE |
+--------------+-----------+
| customer_id  | int       |
| credit_limit | int       |
+--------------+-----------+

Table: loans
+---------------+-----------+
| COLUMN_NAME   | DATA_TYPE |
+---------------+-----------+
| customer_id   | int       |
| loan_id       | int       |
| loan_due_date | date      |
+---------------+-----------+

Table: credit_card_bills
+----------------+-----------+
| COLUMN_NAME    | DATA_TYPE |
+----------------+-----------+
| bill_amount    | int       |
| bill_due_date  | date      |
| bill_id        | int       |
| customer_id    | int       |
+----------------+-----------+

Table: customer_transactions
+------------------+-------------+
| COLUMN_NAME      | DATA_TYPE   |
+------------------+-------------+
| loan_bill_id     | int         |
| transaction_date | date        |
| transaction_type | varchar(10) |
+------------------+-------------+
  Ans:-
  
WITH all_bills AS (
    SELECT customer_id, loan_id AS bill_id, loan_due_date AS due_date, 0 AS bill_amount    --    Select loan bills with zero bill_amount
    FROM loans
    UNION ALL
    SELECT customer_id, bill_id, bill_due_date AS due_date, bill_amount                    --    Select credit card bills with actual amounts
    FROM credit_card_bills
),
on_time_calc AS (
    SELECT b.customer_id,
           SUM(b.bill_amount) AS bill_amount,                                            --    Total bill amount per customer
           COUNT(*) AS total_bills,                                                      --    Total number of bills per customer
           SUM(CASE WHEN ct.transaction_date <= due_date THEN 1 ELSE 0 END) AS on_time_payments    --    Count of on-time payments per customer
    FROM all_bills b
    INNER JOIN customer_transactions ct ON b.bill_id = ct.loan_bill_id                    --    Join bills with transactions on bill ID
    GROUP BY b.customer_id
)
SELECT c.customer_id,
       ROUND(
           (ot.on_time_payments * 1.0 / ot.total_bills) * 70 +                         --    Weight on-time payment ratio by 70%
           (CASE
                WHEN ot.bill_amount * 1.0 / c.credit_limit < 0.3 THEN 1               --    High score if bill amount < 30% of credit limit
                WHEN ot.bill_amount * 1.0 / c.credit_limit < 0.5 THEN 0.7             --    Medium score if bill amount < 50% of credit limit
                ELSE 0.5                                                            --    Low score otherwise
            END) * 30, 1
       ) AS cibil_score                                                                --    Calculate final cibil score rounded to 1 decimal place
FROM customers c
INNER JOIN on_time_calc ot ON c.customer_id = ot.customer_id                          --    Join customers with calculated payment info
ORDER BY c.customer_id ASC;                                                            --    Order results by customer_id ascending

########################################################################################################################
6 - Electricity Consumption

You have access to data from an electricity billing system, detailing the electricity usage and cost for specific
households over billing periods in the years 2023 and 2024. Your objective is to present the total electricity consumption, 
total cost and average monthly consumption for each household per year display the output in ascending order of each household id & year of the bill.

Tables: electricity_bill
+-----------------+---------------+
| COLUMN_NAME     | DATA_TYPE     |
+-----------------+---------------+
| bill_id         | int           |
| household_id    | int           |
| billing_period  | varchar(7)    |
| consumption_kwh | decimal(10,2) |
| total_cost      | decimal(10,2) |
+-----------------+---------------+

Ans:-
select household_id, 
LEFT(billing_period, 4)as bill_year,
sum(consumption_kwh) as consumption_kwh,
sum(total_cost) As total_cost,
avg(consumption_kwh) as avg_consumption_kwh
from electricity_bill 
group by household_id, bill_year
order by household_id, bill_year;

########################################################################################################################
7- Airbnb Top Hosts
  Suppose you are a data analyst working for a travel company that offers vacation rentals similar to Airbnb. 
  Your company wants to identify the top hosts with the highest average ratings for their listings. 
  This information will be used to recognize exceptional hosts and potentially offer them incentives to continue providing outstanding service.
Your task is to write an SQL query to find the top 2 hosts with the highest average ratings for their listings. However,
  you should only consider hosts who have at least 2 listings, as hosts with fewer listings may not be representative.
Display output in descending order of average ratings and round the average ratings to 2 decimal places 

Table: listings
+----------------+---------------+
| COLUMN_NAME    | DATA_TYPE     |
+----------------+---------------+
| host_id        | int           |
| listing_id     | int           |
| minimum_nights | int           |
| neighborhood   | varchar(20)   |
| price          | decimal(10,2) |
| room_type      | varchar(20)   |
+----------------+---------------+
Table: reviews
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| listing_id  | int       |
| rating      | int       |
| review_date | date      |
| review_id   | int       |
+-------------+-----------+

  Ans:-
  
WITH cte AS (  
    SELECT host_id, listing_id  
        , COUNT(*) OVER(PARTITION BY host_id) AS cnt_listings      --  Count listings per host using window function  
    FROM listings  
)  
SELECT cte.host_id, cte.cnt_listings AS no_of_listings  
    , ROUND(AVG(r.rating), 2) AS avg_rating                        --  Calculate average rating rounded to 2 decimals  
FROM cte  
INNER JOIN reviews r ON cte.listing_id = r.listing_id             --  Join with reviews on listing_id  
WHERE cte.cnt_listings >= 2                                        --  Filter hosts with 2 or more listings  
GROUP BY cte.host_id, cte.cnt_listings                             --  Group by host_id and listing count  
ORDER BY avg_rating DESC                                           --  Order by average rating descending  
LIMIT 2;                                                          --  Limit to top 2 hosts  

########################################################################################################################
8 - Library Borrowing Habits
  Write an SQL to display the name of each borrower along with a comma-separated list of the books they have borrowed in alphabetical order
  , display the output in ascending order of Borrower Name.

Tables: Books
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| BookID      | int         |
| BookName    | varchar(30) |
| Genre       | varchar(20) |
+-------------+-------------+

Tables: Borrowers
+--------------+-------------+
| COLUMN_NAME  | DATA_TYPE   |
+--------------+-------------+
| BorrowerID   | int         |
| BorrowerName | varchar(10) |
| BookID       | int         |
+--------------+-------------+

  Ans:- 
  select 
b.borrowerName,
Group_CONCAT(bk.bookname order by bk.bookname separator ',') as BorrowedBooks
from Borrowers b 
left Join books bk on b.bookid = bk.bookid
group by 
    b.BorrowerName                                                    
ORDER BY 
    b.BorrowerName ASC; 

########################################################################################################################
9 - New and Repeat Customers
  Flipkart wants to build a very important business metrics where they want to track on daily basis how many new and repeat 
  customers are purchasing products from their website. A new customer is defined when he purchased anything for the first time 
  from the website and repeat customer is someone who has done at least one purchase in the past.
Display order date , new customers , repeat customers  in ascending order of repeat customers.
Table: customer_orders
+--------------+-----------+
| COLUMN_NAME  | DATA_TYPE |
+--------------+-----------+
| order_id     | int       |
| customer_id  | int       |
| order_date   | date      |
| order_amount | int       |
+--------------+-----------+
  Ans:-
  
WITH first_order_date AS (  
    SELECT customer_id, MIN(order_date) AS first_order      -- Get the first order date per customer
    FROM customer_orders  
    GROUP BY customer_id  
)  
SELECT co.order_date  
    , SUM(CASE WHEN co.order_date = fod.first_order THEN 1 ELSE 0 END) AS new_customers     -- Count new customers placing their first order on this date
    , SUM(CASE WHEN co.order_date > fod.first_order THEN 1 ELSE 0 END) AS repeat_customers  -- Count repeat customers ordering after their first order date
FROM customer_orders co  
INNER JOIN first_order_date fod ON co.customer_id = fod.customer_id  
GROUP BY co.order_date     -- Group by each order date
ORDER BY repeat_customers ASC;     -- Order results by number of repeat customers ascending

########################################################################################################################
10- The Little Master
  Sachin Tendulkar - Also known as little master. You are given runs scored by Sachin in his first 10 matches. 
  You need to write an SQL to get match number when he completed 500 runs and his batting average at the end of 10 matches.

Batting Average = (Total runs scored) / (no of times batsman got out)

Round the result to 2 decimal places.
Table: sachin
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| match_no    | int         |
| runs_scored | int         |
| status      | varchar(10) |
+-------------+-------------+
  Ans:-
  
WITH cte AS (
    SELECT *                                                                    
        , SUM(runs_scored) OVER() * 1.0 / SUM(CASE WHEN status = 'out' THEN 1 ELSE 0 END) OVER() AS batting_average    --  Compute batting average over all matches
        , SUM(runs_scored) OVER(ORDER BY match_no ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_sum    --  Calculate cumulative running sum of runs
    FROM sachin
)
SELECT match_no                                                                 
        , CAST(ROUND(batting_average, 2) AS DECIMAL(10, 2)) AS batting_average   --  Round and cast the batting average to 2 decimal places
FROM (
    SELECT * 
            , ROW_NUMBER() OVER(ORDER BY running_sum) AS rn                      --  Assign row number based on running sum
    FROM cte 
    WHERE running_sum > 500                                                      --  Filter records where cumulative runs cross 500
) s
WHERE rn = 1;                                                                    --  Select the first match where cumulative runs exceed 500

########################################################################################################################
11 - Math Champions
  You are provided with two tables: Students and Grades. Write a SQL query to find students who have higher grade in Math than the 
  average grades of all the students together in Math. Display student name and grade in Math order by grades. 

Tables: Students
+--------------+-------------+
| COLUMN_NAME  | DATA_TYPE   |
+--------------+-------------+
| class_id     | int         |
| student_id   | int         |
| student_name | varchar(20) |
+--------------+-------------+

Tables: Grades
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| student_id  | int         |
| subject     | varchar(20) |
| grade       | int         |
+-------------+-------------+

  Ans:-
  SELECT
    s.student_name,
    g.grade AS math_grade
FROM
    Students s
JOIN
    Grades g ON s.student_id = g.student_id
WHERE
    g.subject = 'Math'
AND
    g.grade > (
        SELECT AVG(grade)
        FROM Grades
        WHERE subject = 'Math'
    )
order by g.grade;

PySpark:-
  # Step 1: Calculate the average math grade
avg_math_grade = grades_df.filter(grades_df.subject == 'Math').agg(F.avg('grade')).collect()[0][0]

# Step 2: Perform the join
result_df = students_df.join(grades_df, on='student_id', how='inner')

# Step 3: Filter for Math grades above the average and sort
result_df = result_df.filter((result_df.subject == 'Math') & (result_df.grade > avg_math_grade)) \
                     .sort('grade') \
                     .select('student_name', F.col('grade').alias('math_grade'))

# Step 4: Show the result
result_df.show()
  
########################################################################################################################
12- Deliveroo Top Customer
  You are provided with data from a food delivery service called Deliveroo. Each order has details about the delivery time, 
  the rating given by the customer, and the total cost of the order. Write an SQL to find customer with highest total expenditure. 
  Display customer id and total expense by him/her.

Tables: orders
+---------------+-----------+
| COLUMN_NAME   | DATA_TYPE |
+---------------+-----------+
| customer_id   | int       |
| delivery_time | int       |
| order_id      | int       |
| restaurant_id | int       |
| total_cost    | int       |
+---------------+-----------+

  Ans:-
  select customer_id,
sum(total_cost) as total_expense
from orders  
group by customer_id
order by total_expense desc
limit 1;
  
########################################################################################################################
13 - Best Employee Award
TCS wants to award employees based on number of projects completed by each individual each month.  
  Write an SQL to find best employee for each month along with number of projects completed by him/her in that month, 
  display the output in descending order of number of completed projects.

Table: projects
+-------------------------+-------------+
| COLUMN_NAME             | DATA_TYPE   |
+-------------------------+-------------+
| project_id              | int         |
| employee_name           | varchar(10) |
| project_completion_date | date        |
+-------------------------+-------------+

Ans:-
  WITH project_counts AS (
    SELECT 
        DATE_FORMAT(project_completion_date, '%Y%m') AS month,
        employee_name,
        COUNT(*) AS project_count
    FROM projects
    where project_completion_date is not null
    GROUP BY month, employee_name
),
ranked_employees AS (
    SELECT 
        month,
        employee_name,
        project_count,
        ROW_NUMBER() OVER (
            PARTITION BY month
            ORDER BY project_count DESC
        ) AS rn
    FROM project_counts
)
SELECT 
    employee_name,
    project_count as no_of_completed_projects,
    month as yearmonth
FROM ranked_employees
WHERE rn = 1
ORDER BY project_count DESC;

########################################################################################################################
14 - Workaholics Employees
  Write a query to find workaholics employees.  Workaholics employees are those who satisfy at least one of the given criterions 

1- Worked for more than 8 hours a day for at least 3 days in a week. 
2- worked for more than 10 hours a day for at least 2 days in a week. 
You are given the login and logout timings of all the employees for a given week. 
  Write a SQL to find all the workaholic employees along with the criterion that they are satisfying (1,2 or both), 
  display it in the order of increasing employee id
Table: employees
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| emp_id      | int       |
| login       | datetime  |
| logout      | datetime  |
+-------------+-----------+
  Ans:-
  with logged_hours as (
select *,TIMESTAMPDIFF(second, login, logout)/3600.0,case when TIMESTAMPDIFF(second, login, logout) / 3600.0  > 10 then '10+'
when TIMESTAMPDIFF(second, login, logout) / 3600.0  > 8 then '8+'
else '8-' end as time_window
from employees)
 , time_window as (
 select emp_id , count(*) as days_8
, sum(case when time_window='10+' then 1 else 0 end ) as days_10
 from logged_hours
where time_window in ('10+','8+')
 group by emp_id)
 select emp_id, case when days_8 >=3 and days_10>=2 then 'both'
 when days_8 >=3 then '1'
 else '2' end as criterian
 from time_window
  where days_8>=3 or days_10>=2 
ORDER BY emp_id ASC;
########################################################################################################################
15 - Lift Overloaded (Part 1)
  You are given a table of list of lifts , their maximum capacity and people along with their weight who wants to enter into it.
  You need to make sure maximum people enter into the lift without lift getting overloaded.

For each lift find the comma separated list of people who can be accommodated. The comma separated list should have people in
  the order of their weight in increasing order, display the output in increasing order of id.

Table: lifts
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| capacity_kg | int       |
| id          | int       |
+-------------+-----------+
Table: lift_passengers
+----------------+-------------+
| COLUMN_NAME    | DATA_TYPE   |
+----------------+-------------+
| passenger_name | varchar(10) |
| weight_kg      | int         |
| lift_id        | int         |
+----------------+-------------+
  Ans:-
  with running_weight as (
select l.id , lp.passenger_name ,lp.weight_kg,l.capacity_kg 
, sum(lp.weight_kg) over(partition by l.id order by lp.weight_kg rows between unbounded preceding and current row) as running_sum
from lifts l
inner join lift_passengers lp on l.id=lp.lift_id
)
select id, GROUP_CONCAT(DISTINCT passenger_name ORDER BY weight_kg  SEPARATOR',') as passenger_list
from running_weight
where running_sum < capacity_kg
group by id
ORDER BY id;
########################################################################################################################
16 - Lift Overloaded (Part 2)
  You are given a table of list of lifts , their maximum capacity and people along with their weight and gender who wants to enter into it. 
  You need to make sure maximum people enter into the lift without lift getting overloaded but you need to give preference to female passengers first.

For each lift find the comma separated list of people who can be accomodated. The comma separated list should have female first and
  then people in the order of their weight in increasing order, display the output in increasing order of id.

Table: lifts 
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| capacity_kg | int       |
| id          | int       |
+-------------+-----------+
Table: lift_passengers
+----------------+-------------+
| COLUMN_NAME    | DATA_TYPE   |
+----------------+-------------+
| passenger_name | varchar(10) |
| weight_kg      | int         |
| gender         | varchar(1)  |
| lift_id        | int         |
+----------------+-------------+
  Ans:-
  with running_weight as (
select l.id , lp.passenger_name ,lp.weight_kg,l.capacity_kg,lp.gender
, sum(lp.weight_kg) over(partition by l.id order by case when lp.gender='F' then 0 else 1 end, lp.weight_kg rows between unbounded preceding and current row) as running_sum
from lifts l
inner join lift_passengers lp on l.id=lp.lift_id
)
select id, GROUP_CONCAT(passenger_name ORDER BY gender,weight_kg SEPARATOR',') as passenger_list
from running_weight
where running_sum < capacity_kg
group by id
ORDER BY id;
########################################################################################################################
17 - Business Expansion
  Amazon is expanding their pharmacy business to new cities every year. You are given a table of business operations where 
  you have information about cities where Amazon is doing operations along with the business date information.

Write a SQL to find year wise number of new cities added to the business, display the output in increasing order of year.

Table: business_operations
+---------------+-----------+
| COLUMN_NAME   | DATA_TYPE |
+---------------+-----------+
| business_date | date      |
| city_id       | int       |
+---------------+-----------+
  Ans:
  with cte as (
select city_id,min(YEAR(business_date)) as first_operation_year
 from business_operations 
 group by city_id
)
select first_operation_year,count(*) as no_of_new_cities
from cte
group by first_operation_year
ORDER BY first_operation_year ASC;
########################################################################################################################
18 - Hero Products
Flipkart an ecommerce company wants to find out its top most selling product by quantity in each category. 
In case of a tie when quantities sold are same for more than 1 product, then we need to give preference to the product with higher sales value.
Display category and product in output with category in ascending order.
Table: orders
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| category    | varchar(10) |
| order_id    | int         |
| product_id  | varchar(20) |
| quantity    | int         |
| unit_price  | int         |
+-------------+-------------+
  with sales as (
select category,product_id,sum(quantity) as quantity_sold, sum(unit_price*quantity) total_sales
 from orders
 group by category,product_id
)
select category,product_id 
from (
select *
 , row_number() over(partition by category order by quantity_sold desc,total_sales desc) as rn 
 from sales 
 ) s
where rn=1
ORDER BY category ASC;
########################################################################################################################
19 - Order Fulfilment
  You are given two tables: products and orders. The products table contains information about each product, 
  including the product ID and available quantity in the warehouse. The orders table contains details about customer orders,
  including the order ID, product ID, order date, and quantity requested by the customer.

Write an SQL query to generate a report listing the orders that can be fulfilled based on the available inventory in the warehouse, 
  following a first-come-first-serve approach based on the order date. Each row in the report should include the order ID, product name, 
  quantity requested by the customer, quantity actually fulfilled, and a comments column as below
 

If the order can be completely fulfilled then 'Full Order'.
If the order can be partially fulfilled then 'Partial Order'.
If order can not be fulfilled at all then 'No Order' .
Display the output in ascending order of order id. 

Table: products
+--------------------+-------------+
| COLUMN_NAME        | DATA_TYPE   |
+--------------------+-------------+
| product_id         | int         |
| product_name       | varchar(10) |
| available_quantity | int         |
+--------------------+-------------+

Table: orders
+--------------------+-----------+
| COLUMN_NAME        | DATA_TYPE |
+--------------------+-----------+
| order_id           | int       |
| product_id         | int       |
| order_date         | date      |
| quantity_requested | int       |
+--------------------+-----------+
  Ans:-
  with cte as (
select o.*
,sum(quantity_requested) over(partition by o.product_id order by order_date) as running_requested_qty
,p.available_quantity
,p.product_name
from orders o
inner join products p on o.product_id=p.product_id
)
select order_id,product_name,quantity_requested
,case when  running_requested_qty <= available_quantity then quantity_requested
when available_quantity-(running_requested_qty-quantity_requested) > 0 then available_quantity-(running_requested_qty-quantity_requested)
else 0 end as qty_fulfilled  
,case when  running_requested_qty <= available_quantity then 'Full Order'
when available_quantity-(running_requested_qty-quantity_requested) > 0 then 'Partial Order'
else 'No Order' end as comments  
from cte
ORDER BY order_id;
########################################################################################################################
20 - Trending Products
  Amazon wants to find out the trending products for each month. Trending products are those for which any given month sales are more 
  than the sum of previous 2 months sales for that product.

Please note that for first 2 months of operations this metrics does not make sense. So output should start from 3rd month only.  
  Assume that each product has at least 1 sale each month, display order month and product id. Sort by order month.
Table: orders 
+-------------+------------+
| COLUMN_NAME | DATA_TYPE  |
+-------------+------------+
| order_month | varchar(6) |
| product_id  | varchar(5) |
| sales       | int        |
+-------------+------------+
  Ans:-
  with cte as (
select * 
,sum(sales) over(partition by product_id order by order_month rows between 2 preceding and 1 preceding) as last2
,row_number() over(partition by product_id order by order_month) as rn
from orders 
)
select order_month,product_id from cte 
where rn>=3 and sales > last2
ORDER BY order_month,product_id ASC;
########################################################################################################################
21. Uber Profits Rides
  A profit ride for a Uber driver is considered when the start location and start time of a ride exactly match with the previous ride's end location and end time. 
Write an SQL to calculate total number of rides and total profit rides by each driver, display the output in ascending order of id
Table: drivers
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| id          | varchar(10) |
| start_loc   | varchar(1)  |
| start_time  | time        |
| end_loc     | varchar(1)  |
| end_time    | time        |
+-------------+-------------+
  Ans:-
  with cte as (
select * 
, lag(end_time,1) over(partition by id order by start_time) as prev_end_time
, lag(end_loc,1) over(partition by id order by start_time) as prev_end_loc
from drivers
)
select id, count(*) as total_rides , 
sum(case when start_time = prev_end_time and start_loc=prev_end_loc then 1 else 0 end) as profit_rides
from cte 
group by id
ORDER BY id ASC;
########################################################################################################################
22 - The United States of America
  In some poorly designed UI applications, there's often a lack of data input restrictions. For instance, in a free text field for the country,
  users might input variations such as 'USA,' 'United States of America,' or 'US.'
Suppose we have survey data from individuals in the USA about their job satisfaction, rated on a scale of 1 to 5.
  Write a SQL query to count the number of respondents for each rating on the scale. Additionally,
  include the country name in the format that occurs most frequently in that scale, display the output in ascending order of job satisfaction.

Table: survey 
+------------------+-------------+
| COLUMN_NAME      | DATA_TYPE   |
+------------------+-------------+
| country          | varchar(20) |
| job_satisfaction | int         |
| name             | varchar(10) |
+------------------+-------------+
  Ans:-
  with cte as (
select country,job_satisfaction,count(*) as cnt 
from survey
group by country,job_satisfaction
)
, cte2 as (
select *, sum(cnt) over(partition by job_satisfaction) as number_of_respondents
,max(cnt) over(partition by job_satisfaction) as max_cnt
from cte
)
select job_satisfaction,country,number_of_respondents from cte2 
where cnt=max_cnt
ORDER BY job_satisfaction ASC;
########################################################################################################################
23 - Product Recommendation
  Product recommendation. Just the basic type (“customers who bought this also bought…”). That, in its simplest form, is an outcome of basket analysis. 
  Write a SQL to find the product pairs which have been purchased together in same order along with the purchase frequency (count of times they have 
  been purchased together). Based on this data Amazon can recommend frequently bought together products to other users.

Order the output by purchase frequency in descending order. Please make in the output first product column has id greater than second product column.

Table: orders (primary key : order_id)
+-------------+------------+
| COLUMN_NAME | DATA_TYPE  |
+-------------+------------+
| order_id    | int        |
| customer_id | int        |
| product_id  | varchar(2) |
+-------------+------------+
  select o1.product_id product_1,o2.product_id as product_2
, count(*) as purchase_frequency
from orders o1
inner join orders o2 on o1.order_id=o2.order_id 
where o1.product_id>o2.product_id
group by o1.product_id,o2.product_id
ORDER BY purchase_frequency desc ;
########################################################################################################################
24 - Account Balance
You are given a list of users and their opening account balance along with the transactions done by them.
  Write a SQL to calculate their account balance at the end of all the transactions. Please note that users can do 
  transactions among themselves as well, display the output in ascending order of the final balance.
Table: users
+-----------------+-------------+
| COLUMN_NAME     | DATA_TYPE   |
+-----------------+-------------+
| user_id         | int         |
| username        | varchar(10) |
| opening_balance | int         |
+-----------------+-------------+

Table: transactions
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| id          | int       |
| from_userid | int       |
| to_userid   | int       |
| amount      | int       |
+-------------+-----------+

  with all_trans as (
select from_userid as user_id    , -1*amount as amount from transactions 
union all
select to_userid, amount as amount from transactions 
)
,trans_amount as 
(select user_id,sum(amount) as transact_amount
from all_trans
group by user_id
)
select u.username , opening_balance + coalesce(transact_amount,0) as final_balance
from users u 
left join trans_amount t on u.user_id=t.user_id
ORDER BY final_balance ASC;
########################################################################################################################
25 - boAt Lifestyle Marketing
  boAt Lifestyle is focusing on influencer marketing to build and scale their brand. They want to partner with power creators
  for their upcoming campaigns. The creators should satisfy below conditions to qualify:
1- They should have 100k+ followers on at least 2 social media platforms and
2- They should have at least 50k+ views on their latest YouTube video.
Write an SQL to get creator id and name satisfying above conditions.
Table: creators
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| id          | int         |
| name        | varchar(10) |
| followers   | int         |
| platform    | varchar(10) |
+-------------+-------------+
Table: youtube_videos
+--------------+-----------+
| COLUMN_NAME  | DATA_TYPE |
+--------------+-----------+
| id           | int       |
| creator_id   | int       |
| publish_date | date      |
| views        | int       |
+--------------+-----------+
  with condition_1 as (
select id,name
 from creators
 where followers > 100000
 group by id,name
 having count(*)>=2
)
,condition_2 as 
(
select *, row_number() over(partition by creator_id order by publish_date desc) as rn    
from youtube_videos
)
select c1.id,c1.name from condition_2 c2
inner join condition_1 c1 on c1.id=c2.creator_id
where rn=1 and views>50000;
########################################################################################################################
26 - Dynamic Pricing
  You are given a products table where a new row is inserted every time the price of a product changes. Additionally, 
  there is a transaction table containing details such as order_date and product_id for each order.

Write an SQL query to calculate the total sales value for each product, considering the cost of the product at the time 
  of the order date, display the output in ascending order of the product_id.
Table: products
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| product_id  | int       |
| price       | int       |
| price_date  | date      |
+-------------+-----------+
Table: orders 
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| order_id    | int       |
| order_date  | date      |
| product_id  | int       |
+-------------+-----------+
WITH price_range AS (
    SELECT *,
           DATE_ADD(LEAD(price_date, 1, '9999-12-31') OVER (PARTITION BY product_id ORDER BY price_date), INTERVAL -1 DAY) AS price_end_date  --    Calculate price end date as one day before next price_date
    FROM products                                                                                                                        --    Products table containing price history
)
SELECT p.product_id, 
       SUM(p.price) AS total_sales                                                                                                      --    Sum total price for orders within valid price period
FROM orders o
INNER JOIN price_range p ON o.product_id = p.product_id                                                                                  --    Join orders with price ranges on product_id
    AND o.order_date BETWEEN p.price_date AND p.price_end_date                                                                          --    Filter orders within price validity period
GROUP BY p.product_id                                                                                                                    --    Group by product_id to aggregate sales
ORDER BY p.product_id ASC;                                                                                                               --    Order results by product_id ascending

########################################################################################################################
27 - Income Tax Returns
  Given two tables: income_tax_dates and users, write a query to identify users who either filed their income tax returns late or completely
  skipped filing for certain financial years.

A return is considered late if the return_file_date is after the file_due_date.
A return is considered missed if there is no entry for the user in the users table for a given financial year (i.e., the user did not file at all).
Your task is to generate a list of users along with the financial year for which they either filed late or missed filing, and also include
  a comment column specifying whether it is a 'late return' or 'missed'. The result should be sorted by financial year in ascending order.

Table: income_tax_dates
+-----------------+------------+
| COLUMN_NAME     | DATA_TYPE  |
+-----------------+------------+
| financial_year  | varchar(4) |
| file_start_date | date       |
| file_due_date   | date       |
+-----------------+------------+
Table: users
+------------------+------------+
| COLUMN_NAME      | DATA_TYPE  |
+------------------+------------+
| user_id          | int        |
| financial_year   | varchar(4) |
| return_file_date | date       |
+------------------+------------+
  Ans:
  with all_users_years as 
(
select u.user_id,it.financial_year,it.file_due_date
from users u cross join income_tax_dates it
group by u.user_id,it.financial_year,it.file_due_date
)
select a.user_id,a.financial_year
,case when u.return_file_date > a.file_due_date then 'late return' else 'missed' end as comment
from all_users_years a 
left join users u on a.user_id=u.user_id and a.financial_year=u.financial_year 
where u.return_file_date > a.file_due_date or u.return_file_date is null
ORDER BY a.financial_year;

########################################################################################################################
28 - Malware Detection
  There are multiple antivirus software which are running on the system and you have the data of how many malware they have detected in each run. 
  You need to find out how many malwares each software has detected in their latest run and what is the difference between the number of malwares
  detected in latest run and the second last run for each software. 

Please note that list only the software which have run for at least 2 times and have detected at least 10 malware in the latest run.
Table: malware
+------------------+-----------+
| COLUMN_NAME      | DATA_TYPE |
+------------------+-----------+
| software_id      | int       |
| run_date         | datetime  |
| malware_detected | int       |
+------------------+-----------+
  with cte1 as (
select *,
row_number() over(partition by software_id order by run_date desc) as rn
 from malware 
)
,cte2 as (
select software_id
, sum(case when rn=1 then malware_detected end) as latest_run_count
, sum(case when rn=2 then malware_detected end) as previous_run
from cte1
where rn in (1,2)
group by software_id
having count(*)=2
)
select software_id,latest_run_count
,(latest_run_count-previous_run) as difference_to_previous 
from cte2
where latest_run_count>=10;
########################################################################################################################
29 - Software vs Data Analytics Engineers
  Medium - 20 Points
You are given the details of employees of a new startup. Write an SQL query to retrieve number of Software Engineers , Data Professionals and 
  Managers in the team to separate columns. Below are the rules to identify them using Job Title. 

1- Software Engineers  :  The title should starts with “Software”
2- Data Professionals :  The title should starts with “Data”
3- Managers : The title should contain "Manager"

Tables: Employees
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| EmployeeID  | int         |
| Name        | varchar(20) |
| JoinDate    | date        |
| JobTitle    | varchar(20) |
+-------------+-------------+
  with cte as (
SELECT *
, case when JobTitle like 'Software%' Then 'Software Engineers'
when JobTitle like 'Data%' Then 'Data Professionals'
when JobTitle like '%Manager%' Then 'Managers'
end as emp_group
FROM employees
)
, cte1 as (
select emp_group,count(*) as cnt
from cte
group by emp_group
)
select 
sum(case when emp_group='Software Engineers' then cnt end) as Software_Engineers,
sum(case when emp_group='Data Professionals' then cnt end) as Data_Professionals,
sum(case when emp_group='Managers' then cnt end) as Managers
from cte1
########################################################################################################################
30- Employee Salary Levels
  Write an SQL query to find the average salaries of employees at each salary level. "Salary Level" are defined as per below conditions:
If the salary is less than 50000, label it as "Low".
If the salary is between 50000 and 100000 (inclusive), label it as "Medium".
If the salary is greater than 100000, label it as "High".
Round the average to nearest integer. Display the output in ascending order of salary level.
Tables: Employees
+---------------+--------------+
| COLUMN_NAME   | DATA_TYPE    |
+---------------+--------------+
| employee_id   | int          |
| employee_name | varchar(20) |
| salary        | int          |
+---------------+--------------+
  with salaries as (
  select employee_id, Employee_name, salary,
  case when salary  < 50000 then "Low"  
       when salary  between 50000 and 100000 then "Medium"
       else 'High' END as salary_levels
  from Employees )
  select salary_levels, round(avg(salary),0) as avg_salary
  from salaries
  group by salary_levels
  order by salary_levels;
       
########################################################################################################################
31 - Highly Paid Employees
  You are given the data of employees along with their salary and department. Write an SQL to find list of employees who have
  salary greater than average employee salary of the company.  However, while calculating the company average salary to compare 
  with an employee salary do not consider salaries of that employee's department, display the output in ascending order of employee ids.

Table: employee
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| emp_id      | int         |
| salary      | int         |
| department  | varchar(15) |
+-------------+-------------+
  select * from 
employee e1
where salary > (select avg(e2.salary) 
from employee e2 
where e1.department != e2.department
)
ORDER BY emp_id ;
########################################################################################################################
32 - Warikoo 20-6-20
  Ankur Warikoo, an influential figure in Indian social media, shares a guideline in one of his videos called the 
  20-6-20 rule for determining whether one can afford to buy a phone or not. The rule for affordability entails three conditions:
1. Having enough savings to cover a 20 percent down payment.
2. Utilizing a maximum 6-month EMI plan (no-cost) for the remaining cost.
3. Monthly EMI should not exceed 20 percent of ones monthly salary.
  Given the salary and savings of various users, along with data on phone costs, the task is to write an SQL to generate a list of phones 
(comma-separated) that each user can afford based on these criteria, display the output in ascending order of the user name.
Table: users
+----------------+-------------+
| COLUMN_NAME    | DATA_TYPE   |
+----------------+-------------+
| user_name      | varchar(10) |
| monthly_salary | int         |
| savings        | int         |
+----------------+-------------+
Table: phones
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| cost        | int         |
| phone_name  | varchar(15) |
+-------------+-------------+
  
  select u.user_name,group_concat(p.phone_name SEPARATOR ',') as affordable_phones
  from users u cross join phones p
where u.savings >= p.cost*0.2 and u.monthly_salary*0.2 >= p.cost*0.8/6
group by u.user_name
ORDER BY u.user_name;
########################################################################################################################
33 - Average Order Value
  Write an SQL query to determine the transaction date with the lowest average order value (AOV) among all dates recorded 
  in the transaction table. Display the transaction date, its corresponding AOV, and the difference between the AOV for 
  that date and the highest AOV for any day in the dataset. Round the result to 2 decimal places.

Table: transactions 
+--------------------+--------------+
| COLUMN_NAME        | DATA_TYPE    |
+--------------------+--------------+
| order_id           | int          |
| transaction_amount | decimal(5,2) |
| transaction_date   | date         |
| user_id            | int          |
+--------------------+--------------+
  with cte as (
select transaction_date, avg(transaction_amount) as aov
 from transactions
 group by transaction_date
)
, cte1 as (
select *
,row_number() over(order by aov) as rn
,max(aov) over() as highest_aov
from cte 
)
select transaction_date,round(aov,2) as aov,round(highest_aov-aov,2) as diff_from_highest_aov
from cte1
where rn=1;
########################################################################################################################
34 - Employee vs Manager
  Medium - 20 Points
You are given the table of employee details. Write an SQL to find details of employee with salary 
  more than their manager salary but they joined the company after the manager joined.
Display employee name, salary and joining date along with their managers salary and joining date,
  sort the output in ascending order of employee name.
Please note that manager id in the employee table referring to emp id of the same table.

Table: employee
+--------------+-------------+
| COLUMN_NAME  | DATA_TYPE   |
+--------------+-------------+
| emp_id       | int         |
| emp_name     | varchar(10) |
| joining_date | date        |
| salary       | int         |
| manager_id   | int         |
+--------------+-------------+
  select e.emp_name,e.salary,e.joining_date,m.salary as manager_salary
,m.joining_date as manager_joining_date
from employee e
inner join employee m on e.manager_id=m.emp_id
where e.salary>m.salary and e.joining_date > m.joining_date
ORDER BY emp_name;
########################################################################################################################
35 - Cancellation vs Return
  You are given an orders table containing data about orders placed on an e-commerce website, with information on order date, delivery date, 
  and cancel date. The task is to calculate both the cancellation rate and the return rate for each month based on the order date.

Definitions:

An order is considered cancelled if it is cancelled before delivery (i.e., cancel_date is not null, and delivery_date is null).
  If an order is cancelled, no delivery will take place.
An order is considered a return if it is cancelled after it has already been delivered (i.e., cancel_date is not null,
  and cancel_date > delivery_date).

Metrics to Calculate:
Cancel Rate = (Number of orders cancelled / Number of orders placed but not returned) * 100
Return Rate = (Number of orders returned / Number of orders placed but not cancelled) * 100

Write an SQL query to calculate the cancellation rate and return rate for each month (based on the order_date).
  Round the rates to 2 decimal places. Sort the output by year and month in increasing order.

Table: orders 
+---------------+-----------+
| COLUMN_NAME   | DATA_TYPE |
+---------------+-----------+
| order_id      | int       |
| order_date    | date      |
| customer_id   | int       |
| delivery_date | date      |
| cancel_date   | date      |
+---------------+-----------+
  with cte as (
select year(order_date) as order_year
,month(order_date) as order_month,order_id
,case when delivery_date is null and cancel_date is not null 
then 1 else 0 end as cancel_flag 
,case when delivery_date is not null and cancel_date is not null then 1 else 0 end as return_flag 
from orders
)
select order_year,order_month
,round(sum(cancel_flag)*100.0/(count(*)-sum(return_flag)),2)  as cancellation_rate
,round(sum(return_flag)*100.0/(count(*)-sum(cancel_flag)),2) as return_rate
from cte
group by order_year,order_month
order by order_year,order_month;

########################################################################################################################
36 - Airbnb Business
  You are planning to list a property on Airbnb. To maximize profits, you need to analyze the Airbnb data for the month of 
  January 2023 to determine the best room type for each location. The best room type is based on the maximum average occupancy during the given month.

Write an SQL query to find the best room type for each location based on the average occupancy days. Order the results in
  descending order of average occupancy days, rounded to 2 decimal places.
Table: listings
+----------------+---------------+
| COLUMN_NAME    | DATA_TYPE     |
+----------------+---------------+
| listing_id     | int           |
| host_id        | int           |
| location       | varchar(20)   |
| room_type      | varchar(20)   |
| price          | decimal(10,2) |
| minimum_nights | int           |
+----------------+---------------+
Table: bookings
+---------------+-----------+
| COLUMN_NAME   | DATA_TYPE |
+---------------+-----------+
| booking_id    | int       |
| checkin_date  | date      |
| checkout_date | date      |
| listing_id    | int       |
+---------------+-----------+
  with cte as (
select listing_id, sum(checkout_date - checkin_date) as book_days
 from bookings 
  group by listing_id
)
, cte1 as (
select l.location,l.room_type , avg(cte.book_days * 1.0) as avg_book_days 
from cte
inner join listings l on cte.listing_id=l.listing_id
group by l.location,l.room_type 
)
select location,room_type,round(avg_book_days,2) as avg_book_days from (
select *,
 row_number() over(partition by location order by avg_book_days desc) as rn 
from cte1 
) s
where rn=1
order by avg_book_days desc;

########################################################################################################################
37 - Spotify Popular Tracks
  Suppose you are a data analyst working for Spotify (a music streaming service company) . Your company is interested in analyzing 
  user engagement with playlists and wants to identify the most popular tracks among all the playlists.

Write an SQL query to find the top 2 most popular tracks based on number of playlists they are part of. 

Your query should return the top 2 track ID along with total number of playlist they are part of , sorted by the same and 
  track id in descending order , Please consider only those playlists which were played by at least 2 distinct users.

Table: playlists
+---------------+--------------+
| COLUMN_NAME   | DATA_TYPE    |
+---------------+--------------+
| playlist_id   | int          |
| playlist_name | varchar(15) |
+---------------+--------------+
Table: playlist_tracks
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| playlist_id | int       |
| track_id    | int       |
+-------------+-----------+
Table: playlist_plays
+-------------+------------+
| COLUMN_NAME | DATA_TYPE  |
+-------------+------------+
| playlist_id | int        |
| user_id     | varchar(2) |
+-------------+------------+
SELECT pt.track_id, count(distinct p.playlist_id) as no_of_playlist
FROM playlists p
INNER JOIN playlist_tracks pt ON p.playlist_id = pt.playlist_id 
INNER JOIN (select playlist_id from playlist_plays
group by playlist_id
having count(distinct user_id)>1
) t on t.playlist_id = pt.playlist_id 
GROUP BY pt.track_id 
ORDER BY no_of_playlist desc,pt.track_id DESC
limit 2;
########################################################################################################################

########################################################################################################################

########################################################################################################################

########################################################################################################################

########################################################################################################################

########################################################################################################################

########################################################################################################################

########################################################################################################################

########################################################################################################################

########################################################################################################################

########################################################################################################################

########################################################################################################################

########################################################################################################################

########################################################################################################################

########################################################################################################################

########################################################################################################################

########################################################################################################################

########################################################################################################################

########################################################################################################################

########################################################################################################################

########################################################################################################################

########################################################################################################################

########################################################################################################################

########################################################################################################################

########################################################################################################################

########################################################################################################################
########################################################################################################################

########################################################################################################################

########################################################################################################################

########################################################################################################################

########################################################################################################################

  
########################################################################################################################

##################################################################################################################################################
