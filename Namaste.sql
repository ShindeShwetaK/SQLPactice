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
Expected Output
+---------------+----------------+
| customer_name | return_percent |
+---------------+----------------+
| Alexa         |          75.00 |
| Ankit         |         100.00 |
+---------------+----------------+

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
Expected Output
+--------------+----------------+
| category     | no_of_products |
+--------------+----------------+
| Low Price    |              9 |
| Medium Price |              4 |
| High Price   |              2 |
+--------------+----------------+

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
Expected Output
+--------------+-------------+-------------------+
| creator_name | no_of_posts | total_impressions |
+--------------+-------------+-------------------+
| Ankit Bansal |           3 |            132000 |
+--------------+-------------+-------------------+

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

Expected Output
+---------------+--------------+
| customer_name | no_of_orders |
+---------------+--------------+
| Alexa         |            4 |
| Ramesh        |            3 |
+---------------+--------------+
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
  CIBIL score, often referred to as a credit score, is a numerical representation of an individuals credit worthiness.
While the exact formula used by credit bureaus like CIBIL may not be publicly disclosed and can vary slightly between bureaus, 
the following are some common factors that typically influence the calculation of a credit score:

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

	Expected Output
+-------------+-------------+
| customer_id | cibil_score |
+-------------+-------------+
|           1 |        82.5 |
|           2 |        91.0 |
+-------------+-------------+
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

Expected Output
+--------------+-----------+-----------------+------------+---------------------+
| household_id | bill_year | consumption_kwh | total_cost | avg_consumption_kwh |
+--------------+-----------+-----------------+------------+---------------------+
|          101 | 2023      |         3743.50 |     561.56 |          311.958333 |
|          101 | 2024      |         3743.50 |     561.56 |          311.958333 |
|          102 | 2023      |         5980.00 |     897.00 |          498.333333 |
|          102 | 2024      |         7380.00 |    1107.00 |          615.000000 |
|          103 | 2023      |         6788.40 |    1018.32 |          565.700000 |
|          103 | 2024      |         8228.40 |    1234.32 |          685.700000 |
+--------------+-----------+-----------------+------------+---------------------+

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
Expected Output
+---------+----------------+------------+
| host_id | no_of_listings | avg_rating |
+---------+----------------+------------+
|     103 |              2 |       5.00 |
|     102 |              3 |       4.50 |
+---------+----------------+------------+

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

Expected Output
+--------------+-----------------------------------------+
| BorrowerName | BorrowedBooks                           |
+--------------+-----------------------------------------+
| Alice        | Pride and Prejudice,The Great Gatsby    |
| Bob          | Romeo and Juliet,To Kill a Mockingbird  |
| Charlie      | 1984,The Notebook                       |
| David        | The Catcher in the Rye,The Hunger Games |
| Eve          | Pride and Prejudice                     |
| Frank        | Foundation,Romeo and Juliet             |
| Grace        | The Notebook                            |
| Harry        | To Kill a Mockingbird                   |
| Ivy          | 1984                                    |
+--------------+-----------------------------------------+

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

Expected Output
+------------+---------------+------------------+
| order_date | new_customers | repeat_customers |
+------------+---------------+------------------+
| 2022-01-01 |             3 |                0 |
| 2022-01-02 |             2 |                1 |
| 2022-01-03 |             1 |                2 |
+------------+---------------+------------------+
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
Expected Output
+----------+-----------------+
| match_no | batting_average |
+----------+-----------------+
|        8 |           70.33 |
+----------+-----------------+
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
Expected Output
+----------------+------------+
| student_name   | math_grade |
+----------------+------------+
| Laura White    |         86 |
| Emily Clark    |         88 |
| David Martinez |         90 |
| Alice Johnson  |         92 |
| Michael Lee    |         95 |
+----------------+------------+

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
Expected Output
+-------------+---------------+
| customer_id | total_expense |
+-------------+---------------+
|         101 |          4125 |
+-------------+---------------+

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
Expected Output
+---------------+--------------------------+-----------+
| employee_name | no_of_completed_projects | yearmonth |
+---------------+--------------------------+-----------+
| Shilpa        |                        3 | 202301    |
| Mukesh        |                        2 | 202302    |
| Ankit         |                        1 | 202212    |
+---------------+--------------------------+-----------+

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
Expected Output
+--------+-----------+
| emp_id | criterian |
+--------+-----------+
|    100 | 1         |
|    200 | 2         |
|    300 | both      |
+--------+-----------+
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

Expected Output
+------+---------------------------+
| id   | passenger_list            |
+------+---------------------------+
|    1 | Adarsh,Dheeraj,Rahul      |
|    2 | Priti,Neha,Vimal,Himanshi |
+------+---------------------------+
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
Expected Output
+------+---------------------------+
| id   | passenger_list            |
+------+---------------------------+
|    1 | Riti,Adarsh,Dheeraj       |
|    2 | Priti,Neha,Himanshi,Vimal |
+------+---------------------------+
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
Expected Output
+----------------------+------------------+
| first_operation_year | no_of_new_cities |
+----------------------+------------------+
|                 2020 |                2 |
|                 2021 |                1 |
|                 2022 |                1 |
+----------------------+------------------+
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
Expected Output
+-----------+---------------+
| category  | product_id    |
+-----------+---------------+
| Footwear  | floaters-3421 |
| Furniture | Table-3421    |
+-----------+---------------+
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
	Expected Output
+----------+--------------+--------------------+---------------+---------------+
| order_id | product_name | quantity_requested | qty_fulfilled | comments      |
+----------+--------------+--------------------+---------------+---------------+
|        1 | Product A    |                  5 |             5 | Full Order    |
|        2 | Product A    |                  7 |             5 | Partial Order |
|        3 | Product B    |                 10 |            10 | Full Order    |
|        4 | Product B    |                 10 |            10 | Full Order    |
|        5 | Product B    |                  5 |             0 | No Order      |
|        6 | Product C    |                  4 |             4 | Full Order    |
|        7 | Product C    |                  5 |             5 | Full Order    |
|        8 | Product D    |                  4 |             4 | Full Order    |
|        9 | Product D    |                  5 |             5 | Full Order    |
|       10 | Product D    |                  8 |             1 | Partial Order |
|       11 | Product D    |                  5 |             0 | No Order      |
+----------+--------------+--------------------+---------------+---------------+

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
Expected Output
+-------------+------------+
| order_month | product_id |
+-------------+------------+
| 202303      | p1         |
| 202304      | p1         |
| 202304      | p2         |
| 202310      | p1         |
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
  A profit ride for a Uber driver is considered when the start location and start time of a ride exactly match with the previous rides end location and end time. 
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
Expected Output
+-------+-------------+--------------+
| id    | total_rides | profit_rides |
+-------+-------------+--------------+
| dri_1 |           5 |            1 |
| dri_2 |           2 |            0 |
+-------+-------------+--------------+
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
  In some poorly designed UI applications, theres often a lack of data input restrictions. For instance, in a free text field for the country,
  users might input variations such as USA, United States of America, or US.
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
Expected Output
+------------------+---------------+-----------------------+
| job_satisfaction | country       | number_of_respondents |
+------------------+---------------+-----------------------+
|                3 | USA           |                     3 |
|                4 | USA           |                     6 |
|                5 | United States |                     6 |
+------------------+---------------+-----------------------+
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
Expected Output
+-----------+-----------+--------------------+
| product_1 | product_2 | purchase_frequency |
+-----------+-----------+--------------------+
| p2        | p1        |                  3 |
| p3        | p1        |                  2 |
| p4        | p1        |                  2 |
| p4        | p2        |                  2 |
| p3        | p2        |                  1 |
| p6        | p5        |                  1 |
| p5        | p1        |                  1 |
| p5        | p3        |                  1 |
+-----------+-----------+--------------------+
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
Expected Output
+----------+---------------+
| username | final_balance |
+----------+---------------+
| Ankit    |          2000 |
| Amit     |          2800 |
| Agam     |          7500 |
| Rahul    |         10200 |
+----------+---------------+

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
Expected Output
+------+-------+
| id   | name  |
+------+-------+
|  102 | Dhruv |
|  104 | Neha  |
|  105 | Amit  |
+------+-------+
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
Expected Output
+------------+-------------+
| product_id | total_sales |
+------------+-------------+
|        100 |         510 |
|        101 |        4700 |
+------------+-------------+
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
Expected Output
+---------+----------------+-------------+
| user_id | financial_year | comment     |
+---------+----------------+-------------+
|       1 | FY21           | late return |
|       1 | FY22           | missed      |
|       2 | FY23           | late return |
+---------+----------------+-------------+
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

Expected Output
+-------------+------------------+------------------------+
| software_id | latest_run_count | difference_to_previous |
+-------------+------------------+------------------------+
|         101 |               12 |                      2 |
|         102 |               13 |                     -1 |
|         103 |               16 |                      5 |
+-------------+------------------+------------------------+
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
Expected Output
+--------------------+--------------------+----------+
| Software_Engineers | Data_Professionals | Managers |
+--------------------+--------------------+----------+
|                  9 |                  3 |        3 |
+--------------------+--------------------+----------+
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
Expected Output
+--------------+------------+
| Salary_Level | avg_salary |
+--------------+------------+
| High         |     110000 |
| Low          |      46500 |
| Medium       |      76417 |
+--------------+------------+
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
  with an employee salary do not consider salaries of that employees department, display the output in ascending order of employee ids.

Table: employee
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| emp_id      | int         |
| salary      | int         |
| department  | varchar(15) |
+-------------+-------------+
Expected Output
+--------+--------+-------------+
| emp_id | salary | department  |
+--------+--------+-------------+
|    102 |  50000 | Analytics   |
|    103 |  45000 | Engineering |
|    104 |  48000 | Engineering |
|    105 |  51000 | Engineering |
|    106 |  46000 | Science     |
|    110 |  55000 | Engineering |
|    112 |  47000 | Analytics   |
|    113 |  43000 | Engineering |
+--------+--------+-------------+
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
Expected Output
+-----------+----------------------+
| user_name | affordable_phones    |
+-----------+----------------------+
| Rahul     | iphone-12,oneplus-12 |
| Vivek     | oneplus-12           |
+-----------+----------------------+
  
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

Expected Output
+------------------+-------+-----------------------+
| transaction_date | aov   | diff_from_highest_aov |
+------------------+-------+-----------------------+
| 2024-02-26       | 30.00 |                103.33 |
+------------------+-------+-----------------------+
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
	
Expected Output
+----------+--------+--------------+----------------+----------------------+
| emp_name | salary | joining_date | manager_salary | manager_joining_date |
+----------+--------+--------------+----------------+----------------------+
| Mohit    |  15000 | 2022-05-01   |          12000 | 2021-03-01           |
| Vikas    |  10000 | 2023-06-01   |           5000 | 2022-02-01           |
+----------+--------+--------------+----------------+----------------------+
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

Expected Output
+------------+-------------+-------------------+-------------+
| order_year | order_month | cancellation_rate | return_rate |
+------------+-------------+-------------------+-------------+
|       2023 |           1 |             33.33 |       50.00 |
|       2023 |           2 |             50.00 |       50.00 |
+------------+-------------+-------------------+-------------+
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
Expected Output
+----------+-----------------+---------------+
| location | room_type       | avg_book_days |
+----------+-----------------+---------------+
| Midtown  | Private room    |          7.00 |
| Downtown | Entire home/apt |          6.33 |
+----------+-----------------+---------------+
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
Expected Output
+----------+----------------+
| track_id | no_of_playlist |
+----------+----------------+
|      104 |              4 |
|      101 |              3 |
+----------+----------------+
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
38 - Product Reviews
  Suppose you are a data analyst working for a retail company, and your team is interested in analysing customer feedback to identify 
  trends and patterns in product reviews.
Your task is to write an SQL query to find all product reviews containing the word "excellent" or "amazing" in the review text. However,
you want to exclude reviews that contain the word "not" immediately before "excellent" or "amazing". Please note that the words can be in 
upper or lower case or combination of both. 

Your query should return the review_id,product_id, and review_text for each review meeting the criteria, display the output in ascending order of review_id.

Table: product_reviews
+-------------+--------------+
| COLUMN_NAME | DATA_TYPE    |
+-------------+--------------+
| review_id   | int          |
| product_id  | int          |
| review_text | varchar(40)  |
+-------------+--------------+

Expected Output
+-----------+------------+---------------------------------+
| review_id | product_id | review_text                     |
+-----------+------------+---------------------------------+
|         1 |        101 | The product is excellent!       |
|         2 |        102 | This product is Amazing.        |
|         3 |        103 | Not an excellent product.       |
|         4 |        104 | The quality is Excellent.       |
|         5 |        105 | An amazing product!             |
|         6 |        106 | This is not an amazing product. |
+-----------+------------+---------------------------------+
  
SELECT review_id, product_id, review_text
FROM product_reviews                                                                                   --    Table containing product reviews
WHERE (LOWER(review_text) LIKE '% excellent%' OR LOWER(review_text) LIKE '% amazing%')                --    Include reviews containing 'excellent' or 'amazing' (case-insensitive)
  AND LOWER(review_text) NOT LIKE '%not excellent%'                                                  --    Exclude reviews with 'not excellent'
  AND LOWER(review_text) NOT LIKE '%not amazing%'                                                    --    Exclude reviews with 'not amazing'
ORDER BY review_id ASC;                                                                                --    Order results by review_id ascending

########################################################################################################################
39 - Walmart Sales Pattern
  You are tasked with analyzing the sales data of a Walmart chain with multiple stores across different locations.
  The company wants to identify the highest and lowest sales months for each location for the year 2023 to gain insights 
  into their sales patterns, display the output in ascending order of location. In case of a tie display the latest month.
Table: stores
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| store_id    | int         |
| store_name  | varchar(20) |
| location    | varchar(20) |
+-------------+-------------+
Table: transactions 
+------------------+-----------+
| COLUMN_NAME      | DATA_TYPE |
+------------------+-----------+
| customer_id      | int       |
| store_id         | int       |
| amount           | int       |
| transaction_date | date      |
| transaction_id   | int       |
+------------------+-----------+
Expected Output
+-------------+---------------------+--------------------+
| location    | highest_sales_month | lowest_sales_month |
+-------------+---------------------+--------------------+
| Chicago     |                   1 |                  2 |
| Los Angeles |                  12 |                  2 |
| New York    |                  12 |                  4 |
+-------------+---------------------+--------------------+
WITH monthly_sales AS (
    SELECT
        s.location,
        month(t.transaction_date) AS order_month,
        SUM(t.amount) AS total_sales,
        RANK() OVER (PARTITION BY s.location ORDER BY SUM(t.amount) DESC) AS sales_rank_desc,
        RANK() OVER (PARTITION BY s.location ORDER BY SUM(t.amount)) AS sales_rank_asc
    FROM
        transactions t
    JOIN
        stores s ON t.store_id = s.store_id
    GROUP BY
        s.location, month(t.transaction_date))
SELECT
    location,
    MAX(CASE WHEN sales_rank_desc = 1 THEN order_month END) AS highest_sales_month,
    MAX(CASE WHEN sales_rank_asc = 1 THEN order_month END) AS lowest_sales_month
FROM  monthly_sales
GROUP BY location
ORDER BY location;

########################################################################################################################
40 – Uber Driver Ratings
  Suppose you are a data analyst working for ride-sharing platform Uber. Uber is interested in analyzing the performance of drivers based on their ratings and
  wants to categorize them into different performance tiers. 
Write an SQL query to categorize drivers equally into three performance tiers (Top, Middle, and Bottom) based on their average ratings.
  Drivers with the highest average ratings should be placed in the top tier, drivers with ratings below the top tier but above the bottom tier
  should be placed in the middle tier, and drivers with the lowest average ratings should be placed in the bottom tier. Sort the output in decreasing 
  order of average rating.
Table : driver_ratings
+-------------+--------------+
| COLUMN_NAME | DATA_TYPE    |
+-------------+--------------+
| driver_id   | int          |
| avg_rating  | decimal(3,2) |
+-------------+--------------+

Expected Output
+-----------+------------+------------------+
| driver_id | avg_rating | performance_tier |
+-----------+------------+------------------+
|         7 |       4.90 | Top              |
|         1 |       4.80 | Top              |
|         5 |       4.70 | Top              |
|        12 |       4.60 | Top              |
|         2 |       4.50 | Middle           |
|         9 |       4.40 | Middle           |
|         4 |       4.20 | Middle           |
|        11 |       4.10 | Middle           |
|         3 |       3.90 | Bottom           |
|         8 |       3.80 | Bottom           |
|         6 |       3.60 | Bottom           |
|        10 |       3.50 | Bottom           |
+-----------+------------+------------------+
  SELECT driver_id,avg_rating,
    CASE
        WHEN tier = 1 THEN 'Top'
        WHEN tier = 2 THEN 'Middle'
        ELSE 'Bottom'
    END AS performance_tier
FROM (
    SELECT
        driver_id,avg_rating
        ,NTILE(3) OVER (ORDER BY avg_rating DESC) AS tier
    FROM
        driver_ratings
) AS ranked_drivers;

########################################################################################################################
41 - Zomato Customer Behavior
  Suppose you are a data analyst working for Zomato (a online food delivery company) . Zomato is interested in analysing customer 
  food ordering behavior and wants to identify customers who have exhibited inconsistent patterns over time.

Your task is to write an SQL query to identify customers who have placed orders on both weekdays and weekends, but with a significant 
difference in the average order amount between weekdays and weekends. Specifically, you need to identify customers who have a minimum of 3 orders placed 
both on weekdays and weekends each, and where the average order amount on weekends is at least 20% higher than the average order amount on weekdays.
Your query should return the customer id, the average order amount on weekends, the average order amount on weekdays, and 
the percentage difference (round to 2 decimal places) in average order amount between weekends and weekdays for each customer meeting the criteria.
Table: orders
+--------------+---------------+
| COLUMN_NAME  | DATA_TYPE     |
+--------------+---------------+
| order_id     | int           |
| customer_id  | int           |
| order_amount | decimal(10,2) |
| order_date   | date          |
+--------------+---------------+
Expected Output
+-------------+--------------------+--------------------+--------------+
| customer_id | weekend_avg_amount | weekday_avg_amount | percent_diff |
+-------------+--------------------+--------------------+--------------+
|         104 |           135.0000 |           100.0000 |        35.00 |
+-------------+--------------------+--------------------+--------------+
  WITH cte AS (
SELECT *,CASE WHEN WEEKDAY(order_date) IN ('5', '6') THEN 'Weekend' ELSE 'Weekday' END AS day_type
FROM orders
)
, order_summary as (
SELECT customer_id ,day_type,
		COUNT(day_type)OVER(PARTITION BY customer_id,day_type) AS order_count,
		AVG(order_amount)OVER(PARTITION BY customer_id,day_type) AS avg_order_amount
FROM cte
),
weekend_weekday_summary AS (
SELECT customer_id,
MAX(CASE WHEN day_type = 'Weekend' THEN order_count END) AS weekend_order_count,
MAX(CASE WHEN day_type = 'Weekday' THEN order_count END) AS weekday_order_count,
MAX(CASE WHEN day_type = 'Weekend' THEN avg_order_amount END) AS weekend_avg_amount,
MAX(CASE WHEN day_type = 'Weekday' THEN avg_order_amount END) AS weekday_avg_amount
FROM order_summary
GROUP BY customer_id
)
SELECT customer_id,weekend_avg_amount,weekday_avg_amount
,cast((weekend_avg_amount - weekday_avg_amount)*100.0 / weekday_avg_amount  as decimal(5,2) )AS percent_diff
FROM weekend_weekday_summary
where weekend_avg_amount>1.2*weekday_avg_amount
and weekend_order_count>=3 and weekday_order_count>=3;
########################################################################################################################
42 - Points Table
  Hard - 40 Points
You are given table of cricket match played in a ICC cricket tournament with the details of winner for each match. 
You need to derive a points table using below rules.
1- For each win a team gets 2 points. 
2- For a loss team gets 0 points.
3- In case of a draw both the team gets 1 point each.
Display team name , matches played, # of wins , # of losses and points.  Sort output in ascending order of team name.
Table: icc_world_cup 
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| team_1      | varchar(10) |
| team_2      | varchar(10) |
| winner      | varchar(10) |
+-------------+-------------+

Expected Output
+-----------+--------------+------------+--------------+--------------+
| team_name | match_played | no_of_wins | no_of_losses | total_points |
+-----------+--------------+------------+--------------+--------------+
| Aus       |            2 |          0 |            1 |            1 |
| Eng       |            3 |          1 |            1 |            3 |
| India     |            2 |          2 |            0 |            4 |
| NZ        |            1 |          1 |            0 |            2 |
| SA        |            2 |          0 |            1 |            1 |
| SL        |            2 |          0 |            1 |            1 |
+-----------+--------------+------------+--------------+--------------+
  with cte as (
select team_1 as team_name
, case when team_1=winner then 1 else 0 end as win_flag
, case when winner='Draw' then 1 else 0 end as draw_flag
from icc_world_cup 
union all
select team_2 as team_name
, case when team_2=winner then 1 else 0 end as win_flag
, case when winner='Draw' then 1 else 0 end as draw_flag
from icc_world_cup 
)
select team_name,count(*) as match_played
,sum(win_flag) as no_of_wins
,count(*)-sum(win_flag)-sum(draw_flag) as no_of_losses
,2*sum(win_flag)+sum(draw_flag) as total_points
from cte
group by team_name
ORDER BY team_name ;
########################################################################################################################
43 - Customer Retention
  Extreme Hard - 75 Points
Customer retention can be defined as number of customers who continue to make purchases over a certain period compared to the 
total number of customers. Heres a step-by-step approach to calculate customer retention rate:

1- Determine the number of customers who made purchases 
in the current period (e.g., month: m )
2- Identify the number of customers from month m who made purchases 
in month m+1 , m+2 as well.
Suppose you are a data analyst working for Amazon. The company is interested in measuring customer retention over the months 
  to understand how many customers continue to make purchases over time. Your task is to write an SQL to derive customer retention month over month,
  display the output in ascending order of current year, month & future year, month.

Table: orders
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| order_id    | int       |
| customer_id | int       |
| order_date  | date      |
+-------------+-----------+
Expected Output
+--------------+---------------+-------------+--------------+-----------------+--------------------+
| current_year | current_month | future_year | future_month | total_customers | retained_customers |
+--------------+---------------+-------------+--------------+-----------------+--------------------+
|         2023 |            12 |        2024 |            1 |               3 |                  2 |
|         2023 |            12 |        2024 |            2 |               3 |                  1 |
|         2024 |             1 |        2024 |            2 |               3 |                  2 |
+--------------+---------------+-------------+--------------+-----------------+--------------------+

  WITH cte AS (
    SELECT DISTINCT 
        YEAR(order_date) AS year, 
        MONTH(order_date) AS month, 
        customer_id 
    FROM orders
)
SELECT 
    cm.year AS current_year,
    cm.month AS current_month,
    fm.year AS future_year,
    fm.month AS future_month,
    COUNT(DISTINCT cm.customer_id) AS total_customers,
    COUNT(DISTINCT CASE WHEN fm.customer_id = cm.customer_id THEN fm.customer_id END) AS retained_customers
FROM cte cm
INNER JOIN cte fm 
    ON (fm.year > cm.year OR (fm.year = cm.year AND fm.month > cm.month))
GROUP BY cm.year, cm.month, fm.year, fm.month
ORDER BY cm.year, cm.month, fm.year, fm.month;

########################################################################################################################
44 - Excess/insufficient Inventory
  Suppose you are a data analyst working for Flipkart. Your task is to identify excess and insufficient inventory at 
  various Flipkart warehouses in terms of no of units and cost.  Excess inventory is when inventory levels are greater than inventory 
  targets else its insufficient inventory.

Write an SQL to derive excess/insufficient Inventory volume and value in cost for each location as well as at overall company level, 
  display the results in ascending order of location id.

Table: inventory
+------------------+-----------+
| COLUMN_NAME      | DATA_TYPE |
+------------------+-----------+
| inventory_level  | int       |
| inventory_target | int       |
| location_id      | int       |
| product_id       | int       |
+------------------+-----------+
Table: products
+-------------+--------------+
| COLUMN_NAME | DATA_TYPE    |
+-------------+--------------+
| product_id  | int          |
| unit_cost   | decimal(5,2) |
+-------------+--------------+
Expected Output
+-------------+-------------------------+---------------------------+
| location_id | excess_insufficient_qty | excess_insufficient_value |
+-------------+-------------------------+---------------------------+
| 1           |                      25 |                   1347.50 |
| 2           |                     -25 |                  -1420.00 |
| 3           |                      20 |                   1180.00 |
| 4           |                     -12 |                   -600.00 |
| Overall     |                       8 |                    507.50 |
+-------------+-------------------------+---------------------------+
  with cte as (
select i.location_id as location_id
,sum(inventory_level-inventory_target) as excess_insufficient_qty
,sum((inventory_level-inventory_target)*p.unit_cost) as excess_insufficient_value 
from inventory i 
inner join products p on i.product_id=p.product_id
group by i.location_id)

select CAST(location_id as CHAR) as location_id , excess_insufficient_qty,excess_insufficient_value
from cte
union all
select 'Overall' as location_id 
, sum(excess_insufficient_qty) as excess_insufficient_qty
, sum(excess_insufficient_value) as excess_insufficient_value
from cte
ORDER BY location_id;

########################################################################################################################
45 - Zomato Membership
  Zomato is planning to offer a premium membership to customers who have placed multiple orders in a single day.

Your task is to write a SQL to find those customers who have placed multiple orders in a single day at least once , 
  total order value generate by those customers and order value generated only by those orders, display the results in ascending order of total order value.
Table: orders (primary key : order_id)
+---------------+-------------+
| COLUMN_NAME   | DATA_TYPE   |
+---------------+-------------+
| customer_name | varchar(20) |
| order_date    | datetime    |
| order_id      | int         |
| order_value   | int         |
+---------------+-------------+
Expected Output
+---------------+-------------------+-------------+
| customer_name | total_order_value | order_value |
+---------------+-------------------+-------------+
| Mudit         |               780 |         550 |
| Rahul         |              1300 |        1150 |
+---------------+-------------------+-------------+
with cte as (
select customer_name,CAST(order_date as DATE) as order_day
,count(*) as no_of_orders
 from orders 
group by customer_name,CAST(order_date as DATE) 
having count(*)>1
)
select orders.customer_name,sum(orders.order_value) as total_order_value
,sum(case when cte.customer_name is not null then orders.order_value end) as order_value
from orders
left join cte on orders.customer_name=cte.customer_name and 
CAST(orders.order_date as DATE) =cte.order_day
where orders.customer_name in (select distinct customer_name from cte)
group by orders.customer_name
ORDER BY total_order_value;
########################################################################################################################
46 - Employees Inside Office (Part 1)
  A company record its employees movement In and Out of office in a table. Please note below points about the data:
1- First entry for each employee is “in”
2- Every “in” is succeeded by an “out”
3- Employee can work across days
Write a SQL to find the number of employees inside the Office at "2019-04-01 19:05:00".
Table: employee_record
+-------------+------------+
| COLUMN_NAME | DATA_TYPE  |
+-------------+------------+
| emp_id      | int        |
| action      | varchar(3) |
| created_at  | datetime   |
+-------------+------------+
Expected Output
+------------------+
| no_of_emp_inside |
+------------------+
|                3 |
+------------------+
  with cte as (
select *
, lead(created_at) over(partition by emp_id order by created_at) as next_created_at
 from employee_record )
 select count(*) as no_of_emp_inside
 from cte
 where action='in'
 and '2019-04-01 19:05:00' between created_at and next_created_at;

########################################################################################################################
47 - Employees Inside Office (Part 2)
  A company record its employees movement In and Out of office in a table. Please note below points about the data:
1- First entry for each employee is “in”
2- Every “in” is succeeded by an “out”
3- Employee can work across days
Write an SQL to measure the time spent by each employee inside the office between “2019-04-01 14:00:00” and 2019-04-02 10:00:00 in minutes, 
  display the output in ascending order of employee id .
Table: employee_record
+-------------+------------+
| COLUMN_NAME | DATA_TYPE  |
+-------------+------------+
| emp_id      | int        |
| action      | varchar(3) |
| created_at  | datetime   |
+-------------+------------+
  with cte as (
select *
, lead(created_at) over(partition by emp_id order by created_at) as next_created_at
 from employee_record
 ),
 considered_time as (
 select emp_id
 , case when created_at < '2019-04-01 14:00:00' then '2019-04-01 14:00:00' else created_at end as in_time
 , case when next_created_at > '2019-04-02 10:00:00' then '2019-04-02 10:00:00' else next_created_at end as out_time
 from cte
 where action='in'
 )
select emp_id 
, ROUND(sum(case when in_time>=out_time then 0 else TIMESTAMPDIFF(minute,in_time,out_time) end) , 1 ) as time_spent_in_mins
from considered_time
group by emp_id
ORDER BY emp_id;
########################################################################################################################
48 – Female Contribution
  Medium - 20 Points
You are given a history of credit card transaction data for the people of India across cities. 
  Write an SQL to find percentage contribution of spends by females in each city.  Round the percentage
  to 2 decimal places. Display city, total spend , female spend and female contribution in ascending order of city.
Table: credit_card_transactions
+------------------+-------------+
| COLUMN_NAME      | DATA_TYPE   |
+------------------+-------------+
| amount           | int         |
| card_type        | varchar(10) |
| city             | varchar(10) |
| gender           | varchar(1)  |
| transaction_date | date        |
| transaction_id   | int         |
+------------------+-------------+
Expected Output
+--------+--------------------+
| emp_id | time_spent_in_mins |
+--------+--------------------+
|      1 |                300 |
|      2 |                  0 |
|      3 |                600 |
|      4 |                960 |
|      5 |               1200 |
|      6 |                  0 |
+--------+--------------------+
  select city,sum(amount) as total_spend
, sum(case when gender='F' then amount else 0 end) as female_spend
, round(sum(case when gender='F' then amount else 0 end)*1.0/sum(amount)*100,2) as female_contribution
from credit_card_transactions
group by city
ORDER BY city ;
########################################################################################################################
49 - Credit Card Transactions (Part-1)
  You are given a history of credit card transaction data for the people of India across cities . 
  Write an SQL to find how many days each city took to reach cumulative spend of 1500 from its first day of transactions. 
Display city, first transaction date , date of 1500 spend and # of days in the ascending order of city.

Table: credit_card_transactions
+------------------+-------------+
| COLUMN_NAME      | DATA_TYPE   |
+------------------+-------------+
| transaction_id   | int         |
| transaction_date | date        |
| amount           | int         |
| card_type        | varchar(12) |
| city             | varchar(20) |
| gender           | varchar(1)  |
+------------------+-------------+
Expected Output
+-----------+-------------+--------------+---------------------+
| city      | total_spend | female_spend | female_contribution |
+-----------+-------------+--------------+---------------------+
| Bengaluru |        3450 |          300 |                8.70 |
| Delhi     |        1630 |         1430 |               87.73 |
| Mumbai    |        4150 |         4150 |              100.00 |
+-----------+-------------+--------------+---------------------+
  with cte as (
select city, transaction_date, sum(amount) as total_amount
,min(transaction_date) over(partition by city) as first_transaction_date
from credit_card_transactions
group by city,transaction_date
)
,cte2 as (
select *
,sum(total_amount) over(partition by city order by transaction_date rows between unbounded preceding and current row) as cum_sum
 from cte
)
select city, first_transaction_date,MIN(transaction_date) as tran_date_1500
, MIN(transaction_date) - first_transaction_date as no_of_days
from cte2 
where cum_sum>=1500
group by city,first_transaction_date
ORDER BY city;
########################################################################################################################
50 - Adverse Reactions
In the field of pharmacovigilance, its crucial to monitor and assess adverse reactions that patients may experience after
taking certain medications. Adverse reactions, also known as side effects, can range from mild to severe and can impact the safety and efficacy of a medication.
For each medication, count the number of adverse reactions reported within the first 30 days of the prescription being issued.
Assume that the prescription date in the Prescriptions table represents the start date of the medication usage, 
display the output in ascending order of medication name.

Table: patients
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| patient_id  | int         |
| name        | varchar(20) |
| age         | int         |
| gender      | varchar(10) |
+-------------+-------------+
Table: medications
+-----------------+-------------+
| COLUMN_NAME     | DATA_TYPE   |
+-----------------+-------------+
| manufacturer    | varchar(20) |
| medication_id   | int         |
| medication_name | varchar(20) |
+-----------------+-------------+
Table: prescriptions
+-------------------+-----------+
| COLUMN_NAME       | DATA_TYPE |
+-------------------+-----------+
| prescription_id   | int       |
| patient_id        | int       |
| medication_id     | int       |
| prescription_date | date      |
+-------------------+-----------+
Table: adverse_reactions
+----------------------+-------------+
| COLUMN_NAME          | DATA_TYPE   |
+----------------------+-------------+
| patient_id           | int         |
| reaction_date        | date        |
| reaction_description | varchar(20) |
| reaction_id          | int         |
+----------------------+-------------+

Expected Output
+-----------------+-------------------+-----------------------+
| medication_name | manufacturer      | num_adverse_reactions |
+-----------------+-------------------+-----------------------+
| Aspirin         | Pfizer            |                     4 |
| Lipitor         | Pfizer            |                     1 |
| Tylenol         | Johnson & Johnson |                     0 |
+-----------------+-------------------+-----------------------+
  SELECT 
    m.medication_name,
    m.manufacturer,
    COUNT(AR.reaction_id) AS num_adverse_reactions
FROM 
    Medications m
INNER JOIN 
    Prescriptions p ON M.medication_id = p.medication_id
LEFT JOIN 
    adverse_reactions ar ON p.patient_id = AR.patient_id
                        AND AR.reaction_date BETWEEN P.prescription_date AND DATE_ADD(P.prescription_date , INTERVAL 30 DAY)
GROUP BY 
    m.medication_name, m.manufacturer
ORDER BY m.medication_name;
########################################################################################################################
51 - Balanced Team
  Suppose you are a manager of a data analytics company. You are tasked to build a new team consists of senior and junior data analysts. 
  The total budget for the salaries is 70000.  You need to use the below criterion for hiring.
1- Keep hiring the seniors with the smallest salaries until you cannot hire anymore seniors.
2- Use the remaining budget to hire the juniors with the smallest salaries until you cannot hire anymore juniors.
Display employee id, experience and salary. Sort in decreasing order of salary.

Table: candidates
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| emp_id      | int         |
| experience  | varchar(6) |
| salary      | int         |
+-------------+-------------+
Expected Output
+--------+------------+--------+
| emp_id | experience | salary |
+--------+------------+--------+
|      5 | Senior     |  20000 |
|      4 | Senior     |  16000 |
|      2 | Junior     |  15000 |
|      1 | Junior     |  10000 |
+--------+------------+--------+
with total_sal as (
select *
,sum(salary) over(partition by experience order by salary rows between unbounded preceding and current row) as running_sal
 from candidates
)
,seniors as (
select * 
from total_sal
where experience='Senior' and running_sal<=70000
)
select emp_id,experience,salary from seniors
union all
select emp_id,experience,salary from total_sal 
where experience='Junior' 
and running_sal<=70000-(select sum(salary) from seniors)
order by salary desc;
########################################################################################################################
52 - Loan Repayment
Youre working for a large financial institution that provides various types of loans to customers. 
Your task is to analyze loan repayment data to assess credit risk and improve risk management strategies.
Write an SQL to create 2 flags for each loan as per below rules. Display loan id, loan amount , due date and the 2 flags.

1- fully_paid_flag: 1 if the loan was fully repaid irrespective of payment date else it should be 0.
2- on_time_flag : 1 if the loan was fully repaid on or before due date else 0.
Table: loans
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| loan_id     | int       |
| customer_id | int       |
| loan_amount | int       |
| due_date    | date      |
+-------------+-----------+
Table: payments
+--------------+-----------+
| COLUMN_NAME  | DATA_TYPE |
+--------------+-----------+
| amount_paid  | int       |
| loan_id      | int       |
| payment_date | date      |
| payment_id   | int       |
+--------------+-----------+
Expected Output
+---------+-------------+------------+-----------------+--------------+
| loan_id | loan_amount | due_date   | fully_paid_flag | on_time_flag |
+---------+-------------+------------+-----------------+--------------+
|       1 |        5000 | 2023-01-15 |               0 |            0 |
|       2 |        8000 | 2023-02-20 |               1 |            1 |
|       3 |       10000 | 2023-03-10 |               0 |            0 |
|       4 |        6000 | 2023-04-05 |               1 |            1 |
|       5 |        7000 | 2023-05-01 |               1 |            0 |
+---------+-------------+------------+-----------------+--------------+
  
SELECT 
    l.loan_id, 
    l.loan_amount, 
    l.due_date,
    CASE WHEN SUM(p.amount_paid) = l.loan_amount THEN 1 ELSE 0 END AS fully_paid_flag                --    Flag set to 1 if total amount paid equals loan amount, else 0
   ,CASE WHEN SUM(CASE WHEN p.payment_date <= l.due_date THEN p.amount_paid END) = l.loan_amount THEN 1 ELSE 0 END AS on_time_flag  --    Flag set to 1 if full loan amount paid on or before due date, else 0
FROM loans l                                                                                       --    Loans table alias 'l'
LEFT JOIN payments p ON l.loan_id = p.loan_id                                                     --    Left join with payments table on loan_id
GROUP BY l.loan_id, l.loan_amount, l.due_date                                                     --    Group by loan details to aggregate payments
ORDER BY l.loan_id;                                                                               --    Order results by loan_id ascending

########################################################################################################################
53 - LinkedIn Recommendation
  LinkedIn stores information of post likes in below format. Every time a user likes a post there will be an entry made in post likes table.
Table : post_likes 
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| post_id     | int       |
| user_id     | int       |
+-------------+-----------+
LinkedIn also stores the information when someone follows another user in below format.
Table : user_follows
+-----------------+-----------+
| COLUMN_NAME     | DATA_TYPE |
+-----------------+-----------+
| follows_user_id | int       |
| user_id         | int       |
+-----------------+-----------+
The marketing team wants to send one recommendation post to each user . Write an SQL to find out that one post id for each user 
  that is liked by the most number of users that they follow. Display user id, post id and no of likes.
Please note that team do not want to recommend a post which is already liked by the user. If for any user,  2 or more posts are 
  liked by equal number of users that they follow then select the smallest post id, display the output in ascending order of user id.

Expected Output
+---------+---------+-------------+
| user_id | post_id | no_of_likes |
+---------+---------+-------------+
|       1 |     200 |           1 |
|       2 |     400 |           3 |
|       3 |     100 |           2 |
|       4 |     100 |           2 |
+---------+---------+-------------+
  with cte as (
select f.user_id,p.post_id,count(*) as no_of_likes
from user_follows f 
inner join post_likes p on f.follows_user_id = p.user_id 
group by f.user_id,p.post_id
)
select user_id,post_id,no_of_likes from (
select cte.* 
,row_number() over(partition by cte.user_id order by no_of_likes desc, cte.post_id ) as rn
from cte
left join post_likes p on p.user_id=cte.user_id and p.post_id=cte.post_id
where p.post_id is null
) s
where rn=1
ORDER BY user_id;

########################################################################################################################
54 - Employees Payout
  An IT company pays its employees on hourly basis. You are given the database of employees along with their department id.
Table: employees
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| emp_id      | int         |
| emp_name    | varchar(20) |
| dept_id     | int         |
+-------------+-------------+
Department table which consist of hourly rate for each department.
Table: dept
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| dept_id     | int       |
| hourly_rate | int       |
+-------------+-----------+
Given the daily entry_time and exit_time of each employee, calculate the total amount payable to each employee.
Table: daily_time
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| emp_id      | int       |
| entry_time  | datetime  |
| exit_time   | datetime  |
+-------------+-----------+
Please note that company also pays overtime to employees who work for more than 8 hours a day which is 1.5 times of hourly rate. 
  So for example if hourly rate is 10 and a employee works for 9 hours then total payable will be 10*8+15*1 = 95 for that day.
  In this example 95 is total payout and 15 is overtime payout.  Round the result to 
  2 decimal places and sort the output by decreasing order of total payout.
Expected Output
+----------+--------------+-----------------+
| emp_name | total_payout | overtime_payout |
+----------+--------------+-----------------+
| Jane     |       234.00 |           54.00 |
| Alice    |       212.50 |           52.50 |
| Bob      |       210.00 |            0.00 |
| Emily    |       204.00 |           36.00 |
| John     |       160.00 |            0.00 |
+----------+--------------+-----------------+
  
with cte as (
select e.emp_name ,d.hourly_rate ,TIMESTAMPDIFF(second, entry_time, exit_time)/3600.0 as total_hours
from daily_time t 
inner join employees e on t.emp_id=e.emp_id
inner join dept d on d.dept_id=e.dept_id
)
select emp_name
,ROUND(sum(case when total_hours <=8 then total_hours*hourly_rate*1.0
else 8*hourly_rate*1.0 + (total_hours-8)*hourly_rate*1.5 end),2) as total_payout
,ROUND(sum(case when total_hours <=8 then 0
else (total_hours-8)*hourly_rate*1.5 end),2) as overtime_payout
from cte 
group by emp_name
order by total_payout desc;
 
########################################################################################################################
55 - Lowest Price
  You own a small online store, and want to analyze customer ratings for the products that youre selling. 
  After doing a data pull, you have a list of products and a log of purchases. Within the purchase log, each record includes the number of stars (from 1 to 5) as a customer rating for the product.

For each category, find the lowest price among all products that received at least one 4-star or above rating from customers.
If a product category did not have any products that received at least one 4-star or above rating, the lowest price is considered to be 0.
  The final output should be sorted by product category in alphabetical order.

Table: products
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| category    | varchar(10) |
| id          | int         |
| name        | varchar(20) |
| price       | int         |
+-------------+-------------+
Table: purchases
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| id          | int       |
| product_id  | int       |
| stars       | int       |
+-------------+-----------+
Expected Output
+----------+-------+
| category | price |
+----------+-------+
| apple    |     0 |
| cherry   |    36 |
| grape    |     0 |
| orange   |    14 |
+----------+-------+
	
SELECT 
    category,
    COALESCE(MIN(CASE WHEN pur.product_id IS NOT NULL THEN price END), 0) AS price          --    Minimum price of products purchased with 4 or 5 stars, default 0 if none
FROM products p                                                                            --    Products table alias 'p'
LEFT JOIN purchases pur ON p.id = pur.product_id AND pur.stars IN (4, 5)                   --    Left join purchases with 4 or 5 star ratings
GROUP BY category                                                                         --    Group results by product category
ORDER BY category;                                                                        --    Order results by category ascending

########################################################################################################################
56 – Expenses Excluding MasterCard
You're working for a financial analytics company that specializes in analyzing credit card expenditures. You have a dataset containing information about users' 
credit card expenditures across different card companies.
Write an SQL query to find the total expenditure from other cards (excluding Mastercard) for users who hold Mastercard.  Display only the users(along with Mastercard expense and other expense) 
for which expense from other cards together is more than Mastercard expense.
Table: expenditures
+--------------+-------------+
| COLUMN_NAME  | DATA_TYPE   |
+--------------+-------------+
| user_name    | varchar(10) |
| expenditure  | int         |
| card_company | varchar(15) |
+--------------+-------------+
Expected Output
+-----------+--------------------+---------------+
| user_name | mastercard_expense | other_expense |
+-----------+--------------------+---------------+
| user1     |               1000 |          2500 |
+-----------+--------------------+---------------+
with mastercard as (
select user_name,sum(expenditure) as expenditure
from expenditures 
where card_company='Mastercard'
group by user_name
)
, non_mastercard as (
select user_name,sum(expenditure) as expenditure
from expenditures 
where card_company!='Mastercard'
group by user_name
)
select m.user_name, m.expenditure as mastercard_expense,nm.expenditure as other_expense
from mastercard m 
inner join non_mastercard nm on m.user_name=nm.user_name
where nm.expenditure > m.expenditure;
########################################################################################################################
57 - Dashboard Visits
Youre working as a data analyst for a popular websites dashboard analytics team.
Your task is to analyze user visits to the dashboard and identify users who are highly engaged with the platform. 
The dashboard records user visits along with timestamps to provide insights into user activity patterns.
A user can visit the dashboard multiple times within a day. However, to be counted as separate visits, 
there should be a minimum gap of 60 minutes between consecutive visits. If the next visit occurs within 60 minutes of the previous one, its
considered part of the same visit.

Table: dashboard_visit
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| user_id     | varchar(10) |
| visit_time  | datetime    |
+-------------+-------------+

Write an SQL query to find total number of visits by each user along with number of distinct days user has visited the dashboard. 
While calculating the number of distinct days you have to consider a visit even if it is same as previous days visit.
So for example if there is a visit at 2024-01-12 23:30:00 and next visit at 2024-01-13 00:15:00 , 
The visit on 13th will not be considered as new visit because it is within 1 hour window of previous visit but number of
days will be counted as 2 only, display the output in ascending order of user id.
	
Expected Output
+---------+--------------+------------+
| user_id | no_of_visits | visit_days |
+---------+--------------+------------+
| Alice   |            2 |          1 |
| Bob     |            2 |          2 |
| Charlie |            1 |          1 |
| David   |            3 |          4 |
+---------+--------------+------------+
	
WITH previous_visits AS (
    SELECT 
        user_id,
        visit_time,
        LAG(visit_time) OVER (PARTITION BY user_id ORDER BY visit_time) AS previous_visit_time
    FROM
        dashboard_visit
)
, vigit_flag as (
select user_id, previous_visit_time,visit_time
, CASE WHEN previous_visit_time IS NULL THEN 1
      WHEN TIMESTAMPDIFF(second, previous_visit_time, visit_time) / 3600 > 1 THEN 1
            ELSE 0
        END AS new_visit_flag
from previous_visits
)
select user_id, sum(new_visit_flag) as no_of_visits, count(distinct CAST(visit_time as DATE)) as visit_days
from vigit_flag
group by user_id
ORDER BY user_id ASC;
########################################################################################################################
58 - Final Account Balance
You are given history of your bank account for the year 2020. Each transaction is either a credit card payment or
incoming transfer. There is a fee of holding a credit card which you have to pay every month, Fee is 5 per month.
However, you are not charged for a given month if you made at least 2 credit card payments for a total cost of at least 
100 within that month. Note that this fee is not included in the supplied history of transactions.
Each row in the table contains information about a single transaction. If the amount value is negative, it is a credit
card payment otherwise it is an incoming transfer. At the beginning of the year, the balance of your account was 0 . 
Your task is to compute the balance at the end of the year. 

Table : Transactions 
+------------------+-----------+
| COLUMN_NAME      | DATA_TYPE |
+------------------+-----------+
| amount           | int       |
| transaction_date | date      |
+------------------+-----------+
Expected Output
+---------------+
| final_balance |
+---------------+
|           -95 |
+---------------+
with cte as (
select month(transaction_date)  as tran_month ,amount
 from transactions
)
,cte2 as (
select tran_month
, sum(amount) as net_amount , sum(case when amount<0 then -1*amount else 0 end) as credit_card_amount
, sum(case when amount<0 then 1 else 0 end) as credit_card_transact_cnt
from cte 
group by tran_month
)
select sum(net_amount) - sum(case when credit_card_amount >=100 and credit_card_transact_cnt >=2 then 0 else 5 end)
- 5*(12-(select count(distinct tran_month) from cte)) as final_balance
from cte2;

########################################################################################################################
59 - Order Lead Time
You are given orders data of an online ecommerce company. Dataset contains order_id , order_date and ship_date. 
Your task is to find lead time in days between order date and ship date using below rules:
1- Exclude holidays. List of holidays present in holiday table. 
2- If the order date is on weekends, then consider it as order placed on immediate next Monday 
and if the ship date is on weekends, then consider it as immediate previous Friday to do calculations.
For example, if order date is March 14th 2024 and ship date is March 20th 2024. Consider March 18th is 
a holiday then lead time will be (20-14) -1 holiday = 5 days.
Table: orders
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| order_date  | date      |
| order_id    | int       |
| ship_date   | date      |
+-------------+-----------+
Table: holidays
+--------------+-----------+
| COLUMN_NAME  | DATA_TYPE |
+--------------+-----------+
| holiday_date | date      |
| holiday_id   | int       |
+--------------+-----------+

Expected Output
+----------+-----------+
| order_id | lead_time |
+----------+-----------+
|        1 |         5 |
|        2 |         4 |
|        3 |         7 |
|        4 |         2 |
|        5 |         4 |
|        6 |        12 |
+----------+-----------+
	
with cte as (
select *
,case when WEEKDAY(order_date)=6 then DATE_ADD(order_date , INTERVAL 1 DAY) 
when WEEKDAY(order_date)=5 then DATE_ADD(order_date , INTERVAL 2 DAY) 
else order_date end as order_date_new
,case when WEEKDAY(ship_date)=6 then DATE_ADD(ship_date , INTERVAL -2 DAY) 
when WEEKDAY(ship_date)=5 then DATE_ADD(ship_date , INTERVAL -1 DAY) 
else ship_date end as ship_date_new
from orders
)
,cte2 as (
select order_id,order_date_new,ship_date_new
,DATEDIFF(ship_date_new,order_date_new) as no_of_days
from cte
)
select order_id , no_of_days-count(holiday_date) as lead_time
from cte2 
left join holidays on holiday_date between order_date_new and ship_date_new
group by order_id , no_of_days
ORDER BY order_id ;

########################################################################################################################
60 - Instagram Marketing Agency
You are working for a marketing agency that manages multiple Instagram influencer accounts. 
Your task is to analyze the engagement performance of these influencers before and after they join your company.
Write an SQL query to calculate average engagement growth rate percent for each influencer after they joined your 
company compare to before. Round the growth rate to 2 decimal places and sort the output in decreasing order of growth rate.

Engagement = (# of likes + # of comments on each post)
 
Table: influencers
+---------------+-------------+
| COLUMN_NAME   | DATA_TYPE   |
+---------------+-------------+
| influencer_id | int         |
| join_date     | date        |
| username      | varchar(10) |
+---------------+-------------+
Table: posts
+---------------+-----------+
| COLUMN_NAME   | DATA_TYPE |
+---------------+-----------+
| comments      | int       |
| influencer_id | int       |
| likes         | int       |
| post_date     | date      |
| post_id       | int       |
+---------------+-----------+
Expected Output
+----------+-------------------+------------------+--------+
| username | before_engagement | after_engagement | growth |
+----------+-------------------+------------------+--------+
| Ankit    |          150.0000 |         195.0000 |  30.00 |
| Rahul    |          202.5000 |         250.0000 |  23.46 |
+----------+-------------------+------------------+--------+
with cte as (
select  i.username 
, avg(case when p.post_date < i.join_date then (likes+comments) end) as before_engagement
, avg(case when p.post_date > i.join_date then (likes+comments) end) as after_engagement
from posts p
inner join influencers i on i.influencer_id=p.influencer_id
group by i.username 
)
select *
,round((after_engagement-before_engagement)*100/before_engagement,2)  as growth
from cte
order by growth desc;
########################################################################################################################
61 - Category Sales (Part 1)
Write an SQL query to retrieve the total sales amount for each product category in the month of February 2022, 
only including sales made on weekdays (Monday to Friday). Display the output in ascending order of total sales.
Tables: sales
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| id          | int         |
| product_id  | int         |
| category    | varchar(12) |
| amount      | int         |
| order_date  | date        |
+-------------+-------------+

Expected Output
+-------------+-------------+
| category    | total_sales |
+-------------+-------------+
| Books       |         400 |
| Clothing    |         500 |
| Electronics |        2000 |
+-------------+-------------+

SELECT 
    category,
    SUM(amount) AS total_sales                                                        --    Sum of sales amounts per category
FROM sales
WHERE YEAR(order_date) = 2022                                                         --    Filter orders from year 2022
  AND MONTH(order_date) = 2                                                           --    Filter orders from February
  AND DAYOFWEEK(order_date) BETWEEN 2 AND 6                                          --    Filter orders from Monday (2) to Friday (6)
GROUP BY category                                                                     --    Group sales by category
ORDER BY total_sales;                                                                 --    Order results by total sales ascending

########################################################################################################################
62 - Category Sales (Part 2)
Write an SQL query to retrieve the total sales amount in each category. Include all categories, if no products were sold in a category
display as 0. Display the output in ascending order of total_sales.

Tables: sales
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| amount      | int       |
| category_id | int       |
| sale_date   | date      |
| sale_id     | int       |
+-------------+-----------+
Tables: Categories
+---------------+-------------+
| COLUMN_NAME   | DATA_TYPE   |
+---------------+-------------+
| category_id   | int         |
| category_name | varchar(12) |
+---------------+-------------+

Expected Output
+---------------+-------------+
| category_name | total_sales |
+---------------+-------------+
| Clothing      |           0 |
| Books         |         350 |
| Home Decor    |        1000 |
| Electronics   |        1300 |
+---------------+-------------+
SELECT 
    c.category_name,
    COALESCE(SUM(s.amount), 0) AS total_sales                                        --    Sum of sales amount per category; defaults to 0 if no sales
FROM categories c                                                                   --    Categories table alias 'c'
LEFT JOIN sales s ON c.category_id = s.category_id                                  --    Left join to include categories with no sales
GROUP BY c.category_name                                                            --    Group results by category name
ORDER BY total_sales;                                                               --    Order results by total sales in ascending order

########################################################################################################################
63 - Prime Subscription
Amazon, the worlds largest online retailer, offers various services to its customers, including Amazon Prime membership, Video streaming, 
Amazon Music, Amazon Pay, and more. The company is interested in analyzing which of its services are most effective at converting regular 
customers into Amazon Prime members.
You are given a table of events which consists services accessed by each users along with service access date. 
This table also contains the event when customer bought the prime membership (type='prime').
Write an SQL to get date when each customer became prime member, last service used and last service access date 
(just before becoming prime member). If a customer never became prime member, then populate only the last service used 
and last service access date by the customer, display the output in ascending order of last service access date.

Table: users
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| name        | varchar(15) |
| user_id     | int         |
+-------------+-------------+
Table : events
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| user_id     | int         |
| type        | varchar(15) |
| access_date | date        |
+-------------+-------------+
Expected Output
+-----------+-------------------+---------------------+--------------------------+
| user_name | prime_member_date | last_access_service | last_access_service_date |
+-----------+-------------------+---------------------+--------------------------+
| Saurabh   | 2024-01-08        | Amazon Video        | 2024-01-07               |
| Amit      | 2024-01-09        | Amazon Pay          | 2024-01-08               |
| Ankit     | NULL              | Amazon Music        | 2024-01-09               |
+-----------+-------------------+---------------------+--------------------------+

WITH cte as (
select *
, lag(type,1) over(partition by user_id order by access_date) as prev_type
, lag(access_date,1) over(partition by user_id order by access_date) as prev_access_date
,row_number() over(partition by user_id order by access_date desc) as rn
from events
)
select u.name as user_name 
, cte.access_date as prime_member_date , coalesce(cte.prev_type,c.type) as last_access_service, coalesce(cte.prev_access_date,c.access_date) as last_access_service_date
from users u
left join cte on u.user_id=cte.user_id and cte.type='Prime'
left join cte c on c.user_id=u.user_id and c.rn=1
ORDER BY last_access_service_date;
########################################################################################################################
64 - Penultimate Order
You are a data analyst working for an e-commerce company, responsible for analysing customer orders 
to gain insights into their purchasing behaviour. Your task is to write a SQL query to retrieve the details 
of the penultimate order for each customer. However, if a customer has placed only one order, you need to retrieve 
the details of that order instead, display the output in ascending order of customer name.

Table: orders
+---------------+-------------+
| COLUMN_NAME   | DATA_TYPE   |
+---------------+-------------+
| order_id      | int         |
| order_date    | date        |
| customer_name | varchar(10) |
| product_name  | varchar(10) |
| sales         | int         |
+---------------+-------------+

Expected Output
+----------+------------+---------------+--------------+-------+
| order_id | order_date | customer_name | product_name | sales |
+----------+------------+---------------+--------------+-------+
|        2 | 2023-01-02 | Alexa         | boAt         |   300 |
|        6 | 2023-01-03 | Neha          | Dress        |   100 |
|        4 | 2023-01-01 | Ramesh        | Titan        |   200 |
+----------+------------+---------------+--------------+-------+
	
WITH cte AS (
    SELECT * 
         ,ROW_NUMBER() OVER(PARTITION BY customer_name ORDER BY order_date DESC) AS rn         --    Assigns rank to each order per customer based on most recent order
         ,COUNT(*) OVER(PARTITION BY customer_name) AS cnt_of_orders                          --    Counts total number of orders per customer
    FROM orders
)
SELECT 
    order_id,
    order_date,
    customer_name,
    product_name,
    sales
FROM cte
WHERE rn = 2 OR cnt_of_orders = 1                                                             --    Selects second most recent order or the only order if customer has just one
ORDER BY customer_name;                                                                       --    Order results by customer name alphabetically

########################################################################################################################
65 - Service Downtime
You are a DevOps engineer responsible for monitoring the health and status of various services in your 
organizations infrastructure. Your team conducts canary tests on each service every minute to ensure their 
reliability and performance. As part of your responsibilities, you need to develop a SQL to identify any service that 
experiences continuous downtime for at least 5 minutes so that team can find the root cause and fix the issue. 
Display the output in descending order of service down minutes.

Table:service_status 
+--------------+-------------+
| COLUMN_NAME  | DATA_TYPE   |
+--------------+-------------+
| service_name | varchar(4) |
| status       | varchar(4)  |
| updated_time | datetime    |
+--------------+-------------+
Expected Output
+--------------+---------------------+---------------------+--------------+
| service_name | down_start_time     | down_end_time       | down_minutes |
+--------------+---------------------+---------------------+--------------+
| hdfs         | 2024-03-06 10:02:00 | 2024-03-06 10:07:00 |            6 |
| hive         | 2024-03-06 10:03:00 | 2024-03-06 10:07:00 |            5 |
+--------------+---------------------+---------------------+--------------+
WITH consecutive_down AS (
    SELECT 
        service_name,   updated_time,   status,
        ROW_NUMBER() OVER (PARTITION BY service_name ORDER BY updated_time) AS row_num,
        ROW_NUMBER() OVER (PARTITION BY service_name, status ORDER BY updated_time) AS status_row_num
    FROM
        service_status
)
SELECT 
    service_name,
    MIN(updated_time) AS down_start_time,
    MAX(updated_time) AS down_end_time,
    COUNT(*) AS down_minutes
FROM 
    consecutive_down
WHERE 
    status = 'down'
GROUP BY 
    service_name, 
    row_num-status_row_num
HAVING 
    COUNT(*) >= 5
ORDER BY down_minutes desc;

########################################################################################################################
66 - Fake Ratings
As an analyst at Amazon, you are responsible for ensuring the integrity of product ratings on the platform. 
Fake ratings can distort the perception of product quality and mislead customers. To maintain trust and reliability,
you need to identify potential fake ratings that deviate significantly from the average ratings for each product.
Write an SQL query to identify the single rating that is farthest (in absolute value) from the average rating value for 
each product, display rating details in ascending order of rating id.
Table : product_ratings
+-------------+--------------+
| COLUMN_NAME | DATA_TYPE    |
+-------------+--------------+
| rating_id   | int          |
| product_id  | int          |
| user_id     | int          |
| rating      | decimal(2,1) |
+-------------+--------------+
Expected Output
+-----------+------------+---------+--------+
| rating_id | product_id | user_id | rating |
+-----------+------------+---------+--------+
|         5 |        101 |    1005 |    3.2 |
|         6 |        102 |    1006 |    4.7 |
+-----------+------------+---------+--------+
WITH rating_stats AS (
    SELECT product_id,AVG(rating) AS avg_rating
    FROM product_ratings
    GROUP BY product_id
),
farthest_rating AS (
    SELECT pr.rating_id,pr.product_id,pr.user_id,pr.rating,rs.avg_rating,
        ABS(pr.rating - rs.avg_rating) AS rating_difference,
        ROW_NUMBER() OVER (PARTITION BY pr.product_id ORDER BY ABS(pr.rating - rs.avg_rating) DESC) AS rn
    FROM
        product_ratings pr JOIN rating_stats rs ON pr.product_id = rs.product_id
)
SELECT rating_id,product_id,user_id,rating
FROM farthest_rating
WHERE rn = 1
ORDER BY rating_id;
########################################################################################################################
67 - Food Preparation Time
Youre analyzing the efficiency of food delivery on Zomato, focusing on the time taken by restaurants to prepare orders. 
Total food delivery time for an order is a combination of food preparation time + time taken by rider to deliver the order. 
Write an SQL to calculate average food preparation time(in minutes) for each restaurant . Round the average to 2 decimal points 
and sort the output in increasing order of average time.
Table: orders
+------------------------+-----------+
| COLUMN_NAME            | DATA_TYPE |
+------------------------+-----------+
| order_id               | int       |
| restaurant_id          | int       |
| order_time             | time      |
| expected_delivery_time | time      |
| actual_delivery_time   | time      |
| rider_delivery_mins    | int       |
+------------------------+-----------+
Expected Output
+---------------+--------------------+
| restaurant_id | avg_food_prep_mins |
+---------------+--------------------+
|           103 |              27.67 |
|           102 |              28.67 |
|           101 |              29.50 |
+---------------+--------------------+
with cte as (
select restaurant_id,order_time,actual_delivery_time,rider_delivery_mins 
, TIMESTAMPDIFF(MINUTE , order_time, actual_delivery_time) as total_delivery_mins
from orders
)
select restaurant_id
,round(avg((total_delivery_mins-rider_delivery_mins)),2) as avg_food_prep_mins
from cte
group by restaurant_id
order by avg_food_prep_mins;

########################################################################################################################
68 - Late Food Deliveries
Medium - 20 Points
Youre analyzing late deliveries on Zomato. Each order’s total delivery time is split equally:
50% for food preparation (restaurant)
50% for the riders trip
Goal: Find orders that were late ONLY because the rider took longer than expected. In other words, food was ready on time, but the rider was slow.

Display the following for each such order:

order_id
expected_delivery_mins
rider_delivery_mins
food_prep_mins
Sort the results by order_id in ascending order.
Expected Output
+----------+------------------------+---------------------+----------------+
| order_id | expected_delivery_mins | rider_delivery_mins | food_prep_mins |
+----------+------------------------+---------------------+----------------+
|        2 |                     25 |                  30 |             10 |
|        6 |                     30 |                  29 |             14 |
+----------+------------------------+---------------------+----------------+

Table: orders
+------------------------+-----------+
| COLUMN_NAME            | DATA_TYPE |
+------------------------+-----------+
| order_id               | int       |
| restaurant_id          | int       |
| order_time             | time      |
| expected_delivery_time | time      |
| actual_delivery_time   | time      |
| rider_delivery_mins    | int       |
+------------------------+-----------+
with cte as (
select order_id,actual_delivery_time,rider_delivery_mins
,TIMESTAMPDIFF(MINUTE , order_time, actual_delivery_time) as  actual_delivery_mins
,TIMESTAMPDIFF(MINUTE , order_time, expected_delivery_time) as  expected_delivery_mins
 from orders
where actual_delivery_time>expected_delivery_time
)
,cte1 as (
select order_id,actual_delivery_mins,expected_delivery_mins,rider_delivery_mins,(actual_delivery_mins - rider_delivery_mins) as food_prep_mins
,(expected_delivery_mins)/2 as expected_food_prep_mins
from cte
)
select order_id,expected_delivery_mins,rider_delivery_mins,food_prep_mins
 from cte1 
where food_prep_mins<=expected_food_prep_mins
ORDER BY order_id;
########################################################################################################################
69 - Country Indicators
In the realm of global indicators and country-level assessments, its imperative to identify the years in which certain indicators 
hit their lowest values for each country. Leveraging a dataset provided by government, which contains indicators across multiple years 
for various countries, your task is to formulate an SQL query to find the following information:
For each country and indicator combination, determine the year in which the indicator value was lowest, along with the corresponding
indicator value. Sort the output by country name and indicator name.

Table: country_data 
+----------------+--------------+
| COLUMN_NAME    | DATA_TYPE    |
+----------------+--------------+
| country_name   | varchar(15)  |
| indicator_name | varchar(25)  |
| year_2010      | decimal(3,2) |
| year_2011      | decimal(3,2) |
| year_2012      | decimal(3,2) |
| year_2013      | decimal(3,2) |
| year_2014      | decimal(3,2) |
+----------------+--------------+
Expected Output
+---------------+--------------------------+-----------------+-------------+
| country_name  | indicator_name           | indicator_value | year_number |
+---------------+--------------------------+-----------------+-------------+
| Canada        | Control of Corruption    |            1.46 |        2010 |
| Canada        | Government Effectiveness |            1.35 |        2013 |
| Canada        | Regulatory Quality       |            1.38 |        2010 |
| Canada        | Rule of Law              |            1.42 |        2010 |
| Canada        | Voice and Accountability |            1.09 |        2014 |
| United States | Control of Corruption    |            1.26 |        2010 |
| United States | Government Effectiveness |            1.25 |        2013 |
| United States | Regulatory Quality       |            1.28 |        2010 |
| United States | Rule of Law              |            1.32 |        2010 |
| United States | Voice and Accountability |            1.05 |        2014 |
+---------------+--------------------------+-----------------+-------------+
with cte as (
select country_name,indicator_name,year_2010 as indicator_value, 2010 as year_number
 from country_data 
union all
select country_name,indicator_name,year_2011 as indicator_value, 2011 as year_number
 from country_data 
union all
select country_name,indicator_name,year_2012 as indicator_value, 2012 as year_number
 from country_data 
union all
select country_name,indicator_name,year_2013 as indicator_value, 2013 as year_number
 from country_data 
union all
select country_name,indicator_name,year_2014 as indicator_value, 2014 as year_number
 from country_data )
 select country_name,indicator_name,indicator_value,year_number from (
 select *
 ,rank() over(partition by country_name,indicator_name order by indicator_value) as rn
 from cte
 ) a
 where rn=1
 order by country_name,indicator_name;
########################################################################################################################
70 - Employee Name
Hard - 40 Points
The HR department needs to extract the first name, middle name and last name of each employee from the full name column. However, the full name column contains names in the format "Lastname,Firstname Middlename". 
Please consider that an employee name can be in one of the 3 following formats.
1- "Lastname,Firstname Middlename"
2- "Lastname,Firstname"
3- "Firstname"

Table : employee 
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| employeeid  | int         |
| fullname    | varchar(20) |
+-------------+-------------+

Expected Output
+--------------------+------------+-------------+-----------+
| fullname           | first_name | middle_name | last_name |
+--------------------+------------+-------------+-----------+
| Doe,John Michael   | John       | Michael     | Doe       |
| Smith,Alice        | Alice      | NULL        | Smith     |
| Johnson,Robert Lee | Robert     | Lee         | Johnson   |
| Alex               | Alex       | NULL        | NULL      |
| White,Sarah        | Sarah      | NULL        | White     |
+--------------------+------------+-------------+-----------+
with cte as (
select *,instr(fullname,',') as comma_position 
,instr(fullname,' ') as space_position
from employee
)
select fullname
, case when comma_position=0 then fullname
when space_position>0 then substr(fullname,comma_position+1,space_position-comma_position-1)
else substr(fullname,comma_position+1,length(fullname)-comma_position)
end as first_name
,case when space_position=0 then null
else substr(fullname,space_position+1,length(fullname)-space_position)
end as middle_name
,case when comma_position=0 then null
else substr(fullname,1,comma_position-1)
end as last_name
from cte;
########################################################################################################################
71 - Department Average Salary

Easy - 10 Points
You are provided with two tables: Employees and Departments. 
The Employees table contains information about employees, including their IDs, names, salaries, and department IDs. 
The Departments table contains information about departments, including their IDs and names. 
Your task is to write a SQL query to find the average salary of employees in each department, but only include departments that have more than 2 employees . 
Display department name and average salary round to 2 decimal places. Sort the result by average salary in descending order.
Tables: Employees
+---------------+-------------+
| COLUMN_NAME   | DATA_TYPE   |
+---------------+-------------+
| employee_id   | int         |
| employee_name | varchar(20) |
| salary        | int         |
| department_id | int         |
+---------------+-------------+
Tables: Departments
+-----------------+-------------+
| COLUMN_NAME     | DATA_TYPE   |
+-----------------+-------------+
| department_id   | int         |
| department_name | varchar(10) |
+-----------------+-------------+
Expected Output
+-----------------+----------------+
| department_name | average_salary |
+-----------------+----------------+
| Finance         |       57000.00 |
| Sales           |       56200.00 |
+-----------------+----------------+
SELECT 
    d.department_name, 
    ROUND(AVG(e.salary), 2) AS average_salary                                       --    Calculate average salary per department rounded to 2 decimals
FROM 
    Employees e
JOIN 
    Departments d ON e.department_id = d.department_id                             --    Join employees with departments using department_id
GROUP BY 
    d.department_name                                                              --    Group results by department name
HAVING COUNT(*) > 2                                                                --    Include only departments with more than 2 employees
ORDER BY average_salary DESC;                                                      --    Order results by average salary in descending order

########################################################################################################################
72 - Product Sales
Easy - 10 Points
You are provided with two tables: Products and Sales. The Products table contains information about various products, 
including their IDs, names, and prices. The Sales table contains data about sales transactions, including the product IDs, 
quantities sold, and dates of sale. Your task is to write a SQL query to find the total sales amount for each product. Display product name and total sales . 
Sort the result by product name.

Table: products
+--------------+-------------+
| COLUMN_NAME  | DATA_TYPE   |
+--------------+-------------+
| product_id   | int         |
| product_name | varchar(10) |
| price        | int         |
+--------------+-------------+
Table: sales
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| sale_id     | int       |
| product_id  | int       |
| quantity    | int       |
| sale_date   | date      |
+-------------+-----------+
Expected Output
+--------------+--------------------+
| product_name | total_sales_amount |
+--------------+--------------------+
| Headphones   |                850 |
| Laptop       |              13600 |
| Smartphone   |               9000 |
| Tablet       |               2800 |
+--------------+--------------------+

SELECT 
    p.product_name, 
    SUM(s.quantity * p.price) AS total_sales_amount                                --    Calculate total sales by multiplying quantity with price and summing
FROM 
    products p
INNER JOIN 
    sales s ON p.product_id = s.product_id                                         --    Join sales with products using product_id
GROUP BY 
    p.product_name                                                                 --    Group results by product name
ORDER BY p.product_name;                                                           --    Order results alphabetically by product name

########################################################################################################################
73 - Category Product Count
You are provided with a table that lists various product categories, each containing a comma-separated list of products. 
Your task is to write a SQL query to count the number of products in each category. Sort the result by product count.
Tables: categories
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| category    | varchar(15) |
| products    | varchar(30) |
+-------------+-------------+
Expected Output
+-------------+---------------+
| category    | product_count |
+-------------+---------------+
| Furniture   |             1 |
| Groceries   |             2 |
| Electronics |             3 |
| Clothing    |             4 |
+-------------+---------------+

SELECT 
        category,
        LENGTH(products) - LENGTH(REPLACE(products, ',', '')) + 1 AS product_count   --    Count number of products by counting commas plus one
    FROM 
        categories
ORDER BY product_count;                                                          --    Order results by product count ascending
########################################################################################################################
74 - Above Average Employees
You are working as a data analyst at a tech company called "TechGuru Inc." that specializes in software development and data science solutions. 
The HR department has tasked you with analyzing the salaries of employees. Your goal is to identify employees who earn above the average salary 
for their respective job title but are not among the top 3 earners within their job title. Consider the sum of base_pay, overtime_pay and other_pay as total salary. 
In case multiple employees have same total salary then ranked them based on higher base pay. Sort the output by total salary in descending order.

Table: employee 
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| emp_id      | int         |
| emp_name    | varchar(20) |
| job_title   | varchar(20) |
+-------------+-------------+
Table: salary 
+--------------+-----------+
| COLUMN_NAME  | DATA_TYPE |
+--------------+-----------+
| emp_id       | int       |
| base_pay     | int       |
| other_pay    | int       |
| overtime_pay | int       |
+--------------+-----------+
Expected Output
+------------------+-------------------+-----------+----------+---------------+
| emp_name         | job_title         | total_pay | base_pay | title_avg_pay |
+------------------+-------------------+-----------+----------+---------------+
| Sophia Wilson    | Data Scientist    |     77700 |    73300 |    75720.0000 |
| William Anderson | Data Scientist    |     76000 |    71000 |    75720.0000 |
| Jane Smith       | Software Engineer |     65000 |    62000 |    64250.0000 |
| Kevin Davis      | Software Engineer |     64700 |    61000 |    64250.0000 |
+------------------+-------------------+-----------+----------+---------------+
with cte as (
select e.emp_name,e.job_title,(base_pay+overtime_pay+other_pay) as total_pay,base_pay
,avg(base_pay+overtime_pay+other_pay) over(partition by e.job_title) as title_avg_pay
, row_number() over(partition by e.job_title order by (base_pay+overtime_pay+other_pay) desc,base_pay desc ) as rn
from employee e 
inner join salary s on e.emp_id=s.emp_id
)
select emp_name,job_title,total_pay,base_pay,title_avg_pay
from cte
where total_pay>title_avg_pay and rn>3
order by  total_pay desc;

########################################################################################################################
75 - Rider Ride Time -- HARD
You are working with Zomato, a food delivery platform, and you need to analyze the performance of 
Zomato riders in terms of the time they spend delivering orders each day. Given the pickup and delivery 
times for each order, your task is to calculate the duration of time spent by each rider on deliveries each day. 
Order the output by rider id and ride date.
Table:orders 
+---------------+-----------+
| COLUMN_NAME   | DATA_TYPE |
+---------------+-----------+
| rider_id      | int       |
| order_id      | int       |
| pickup_time   | datetime  |
| delivery_time | datetime  |
+---------------+-----------+
Expected Output
+----------+------------+----------------+
| rider_id | ride_date  | ride_time_mins |
+----------+------------+----------------+
|      101 | 2024-01-01 |             45 |
|      101 | 2024-01-02 |             15 |
|      101 | 2024-01-03 |             60 |
|      102 | 2024-01-01 |             10 |
|      102 | 2024-01-02 |             40 |
|      102 | 2024-01-03 |             30 |
|      103 | 2024-01-01 |             30 |
|      103 | 2024-01-02 |              1 |
|      103 | 2024-01-03 |             36 |
|      103 | 2024-01-04 |             15 |
+----------+------------+----------------+
with cte as 
(
select order_id,rider_id,CAST(pickup_time AS DATE) as ride_date
,TIMESTAMPDIFF(MINUTE, pickup_time,delivery_time) as ride_time
 from orders
 where CAST(pickup_time AS DATE)=CAST(delivery_time AS DATE)

union all

select order_id,rider_id, CAST(pickup_time AS DATE) as ride_date
,TIMESTAMPDIFF(MINUTE, pickup_time,CAST(delivery_time as DATE)) as ride_time
 from orders
where CAST(pickup_time AS DATE)!=CAST(delivery_time AS DATE)

union all

select order_id,rider_id, CAST(delivery_time AS DATE) as ride_date
,TIMESTAMPDIFF(MINUTE,CAST(delivery_time as DATE), delivery_time) as ride_time
 from orders
where CAST(pickup_time AS DATE)!=CAST(delivery_time AS DATE)
)
select rider_id,ride_date,sum(ride_time) as ride_time_mins
 from cte
where ride_time!=0
group by rider_id,ride_date
order by rider_id,ride_date;
########################################################################################################################
76 - Amazon Notifications -- HARD
Your task is to analyze the effectiveness of Amazons notifications in driving user engagement and conversions, 
considering the user purchase data. A purchase is considered to be associated with a notification if the purchase happens within 
the timeframe of earliest of below 2 events:
1-  2 hours from notification delivered time
2-  Next notification delivered time.
Each notification is sent for a particular product id but a customer may purchase same or another product. 
Considering these rules write an SQL to find number of purchases associated with each notification for same product or 
a different product in 2 separate columns, display the output in ascending order of notification id.
Expected Output
+-----------------+------------------------+-----------------------------+
| notification_id | same_product_purchases | different_product_purchases |
+-----------------+------------------------+-----------------------------+
|               1 |                      1 |                           2 |
|               2 |                      2 |                           0 |
|               3 |                      2 |                           1 |
+-----------------+------------------------+-----------------------------+

Table:notifications
+-----------------+------------+
| COLUMN_NAME     | DATA_TYPE  |
+-----------------+------------+
| notification_id | int        |
| delivered_at    | datetime   |
| product_id      | varchar(2) |
+-----------------+------------+

Table:purchases 
+--------------------+------------+
| COLUMN_NAME        | DATA_TYPE  |
+--------------------+------------+
| product_id         | varchar(2) |
| purchase_timestamp | datetime   |
| user_id            | int        |
+--------------------+------------+

WITH cte AS (
    SELECT * 
         ,CASE 
              WHEN DATE_ADD(delivered_at, INTERVAL 2 HOUR) <= LEAD(delivered_at, 1, '9999-12-31') OVER (ORDER BY notification_id) 
                  THEN DATE_ADD(delivered_at, INTERVAL 2 HOUR)                            --    Calculate valid notification end time as 2 hours after delivery if earlier than next notification
              ELSE LEAD(delivered_at, 1, '9999-12-31') OVER (ORDER BY notification_id)   --    Otherwise use next notification's delivered_at timestamp
          END AS notification_valid_till
    FROM notifications
),
cte2 AS (
    SELECT 
        notification_id,
        p.user_id,
        p.product_id AS purchased_product,
        cte.product_id AS notified_product
    FROM purchases p 
    INNER JOIN cte ON p.purchase_timestamp BETWEEN delivered_at AND notification_valid_till   --    Join purchases made during notification validity period
)
SELECT 
    notification_id,
    SUM(CASE WHEN purchased_product = notified_product THEN 1 ELSE 0 END) AS same_product_purchases    --    Count purchases of notified product
   ,SUM(CASE WHEN purchased_product != notified_product THEN 1 ELSE 0 END) AS different_product_purchases --    Count purchases of different products
FROM cte2
GROUP BY notification_id                                                                                --    Aggregate counts per notification
ORDER BY notification_id;                                                                              --    Order results by notification_id ascending
########################################################################################################################
77 - 2022 vs 2023 vs 2024 Sales --- MEDIUM
You are tasked with analyzing the sales growth of products over the years 2022, 2023, and 2024.
Your goal is to identify months where the sales for a product have consistently increased from 2022 to 2023 and from 2023 to 2024.
Your task is to write an SQL query to generate a report that includes the sales for each product at the month level for the years 
2022, 2023, and 2024. However, you should only include product and months combination where the sales have consistently increased 
from 2022 to 2023 and from 2023 to 2024, display the output in ascending order of product_id.

Table: orders
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| order_id    | int       |
| customer_id | int       |
| order_date  | date      |
| product_id  | int       |
| sales       | int       |
+-------------+-----------+
Expected Output
+------------+-------------+------------+------------+------------+
| product_id | order_month | sales_2022 | sales_2023 | sales_2024 |
+------------+-------------+------------+------------+------------+
|          1 |           2 |        280 |        520 |        730 |
|          2 |           7 |        225 |        325 |        525 |
|          3 |           9 |         90 |        190 |        290 |
+------------+-------------+------------+------------+------------+
with cte as (
select product_id, MONTH(order_date) AS order_month
,YEAR(order_date) AS order_year
,SUM(sales) AS sales
from orders
group by product_id,MONTH(order_date) ,YEAR(order_date)
)
,cte2 as (
select product_id,order_month
, sum(case when order_year='2022' then sales else 0 end) as sales_2022 
, sum(case when order_year='2023' then sales else 0 end) as sales_2023
, sum(case when order_year='2024' then sales else 0 end) as sales_2024
from cte
group by product_id,order_month
)
select * 
from cte2
where sales_2024>sales_2023 and sales_2023>sales_2022
ORDER BY product_id;
########################################################################################################################
78 - Hotel Booking Mistake
Medium - 20 Points
A hotel has accidentally made overbookings for certain rooms on specific dates. Due to this error, some rooms have been assigned to multiple 
customers for overlapping periods, leading to potential conflicts. The hotel management needs to rectify this mistake by contacting the affected 
customers and providing them with alternative arrangements.
Your task is to write an SQL query to identify the overlapping bookings for each room and determine the list of customers affected by these overlaps.
For each room and overlapping date, the query should list the customers who have booked the room for that date. 
A bookings check-out date is not inclusive, meaning that if a room is booked from April 1st to April 4th, it is 
considered occupied from April 1st to April 3rd , another customer can check-in on April 4th and that will not be considered as overlap.

Order the result by room id, booking date. You may use calendar dim table which has all the dates for the year April 2024.
Table : bookings
+----------------+-----------+
| COLUMN_NAME    | DATA_TYPE |
+----------------+-----------+
| room_id        | int       |
| customer_id    | int       |
| check_in_date  | date      |
| check_out_date | date      |
+----------------+-----------+
Table : calendar_dim
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| cal_date    | date      |
+-------------+-----------+
Expected Output
+---------+------------+-----------+
| room_id | book_date  | customers |
+---------+------------+-----------+
|       1 | 2024-04-02 | 101,103   |
|       1 | 2024-04-03 | 101,103   |
|       1 | 2024-04-05 | 103,106   |
|       2 | 2024-04-04 | 102,105   |
+---------+------------+-----------+
with cte as (
select room_id,customer_id,c.cal_date as book_date
from bookings b
inner join calendar_dim c on c.cal_date >= b.check_in_date and c.cal_date < b.check_out_date
)
select room_id,book_date , group_concat(customer_id ORDER BY customer_id)  as customers
from cte 
group by room_id,book_date 
having count(*)>1
order by room_id,book_date ;
########################################################################################################################
79 - Top Products of Top Category -- HARD
You are analyzing sales data from an e-commerce platform, which includes information about orders placed for
various products across different categories. Each order contains details such as the order ID, order date, product ID, category, and amount.
Write an SQL to identify the top 3 products within the top-selling category based on total sales. The top-selling category
is determined by the sum of the amounts sold for all products within that category. Sort the output by products sales in descending order.
Table: orders
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| amount      | int         |
| category    | varchar(20) |
| order_date  | date        |
| order_id    | int         |
| product_id  | int         |
+-------------+-------------+

Expected Output
+------------+-----------+-------------+
| product_id | category  | total_sales |
+------------+-----------+-------------+
|          2 | Furniture |         800 |
|          1 | Furniture |         690 |
|          4 | Furniture |         500 |
+------------+-----------+-------------+
WITH category_sales AS (
    SELECT category, SUM(amount) AS total_sales
    FROM orders
    GROUP BY category
),
ranked_categories AS (
    SELECT category, total_sales,
           RANK() OVER (ORDER BY total_sales DESC) AS category_rank
    FROM category_sales
),
top_category AS (
    SELECT category
    FROM ranked_categories
    WHERE category_rank = 1
)
SELECT o.product_id, o.category, SUM(o.amount) AS total_sales
FROM orders o
JOIN top_category tc ON o.category = tc.category
GROUP BY o.product_id, o.category
ORDER BY total_sales DESC
LIMIT 3;	
########################################################################################################################
80- Rolling Sales -- HARD
Hard - 40 Points
You are tasked with analysing the sales data for products during the month of January 2024. Your goal is to calculate the
rolling sum of sales for each product and each day of Jan 2024, considering the sales for the current day and the two previous days.
Note that for some days, there might not be any sales for certain products, and you need to consider these days as having sales of 0.

You can make use of the calendar table which has the all the dates for Jan-2024.

Tables: orders
+-------------+------------+
| COLUMN_NAME | DATA_TYPE  |
+-------------+------------+
| amount      | int        |
| order_date  | date       |
| order_id    | int        |
| product_id  | varchar(5) |
+-------------+------------+
Tables: calendar_dim
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| cal_date    | date      |
+-------------+-----------+
Expected Output
+------------+------------+-------+--------------+
| product_id | order_date | sales | rolling3_sum |
+------------+------------+-------+--------------+
| p1         | 2024-01-01 |   250 |          250 |
| p1         | 2024-01-02 |     0 |          250 |
| p1         | 2024-01-03 |   120 |          370 |
| p1         | 2024-01-04 |     0 |          120 |
| p1         | 2024-01-05 |   180 |          300 |
| p1         | 2024-01-06 |   110 |          290 |
| p1         | 2024-01-07 |   220 |          510 |
| p1         | 2024-01-08 |     0 |          330 |
| p1         | 2024-01-09 |   190 |          410 |
| p1         | 2024-01-10 |     0 |          190 |
| p1         | 2024-01-11 |   140 |          330 |
| p1         | 2024-01-12 |     0 |          140 |
| p1         | 2024-01-13 |     0 |          140 |
| p1         | 2024-01-14 |     0 |            0 |
| p1         | 2024-01-15 |   210 |          210 |
| p1         | 2024-01-16 |     0 |          210 |
| p1         | 2024-01-17 |     0 |          210 |
| p1         | 2024-01-18 |     0 |            0 |
| p1         | 2024-01-19 |   300 |          300 |
| p1         | 2024-01-20 |     0 |          300 |
| p1         | 2024-01-21 |   230 |          530 |
| p1         | 2024-01-22 |     0 |          230 |
| p1         | 2024-01-23 |   180 |          410 |
| p1         | 2024-01-24 |   240 |          420 |
| p1         | 2024-01-25 |   340 |          760 |
| p1         | 2024-01-26 |     0 |          580 |
| p1         | 2024-01-27 |   250 |          590 |
| p1         | 2024-01-28 |     0 |          250 |
| p1         | 2024-01-29 |   200 |          450 |
| p1         | 2024-01-30 |     0 |          200 |
| p1         | 2024-01-31 |     0 |          200 |
| p2         | 2024-01-01 |     0 |            0 |
| p2         | 2024-01-02 |     0 |            0 |
| p2         | 2024-01-03 |     0 |            0 |
| p2         | 2024-01-04 |   200 |          200 |
| p2         | 2024-01-05 |     0 |          200 |
| p2         | 2024-01-06 |     0 |          200 |
| p2         | 2024-01-07 |     0 |            0 |
| p2         | 2024-01-08 |   130 |          130 |
| p2         | 2024-01-09 |     0 |          130 |
| p2         | 2024-01-10 |   240 |          370 |
| p2         | 2024-01-11 |     0 |          240 |
| p2         | 2024-01-12 |   200 |          440 |
| p2         | 2024-01-13 |   260 |          460 |
| p2         | 2024-01-14 |   150 |          610 |
| p2         | 2024-01-15 |     0 |          410 |
| p2         | 2024-01-16 |   440 |          590 |
| p2         | 2024-01-17 |     0 |          440 |
| p2         | 2024-01-18 |   220 |          660 |
| p2         | 2024-01-19 |     0 |          220 |
| p2         | 2024-01-20 |   170 |          390 |
| p2         | 2024-01-21 |     0 |          170 |
| p2         | 2024-01-22 |   320 |          490 |
| p2         | 2024-01-23 |     0 |          320 |
| p2         | 2024-01-24 |     0 |          320 |
| p2         | 2024-01-25 |     0 |            0 |
| p2         | 2024-01-26 |   190 |          190 |
| p2         | 2024-01-27 |     0 |          190 |
| p2         | 2024-01-28 |   360 |          550 |
| p2         | 2024-01-29 |     0 |          360 |
| p2         | 2024-01-30 |   260 |          620 |
| p2         | 2024-01-31 |     0 |          260 |
+------------+------------+-------+--------------+
with cte as (
select product_id,order_date,sum(amount) as sales
 from orders
group by product_id,order_date
)
, all_products_dates as (
select distinct product_id, cal_date as order_date
from cte 
cross join calendar_dim
)
select a.product_id,a.order_date,coalesce(cte.sales,0) as sales
,sum(coalesce(cte.sales,0)) over(partition by a.product_id order by a.order_date rows between 2 preceding and current row) as rolling3_sum
from all_products_dates a 
left join cte on a.product_id=cte.product_id and a.order_date=cte.order_date
ORDER BY a.product_id , a.order_date;
########################################################################################################################
81 - Consistent Growth
In a financial analysis project, you are tasked with identifying companies that have consistently increased their revenue 
by at least 25% every year. You have a table named revenue that contains information about the revenue of different companies over several years.
Your goal is to find companies whose revenue has increased by at least 25% every year consecutively. So for example 
If a companys revenue has increased by 25% or more for three consecutive years but not for the fourth year, it will not be considered.
Write an SQL query to retrieve the names of companies that meet the criteria mentioned above along with total lifetime revenue , 
display the output in ascending order of company id
Table : revenue 
+-------------+---------------+
| COLUMN_NAME | DATA_TYPE     |
+-------------+---------------+
| company_id  | int           |
| year        | int           |
| revenue     | decimal(10,2) |
+-------------+---------------+
Expected Output
+------------+---------------+
| company_id | total_revenue |
+------------+---------------+
|          1 |     841250.00 |
|          4 |    1860000.00 |
+------------+---------------+

WITH revenue_growth AS (
    SELECT 
        company_id,
        year,
        revenue,
        CASE 
        WHEN revenue >= 1.25 * LAG(revenue,1,0) OVER (PARTITION BY company_id ORDER BY year) THEN 1
            ELSE 0
        END AS revenue_growth_flag
    FROM revenue
)
SELECT company_id, sum(revenue) as total_revenue
FROM revenue_growth
where company_id not in
 (select company_id from revenue_growth where revenue_growth_flag=0)
group by company_id 
ORDER BY company_id;
########################################################################################################################
82 - Child and Parents
You are tasked to determine the mother and fathers name for each child based on the given data. 
The people table provides information about individuals, including their names and genders. 
The relations table specifies parent-child relationships, linking each child (c_id) to their parent (p_id). Each parent is identified by their ID,
and their gender is used to distinguish between mothers (F) and fathers (M).
Write an SQL query to retrieve the names of each child along with the names of their respective mother and father, 
if available. If a child has only one parent listed in the relations table, the query should still include that parent's 
name and leave the other parent's name as NULL. Order the output by child name in ascending order.
Tables: people
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| gender      | char(2)     |
| id          | int         |
| name        | varchar(20) |
+-------------+-------------+
Tables: relations 
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| c_id        | int       |
| p_id        | int       |
+-------------+-----------+
Expected Output
+------------+-------------+-------------+
| child_name | mother_name | father_name |
+------------+-------------+-------------+
| Dimartino  | Hansard     | NULL        |
| Hawbaker   | Days        | Blackston   |
| Keffer     | Hansel      | Canty       |
| Mozingo    | Criss       | Nolf        |
| Waugh      | NULL        | Tong        |
+------------+-------------+-------------+
WITH mother_father AS (
    SELECT r.c_id AS child_id,
           max(p1.name) AS mother_name,
           max(p2.name) AS father_name
    FROM relations r
    LEFT JOIN people p1 ON r.p_id = p1.id AND p1.gender = 'F' -- Join with people table to get mother's name
    LEFT JOIN people p2 ON r.p_id = p2.id AND p2.gender = 'M' -- Join with people table to get father's name
    group by r.c_id
)
SELECT p.name AS child_name,
       mf.mother_name,
       mf.father_name
FROM people p
INNER JOIN mother_father mf ON p.id = mf.child_id
order by child_name;
########################################################################################################################
83 - Unique Daily Purchases
Suppose you are analyzing the purchase history of customers in an e-commerce platform. Your task is to identify customers who 
have bought different products on different dates.
Write an SQL to find customers who have bought different products on different dates, means product purchased on a given day 
is not repeated on any other day by the customer. Also note that for the customer to qualify he should have made purchases on at least 2
distinct dates. Please note that customer can purchase same product more than once on the same day and that doesnt disqualify him. 
Output should contain customer id and number of products bought by the customer in ascending order of userid.
Table: purchase_history 
+--------------+-----------+
| COLUMN_NAME  | DATA_TYPE |
+--------------+-----------+
| userid       | int       |
| productid    | int       |
| purchasedate | date      |
+--------------+-----------+
Expected Output
+--------+--------------+
| userid | cnt_products |
+--------+--------------+
|      1 |            3 |
|      4 |            2 |
+--------+--------------+
with cte as (
select userid,productid,purchasedate
  from purchase_history
group by userid,productid,purchasedate 
)
, cte1 as (
select userid, count(distinct purchasedate) as cnt_dist_date
,count(productid) as cnt_products,count(distinct productid) as cnt_dist_products
from cte 
group by userid
)
select userid, cnt_products
from cte1
where cnt_dist_date>1 and cnt_products=cnt_dist_products
ORDER BY userid;
########################################################################################################################
84 - Uber Commission
In a bustling city, Uber operates a fleet of drivers who provide transportation services to passengers. As part of Ubers policy, drivers are subject to a 
commission deduction from their total earnings. The commission rate is determined based on the average rating received by the driver over their recent trips. 
This ensures that drivers delivering exceptional service are rewarded with lower commission rates, 
while those with lower ratings are subject to higher commission rates. 
Commission Calculation: For the first 3 trips of each driver, a standard commission rate of 24% is applied.
After the first 3 trips, the commission rate is determined based on the average rating of the drivers last 3 trips before the current trip:
If the average rating is between 4.7 and 5 (inclusive), the commission rate is 20%.
If the average rating is between 4.5 and 4.7 (inclusive), the commission rate is 23%.
For any other average rating, the default commission rate remains at 24%.

Write an SQL query to calculate the total earnings for each driver after deducting Ubers commission, 
considering the commission rates as per the given criteria, display the output in ascending order of driver id.

Table: trips 
+-------------+--------------+
| COLUMN_NAME | DATA_TYPE    |
+-------------+--------------+
| trip_id     | int          |
| driver_id   | int          |
| fare        | int          |
| rating      | decimal(3,2) |
+-------------+--------------+

Expected Output
+-----------+----------------+
| driver_id | total_earnings |
+-----------+----------------+
|       101 |       28755.00 |
|       102 |       32840.00 |
|       103 |       40415.00 |
+-----------+----------------+
with cte as (
select *
,row_number() over(partition by driver_id order by trip_id) as trip_number
,avg(rating) over(partition by driver_id order by trip_id rows between 3 preceding and 1 preceding) as avg_last3
 from trips
)
, cte2 as (
select *
, case when trip_number<=3 or avg_last3<=4.5 then 0.24*fare
when avg_last3 <=4.7 then 0.23*fare
else 0.2*fare end as commision  
from cte
)
select driver_id, sum(fare-commision) as total_earnings
from cte2
group by driver_id
ORDER BY driver_id;
########################################################################################################################
85 - Customer Support Metrics
You are working for a customer support team at an e-commerce company. The company provides customer support 
through both web-based chat and mobile app chat. Each conversation between a customer and a support agent is logged in a 
database table named conversation. The table contains information about the sender (customer or agent), the message content,
the order related to the conversation, and other relevant details.
Your task is to analyze the conversation data to extract meaningful insights for improving customer support efficiency.
Write an SQL query to fetch the following information from the conversation table for each order_id and sort the output by order_id.

order_id: The unique identifier of the order related to the conversation.
city_code: The city code where the conversation took place. This is unique to each order_id.
first_agent_message: The timestamp of the first message sent by a support agent in the conversation.
first_customer_message: The timestamp of the first message sent by a customer in the conversation.
num_messages_agent: The total number of messages sent by the support agent in the conversation.
num_messages_customer: The total number of messages sent by the customer in the conversation.
first_message_by: Indicates whether the first message in the conversation was sent by a support agent or a customer.
resolved(0 or 1): Indicates whether the conversation has a message marked as resolution = true, atleast once.
reassigned(0 or 1): Indicates whether the conversation has had interactions by more than one support agent.

Table: conversation 
+------------------+-------------+
| COLUMN_NAME      | DATA_TYPE   |
+------------------+-------------+
| senderDeviceType | varchar(20) |
| customerId       | int         |
| orderId          | varchar(10) |
| resolution       | varchar(10) |
| agentId          | int         |
| messageSentTime  | datetime    |
| cityCode         | varchar(6) |
+------------------+-------------+
Expected Output
+----------+-----------+---------------------+------------------------+--------------------+-----------------------+------------------+----------+------------+
| order_id | city_code | first_agent_message | first_customer_message | num_messages_agent | num_messages_customer | first_message_by | resolved | reassigned |
+----------+-----------+---------------------+------------------------+--------------------+-----------------------+------------------+----------+------------+
| 59528038 | Mysore    | 2019-08-19 07:59:33 | NULL                   |                  1 |                     0 | Agent            |        0 |          0 |
| 59528555 | LOS       | 2019-08-19 08:01:04 | 2019-08-19 08:00:04    |                  1 |                     2 | Customer         |        1 |          0 |
| 59528556 | NYC       | 2019-08-20 10:15:32 | 2019-08-20 10:16:25    |                  1 |                     1 | Agent            |        0 |          1 |
| 59528557 | LA        | 2019-08-21 09:30:18 | 2019-08-21 09:32:05    |                  1 |                     1 | Agent            |        0 |          0 |
+----------+-----------+---------------------+------------------------+--------------------+-----------------------+------------------+----------+------------+

SELECT
        orderId AS order_id,
        cityCode AS city_code,
        MIN(CASE WHEN senderDeviceType = 'Web Agent' THEN messageSentTime END) AS first_agent_message,
        MIN(CASE WHEN senderDeviceType = 'Android Customer' THEN messageSentTime END) AS first_customer_message,
        SUM(CASE WHEN senderDeviceType = 'Web Agent' THEN 1 ELSE 0 END) AS num_messages_agent,
        SUM(CASE WHEN senderDeviceType = 'Android Customer' THEN 1 ELSE 0 END) AS num_messages_customer,
        CASE WHEN MIN(messageSentTime) = MIN(CASE WHEN senderDeviceType = 'Web Agent' THEN messageSentTime END) THEN 'Agent'
             WHEN MIN(messageSentTime) = MIN(CASE WHEN senderDeviceType = 'Android Customer' THEN messageSentTime END) THEN 'Customer' END AS first_message_by,
        MAX(case when resolution='True' then 1 else 0 end) AS resolved,
        CASE WHEN COUNT(DISTINCT agentId) > 1 THEN 1 ELSE 0 END AS reassigned
    FROM
        conversation
    GROUP BY
        orderId,cityCode
    order by orderId;

########################################################################################################################
86 - IPL Away Wins
In the Indian Premier League (IPL), each team plays two matches against every other team: one at their home venue and one at
their opponents venue. We want to identify team combinations where each team wins the away match but loses the home match against the same opponent.
Write an SQL query to find such team combinations, where each team wins at the opponents venue but loses at their own home venue.
Table: Matches
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| away_team   | varchar(10) |
| home_team   | varchar(10) |
| match_id    | int         |
| winner_team | varchar(10) |
+-------------+-------------+
Expected Output
+-------+-------+
| team1 | team2 |
+-------+-------+
| DD    | KKR   |
+-------+-------+
SELECT T1.home_team as team1,T1.away_team as team2
FROM Matches AS T1
JOIN Matches AS T2 ON T1.home_team = T2.away_team AND T1.away_team = T2.home_team
WHERE
 T1.match_id < T2.match_id  and  T1.winner_team = T1.away_team  AND T2.winner_team = T2.away_team;
########################################################################################################################
87 - Leave Approval
You are tasked with writing an SQL query to determine whether a leave request can be approved for each employee based on their available leave balance for 2024.
Employees receive 1.5 leaves at the start of each month, and they may have some balance leaves carried over from the previous year 2023(available in employees table).
A leave request can only be approved if the employee has a sufficient leave balance at the start date of planned leave period. 
Write an SQL to derive a new status column stating if leave request is Approved or Rejected for each leave request. 
Sort the output by request id. Consider the following assumptions:
1- If a leave request is eligible for approval, then it will always be taken by employee and leave balance will be deducted as per the leave period. If the leave is rejected then the balance will not be deducted.
2- A leave will either be fully approved or cancelled. No partial approvals possible.
3- If a weekend is falling between the leave start and end date then do consider them when calculating the leave days, Meaning no exclusion of weekends.
Tables:employees
+-------------------------+-------------+
| COLUMN_NAME             | DATA_TYPE   |
+-------------------------+-------------+
| employee_id             | int         |
| leave_balance_from_2023 | int         |
| name                    | varchar(20) |
+-------------------------+-------------+
Tables:leave_requests
+------------------+-----------+
| COLUMN_NAME      | DATA_TYPE |
+------------------+-----------+
| request_id       | int       |
| employee_id      | int       |
| leave_start_date | date      |
| leave_end_date   | date      |
+------------------+-----------+

Expected Output
+------------+-------------+------------------+----------------+----------+
| request_id | employee_id | leave_start_date | leave_end_date | status   |
+------------+-------------+------------------+----------------+----------+
|          1 |           1 | 2024-01-05       | 2024-01-15     | Rejected |
|          2 |           1 | 2024-01-21       | 2024-01-27     | Rejected |
|          3 |           1 | 2024-02-12       | 2024-02-17     | Approved |
|          4 |           1 | 2024-07-03       | 2024-07-12     | Rejected |
|          5 |           2 | 2024-01-20       | 2024-01-25     | Approved |
|          6 |           2 | 2024-03-20       | 2024-03-30     | Rejected |
|          7 |           2 | 2024-10-05       | 2024-10-12     | Approved |
|          8 |           3 | 2024-01-17       | 2024-01-25     | Rejected |
|          9 |           3 | 2024-10-05       | 2024-10-14     | Approved |
+------------+-------------+------------------+----------------+----------+

WITH recursive cte as (
select lr.*, e.leave_balance_from_2023
,MONTH(leave_start_date) as leave_start_month
, DATEDIFF(leave_end_date ,leave_start_date)+1 as leave_days
,row_number() over(partition by lr.employee_id order by lr.leave_start_date) as rn
 from leave_requests lr 
 inner join employees e on lr.employee_id=e.employee_id
)
, r_cte as (
select request_id,leave_start_date,leave_end_date,employee_id,leave_start_month
,case when leave_balance_from_2023+leave_start_month*1.5 >= leave_days 
then leave_balance_from_2023+leave_start_month*1.5-leave_days
else leave_balance_from_2023+leave_start_month*1.5
 end  as balance_leaves 
, case when leave_balance_from_2023+leave_start_month*1.5 >= leave_days 
then 'Approved' else 'Rejected' end as status
,rn
from cte where rn=1
union all
select cte.request_id,cte.leave_start_date,cte.leave_end_date,cte.employee_id,cte.leave_start_month
,case when r_cte.balance_leaves+(cte.leave_start_month-r_cte.leave_start_month)*1.5 > cte.leave_days
then r_cte.balance_leaves+(cte.leave_start_month-r_cte.leave_start_month)*1.5 - cte.leave_days
else r_cte.balance_leaves+(cte.leave_start_month-r_cte.leave_start_month)*1.5 
end as balance_leaves
,case when r_cte.balance_leaves+(cte.leave_start_month-r_cte.leave_start_month)*1.5 > cte.leave_days
then 'Approved' else 'Rejected' end as status
,cte.rn
from cte 
inner join r_cte on cte.employee_id=r_cte.employee_id 
and cte.rn=r_cte.rn+1
)
select request_id,employee_id,leave_start_date,leave_end_date,status
 from r_cte
order by request_id;
########################################################################################################################
88 - Netflix Device Type (PART-1)
In the Netflix dataset containing information about viewers and their viewing history, devise a query to identify viewers who primarily 
use mobile devices for viewing, but occasionally switch to other devices. Specifically, find viewers who have watched at least 75% of 
their total viewing time on mobile devices but have also used at least one other devices such as tablets or smart TVs for viewing. 
Provide the user ID and the percentage of viewing time spent on mobile devices. Round the result to nearest integer.

Table: viewing_history
+-------------+--------------+
| COLUMN_NAME | DATA_TYPE    |
+-------------+--------------+
| user_id     | int          |
| title       | varchar(20)  |
| device_type | varchar(10)  |
| watch_mins  | int          |
+-------------+--------------+
Expected Output
+---------+------------------------+
| user_id | mobile_percentage_view |
+---------+------------------------+
|       2 |                     78 |
+---------+------------------------+
with cte as (
select user_id, count(distinct device_type) as cnt_device
, sum(case when device_type='Mobile' then watch_mins end) as mobile_watch_mins
,sum(watch_mins) as total_watch_mins
from viewing_history 
group by user_id
)
select user_id,ROUND( mobile_watch_mins*100.0/total_watch_mins ,0 ) as mobile_percentage_view
 from cte 
where cnt_device >=2 
and (mobile_watch_mins*1.0/total_watch_mins) > 0.75;
########################################################################################################################
89 - Netflix Device Type (PART-2)
In the Netflix viewing history dataset, you are tasked with identifying viewers who have a consistent viewing pattern across
multiple devices. Specifically, viewers who have watched the same title on more than 1 device type. 
Write an SQL query to find users who have watched more number of titles on multiple devices than the number of titles 
they watched on single device. Output the user id , no of titles watched on multiple devices and no of titles watched on single device, 
display the output in ascending order of user_id.

Table:viewing_history
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| user_id     | int         |
| title       | varchar(20) |
| device_type | varchar(10) |
+-------------+-------------+
Expected Output
+---------+---------------------+-------------------+
| user_id | multiple_device_cnt | single_device_cnt |
+---------+---------------------+-------------------+
|       1 |                   2 |                 1 |
|       3 |                   1 |                 0 |
+---------+---------------------+-------------------+
with cte as (
select user_id,title,count(device_type) as cnt_device_type
from viewing_history 
group by user_id,title
)
, cte2 as (
select user_id
,sum(case when cnt_device_type>1 then 1 else 0 end) as multiple_device_cnt
,sum(case when cnt_device_type=1 then 1 else 0 end) as single_device_cnt
from cte 
group by user_id
)
select * 
from cte2
where multiple_device_cnt>single_device_cnt
ORDER BY user_id ;

########################################################################################################################
90 - Calculate Customer Interest
You are tasked with analyzing the interest earned by customers based on their account balances and transaction history. 
Each customers account accrues interest based on their balance and prevailing interest rates. The interest is calculated for the ending balance 
on each day. Your goal is to determine the total interest earned by each customer for the month of March-2024. 
The interest rates (per day) are given in the interest table as per the balance amount range. 
Please assume that the account balance for each customer was 0 at the start of March 2024.  
Write an SQL to calculate interest earned by each customer from March 1st 2024 to March 31st 2024, display the output in ascending order of customer id.

Table: transactions
+------------------+-----------+
| COLUMN_NAME      | DATA_TYPE |
+------------------+-----------+
| transaction_id   | int       |
| customer_id      | int       |
| transaction_date | date      |
| amount           | int       |
+------------------+-----------+
Table: interestrates
+---------------+--------------+
| COLUMN_NAME   | DATA_TYPE    |
+---------------+--------------+
| rate_id       | int          |
| max_balance   | int          |
| min_balance   | int          |
| interest_rate | decimal(5,4) |
+---------------+--------------+
Expected Output
+-------------+-----------------+
| customer_id | interest_earned |
+-------------+-----------------+
|           1 |        734.0000 |
|           2 |        548.0000 |
|           3 |       1650.0000 |
+-------------+-----------------+
WITH cte AS (
    SELECT 
        customer_id,
        transaction_date,
        SUM(sum(amount)) OVER (PARTITION BY customer_id ORDER BY transaction_date) AS net_amount
    FROM transactions
group by customer_id,transaction_date
),

cte2 AS (
    SELECT 
        customer_id,
        transaction_date,
        net_amount,
        LEAD(transaction_date, 1, '2024-04-01') OVER (PARTITION BY customer_id ORDER BY transaction_date) AS next_trans_date
    FROM cte
)

SELECT 
    cte2.customer_id,
    SUM(
        DATEDIFF(next_trans_date, transaction_date) * net_amount * ir.interest_rate
    ) AS interest_earned
FROM cte2
INNER JOIN InterestRates ir 
    ON cte2.net_amount BETWEEN ir.min_balance AND ir.max_balance
GROUP BY cte2.customer_id
ORDER BY cte2.customer_id;

########################################################################################################################
91 - Election Winner
You are provided with election data from multiple districts in India. Each district conducted elections for
selecting a representative from various political parties. 
Your task is to analyze the election results to determine the winning party at national levels.  Here are the steps to identify winner:
1- Determine the winning party in each district based on the candidate with the highest number of votes.
2- If multiple candidates from different parties have the same highest number of votes in a district
  , consider it a tie, and all tied candidates are declared winners for that district.
3- Calculate the total number of seats won by each party across all districts
4- A party wins the election if it secures more than 50% of the total seats available nationwide.
Display the total number of seats won by each party and a result column specifying Winner or Loser. Order the output by total seats won in descending order.

Table: elections
+---------------+-------------+
| COLUMN_NAME   | DATA_TYPE   |
+---------------+-------------+
| district_name | varchar(20) |
| candidate_id  | int         |
| party_name    | varchar(10) |
| votes         | int         |
+---------------+-------------+

Expected Output
+------------+-----------+--------+
| party_name | seats_won | result |
+------------+-----------+--------+
| BJP        |         7 | Winner |
| Congress   |         3 | Loser  |
| AAP        |         1 | Loser  |
+------------+-----------+--------+

with cte as (
select * 
, rank() over(partition by district_name order by votes desc) as rn
from elections
)
, cte_total_seats as (
select count(distinct district_name) as total_seats from elections
)
select party_name, count(*) as seats_won
, case when count(*)>total_seats*0.5 then 'Winner' else 'Loser' end as result
from cte , cte_total_seats
where rn=1
group by party_name,total_seats
order by seats_won desc;
########################################################################################################################
92 - Eat and Win
A pizza eating competition is organized. All the participants are organized into different groups. 
In a contest , A participant who eat the most pieces of pizza is the winner and recieves their original bet plus 30% of 
all losing participants bets. In case of a tie all winning participants will get equal share (of 30%) divided among them .Return the winning participants names for each group and amount of their payout(round to 2 decimal places) . ordered ascending by group_id , participant_name.

Expected Output
+----------+------------------+--------------+
| group_id | participant_name | total_payout |
+----------+------------------+--------------+
|        1 | Bob              |        54.60 |
|        1 | Eve              |        42.60 |
|        2 | Charlie          |        67.20 |
|        2 | David            |        79.20 |
|        2 | Mike             |        61.20 |
|        3 | Grace            |        96.60 |
|        4 | Ivy              |       190.20 |
+----------+------------------+--------------+
	
Tables: Competition
+------------------+-------------+
| COLUMN_NAME      | DATA_TYPE   |
+------------------+-------------+
| group_id         | int         |
| participant_name | varchar(10) |
| slice_count      | int         |
| bet              | int         |
+------------------+-------------+
with cte as (
select *
, rank() over(partition by group_id order by slice_count desc) as rn
from Competition
)
, cte2 as 
(
select group_id
,sum(case when rn=1 then 1 else 0 end) as no_of_winners
,sum(case when rn>1 then bet else 0 end)*0.3 as losers_bet 
from cte 
group by group_id
)
select cte.group_id,cte.participant_name
,round(cte.bet+ (cte2.losers_bet)/cte2.no_of_winners,2) as total_payout 
from cte
inner join cte2 on cte.group_id=cte2.group_id
where cte.rn=1
order by cte.group_id,cte.participant_name;
########################################################################################################################
93 - OTT Viewership
You have a table named ott_viewership. Write an SQL query to find the top 2 most-watched shows in each genre in the 
United States. Return the show name, genre, and total duration watched for each of the top 2 most-watched shows in each genre. 
sort the result by genre and total duration.
Tables: ott_viewership
+--------------+-------------+
| COLUMN_NAME  | DATA_TYPE   |
+--------------+-------------+
| viewer_id    | int         |
| show_id      | int         |
| show_name    | varchar(20) |
| genre        | varchar(10) |
| country      | varchar(15) |
| view_date    | date        |
| duration_min | int         |
+--------------+-------------+
Expected Output
+-----------------+---------+----------------+
| show_name       | genre   | total_duration |
+-----------------+---------+----------------+
| Friends         | Comedy  |             60 |
| The Office      | Comedy  |             70 |
| Breaking Bad    | Drama   |            110 |
| Stranger Things | Drama   |            115 |
| Game of Thrones | Fantasy |            105 |
| The Witcher     | Fantasy |            115 |
| The Mandalorian | Sci-Fi  |             85 |
+-----------------+---------+----------------+
WITH RankedShows AS (
    SELECT show_name, genre, SUM(duration_min) AS total_duration,
           ROW_NUMBER() OVER (PARTITION BY genre ORDER BY SUM(duration_min) DESC) AS rn
    FROM ott_viewership
    WHERE country = 'United States'
    GROUP BY show_name, genre
)
SELECT show_name, genre, total_duration
FROM RankedShows
WHERE rn <= 2
ORDER BY genre,total_duration;
########################################################################################################################
94 - GAP Sales
You have a table called gap_sales. Write an SQL query to find the total sales for each category in each store for the Q2(April-June) of  2023. 
Return the store ID, category name, and total sales for each category in each store. Sort the result by total sales in ascending order.

Tables: gap_sales
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| sale_id     | int         |
| store_id    | int         |
| sale_date   | date        |
| category    | varchar(10) |
| total_sales | int         |
+-------------+-------------+
Expected Output
+----------+-----------+-------------+
| store_id | category  | total_sales |
+----------+-----------+-------------+
|      103 | Outerwear |        3000 |
|      101 | Outerwear |        6000 |
|      101 | Clothing  |        7500 |
|      102 | Outerwear |        7500 |
|      102 | Clothing  |       16000 |
|      103 | Clothing  |       18500 |
+----------+-----------+-------------+
SELECT store_id, category, SUM(total_sales) AS total_sales
FROM gap_sales
WHERE YEAR(sale_date) = 2023 AND MONTH(sale_date) in (4,5,6)
GROUP BY store_id, category
ORDER BY total_sales;
########################################################################################################################
95 - Electronics Items Sale
You have a table called electronic_items. Write an SQL query to find the average price of electronic items in each category, 
considering only categories where the average price exceeds 500 and at least 20 total quantity of items is available.
Additionally, only include items with a warranty period of 12 months or more. Return the category name along with the average price 
of items in that category. Order the result by average price (round to 2 decimal places) in descending order.

Tables: electronic_items
+-----------------+--------------+
| COLUMN_NAME     | DATA_TYPE    |
+-----------------+--------------+
| item_id         | int          |
| item_name       | varchar(20)  |
| category        | varchar(15)  |
| price           | decimal(5,1) |
| quantity        | int          |
| warranty_months | int          |
+-----------------+--------------+

Expected Output
+----------+---------------+
| category | average_price |
+----------+---------------+
| Cameras  |        800.00 |
| Phones   |        700.00 |
+----------+---------------+
SELECT category, round(AVG(price),2) AS average_price
FROM electronic_items
WHERE warranty_months >= 12
GROUP BY category
HAVING AVG(price) > 500 AND SUM(quantity) >= 20
ORDER BY average_price DESC;
########################################################################################################################
96 - Busiest Airline Route
You are given a table named "tickets" containing information about airline tickets sold. 
Write an SQL query to find the busiest route based on the total number of tickets sold. Also display total ticket count for that route.
oneway_round ='O' -> One Way Trip 
oneway_round ='R' -> Round Trip 
Note: DEL -> BOM is different route from BOM -> DEL
Tables: tickets
+----------------+-------------+
| COLUMN_NAME    | DATA_TYPE   |
+----------------+-------------+
| airline_number | varchar(10) |
| origin         | varchar(3)  |
| destination    | varchar(3)  |
| oneway_round   | char(1)     |
| ticket_count   | int         |
+----------------+-------------+
Expected Output
+--------+-------------+------+
| origin | destination | tc   |
+--------+-------------+------+
| DEL    | NYC         |  350 |
+--------+-------------+------+
select origin,destination, SUM(ticket_count) as tc
 from (select origin,destination,ticket_count
 from tickets
 union all
  select destination,origin,ticket_count
 from tickets
 where oneway_round='R') A
 group by origin,destination
 order by tc desc	
 LIMIT 1;
########################################################################################################################
97 - Domain Names
Write an SQL query to extract the domain names from email addresses stored in the Customers table.
Tables: Customers
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| CustomerID  | int         |
| Email       | varchar(25) |
+-------------+-------------+
Expected Output
+------------------------+---------------+
| Email                  | domain_name   |
+------------------------+---------------+
| john@gmail.com         | gmail.com     |
| jane.doe@yahoo.org     | yahoo.org     |
| alice.smith@amazon.net | amazon.net    |
| bob@gmail.com          | gmail.com     |
| charlie@microsoft.com  | microsoft.com |
+------------------------+---------------+
SELECT 
    Email,
    SUBSTRING(Email, INSTR(Email, '@') + 1) AS domain_name
FROM Customers;
########################################################################################################################
98 - Credit Card Transactions (Part-2)
You are given a history of credit card transaction data for the people of India across cities as below.
Your task is to find out highest spend card type and lowest spent card type for each city, display the output in ascending order of city.

Table: credit_card_transactions
+------------------+-------------+
| COLUMN_NAME      | DATA_TYPE   |
+------------------+-------------+
| transaction_id   | int         |
| city             | varchar(10) |
| transaction_date | date        |
| card_type        | varchar(12) |
| gender           | varchar(1)  |
| amount           | int         |
+------------------+-------------+
Expected Output
+-----------+----------------------+---------------------+
| city      | highest_expense_type | lowest_expense_type |
+-----------+----------------------+---------------------+
| Bengaluru | Platinum             | Silver              |
| Delhi     | Gold                 | Platinum            |
| Mumbai    | Platinum             | Gold                |
+-----------+----------------------+---------------------+
with cte as (
select city,card_type,sum(amount) as total_spend 
from credit_card_transactions
group by city,card_type
)
,cte2 as (
select *
,rank() over(partition by city order by total_spend desc) rn_high
,rank() over(partition by city order by total_spend) rn_low
from cte
)
select city
, max(case when rn_high=1 then card_type end) as highest_expense_type
, max(case when rn_low=1 then card_type end) as lowest_expense_type
from cte2
where rn_high=1 or rn_low=1
group by city
ORDER BY city;
########################################################################################################################
99 - Most Visited Floor
You are a facilities manager at a corporate office building, responsible for tracking employee visits, floor preferences, and resource usage 
within the premises. The office building has multiple floors, each equipped with various resources such as desks, computers, monitors, and other office supplies.
You have a database table “entries” that stores information about employee visits to the office building. Each record in the table represents a visit by an employee
and includes details such as their name, the floor they visited, and the resources they used during their visit.
Write an SQL query to retrieve the total visits, most visited floor, and resources used by each employee, display the output in ascending order of employee name.

Table : entries
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| emp_name    | varchar(10) |
| address     | varchar(10) |
| floor       | int         |
| resources   | varchar(10) |
+-------------+-------------+
Expected Output
+----------+--------------+--------------------+-----------------+
| emp_name | total_visits | most_visited_floor | resources_used  |
+----------+--------------+--------------------+-----------------+
| Ankit    |            3 |                  1 | CPU,DESKTOP     |
| Bikaas   |            3 |                  2 | DESKTOP,MONITOR |
+----------+--------------+--------------------+-----------------+
with cte_resources as (
select emp_name ,count(*) as total_visits ,group_concat(distinct resources) as resources_used
from entries
group by emp_name
),
floor_visits as (
select emp_name,floor,count(*) as no_of_floor_visits
,row_number() over(partition by emp_name order by count(*) desc) as rn
from entries
group by emp_name,floor
)
select fv.emp_name,r.total_visits,fv.floor as most_visited_floor,r.resources_used
from floor_visits fv 
inner join cte_resources r on fv.emp_name=r.emp_name
where rn=1
ORDER BY emp_name ;

########################################################################################################################
100 - Loyal Customers
In the domain of retail analytics, understanding customer behavior is crucial for
driving business growth and enhancing customer satisfaction. One essential aspect is identifying customers 
who have purchased all available products, as they exhibit strong engagement with the product offerings and represent potential loyal customers.
Write an SQL to identify customers who have bought all the products available in products table along with total revenue generated by them. 
Sort the output by total revenue in decreasing order.
Table:customers
+---------------+-------------+
| COLUMN_NAME   | DATA_TYPE   |
+---------------+-------------+
| customer_id   | int         |
| customer_name | varchar(15) |
+---------------+-------------+

Table:products
+--------------+-------------+
| COLUMN_NAME  | DATA_TYPE   |
+--------------+-------------+
| product_id   | int         |
| product_name | varchar(10) |
| unit_price   | int         |
+--------------+-------------+

Table:orders
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| order_id    | int       |
| customer_id | int       |
| product_id  | int       |
| quantity    | int       |
| order_date  | date      |
+-------------+-----------+
Expected Output
+---------------+---------------+
| customer_name | total_revenue |
+---------------+---------------+
| Alice Johnson |          1250 |
| Somnath       |          1150 |
+---------------+---------------+
select c.customer_name, sum(o.quantity*p.unit_price) as total_revenue
 from orders o
 inner join customers c on o.customer_id=c.customer_id
 inner join products p on o.product_id=p.product_id
 group by c.customer_name having count(distinct o.product_id)=(select count(*) from products)
 order by total_revenue desc;
########################################################################################################################
101 - Email Response Rate
Given a sample table with emails sent vs. received by the users, calculate the response rate (%) which is given as emails sent/ emails received. 
For simplicity consider sent emails are delivered. List all the users that fall under the top 25 percent based on the highest response rate.
Please consider users who have sent at least one email and have received at least one email.

Table : gmail_data
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| from_user   | varchar(20) |
| to_user     | varchar(20) |
| email_day   | date        |
+-------------+-------------+
Expected Output
+--------------------+---------------+
| user_id            | response_rate |
+--------------------+---------------+
| 6edf0be4b2267df1fa |     500.00000 |
| 32ded68d89443e808  |     400.00000 |
| 75d295377a46f83236 |     350.00000 |
+--------------------+---------------+
WITH sent_emails as (
  SELECT
    from_user,
    COUNT(*) as emails_sent
  FROM
    gmail_data g1
  GROUP BY 1
),
received_emails as (
  SELECT
    to_user,
    COUNT(*) as emails_received
  FROM
    gmail_data g2
  GROUP BY 1
),
summarized_view as (
  SELECT
    from_user as user_id,
    (emails_sent * 100.0 / emails_received) as response_rate,
    ntile(4) OVER (ORDER BY (emails_sent * 1.0 / emails_received) desc) as quartile
  FROM
    sent_emails
    inner JOIN received_emails on sent_emails.from_user = received_emails.to_user
)
SELECT
  user_id,
  response_rate
FROM
  summarized_view
WHERE quartile=1  ;

########################################################################################################################
102 - Users With Valid Passwords
Write a SQL query to identify the users with valid passwords according to the conditions below.
The password must be at least 8 characters long.
The password must contain at least one letter (lowercase or uppercase).
The password must contain at least one digit (0-9).
The password must contain at least one special character from the set @#$%^&*.
The password must not contain any spaces.

Table: user_passwords 
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| user_id     | int         |    
| user_name   | varchar(10) |
| password    | varchar(20) |
+-------------+-------------+
Expected Output
+---------+-----------+
| user_id | user_name |
+---------+-----------+
|       1 | Arjun     |
|       3 | Sneha     |
|       4 | Vikram    |
|       5 | Priya     |
|       7 | Neha      |
+---------+-----------+
SELECT user_id, user_name
FROM user_passwords
WHERE 
LENGTH(Password) >= 8 AND  -- At least 8 characters long
    Password REGEXP '[A-Za-z]' AND  -- Contains at least one letter
    Password REGEXP '[0-9]' AND  -- Contains at least one digit
    Password REGEXP '[@#$%^&*]' AND  -- Contains at least one special character
    Password NOT LIKE '% %';  -- Does not contain spaces
########################################################################################################################
103 - Employee Mentor
You are given a table Employees that contains information about employees in a company. 
Each employee might have been mentored by another employee. Your task is to find the names of all employees who were not mentored by the employee with id = 3.
Table: employees 
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| id          | int         |    
| name        | varchar(10) |
| mentor_id   | int         |
+-------------+-------------+
Expected Output
+--------+
| name   |
+--------+
| Arjun  |
| Sneha  |
| Vikram |
| Priya  |
| Rohan  |
| Amit   |
+--------+
	
SELECT name
FROM Employees
WHERE mentor_id != 3      --    Select employees whose mentor_id is not 3
   OR mentor_id IS NULL;  --    Also include employees with no mentor assigned (NULL)

########################################################################################################################
104 - Seasonal Trends
Youre working for a retail company that sells various products. The company wants to identify seasonal trends in sales for its top-selling 
products across different regions. They are particularly interested in understanding the variation in sales volume across seasons for these products.
For each top-selling product in each region, calculate the total quantity sold for each season (spring, summer, autumn, winter) in 2023, 
display the output in ascending order of region name, product name & season name.

Table: products
+--------------+-------------+
| COLUMN_NAME  | DATA_TYPE   |
+--------------+-------------+
| product_id   | int         |
| product_name | varchar(10) |
+--------------+-------------+
Table: sales
+---------------+-------------+
| COLUMN_NAME   | DATA_TYPE   |
+---------------+-------------+
| sale_id       | int         |
| product_id    | int         |
| region_name   | varchar(20) |
| sale_date     | date        |
| quantity_sold | int         |
+---------------+-------------+
Table: seasons
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| start_date  | date        |
| end_date    | date        |
| season_name | varchar(10) |
+-------------+-------------+
Expected Output
+---------------+--------------+-------------+---------------------+
| region_name   | product_name | season_name | total_quantity_sold |
+---------------+--------------+-------------+---------------------+
| Asia          | Oranges      | Autumn      |                1150 |
| Asia          | Oranges      | Spring      |                 620 |
| Asia          | Oranges      | Summer      |                 730 |
| Asia          | Oranges      | Winter      |                 460 |
| Europe        | Bananas      | Autumn      |                 680 |
| Europe        | Bananas      | Spring      |                 330 |
| Europe        | Bananas      | Summer      |                 450 |
| Europe        | Bananas      | Winter      |                 220 |
| North America | Apples       | Autumn      |                 930 |
| North America | Apples       | Spring      |                 420 |
| North America | Apples       | Summer      |                 620 |
| North America | Apples       | Winter      |                 450 |
+---------------+--------------+-------------+---------------------+
WITH top_selling_per_region AS (
    SELECT
        s.region_name,
        p.product_name,
        SUM(s.quantity_sold) AS total_quantity_sold,
        ROW_NUMBER() OVER(PARTITION BY s.region_name ORDER BY SUM(s.quantity_sold) DESC) AS rn
    FROM
        sales s
    JOIN
        products p ON s.product_id = p.product_id
    GROUP BY
        s.region_name, p.product_name
)
SELECT
    ts.region_name,
    ts.product_name,
    ss.season_name,
    SUM(s.quantity_sold) AS total_quantity_sold
FROM
    sales s
JOIN
    products p ON s.product_id = p.product_id
JOIN
    top_selling_per_region ts ON s.region_name = ts.region_name AND p.product_name = ts.product_name
JOIN
    seasons ss ON s.sale_date BETWEEN ss.start_date AND ss.end_date
WHERE
    ts.rn = 1 -- Select only top-selling product per region
GROUP BY
    ts.region_name, ts.product_name, ss.season_name
ORDER BY
    ts.region_name, ts.product_name, ss.season_name;
+---------------+--------------+-------------+---------------------+
| region_name   | product_name | season_name | total_quantity_sold |
+---------------+--------------+-------------+---------------------+
| Asia          | Oranges      | Autumn      |                1150 |
| Asia          | Oranges      | Spring      |                 620 |
| Asia          | Oranges      | Summer      |                 730 |
| Asia          | Oranges      | Winter      |                 460 |
| Europe        | Bananas      | Autumn      |                 680 |
| Europe        | Bananas      | Spring      |                 330 |
| Europe        | Bananas      | Summer      |                 450 |
| Europe        | Bananas      | Winter      |                 220 |
| North America | Apples       | Autumn      |                 930 |
| North America | Apples       | Spring      |                 420 |
| North America | Apples       | Summer      |                 620 |
| North America | Apples       | Winter      |                 450 |
+---------------+--------------+-------------+---------------------+

########################################################################################################################
105 - Student Major Subject
You are provided with information about students enrolled in various courses at a university. Each student can be enrolled in multiple courses, and for each course, it is specified whether the course is a major or an elective for the student.
Write a SQL query to generate a report that lists the primary (major_flag='Y') course for each student. If a student is enrolled in only one course, that course should be considered their primary course by default irrespective of the flag. Sort the output by student_id.

 
Expected Output
+------------+-----------+
| student_id | course_id |
+------------+-----------+
|          1 |       101 |
|          2 |       101 |
|          3 |       103 |
|          4 |       103 |
|          5 |       104 |
+------------+-----------+

Table: student_courses
+-------------+------------+
| COLUMN_NAME | DATA_TYPE  |
+-------------+------------+
| student_id  | int        |
| course_id   | int        |
| major_flag  | varchar(1) |
+-------------+------------+

Expected Output
+------------+-----------+
| student_id | course_id |
+------------+-----------+
|          1 |       101 |
|          2 |       101 |
|          3 |       103 |
|          4 |       103 |
|          5 |       104 |
+------------+-----------+
SELECT student_id, course_id
FROM student_courses
WHERE major_flag = 'Y'
   OR student_id IN (
       SELECT student_id 
       FROM student_courses 
       GROUP BY student_id 
       HAVING COUNT(*) = 1
   );
########################################################################################################################
106 - Subject Average Score
Easy - 10 Points
Write an SQL query to find the course names where the average score (calculated only for students who have scored less than 70 in at least one course) 
is greater than 70. Sort the result by the average score in descending order.

Table: students
+-------------+------------+
| COLUMN_NAME | DATA_TYPE  |
+-------------+------------+
| student_id  | int        |
| course_name | VARCHAR(10)|
| score       | int        |
+-------------+------------+
Expected Output
+-------------+-----------+
| course_name | avg_score |
+-------------+-----------+
| History     |   87.0000 |
| Science     |   71.0000 |
+-------------+-----------+
SELECT course_name,AVG(score) as avg_score
FROM students
WHERE student_id IN (
    SELECT DISTINCT student_id
    FROM students
    WHERE score < 70
)
GROUP BY course_name
HAVING AVG(score) > 70
order by avg_score desc
;
########################################################################################################################
107 - Contiguous Ranges
Write an SQL query to find all the contiguous ranges of log_id values.
Table: logs
+-------------+------------+
| COLUMN_NAME | DATA_TYPE  |
+-------------+------------+
| log_id      | int        |
+-------------+------------+
Expected Output
+----------+--------+
| start_id | end_id |
+----------+--------+
|        1 |      3 |
|        7 |      8 |
|       10 |     10 |
|       12 |     16 |
|       20 |     20 |
+----------+--------+
WITH numbered_logs AS (
    SELECT 
        log_id,
        log_id - ROW_NUMBER() OVER (ORDER BY log_id) AS grp
    FROM 
        logs
)
SELECT 
    MIN(log_id) AS start_id, 
    MAX(log_id) AS end_id
FROM 
    numbered_logs
GROUP BY 
    grp
ORDER BY 
    start_id;
########################################################################################################################
108 - Products Sold in All Cities
A technology company operates in several major cities across India, selling a variety of tech products. 
The company wants to analyze its sales data to understand which products have been successfully sold in all the cities where 
they operate(available in cities table).
Write an SQL query to identify the product names that have been sold at least 2 times in every city where the company operates.

Table: products
+-------------+------------+
| COLUMN_NAME | DATA_TYPE  |
+-------------+------------+
| product_id  | int        |
| product_name| VARCHAR(12)|
+-------------+------------+
Table: cities
+-------------+------------+
| COLUMN_NAME | DATA_TYPE  |
+-------------+------------+
| city_id     | int        |
| city_name   | VARCHAR(10)|
+-------------+------------+
Table: sales
+-------------+------------+
| COLUMN_NAME | DATA_TYPE  |
+-------------+------------+
| sale_id     | int        |
| product_id  | int        |
| city_id     | int        |
| sale_date   | VARCHAR(12)|
| quantity    | int        |
+-------------+------------+

Expected Output
+--------------+
| product_name |
+--------------+
| Headphones   |
| Laptop       |
| Smartwatch   |
+--------------+

WITH product_sales AS (
    SELECT product_id, city_id
    FROM sales
    GROUP BY product_id, city_id
	having COUNT(*) >= 2
)
    SELECT  p.product_name
    FROM products p
    JOIN product_sales ps ON p.product_id = ps.product_id
	group by p.product_name
    HAVING COUNT(DISTINCT ps.city_id) = (SELECT COUNT(*) FROM cities);

########################################################################################################################
109 - Top 5 Single-Purchase Spendings
Write an SQL to retrieve the top 5 customers who have spent the most on their single purchase. Sort the result by max single purchase in descending order.

Table: purchase
+-------------+------------+
|COLUMN_NAME  | DATA_TYPE  |
+-------------+------------+
|customer_id  | int        |
|purchase_date| date       |
|amount       | int        |
+-------------+------------+

Expected Output
+-------------+------------+
| customer_id | max_amount |
+-------------+------------+
|           5 |       6000 |
|           7 |       5400 |
|          10 |       5100 |
|           2 |       5000 |
|           8 |       4400 |
+-------------+------------+
SELECT customer_id, MAX(amount) AS max_amount
FROM purchase
GROUP BY customer_id
ORDER BY max_amount DESC
LIMIT 5;
########################################################################################################################
110 - Laptop to Laptop Bag Conversion Rate
The marketing team at a retail company wants to analyze customer purchasing behavior. They are particularly interested in understanding
how many customers who bought a laptop later went on to purchase a laptop bag, with no intermediate purchases in between. 
Write an SQL to get number of customer in each country who bought laptop and number of customers who bought laptop bag just after buying a laptop.
Order the result by country.
Table: transactions
+----------------------+------------+
| COLUMN_NAME          | DATA_TYPE  |
+----------------------+------------+
| transaction_id       | int        |
| customer_id          | date       |
| product_name         | varchar(10)|
| transaction_timestamp| datetime   |
| country              | varchar(5) |
+----------------------+------------+
Expected Output
+---------+------------------+----------------------+
| country | laptop_customers | laptop_bag_customers |
+---------+------------------+----------------------+
| India   |                3 |                    2 |
| UK      |                3 |                    2 |
| USA     |                3 |                    1 |
+---------+------------------+----------------------+

WITH RankedPurchases AS (
    SELECT
        customer_id,
        product_name,
        transaction_timestamp,
        country,
        LEAD(product_name) OVER (PARTITION BY customer_id, country ORDER BY transaction_timestamp) AS next_product
    FROM transactions
)
SELECT
    country,
    COUNT(DISTINCT CASE WHEN product_name = 'Laptop' THEN customer_id END) AS laptop_customers,
    COUNT(DISTINCT CASE WHEN product_name = 'Laptop' AND next_product = 'Laptop Bag' THEN customer_id END) AS laptop_bag_customers
FROM RankedPurchases
GROUP BY country
ORDER BY country;
########################################################################################################################
111 - Hierarchy Reportee Count
Write a SQL query to find the number of reportees (both direct and indirect) under each manager. The output should include:
m_id: The manager ID.
num_of_reportees: The total number of unique reportees (both direct and indirect) under that manager.
Order the result by number of reportees in descending order.
Table: hierarchy
+-------------+------------+
|COLUMN_NAME  | DATA_TYPE  |
+-------------+------------+
| e_id        | int        |
| m_id        | int        |
+-------------+------------+	
+------+------------------+
| m_id | num_of_reportees |
+------+------------------+
| F    |               10 |
| E    |                3 |
| C    |                2 |
| I    |                2 |
| G    |                1 |
+------+------------------+
WITH RECURSIVE ReporteesCTE AS (
    -- Anchor member: Get the immediate reportees
    SELECT 
        m_id AS manager_id, 
        e_id AS employee_id
    FROM 
        hierarchy
    
    UNION ALL
    
    -- Recursive part: Get the reportees of the reportees
    SELECT 
        h.m_id AS manager_id, 
        r.employee_id
    FROM 
        hierarchy h
    JOIN 
        ReporteesCTE r ON h.e_id = r.manager_id
)

-- Count the number of reportees under each manager
SELECT 
    manager_id AS m_id,
    COUNT(DISTINCT employee_id) AS num_of_reportees
FROM 
    ReporteesCTE
GROUP BY 
    manager_id
ORDER BY 
    num_of_reportees desc;

########################################################################################################################
112 - Reel Daily View Averages by State
Meta (formerly Facebook) is analyzing the performance of Instagram Reels across different states in the USA.
You have access to a table named REEL that tracks the cumulative views of each reel over time. Write an SQL to get average daily views 
for each Instagram Reel in each state. Round the average to 2 decimal places and sort the result by average is descending order. 

Table: reel 
+-----------------+----------+
| COLUMN_NAME     | DATA_TYPE|
+-----------------+----------+
| reel_id         | int      |    
| record_date     | date     |
| state           | varchar  |
| cumulative_views| int      |
+-------------+--------------+
Expected Output
+---------+------------+-----------------+
| Reel_id | State      | Avg_Daily_Views |
+---------+------------+-----------------+
|       1 | california |          600.00 |
|       2 | florida    |          542.86 |
|       2 | texas      |          500.00 |
|       1 | nevada     |          457.14 |
+---------+------------+-----------------+
WITH MaxViews AS (
    SELECT
        Reel_id,
        State,
        MAX(Cumulative_Views) AS Max_Cumulative_Views,
        COUNT(*) AS Days
    FROM REEL
    GROUP BY Reel_id, State
)
SELECT
    Reel_id,
    State,
    ROUND(Max_Cumulative_Views / Days, 2) AS Avg_Daily_Views
FROM MaxViews
order by Avg_Daily_Views desc;

########################################################################################################################
113 - Cab Driver Streak
A Cab booking company has a dataset of its trip ratings, each row represents a single trip of a driver. A trip has a positive rating if it was rated 4 or above, a streak of positive ratings is when a driver has a rating of 4 and above in consecutive trips. example: If there are 3 consecutive trips with a rating of 4 or above then the streak is 2.
Find out the maximum streak that a driver has had and sort the output in descending order of their maximum streak and then by descending order of driver_id.
Note: only users who have at least 1 streak should be included in the output.

Table: rating_table 
+-----------------+----------+
| COLUMN_NAME     | DATA_TYPE|
+-----------------+----------+
| trip_time       | datetime |    
| driver_id       | varchar  |
| trip_id         | int      |
| rating          | int      |
+-----------------+----------+

Expected Output
+-----------+------------+
| driver_id | max_streak |
+-----------+------------+
| c         |          3 |
| a         |          2 |
| d         |          1 |
| b         |          1 |
+-----------+------------+
WITH RankedRatings AS (
    SELECT 
        driver_id, 
        trip_id,
        trip_time,
        rating,
        trip_id - 
        ROW_NUMBER() OVER (PARTITION BY driver_id ORDER BY trip_time) AS streak_group
    FROM rating_table
    WHERE rating>=4
),
StreakLengths AS (
    SELECT 
        driver_id, 
        streak_group,
        COUNT(*) - 1 AS streak_length
    FROM RankedRatings
    GROUP BY driver_id, streak_group
),
MaxStreaks AS (
    SELECT 
        driver_id, 
        MAX(streak_length) AS max_streak
    FROM StreakLengths
    GROUP BY driver_id
)
SELECT 
    driver_id, 
    max_streak
FROM MaxStreaks
WHERE max_streak > 0
ORDER BY max_streak DESC, driver_id DESC;
########################################################################################################################
114 - Tournament Group Winners
You are given two tables, players and matches, with the following structure.
Each record in the table players represents a single player in the tournament. The column player_id contains the ID of each player.
The column group_id contains the ID of the group each player belongs to.
Table: players 
+-----------------+----------+
| COLUMN_NAME     | DATA_TYPE|
+-----------------+----------+
| player_id       | int      |    
| group_id        | int      |
+-----------------+----------+
Each record in the table matches represents a single match in the group stage.
The column first_player (second_player) contains the ID of the first player (second player) in each match. 
The column first_score (second_score) contains the number of points scored by the first player (second player) in each match. 
You may assume that, in each match, players belong to the same group.
Table: matches 
+---------------+----------+
| COLUMN_NAME   | DATA_TYPE|
+---------------+----------+
| match_id      | int      |    
| first_player  | int      |
| second_player | int      |
| first_score   | int      |
| second_score  | int      |
+---------------+----------+
Write an SQL to compute the winner in each group. The winner in each group is the player who scored the maximum total number of points within the group. 
If there is more than one such player, the winner is the one with the highest ID. Write an SQL query that returns a table containing the winner of each group. 
Each record should contain the ID of the group and the ID of the winner in this group. Records should be sorted by group id. 

Expected Output
+----------+-----------+
| group_id | winner_id |
+----------+-----------+
|        1 |         4 |
|        2 |         6 |
|        3 |        11 |
+----------+-----------+

WITH PlayerPoints AS (
  select group_id,player_id,sum(points) as total_points
from (SELECT
        p.group_id,
        p.player_id,
        m.first_score AS points
    FROM players p
    inner JOIN matches m ON p.player_id = m.first_player 
  union all
   SELECT
        p.group_id,
        p.player_id,
        m.second_score AS points
    FROM players p
    inner JOIN matches m ON p.player_id = m.second_player) a
group by group_id,player_id
)
,RankedPlayers AS (
    SELECT
        group_id,
        player_id,
        total_points,
        ROW_NUMBER() OVER (PARTITION BY group_id ORDER BY total_points DESC, player_id desc) AS rn
    FROM PlayerPoints
)
SELECT
    group_id,
    player_id AS winner_id
FROM RankedPlayers
WHERE rn = 1
ORDER BY group_id;
########################################################################################################################
115 - Sequence Expansion
You have a table named numbers containing a single column n. You are required to generate an output that expands each number n into a sequence where the number appears n times.

 

Table: numbers 
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| n           |   int     |    
+-------------+-----------+

Expected Output
+-----------------+
| expanded_number |
+-----------------+
|               1 |
|               2 |
|               2 |
|               3 |
|               3 |
|               3 |
|               4 |
|               4 |
|               4 |
|               4 |
|               7 |
|               7 |
|               7 |
|               7 |
|               7 |
|               7 |
|               7 |
+-----------------+
WITH RECURSIVE NumberSeries AS (
    SELECT
        n AS original_number,
        n AS expanded_number,
        1 AS sequence_length
    FROM numbers
    UNION ALL
    SELECT
        ns.original_number,
        ns.expanded_number,
        ns.sequence_length + 1
    FROM NumberSeries ns
    WHERE ns.sequence_length < ns.original_number
)
SELECT expanded_number
FROM NumberSeries
ORDER BY original_number, sequence_length;
########################################################################################################################
116 - Goals Scored in Each Game
Please refer to the 3 tables below from a football tournament. Write an SQL which lists every game
with the goals scored by each team. The result set should show: match id, match date, team1, score1, team2, score2. Sort the result by match id.

Please note that score1 and score2 should be number of goals scored by team1 and team2 respectively.
Table: team 
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| id          | int         |
| name        | varchar(20) |
| coach       | varchar(20) |
+-------------+-------------+
Table: game
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| match_id    | int         |
| match_date  | date        |
| stadium     | varchar(20) |
| team1       | int         |
| team2       | int         |
+-------------+-------------+
Table: goal 
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| match_id    | int         |
| team_id     | int         |
| player      | varchar(20) |
| goal_time   | time        |
+-------------+-------------+

Expected Output
+----------+------------+-------+--------+-------+--------+
| match_id | match_date | team1 | score1 | team2 | score2 |
+----------+------------+-------+--------+-------+--------+
|        1 | 2024-09-01 |     1 |      2 |     2 |      0 |
|        2 | 2024-09-02 |     3 |      3 |     4 |      1 |
|        3 | 2024-09-03 |     1 |      2 |     3 |      2 |
|        4 | 2024-09-04 |     1 |      0 |     4 |      0 |
+----------+------------+-------+--------+-------+--------+

select game.match_id,game.match_date,team1, sum(case when team1=team_id then 1 else 0 end) as score1
,team2, sum(case when team2=team_id then 1 else 0 end) as score2
from game 
left join goal on game.match_id=goal.match_id
group by game.match_id,game.match_date,team1,team2
order by game.match_id;
########################################################################################################################
117 - Currency Conversion to USD
You are given two tables, sales_amount and exchange_rate. The sales_amount table contains sales transactions in various currencies,
and the exchange_rate table provides the exchange rates for converting different currencies into USD, along with the dates when these rates became effective.
Your task is to write an SQL query that converts all sales amounts into USD using the most recent applicable exchange rate that was effective 
on or before the sale date. Then, calculate the total sales in USD for each sale date.
Table: sales_amount  
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| sale_date   | int      |    
| sales_amount| int      |
| currency    | varchar  |
+-------------+----------+
Table: exchange_rate  
+-----------------+----------+
| COLUMN_NAME     | DATA_TYPE|
+---------------+------------+
| from_currency | varchar    |    
| to_currency   | varchar    |
| exchange_rate | decimal    |
| effective_date| date       |
+-------------+--------------+
Expected Output
+------------+--------------------+
| sale_date  | total_sales_in_usd |
+------------+--------------------+
| 2020-01-01 |             200.00 |
| 2020-01-02 |             800.00 |
| 2020-01-03 |              75.00 |
| 2020-01-05 |             120.00 |
| 2020-01-06 |             199.50 |
| 2020-01-10 |              48.00 |
| 2020-01-15 |              16.00 |
| 2020-01-17 |             270.00 |
| 2020-01-18 |              60.00 |
+------------+--------------------+
SELECT 
    sa.sale_date,
    SUM(sa.sales_amount * er.exchange_rate) AS total_sales_in_usd
FROM 
    sales_amount sa
JOIN 
    exchange_rate er ON sa.currency = er.from_currency
AND 
    er.effective_date = (
        SELECT MAX(effective_date)
        FROM exchange_rate
        WHERE from_currency = sa.currency
        AND effective_date <= sa.sale_date
    )
GROUP BY 
    sa.sale_date
ORDER BY 
    sa.sale_date;

########################################################################################################################
118 - User Session Activity
You are given a table user events that tracks user activity with the following schema:
Table: events
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| user_id     | int      |    
| event_type  | varchar  |
| event_time  | timestamp|
+-------------+----------+
Task:

1. Identify user sessions. A session is defined as a sequence of activities by a user where the time difference between consecutive events 
is less than or equal to 30 minutes. If the time between two events exceeds 30 minutes, its considered the start of a new session.
2. For each session, calculate the following metrics:
session_id : a unique identifier for each session.
session_start_time : the timestamp of the first event in the session.
session_end_time : the timestamp of the last event in the session.
session_duration : the difference between session_end_time and session_start_time.
event_count : the number of events in the session.

Hints
Expected Output
+--------+------------+---------------------+---------------------+------------------+-------------+
| userid | session_id | session_start_time  | session_end_time    | session_duration | event_count |
+--------+------------+---------------------+---------------------+------------------+-------------+
|      1 |          1 | 2023-09-10 09:00:00 | 2023-09-10 09:00:00 |                0 |           1 |
|      1 |          2 | 2023-09-10 10:00:00 | 2023-09-10 10:50:00 |               50 |           3 |
|      1 |          3 | 2023-09-10 11:40:00 | 2023-09-10 11:40:00 |                0 |           1 |
|      1 |          4 | 2023-09-10 12:40:00 | 2023-09-10 12:50:00 |               10 |           2 |
|      2 |          1 | 2023-09-10 09:00:00 | 2023-09-10 09:20:00 |               20 |           2 |
|      2 |          2 | 2023-09-10 10:30:00 | 2023-09-10 10:30:00 |                0 |           1 |
+--------+------------+---------------------+---------------------+------------------+-------------+

WITH cte AS (
    SELECT *
         , LAG(event_time, 1, event_time) OVER (PARTITION BY userid ORDER BY event_time) AS prev_event_time      --     Get previous event_time per user
         , TIMESTAMPDIFF(MINUTE,
                         LAG(event_time, 1, event_time) OVER (PARTITION BY userid ORDER BY event_time), 
                         event_time) AS time_diff                                               --     Calculate difference in minutes between current and previous event
    FROM events
),
cte2 AS (
    SELECT userid
         , event_type
         , prev_event_time
         , event_time
         , CASE WHEN time_diff <= 30 THEN 0 ELSE 1 END AS flag                                       --     Flag 1 if gap > 30 mins, else 0
         , SUM(CASE WHEN time_diff <= 30 THEN 0 ELSE 1 END) OVER (PARTITION BY userid ORDER BY event_time) AS group_id  --     Assign group/session ids based on flag
    FROM cte
)
SELECT userid
     , ROW_NUMBER() OVER (PARTITION BY userid ORDER BY MIN(event_time)) AS session_id                  --     Assign session number per user
     , MIN(event_time) AS session_start_time                                                          --     Get session start time
     , MAX(event_time) AS session_end_time                                                            --     Get session end time
     , TIMESTAMPDIFF(MINUTE, MIN(event_time), MAX(event_time)) AS session_duration                     --     Calculate session duration in minutes
     , COUNT(*) AS event_count                                                                        --     Count events in session
FROM cte2
GROUP BY userid, group_id                                                                           --     Group by user and session group
;

########################################################################################################################
119 - COVID Risk by Age
You have a table named covid_tests with the following columns: name, id, age, and corad score. The corad score values are categorized as follows:
-1 indicates a negative result.
Scores from 2 to 5 indicate a mild condition.
Scores from 6 to 10 indicate a serious condition.
Write a query to produce an output with the following columns:

age_group: Groups of ages (18-30, 31-45, 46-60).
count_negative: The number of people with a negative result in each age group.
count_mild: The number of people with a mild condition in each age group.
count_serious: The number of people with a serious condition in each age group.

Table: covid_tests
+---------------+-------------+
| COLUMN_NAME   | DATA_TYPE   |
+---------------+-------------+
| name          | varchar(10) |
| id            | int         |
| age           | int         |
| corad_score   | int         |
+---------------+-------------+
Hints
Expected Output
+-----------+----------------+------------+---------------+
| age_group | count_negative | count_mild | count_serious |
+-----------+----------------+------------+---------------+
| 18-30     |              5 |          4 |             0 |
| 31-45     |              2 |          6 |             5 |
| 46-60     |              0 |          1 |             6 |
+-----------+----------------+------------+---------------+
WITH AgeGroups AS (
    SELECT
        CASE 
            WHEN age BETWEEN 18 AND 30 THEN '18-30'
            WHEN age BETWEEN 31 AND 45 THEN '31-45'
            WHEN age BETWEEN 46 AND 60 THEN '46-60'
        END AS age_group,
        corad_score
    FROM covid_tests
    WHERE age BETWEEN 18 AND 60
)
SELECT
    age_group,
    SUM(CASE WHEN corad_score = -1 THEN 1 ELSE 0 END) AS count_negative,
    SUM(CASE WHEN corad_score BETWEEN 2 AND 5 THEN 1 ELSE 0 END) AS count_mild,
    SUM(CASE WHEN corad_score BETWEEN 6 AND 10 THEN 1 ELSE 0 END) AS count_serious
FROM AgeGroups
WHERE age_group IS NOT NULL
GROUP BY age_group;
########################################################################################################################
120 - Recurring Monthly Customers
In a quick commerce business, Analyzing the frequency and timing of purchases can help the company identify engaged customers and tailor promotions accordingly.
You are tasked to identify customers who have made a minimum of three purchases, ensuring that each purchase occurred in a different month. 
This information will assist in targeting marketing efforts towards customers who show consistent buying behavior over time.
Write an SQL to display customer id and no of orders placed by them.

Table: orders 
+---------------+-----------+
| COLUMN_NAME   | DATA_TYPE |
+---------------+-----------+
| customer_id   | int       |
| order_id      | int       |
| order_date    | date      |
+---------------+-----------+
Hints
Expected Output
+-------------+-------------+
| customer_id | order_count |
+-------------+-------------+
|           2 |           3 |
|           3 |           4 |
+-------------+-------------+
SELECT 
        customer_id,
        COUNT(order_id) AS order_count
     FROM 
        orders
     GROUP BY 
        customer_id
     HAVING 
        COUNT(order_id) >= 3
        AND COUNT(order_id) = COUNT(DISTINCT DATE_FORMAT(order_date, '%Y-%m'))
########################################################################################################################
121 - Amazon Warehouse Packing
During a warehouse packaging process, items of various weights (1 kg to 5 kg) need to be packed sequentially into boxes. Each box can hold a maximum of 
5 kg in total. The items are presented in a table according to their arrival order, and the goal is to pack them into boxes,
keeping the order (based on id) while ensuring each box’s total weight does not exceed 5 kg. 

**Requirements**:
1. Pack items into boxes in their given order based on id.
2. Each box should not exceed 5 kg in total weight.
3. Once a box reaches the 5 kg limit or would exceed it by adding the next item, start packing into a new box.
4. Assign a box number to each item based on its position in the sequence, so that items within each box do not exceed the 5 kg limit.

**Example**:
Given the items with weights `[1, 3, 5, 3, 2]`, we need to pack them into boxes as follows:

- **Box 1**: Items with weights `[1, 3]` — Total weight = 4 kg
- **Box 2**: Item with weight `[5]` — Total weight = 5 kg
- **Box 3**: Items with weights `[3, 2]` — Total weight = 5 kg

The result should display each item , weight and its assigned box number starting from 1.
Table: items 
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| id          | int       |
| weight      | int       |
+-------------+-----------+

Expected Output
+------+--------+------------+
| id   | weight | box_number |
+------+--------+------------+
|    1 |      1 |          1 |
|    2 |      3 |          1 |
|    3 |      5 |          2 |
|    4 |      3 |          3 |
|    5 |      2 |          3 |
|    6 |      1 |          4 |
|    7 |      4 |          4 |
|    8 |      1 |          5 |
|    9 |      2 |          5 |
|   10 |      5 |          6 |
|   11 |      1 |          7 |
|   12 |      3 |          7 |
|   13 |      2 |          8 |
|   14 |      4 |          9 |
|   15 |      1 |          9 |
+------+--------+------------+
with RECURSIVE cte as (
select  id,weight,weight as running_sum, 1 as box_number 
from items
where id=1
union all
select  b.id, b.weight,case when cte.running_sum+b.weight<=5 then cte.running_sum+b.weight else b.weight end as running_sum
,case when cte.running_sum+b.weight<=5 then cte.box_number else cte.box_number +1  end as box_number
from items b
inner join cte on b.id=cte.id+1
)
select id, weight, box_number from cte;
########################################################################################################################
122 - Third Highest Salary
You are working with an employee database where each employee has a department id and a salary. 
Your task is to find the third highest salary in each department. If there is no third highest salary in a department, then the query should
return salary as null for that department. Sort the output by department id.
Assume that none of the employees have same salary in a particular department.

Table: employees 
+---------------+----------+
| COLUMN_NAME   | DATA_TYPE|
+---------------+----------+
| employee_id   | int      |
| department_id | int      |
| salary        | int      |
+---------------+----------+

Expected Output
+---------------+----------------------+
| department_id | third_highest_salary |
+---------------+----------------------+
|             1 |                 3000 |
|             2 |                 NULL |
|             3 |                 3500 |
|             4 |                 NULL |
|             5 |                 4200 |
+---------------+----------------------+
WITH RankedSalaries AS (
    SELECT 
        department_id,
        salary,
        RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS rn
    FROM employees
)
SELECT 
    e.department_id,
    r.salary AS third_highest_salary
FROM 
    (SELECT DISTINCT department_id FROM employees) e
LEFT JOIN RankedSalaries r 
    ON e.department_id = r.department_id and rn=3
order by   e.department_id;
########################################################################################################################
123 - Perfect Score Candidates
You are given a table named assessments that contains information about candidate evaluations for various technical tasks.
Each row in the table represents a candidate and includes their years of experience, along with scores for three different tasks: 
SQL, Algorithms, and Bug Fixing. A NULL value in any of the task columns indicates that the candidate was not required to solve that specific task.
Your task is to analyze this data and determine, for each experience level, the total number of candidates and 
how many of them achieved a "perfect score." A candidate is considered to have achieved a "perfect score" 
if they score 100 in every task they were requested to solve.
The output should include the experience level, the total number of candidates for each level, 
and the count of candidates who achieved a "perfect score." The result should be ordered by experience level.

Table: assessments 
+--------------+----------+
| COLUMN_NAME  | DATA_TYPE|
+--------------+----------+
| candidate_id | int      |
| experience   | int      |
| sql_score    | int      |
| algo         | int      |
| bug_fixing   | int      |
+--------------+----------+
Expected Output
+------------+------------------+--------------------------+
| experience | total_condidates | perfect_score_candidates |
+------------+------------------+--------------------------+
|          1 |                1 |                        1 |
|          3 |                2 |                        0 |
|          5 |                4 |                        2 |
|         10 |                3 |                        2 |
+------------+------------------+--------------------------+
select experience, COUNT(*) as total_condidates
,sum(case when (case when sql_score IS null or sql_score=100 then 1 else 0 end +
 case when algo IS null or algo=100 then 1 else 0 end +
 case when bug_fixing IS null or bug_fixing=100 then 1 else 0 end)=3 then 1 else 0 end) as perfect_score_candidates
from assessments
group by experience
order by experience;

########################################################################################################################
124 - Top 3 Netflix Shows
Netflix’s analytics team wants to identify the Top 3 most popular shows based on the viewing patterns of its users. 
The definition of "popular" is based on two factors:
Unique Watchers: The total number of distinct users who have watched a show.
Total Watch Duration: The cumulative time users have spent watching the show.
In the case of ties in the number of unique watchers, the total watch duration will serve as the tie-breaker.
Write an SQL query to determine the Top 3 shows based on the above criteria. 
The output should be sorted by show_id and should include: show_id , unique_watchers, total_duration.

Table: watch_history 
+---------------+----------+
| COLUMN_NAME   | DATA_TYPE|
+---------------+----------+
| user_id       | int      |
| show_id       | int      |
| watch_date    | int      |
| watch_duration| int      |
+--------------+-----------+

Expected Output
+---------+-----------------+----------------+
| show_id | unique_watchers | total_duration |
+---------+-----------------+----------------+
|     106 |               3 |            420 |
|     107 |               3 |            420 |
|     108 |               4 |           1150 |
+---------+-----------------+----------------+
WITH aggregated_data AS (
    SELECT 
        show_id,
        COUNT(DISTINCT user_id) AS unique_watchers,
        SUM(watch_duration) AS total_duration
    FROM 
        watch_history
    GROUP BY 
        show_id
),
ranked_shows AS (
    SELECT 
        show_id,
        unique_watchers,
        total_duration,
        RANK() OVER (
            ORDER BY 
                unique_watchers DESC, 
                total_duration DESC
        ) AS rn
    FROM 
        aggregated_data
)
SELECT 
    show_id,
    unique_watchers,
    total_duration
FROM 
    ranked_shows
WHERE 
    rn <= 3
order by show_id
;
########################################################################################################################
125 - Project Budget
You are tasked with managing project budgets at a company. Each project has a fixed budget, and multiple employees work on these projects. 
The companys payroll is based on annual salaries, and each employee works for a specific duration on a project.
Over budget on a project is defined when the salaries (allocated on per day basis as per project duration) exceed the budget of the project. 
For example, if Ankit and Rohit both combined income make 200K and work on a project of a budget of 50K that takes half a year, 
then the project is over budget given 0.5 * 200K = 100K > 50K.
Write a query to forecast the budget for all projects and return a label of "overbudget" 
if it is over budget and "within budget" otherwise. Order the result by project title.

 Note: Assume that employees only work on one project at a time.

Table: employees 
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| id          | int      |
| name        | varchar  |
| salary      | int      |
+-------------+----------+
Table: projects 
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| id          | int      |
| title       | varchar  |
| start_date  | date     |
| end_date    | date     |
| budget      | int      |
+-------------+----------+
Table: project_employees 
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| project_id  | int      |
| employee_id | int      |
+-------------+----------+

Expected Output
+--------------------+--------+---------------+
| title              | budget | label         |
+--------------------+--------+---------------+
| Analytics Platform |  80000 | within budget |
| App Development    | 100000 | overbudget    |
| Cloud Migration    |  20000 | overbudget    |
| Website Redesign   |  50000 | within budget |
+--------------------+--------+---------------+

WITH Project_Salary_Cost AS (
    SELECT 
        p.title AS project_title,                                         -- Project title from Projects table
        p.budget,                                                        -- Project budget
        SUM(e.salary * (DATEDIFF(p.end_date, p.start_date) / 365.0)) AS total_salary_cost  -- Total salary cost prorated by project duration in years
    FROM 
        Projects p
    JOIN 
        Project_Employees pe ON p.id = pe.project_id                      -- Join to get employees assigned to projects
    JOIN 
        Employees e ON e.id = pe.employee_id                             -- Join to get employee salaries
    GROUP BY 
        p.id, p.title, p.budget                                           -- Group by project to calculate total salary cost per project
)
SELECT 
    project_title AS title,                                               -- Project title
    budget,                                                             -- Project budget
    CASE 
        WHEN total_salary_cost > budget THEN 'overbudget'                -- Label 'overbudget' if total cost exceeds budget
        ELSE 'within budget'                                              -- Else label 'within budget'
    END AS label
FROM 
    Project_Salary_Cost                                                    -- Use CTE with calculated salary costs
ORDER BY 
    project_title;                                                       -- Order by project title

########################################################################################################################
126 - Selective Buyers Analysis
You are given an orders table that contains information about customer purchases, including the products they bought. 
Write a query to find all customers who have purchased both "Laptop" and "Mouse", but have never purchased "Phone Case".
Additionally, include the total number of distinct products purchased by these customers. Sort the result by customer id.
Table: orders 
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| customer_id | int      |
| order_id    | int      |
| product_name| varchar  |
+-------------+----------+

Expected Output
+-------------+-------------------------+
| customer_id | total_distinct_products |
+-------------+-------------------------+
|           2 |                       2 |
|           6 |                       3 |
+-------------+-------------------------+
select customer_id, count(distinct product_name) as total_distinct_products
from orders 
where customer_id not in (select customer_id from orders where product_name='Phone Case')
group by customer_id
having count(distinct case when product_name in ('Laptop','Mouse') then product_name end)=2
order by customer_id;
########################################################################################################################
127 - F.R.I.E.N.D.S.
You are given three tables: students, friends and packages. Friends table has student id and friend id(only best friend). 
A student can have more than one best friends. 
Write a query to output the names of those students whose ALL friends got offered a higher salary than them. Display those
students name and difference between their salary and average of their friends salaries.
Table: students 
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| id          | int      |
| name        | varchar  |
+-------------+----------+
Table: friends 
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| id          | int      |
| friend_id   | int      |
+-------------+----------+
Table: packages 
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| id          | int      |
| salary      | int      |
+-------------+----------+

Expected Output
+-------+-------------+
| name  | salary_diff |
+-------+-------------+
| Alice | -15000.0000 |
| Eve   | -20000.0000 |
+-------+-------------+
select s.name, sp.salary-avg(fp.salary) as salary_diff
from students s
inner join friends f on s.id=f.id
inner join packages sp on s.id=sp.id 
inner join packages fp on f.friend_id=fp.id 
group by s.name , sp.salary 
having sp.salary < min(fp.salary) 
order by s.name;
########################################################################################################################
128 - Train Schedule
You are given a table of  train schedule which contains the arrival and departure times of trains at each station on a given day. 
At each station one platform can accommodate only one train at a time, from the beginning of the minute the train arrives until the end of the minute 
it departs. 
Write a query to find the minimum number of platforms required at each station to handle all train traffic to ensure that no two trains 
overlap at any station.
Table: train_schedule 
+---------------+----------+
| COLUMN_NAME   | DATA_TYPE|
+---------------+----------+
| station_id    | int      |
| train_id      | int      |
| arrival_time  | time     |
| departure_time| time     |
+-------------+------------+

Expected Output
+------------+------------------------+
| station_id | min_platforms_required |
+------------+------------------------+
|        100 |                      4 |
|        200 |                      3 |
+------------+------------------------+
WITH combined_times AS (
    SELECT station_id, arrival_time AS event_time, 1 AS event_type 
    FROM train_schedule 
    UNION ALL
    SELECT station_id,departure_time AS event_time, -1 AS event_type 
    FROM train_schedule 
),
cumulative_events AS (
    SELECT station_id, 
        event_time,
        SUM(event_type) OVER (partition by station_id ORDER BY event_time) AS current_trains 
    FROM combined_times
)
SELECT station_id ,MAX(current_trains) AS min_platforms_required 
FROM cumulative_events
group by station_id;
########################################################################################################################
129 - Uber Active Drivers
We have a driver table which has driver id and join date for each Uber drivers. We have another table rides where we have ride id,
ride date and driver id.  A driver becomes inactive if he doesnt have any ride for consecutive 28 days after joining the company. 
Driver can become active again once he takes a new ride. We need to find number of active drivers for uber at the end of each month for year 2023.
For example if a driver joins Uber on Jan 15th and takes his first ride on March 15th. He will be considered active for Jan month end , 
Not active for Feb month end but active for March month end.

Table: drivers 
+---------------+----------+
| COLUMN_NAME   | DATA_TYPE|
+---------------+----------+
| driver_id     | int      |
| join_date     | date     |
+-------------+------------+
Table: rides 
+---------------+----------+
| COLUMN_NAME   | DATA_TYPE|
+---------------+----------+
| ride_id       | int      |
| ride_date     | date     |
| driver_id     | date     |
+-------------+------------+
Table: calendar_dim (Contains all dates of 2023) 
+---------------+----------+
| COLUMN_NAME   | DATA_TYPE|
+---------------+----------+
| cal_date      | date     |
+-------------+------------+ 
Hints
Expected Output
+----------------+----------------------+
| month_end_date | no_of_active_drivers |
+----------------+----------------------+
| 2023-01-31     |                    2 |
| 2023-02-28     |                    3 |
| 2023-03-31     |                    1 |
| 2023-04-30     |                    1 |
| 2023-05-31     |                    2 |
| 2023-06-30     |                    1 |
| 2023-07-31     |                    1 |
| 2023-08-31     |                    1 |
| 2023-09-30     |                    1 |
| 2023-10-31     |                    1 |
| 2023-11-30     |                    1 |
| 2023-12-31     |                    0 |
+----------------+----------------------+
WITH cal AS (
    SELECT MONTH(cal_date) AS cal_month, MAX(cal_date) AS month_end_date
    FROM calendar_dim
    GROUP BY MONTH(cal_date)
),
join_ride AS (
    SELECT driver_id, join_date AS join_ride_date 
    FROM drivers
    UNION 
    SELECT driver_id, ride_date 
    FROM rides
),
days_since_last_ride_monthend AS (
    SELECT cal.month_end_date, jr.driver_id, MAX(jr.join_ride_date) AS latest_ride,
           DATEDIFF(cal.month_end_date, MAX(jr.join_ride_date)) AS days_since_last_ride
    FROM cal
    LEFT JOIN join_ride jr ON cal.month_end_date >= jr.join_ride_date
    GROUP BY cal.month_end_date, jr.driver_id
)
SELECT month_end_date, 
       SUM(CASE WHEN days_since_last_ride <= 28 THEN 1 ELSE 0 END) AS no_of_active_drivers
FROM days_since_last_ride_monthend
GROUP BY month_end_date
ORDER BY month_end_date;

########################################################################################################################
130 - Employees Status Change(Part-1)
You work in the Human Resources (HR) department of a growing company that tracks the status of its employees year over year. 
The company needs to analyze employee status changes between two consecutive years: 2020 and 2021.

The companys HR system has two separate tables of employees for the years 2020 and 2021, which include each employees
unique identifier (emp_id) and their corresponding designation (role) within the organization.

The task is to track how the designations of employees have changed over the year. Specifically, you are required to identify the following changes:

Promoted: If an employees designation has changed (e.g., from Trainee to Developer, or from Developer to Manager).
Resigned: If an employee was present in 2020 but has left the company by 2021.
New Hire: If an employee was hired in 2021 but was not present in 2020.

Assume that employees can only be promoted and cannot be demoted.

Table: emp_2020 
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| emp_id      | int      |
| designation | date     |
+-------------+----------+

Table: emp_2021
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| emp_id      | int      |
| designation | date     |
+-------------+----------+
Hints
Expected Output
+--------+----------+
| emp_id | comment  |
+--------+----------+
|      1 | Promoted |
|      3 | Promoted |
|      4 | Resigned |
|      7 | New Hire |
+--------+----------+
SELECT 
    COALESCE(e20.emp_id, e21.emp_id) AS emp_id,
    CASE 
        WHEN e20.designation != e21.designation THEN 'Promoted'
        WHEN e21.designation IS NULL THEN 'Resigned'
        ELSE 'New Hire'
    END AS comment
FROM emp_2020 e20
LEFT JOIN emp_2021 e21 ON e20.emp_id = e21.emp_id
WHERE e20.designation != e21.designation 
   OR e20.designation IS NULL 
   OR e21.designation IS NULL

UNION 

SELECT 
    COALESCE(e20.emp_id, e21.emp_id) AS emp_id,
    CASE 
        WHEN e20.designation != e21.designation THEN 'Promoted'
        WHEN e21.designation IS NULL THEN 'Resigned'
        ELSE 'New Hire'
    END AS comment
FROM emp_2021 e21
LEFT JOIN emp_2020 e20 ON e20.emp_id = e21.emp_id
WHERE e20.designation != e21.designation 
   OR e20.designation IS NULL 
   OR e21.designation IS NULL;
########################################################################################################################
131 - Employees Status Change(Part-2)
You work in the Human Resources (HR) department of a growing company that tracks the status of its employees year over year.
The company needs to analyze employee status changes between two consecutive years: 2020 and 2021.
The companys HR system has two separate records of employees for the years 2020 and 2021 in the same table, 
which include each employees unique identifier (emp_id) and their corresponding designation (role) within the organization for each year.
The task is to track how the designations of employees have changed over the year. Specifically, you are required to identify the following changes:
Promoted: If an employees designation has changed (e.g., from Trainee to Developer, or from Developer to Manager).
Resigned: If an employee was present in 2020 but has left the company by 2021.
New Hire: If an employee was hired in 2021 but was not present in 2020.

Assume that employees can only be promoted and cannot be demoted.

Table: employees
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| emp_id      | int      |
| year        | int      | 
| designation | date     |
+-------------+----------+
Hints
Expected Output
+--------+----------+
| emp_id | comment  |
+--------+----------+
|      1 | Promoted |
|      3 | Promoted |
|      4 | Resigned |
|      7 | New Hire |
+--------+----------+
SELECT 
    COALESCE(e20.emp_id, e21.emp_id) AS emp_id,
    CASE 
        WHEN e20.designation != e21.designation THEN 'Promoted'
        WHEN e21.designation IS NULL THEN 'Resigned'
        ELSE 'New Hire'
    END AS comment
FROM employees e20
LEFT JOIN employees e21 ON e20.emp_id = e21.emp_id and e21.year=2021
WHERE e20.year=2020 
   and (e20.designation != e21.designation 
   OR e20.designation IS NULL 
   OR e21.designation IS NULL)

UNION 

SELECT 
    COALESCE(e20.emp_id, e21.emp_id) AS emp_id,
    CASE 
        WHEN e20.designation != e21.designation THEN 'Promoted'
        WHEN e21.designation IS NULL THEN 'Resigned'
        ELSE 'New Hire'
    END AS comment
FROM employees e21
LEFT JOIN employees e20 ON e20.emp_id = e21.emp_id and e20.year=2020 
WHERE e21.year=2021
	and (e20.designation != e21.designation 
   OR e20.designation IS NULL 
   OR e21.designation IS NULL);
########################################################################################################################
132 - Last Sunday
Write an SQL to get the date of the last Sunday as per todays date. If you are solving the problem on Sunday then it should still 
return the date of last Sunday (not current date).
Note : Dates are displayed as per UTC time zone.

Hints
Expected Output
+-------------+
| last_sunday |
+-------------+
| 2025-07-13  |
+-------------+
	
SELECT DATE_SUB(DATE(now()), INTERVAL case when DAYOFWEEK(now())=1 then 7 else DAYOFWEEK(now())-1 end DAY) as last_sunday;
########################################################################################################################
133 - Projects Source System
A company manages project data from three source systems with varying reliability:

EagleEye: The most reliable and prioritized internal system.
SwiftLink: A trusted partner system with moderate reliability.
DataVault: A third-party system used as a fallback.

Data for a project can come from multiple systems. For each project, you need to select the most reliable data by prioritizing 
the source systems: EagleEye > SwiftLink > DataVault

Write an SQL to display id , project number and selected source system.
Table: projects
+----------------+----------+
| COLUMN_NAME    | DATA_TYPE|
+----------------+----------+
| id             | int      |
| project_number | int      | 
| Source_System  | varchar  |
+-------------+-------------+

Expected Output
+------+----------------+---------------+
| id   | project_number | source_system |
+------+----------------+---------------+
|    1 |           1001 | EagleEye      |
|    4 |           1002 | SwiftLink     |
|    5 |           1003 | DataVault     |
|    6 |           1004 | EagleEye      |
|    9 |           1005 | EagleEye      |
|   10 |           1006 | EagleEye      |
|   12 |           1007 | SwiftLink     |
+------+----------------+---------------+
WITH RankedData AS (
    SELECT
        ID,
        Project_Number,
        Source_System,
        ROW_NUMBER() OVER (
            PARTITION BY Project_Number
            ORDER BY 
                CASE 
                    WHEN Source_System = 'EagleEye' THEN 1
                    WHEN Source_System = 'SwiftLink' THEN 2
                    WHEN Source_System = 'DataVault' THEN 3
                END
        ) AS rn
    FROM
        projects
)
-- Select the data with the highest priority
SELECT 
     id,project_number, source_system
FROM RankedData
WHERE rn = 1;

########################################################################################################################
134 - Dormant Customers
Imagine you are working for Swiggy (a food delivery service platform). As part of your role in the data analytics team,
youre tasked with identifying dormant customers - those who have registered on the platform but have not placed any orders recently. 
Identifying dormant customers is crucial for targeted marketing efforts and customer re-engagement strategies.
A dormant customer is defined as a user who registered more than 6 months ago from today but has not placed any orders in the last 3 months.
Your query should return the list of dormant customers and order amount of last order placed by them. If no order was placed by a customer 
then order amount should be 0. order the output by user id.

Note: All the dates are in UTC time zone.

Table: users
+--------------+----------+
| COLUMN_NAME  | DATA_TYPE|
+--------------+----------+
| user_id      | int      |
| name         | varchar  | 
| email        | varchar  |
| signup_date  | date     |
+--------------+--------- +
Table: orders
+--------------+----------+
| COLUMN_NAME  | DATA_TYPE|
+--------------+----------+
| order_id     | int      |
| order_date   | date     | 
| user_id      | int      |
| order_amount | int      |
+--------------+----------+

Expected Output
+---------+-------------------+
| user_id | last_order_amount |
+---------+-------------------+
|       3 |               160 |
|       4 |               125 |
|       5 |                 0 |
+---------+-------------------+
WITH cte AS (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY order_date DESC) AS rn
    FROM Orders
)
SELECT Users.user_id, COALESCE(cte.order_amount, 0) AS last_order_amount
FROM Users
LEFT JOIN cte ON Users.user_id = cte.user_id AND cte.rn = 1
WHERE Users.signup_date < DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
  AND (TIMESTAMPDIFF(DAY, cte.order_date, CURDATE()) > 90 OR cte.order_date IS NULL)
ORDER BY Users.user_id ASC;

########################################################################################################################
135 - Music Lovers
At Spotify, we track user activity to understand their engagement with the platform. One of the key metrics we focus on is how consistently
a user listens to music each day.
A user is considered "consistent" if they have login session every single day since their first login.
Your task is to identify users who have logged in and listened to music every single day since their first login date until today.
Note: Dates are as per UTC time zone.
Table: user_sessions
+-----------------+----------+
| COLUMN_NAME     | DATA_TYPE|
+-----------------+----------+
| user_id         | int      |
| login_timestamp | datetime | 
+-----------------+----------+

Expected Output
+---------+
| user_id |
+---------+
|       1 |
|       4 |
|       6 |
+---------+
SELECT user_id
FROM user_sessions
GROUP BY user_id
HAVING COUNT(DISTINCT DATE(login_timestamp)) = DATEDIFF(CURDATE(), MIN(login_timestamp)) + 1;
########################################################################################################################
136 - The Yellow Pages
To enhance the functionality of "The Yellow Pages" website, create a SQL query to generate a report of companies, 
including their phone numbers and ratings. The query must account for the following:

Columns in the output:

name: The company name as per below rules:
    For promoted companies:
        Format: [PROMOTED] <company_name>.
    For non-promoted companies:
        Format: <company_name>.

phone: The company phone number.
rating: The overall star rating of the company as per rules below:
    Promoted companies : should always have NULL as their rating.
    For non-promoted companies:
        Format: <#_stars> (<average_rating>, based on <total_reviews> reviews), where:
        <#_stars>: Rounded down average rating to the nearest whole number.
        <average_rating>: Exact average rating rounded to 1 decimal place.
        <total_reviews>: Total number of reviews across all categories for the company. 

Rules: Non-promoted companies should only be included if their average rating is 1 star or higher.
Results should be sorted:
By promotion status (promoted first).
In descending order of the average rating (before rounding).
By the total number of reviews (descending).

Table: companies
+------------+----------+
| COLUMN_NAME| DATA_TYPE|
+------------+----------+
| id         | int      |
| name       | VARCHAR  | 
| phone      | VARCHAR  | 
| is_promoted| int      | 
+------------+----------+
Table: categories
+------------+----------+
| COLUMN_NAME| DATA_TYPE|
+------------+----------+
| company_id | int      |
| name       | VARCHAR  | 
| rating     | decimal  | 
+------------+----------+

Expected Output
+----------------------------+--------------------+------------------------------+
| name                       | phone              | rating                       |
+----------------------------+--------------------+------------------------------+
| [PROMOTED] King and Sons   | +51 (578) 555-1781 | NULL                         |
| [PROMOTED] Fadel and Fahey | +86 (307) 777-1731 | NULL                         |
| Wehner and Sons            | +86 (302) 414-2559 | ** (2.7, based on 3 reviews) |
| Renner and Parisian        | +7 (720) 699-2313  | ** (2.0, based on 1 reviews) |
| Considine LLC              | +33 (487) 383-2644 | * (1.3, based on 3 reviews)  |
| Parisian-Zieme             | +1 (399) 688-1824  | * (1.0, based on 4 reviews)  |
+----------------------------+--------------------+------------------------------+
WITH company_ratings AS (
    SELECT 
        c.id AS company_id,
        c.name AS company_name,
        c.phone AS company_phone,
        c.is_promoted,
        AVG(cat.rating) AS avg_rating,
        COUNT(cat.rating) AS total_reviews
    FROM 
        companies c
    INNER JOIN 
        categories cat ON c.id = cat.company_id
    GROUP BY 
        c.id, c.name, c.phone, c.is_promoted
),
formatted_output AS (
    SELECT 
        CASE 
            WHEN cr.is_promoted = 1 THEN CONCAT('[PROMOTED] ', cr.company_name)
            ELSE cr.company_name
        END AS name,
        cr.company_phone AS phone,
        CASE
            WHEN cr.is_promoted = 1 THEN NULL
            ELSE CONCAT(
                REPEAT('*', FLOOR(cr.avg_rating)), 
                ' (', 
                FORMAT(cr.avg_rating, 1), 
                ', based on ', 
                cr.total_reviews, 
                ' reviews)'
            )
        END AS rating,
        cr.is_promoted,
        cr.total_reviews,
        cr.avg_rating
    FROM 
        company_ratings cr
    WHERE 
        cr.is_promoted = 1 OR cr.avg_rating >= 1
)
SELECT 
    name, 
    phone, 
    rating 
FROM 
    formatted_output
ORDER BY 
    is_promoted DESC, 
    avg_rating DESC, 
    total_reviews DESC;
########################################################################################################################
137 - Myntra Campaign Effectiveness
Myntra marketing team wants to measure the effectiveness of recent campaigns aimed at acquiring new customers. 
A new customer is defined as someone who made their first-ever purchase during a specific period, with no prior purchase history.
They have asked you to identify the new customers acquired in the last 3 months, excluding the current month. 
Output should display customer id and their first purchase date. Order the result by customer id.

For example:
If today is March 15, 2025, the SQL should give customers whose first purchase falls in the range from December 1, 2024, to February 28, 2025, 
and should not include any new customers made in March 2025.
 
Table: transactions
+---------------+------------+
| COLUMN_NAME     | DATA_TYPE|
+-----------------+----------+
| transaction_id  | int      |
| customer_id     | int      | 
| transaction_date| date     | 
| amount          | int      | 
+-----------------+----------+
Expected Output
+-------------+---------------------+
| customer_id | first_purchase_date |
+-------------+---------------------+
|           3 | 2025-05-16          |
|           4 | 2025-04-12          |
|           6 | 2025-06-11          |
|           7 | 2025-06-16          |
|           8 | 2025-06-26          |
WITH FirstPurchase AS (
    SELECT 
        customer_id,
        MIN(transaction_date) AS first_purchase_date
    FROM 
        transactions
    GROUP BY 
        customer_id
)
SELECT 
    fp.customer_id,
    fp.first_purchase_date
FROM 
    FirstPurchase fp
WHERE 
    fp.first_purchase_date >= DATE_SUB(DATE_FORMAT(CURRENT_DATE, '%Y-%m-01'), INTERVAL 3 MONTH)  -- Start of 3 months ago (excluding current month)
    AND fp.first_purchase_date < DATE_FORMAT(CURRENT_DATE, '%Y-%m-01')  -- Before the start of the current month
ORDER BY 
    fp.customer_id;
########################################################################################################################
138 - Customer Data Cleaning
You are given a table with customers information that contains inconsistent and messy data. Your task is to clean the data by writing an SQL query to:

1- Trim extra spaces from the customer name and email fields.
2- Convert all email addresses to lowercase for consistency.
3- Remove duplicate records based on email address (keep the record with lower customer id).
4- Standardize the phone number format to only contain digits (remove dashes, spaces, and special characters).
5- Replace NULL values in address with 'Unknown'.

Sort the output by customer id.

Table: customers
+---------------+----------+
| COLUMN_NAME   | DATA_TYPE|
+---------------+----------+
| customer_id   | int      |
| customer_name | varchar  | 
| email         | varchar  | 
| phone         | varchar  | 
| address       | varchar  | 
+---------------+----------+

Expected Output
+-------------+-----------------+-----------------------------+-------------+-------------------+
| customer_id | customer_name   | email                       | phone       | address           |
+-------------+-----------------+-----------------------------+-------------+-------------------+
|           1 | John Doe        | john.doe@gmail.com          | 1234567890  | 123 Elm St        |
|           2 | Jane Smith      | jane.smith@yahoo.com        | 9876543210  | Unknown           |
|           4 | Alex White      | alex.white@outlook.com      | 1112223333  | 456 Pine Ave      |
|           5 | Bob Brown       | bob.brown@gmail.com         | 15558889999 | 789 Oak Dr        |
|           6 | Emily Davis     | emily.davis@gmail.com       | 5556667777  | 321 Cedar St      |
|           7 | Michael Johnson | michael.johnson@hotmail.com | 4445556666  | Unknown           |
|           8 | David Miller    | david.miller@yahoo.com      | 7778889999  | 654 Birch Ln      |
|          10 | William Taylor  | william.taylor@outlook.com  | 11234567890 | 852 Walnut St     |
|          12 | Olivia Brown    | olivia.brown@yahoo.com      | 3332221111  | 369 Pineapple Ave |
|          13 | James Wilson    | james.wilson@gmail.com      | 6667778888  | Unknown           |
|          14 | Emma Thomas     | emma.thomas@gmail.com       | 1231231234  | 123 Fake St       |
|          15 | Noah Anderson   | noah.anderson@yahoo.com     | 3216549870  | 456 Real Ave      |
+-------------+-----------------+-----------------------------+-------------+-------------------+
WITH RankedCustomers AS (
    SELECT 
        customer_id,
        TRIM(customer_name) AS customer_name,  -- Trim spaces from customer_name
        LOWER(TRIM(email)) AS email,  -- Convert email to lowercase and trim spaces
        REGEXP_REPLACE(phone, '[^0-9]', '') AS phone,  -- Remove non-digit characters from phone
        COALESCE(address, 'Unknown') AS address,  -- Replace NULL address with 'Unknown'
        ROW_NUMBER() OVER (PARTITION BY LOWER(TRIM(email)) ORDER BY customer_id) AS rn  
        -- Assigns a rank to each duplicate email, keeping the one with the lowest customer_id
    FROM customers
)
SELECT customer_id, customer_name, email, phone, address 
FROM RankedCustomers
WHERE rn = 1
order by customer_id;
########################################################################################################################
139 - Quarterly sales Analysis
Given a sales dataset that records daily transactions for various products, write an SQL query to calculate last quarters 
total sales and quarter-to-date (QTD) sales for each product, helping analyze past performance and current trends.
Table: sales
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| id          | int      |
| product_id  | int      | 
| sale_date   | date     | 
| sale_amount | int      | 
+-------------+----------+
Hints
Expected Output
+------------+--------------------+-----------+
| product_id | last_quarter_sales | qtd_sales |
+------------+--------------------+-----------+
|        101 |               4250 |      5800 |
|        102 |               6170 |      3620 |
+------------+--------------------+-----------+
-- Calculate quarter-to-date start date
with qtd_start AS (
  SELECT 
    DATE_FORMAT(
        DATE_SUB(CURDATE(), INTERVAL (MOD(MONTH(CURDATE())-1, 3)) MONTH),
        '%Y-%m-01'
    ) AS current_qtr_start
),
DateRanges as (
select current_qtr_start,current_qtr_start - INTERVAL 1 QUARTER as last_qtr_start
,current_qtr_start - INTERVAL 1 DAY as last_qtr_end
from qtd_start
),
SalesData AS (
    SELECT 
        product_id,
        SUM(CASE 
            WHEN sale_date >= (SELECT last_qtr_start FROM DateRanges) 
                 AND sale_date <= (SELECT last_qtr_end FROM DateRanges) 
            THEN sales_amount 
            ELSE 0 
        END) AS last_quarter_sales,
        SUM(CASE 
            WHEN sale_date >= (SELECT current_qtr_start FROM DateRanges) 
                 AND sale_date <= CURRENT_DATE 
            THEN sales_amount 
            ELSE 0 
        END) AS qtd_sales
    FROM sales
    GROUP BY product_id
)
SELECT product_id, last_quarter_sales, qtd_sales
FROM SalesData;

########################################################################################################################
140 - Team Points Calculation
Given a list of matches in the group stage of the football World Cup, compute the number of points each team currently has.
You are given two tables, "teams" and "matches", with the following structures:

Table: teams
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| team_id     | int      |
| team_name   | VARCHAR  | 
+-------------+----------+
Table: matches
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| match_id    | int      |
| host_team   | int      | 
| guest_team  | int      | 
| host_goals  | int      | 
| guest_goals | int      | 
+-------------+----------+
 

You need to compute the total number of points each team has scored after all the matches described in the table. The scoring rules are as follows:

• If a team wins a match (scores more goals than the other team), it receives 3 points.
• If a team draws a match (scores exactly the same number of goals as the opponent), it receives 1 point.
• If a team loses a match (scores fewer goals than the opponent), it receives no points.

Write an SQL query that returns all the teams ids along with its name and the number of points it received after all described matches ("num_points"). 
The table should be ordered by "num_points" (in decreasing order). In case of a tie, order the rows by "team_id" (in increasing order).

Expected Output
+---------+-----------+------------+
| team_id | team_name | num_points |
+---------+-----------+------------+
|      20 | Never     |          4 |
|      50 | Gonna     |          4 |
|      10 | Give      |          3 |
|      30 | You       |          3 |
|      40 | Up        |          0 |
+---------+-----------+------------+
SELECT 
    t.team_id,
    t.team_name,
    SUM(CASE
        WHEN m.host_team = t.team_id AND m.host_goals > m.guest_goals THEN 3
        WHEN m.guest_team = t.team_id AND m.guest_goals > m.host_goals THEN 3
        WHEN m.host_team = t.team_id AND m.host_goals = m.guest_goals THEN 1
        WHEN m.guest_team = t.team_id AND m.guest_goals = m.host_goals THEN 1
        ELSE 0
    END) AS num_points
FROM teams t
LEFT JOIN matches m ON m.host_team = t.team_id OR m.guest_team = t.team_id
GROUP BY t.team_id, t.team_name
ORDER BY num_points DESC, t.team_id ASC;
########################################################################################################################
141 - Frequent Flyers
Identify passengers with more than 5 flights from the same airport since last 1 year from current date. 
Display passenger id, departure airport code and number of flights.

Table: passenger_flights
+---------------+----------+
| COLUMN_NAME   | DATA_TYPE|
+---------------+----------+
| Passenger_id  | VARCHAR  |
| Flight_id     | VARCHAR  | 
| Departure_date| date     | 
+---------------+----------+
Table: flight_details
+-------------------+----------+
| COLUMN_NAME       | DATA_TYPE|
+-------------------+----------+
| Flight_id         | VARCHAR  |
| Departure_airport | VARCHAR  | 
| Arrival_airport   | date     | 
+-------------------+----------+

Expected Output
+--------------+------------------------+-----+
| Passenger_id | Departure_airport_code | cnt |
+--------------+------------------------+-----+
| P001         | JFK                    |   5 |
| P005         | JFK                    |   6 |
+--------------+------------------------+-----+
select Passenger_id, Departure_airport_code,count(*) as cnt
from passenger_flights pf 
inner join flight_details fd on pf.Flight_id=fd.Flight_id
where Departure_date > date_sub(curdate(),INTERVAL 365 DAY)
group by Passenger_id, Departure_airport_code
having count(*)>=5;

########################################################################################################################
142 - Salary Difference
You are given an employees table containing information about employees salaries across different departments.
Your task is to calculate the difference between the highest and second-highest salaries for each department.
Conditions:
If a department has only one employee, return NULL for that department.
If all employees in a department have the same salary, return NULL for that department.

The final output should include Department Name and Salary Difference. Order by Department Name.
Table: employees
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| id          | int      |
| name        | VARCHAR  | 
| department  | VARCHAR  | 
| salary      | int      | 
+-------------+----------+
Hints
Expected Output
+-------------+------------------+
| Department  | SalaryDifference |
+-------------+------------------+
| Analytics   |             5000 |
| Engineering |             5000 |
| Finance     |             NULL |
| HR          |             NULL |
| Marketing   |            20000 |
| Sales       |             1000 |
+-------------+------------------+
WITH RankedSalaries AS (
    SELECT 
        Department, 
        Salary,
        DENSE_RANK() OVER (PARTITION BY Department ORDER BY Salary DESC) AS rnk
    FROM employees
)
SELECT 
    Department,
    MAX(CASE WHEN rnk = 1 THEN Salary END) - 
        MAX(CASE WHEN rnk = 2 THEN Salary END) AS SalaryDifference
FROM RankedSalaries
GROUP BY Department
ORDER BY Department;
########################################################################################################################
143 - Airbnb Cheapest Listing
Company X is analyzing Airbnb listings to help travelers find the most affordable yet well-equipped accommodations in various neighborhoods. 
Many users prefer to stay in entire homes or apartments instead of shared spaces and require essential amenities like TV and Internet for work or entertainment.

Your task is to find the cheapest Airbnb listing in each neighborhood that meets the following criteria:

.The property type must be either "Entire home" or "Apartment".
.The property must include both "TV" and "Internet" in its list of amenities.
.Among all qualifying properties in a neighborhood, return the one with the lowest nightly cost.
.If multiple properties have the same lowest cost, return the one with more number of amenities.
.The results(neighborhood, property_id, cost_per_night) should be sorted by neighborhood for better readability.

Table: airbnb_listings
+---------------+----------+
| COLUMN_NAME   | DATA_TYPE|
+---------------+----------+
| property_id   | int      |
| neighborhood  | VARCHAR  | 
| cost_per_night| int      | 
| room_type     | VARCHAR  | 
| amenities     | TEXT     | 
+---------------+----------+
Hints
Expected Output
+---------------+-------------+----------------+
| neighborhood  | property_id | cost_per_night |
+---------------+-------------+----------------+
| Bronx         |         106 |             80 |
| Brooklyn      |         103 |             65 |
| Chicago       |         301 |            100 |
| Manhattan     |         102 |             80 |
| Queens        |         104 |             50 |
| San Francisco |         401 |            200 |
+---------------+-------------+----------------+
WITH FilteredProperties AS (
    SELECT 
        property_id,
        neighborhood,
        cost_per_night,
        amenities,
        room_type,
        LENGTH(amenities) - LENGTH(REPLACE(amenities, ';','')) + 1 AS amenity_count
    FROM airbnb_listings
    WHERE 
        (room_type = 'Entire home' OR room_type = 'Apartment')
        AND upper(amenities) LIKE '%TV%'
        AND upper(amenities) LIKE '%INTERNET%'
), RankedProperties AS (
    SELECT 
        property_id,
        neighborhood,
        cost_per_night,
        amenity_count,
        ROW_NUMBER() OVER (
            PARTITION BY neighborhood 
            ORDER BY cost_per_night ASC, amenity_count DESC
        ) AS rn
    FROM FilteredProperties
)
SELECT 
    neighborhood, 
    property_id, 
    cost_per_night
FROM RankedProperties
WHERE rn= 1
ORDER BY neighborhood;WITH FilteredProperties AS (
    SELECT 
        property_id,
        neighborhood,
        cost_per_night,
        amenities,
        room_type,
        LENGTH(amenities) - LENGTH(REPLACE(amenities, ';','')) + 1 AS amenity_count
    FROM airbnb_listings
    WHERE 
        (room_type = 'Entire home' OR room_type = 'Apartment')
        AND upper(amenities) LIKE '%TV%'
        AND upper(amenities) LIKE '%INTERNET%'
), RankedProperties AS (
    SELECT 
        property_id,
        neighborhood,
        cost_per_night,
        amenity_count,
        ROW_NUMBER() OVER (
            PARTITION BY neighborhood 
            ORDER BY cost_per_night ASC, amenity_count DESC
        ) AS rn
    FROM FilteredProperties
)
SELECT 
    neighborhood, 
    property_id, 
    cost_per_night
FROM RankedProperties
WHERE rn= 1
ORDER BY neighborhood;
########################################################################################################################
144 - Key Out-of-Stock Events
You are working with a large dataset of out-of-stock (OOS) events for products across multiple marketplaces.
Each record in the dataset represents an OOS event for a specific product (MASTER_ID) in a specific marketplace (MARKETPLACE_ID) on a specific date (OOS_DATE). 
The combination of (MASTER_ID, MARKETPLACE_ID, OOS_DATE) is always unique.
Your task is to identify key OOS event dates for each product and marketplace combination.
Steps to identify key OOS events :
Identify the earliest OOS event for each (MASTER_ID, MARKETPLACE_ID).
Recursively find the next OOS event that occurs at least 7 days after the previous event.
Continue this process until no more OOS events meet the condition.
Table: DETAILED_OOS_EVENTS
+---------------+----------+
| COLUMN_NAME   | DATA_TYPE|
+---------------+----------+
| MASTER_ID     | VARCHAR  |
| MARKETPLACE_ID| INTEGER  | 
| OOS_DATE      | DATE     | 
+---------------+----------+
Order the result by MASTER_ID, MARKETPLACE_ID, OOS_DATE
Expected Output
+-----------+----------------+------------+
| MASTER_ID | MARKETPLACE_ID | OOS_DATE   |
+-----------+----------------+------------+
| P04G      |             13 | 2023-07-03 |
| P04G      |             13 | 2024-06-30 |
| P04G      |             13 | 2024-07-07 |
| P04G      |             13 | 2024-07-14 |
| P04G      |             13 | 2024-07-21 |
| P05H      |             14 | 2023-08-01 |
| P05H      |             14 | 2023-08-15 |
| P05H      |             14 | 2023-09-05 |
| P05H      |             14 | 2023-09-15 |
| P05H      |             14 | 2023-10-15 |
| P05H      |             14 | 2023-11-10 |
| P05H      |             14 | 2023-12-05 |
| P05H      |             14 | 2023-12-20 |
| P05H      |             14 | 2024-01-01 |
| P05H      |             14 | 2024-01-30 |
| P05H      |             14 | 2024-02-25 |
| P05H      |             14 | 2024-03-05 |
| P06J      |             15 | 2023-09-01 |
| P06J      |             15 | 2023-09-10 |
| P06J      |             15 | 2023-10-05 |
| P06J      |             15 | 2023-11-01 |
| P06J      |             15 | 2023-12-10 |
| P06J      |             15 | 2023-12-25 |
| P06J      |             15 | 2024-01-05 |
| P06J      |             15 | 2024-02-11 |
| P06J      |             15 | 2024-03-04 |
| P06J      |             15 | 2024-03-15 |
| P06J      |             15 | 2024-03-30 |
| P06J      |             15 | 2024-04-07 |
| P06J      |             15 | 2024-04-15 |

WITH recursive ranked_data AS (  
    SELECT  
        MASTER_ID,  
        MARKETPLACE_ID,  
        OOS_DATE,  
        ROW_NUMBER() OVER (PARTITION BY MASTER_ID, MARKETPLACE_ID ORDER BY OOS_DATE) AS event_id  -- Assign row numbers per MASTER_ID and MARKETPLACE_ID ordered by OOS_DATE
    FROM  
        DETAILED_OOS_EVENTS  
),  
 OOS_Events AS (  
    -- Base case: Find the earliest OOS event for each (MASTER_ID, MARKETPLACE_ID)  
    SELECT  
        MASTER_ID,  
        MARKETPLACE_ID,  
        OOS_DATE,  
        event_id,  
        1 AS valid_flag                                             -- Mark the first event as valid
    FROM  
        ranked_data  
    WHERE event_id = 1  

    UNION ALL  

     -- Recursive case: Find the next OOS event and check if it is at least 7 days after the previous valid event, flag accordingly
    SELECT  
        e.MASTER_ID,  
        e.MARKETPLACE_ID,  
        CASE  
            WHEN e.OOS_DATE >= DATE_ADD(o.OOS_DATE, INTERVAL 7 DAY) THEN e.OOS_DATE  -- If event is 7+ days after previous valid event, use current OOS_DATE
            ELSE o.OOS_DATE                                                          -- Else keep previous OOS_DATE
        END AS OOS_DATE,  
        e.event_id,  
        CASE  
            WHEN e.OOS_DATE >= DATE_ADD(o.OOS_DATE, INTERVAL 7 DAY) THEN 1  -- Flag valid if 7+ days apart
            ELSE 0                                                          -- Otherwise invalid
        END AS valid_flag  
    FROM  
        ranked_data e  
    INNER JOIN  
        OOS_Events o  
    ON  
        e.MASTER_ID = o.MASTER_ID  
        AND e.MARKETPLACE_ID = o.MARKETPLACE_ID  
        AND e.event_id = o.event_id + 1                                 -- Join on next event in sequence
)  
-- Select only valid OOS events spaced by at least 7 days  
SELECT  
    MASTER_ID,  
    MARKETPLACE_ID,  
    OOS_DATE  
FROM  
    OOS_Events  
WHERE valid_flag = 1                                                -- Filter for valid events only
ORDER BY  
    MASTER_ID,  
    MARKETPLACE_ID,  
    OOS_DATE;                                                        -- Order results for readability

########################################################################################################################
145 - Inactive Users
You’re given two tables: users and events. The users table contains information about users, 
including the social media platform they belong to (platform column with values ‘LinkedIn’, ‘Meta’, or ‘Instagram’).
The events table stores user interactions in the action column, which can be ‘like’, ‘comment’, or ‘post’. 
Please note that one user can belong to multiple social media platforms.

Write a query to calculate the percentage of users on each social media platform who have never liked or commented, 
rounded to two decimal places. Order the result by platform.
Table: users
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| user_id     | INTEGER  |
| name        | VARCHAR  | 
| platform    | VARCHAR  | 
+-------------+----------+
Table: events
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| event_id    | INTEGER  |
| user_id     | INTEGER  |
| action      | VARCHAR  | 
| platform    | VARCHAR  | 
| created_at  | DATETIME | 
+-------------+----------+
 
Expected Output
+-----------+-------------------------------------+
| platform  | percentage_never_liked_or_commented |
+-----------+-------------------------------------+
| Instagram |                               40.00 |
| LinkedIn  |                               33.33 |
| Meta      |                               14.29 |
+-----------+-------------------------------------+
WITH engaged_users AS (
    SELECT DISTINCT user_id, platform
    FROM events
    WHERE action IN ('like', 'comment')
),
total_users AS (
    SELECT platform, COUNT(DISTINCT user_id) AS total_user_count
    FROM users
    GROUP BY platform
),
inactive_users AS (
    SELECT u.platform, COUNT(DISTINCT u.user_id) AS inactive_user_count
    FROM users u
    LEFT JOIN engaged_users e 
    ON u.user_id = e.user_id AND u.platform = e.platform
    WHERE e.user_id IS NULL
    GROUP BY u.platform
)
SELECT 
    t.platform, 
    ROUND((COALESCE(i.inactive_user_count, 0) * 100.0) / t.total_user_count, 2) AS percentage_never_liked_or_commented
FROM total_users t
LEFT JOIN inactive_users i ON t.platform = i.platform
order by t.platform;
########################################################################################################################
146 - Cohort Retention
Khan Academy capture data on how users are using their product, with the schemas below. 
Using this data they would like to report on monthly “engaged” retention rates. Monthly “engaged” retention is defined here as the % 
of users from each registration cohort that continued to use the product as an “engaged” user having met the threshold of >= 30 minutes per month. 
They are looking for the retention metric calculated for within 1-3 calendar months post registration.

Table: users
+-------------------+----------+
| COLUMN_NAME       | DATA_TYPE|
+-------------------+----------+
| user_id           | VARCHAR  |
| registration_date | DATE     | 
+-------------+----------------+
Table: usage
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| user_id     | VARCHAR  |
| usage_date  | DATE     | 
| location    | VARCHAR  | 
| time_spent  | INTEGER  | 
+-------------+----------+

Write a SQL query whose output is in the following format using the input tables in the editor:

registration_month 	total_users    	m1_retention   	m2_retention 	m3_retention
2019-01	3	66.67 	33.33	33.33
2019-02	2	100.00	0.00	50.00
 

Explanation:
user aaa used the product 2 times within the first month (2019-01-03, 2019-02-01), 0 times in the 2nd month, and 1 time in the 3rd month (2019-03-04), 
post the user aaa’s initial registration (2019-01-03). User bbb used the product once in 1st month (2019-01-03) and once in 2nd month (2019-02-04)
post registration (2019-01-02), but the 1st month usage is <30 minutes so the user doesn’t count in the m1_retention metric. 
Note that we want to calculate this usage metric as across all geographies.  Round the result to 2 decimal places.

Also note that m1 time period is exact one month from registration date not just the month of registration. Similarly m2 and m3.
 
Expected Output
+--------------------+-------------+--------------+--------------+--------------+
| registration_month | total_users | m1_retention | m2_retention | m3_retention |
+--------------------+-------------+--------------+--------------+--------------+
| 2019-01            |           3 |        66.67 |        33.33 |        33.33 |
| 2019-02            |           2 |       100.00 |         0.00 |        50.00 |
+--------------------+-------------+-
WITH consolidated_usage AS (
    SELECT 
        u.user_id, 
        DATE_FORMAT(u.registration_date, '%Y-%m') AS registration_month,  
        SUM(CASE 
            WHEN usg.usage_date <= DATE_ADD(u.registration_date, INTERVAL 1 MONTH) THEN usg.time_spent 
            ELSE 0 
        END) AS m1_time_spent,
        SUM(CASE 
            WHEN usg.usage_date > DATE_ADD(u.registration_date, INTERVAL 1 MONTH) 
                 AND usg.usage_date <= DATE_ADD(u.registration_date, INTERVAL 2 MONTH) THEN usg.time_spent 
            ELSE 0 
        END) AS m2_time_spent,
        SUM(CASE 
            WHEN usg.usage_date > DATE_ADD(u.registration_date, INTERVAL 2 MONTH) 
                 AND usg.usage_date <= DATE_ADD(u.registration_date, INTERVAL 3 MONTH) THEN usg.time_spent 
            ELSE 0 
        END) AS m3_time_spent
    FROM users u
    LEFT JOIN usage_data usg ON u.user_id = usg.user_id  
    GROUP BY u.user_id, DATE_FORMAT(u.registration_date, '%Y-%m')
)

SELECT 
    registration_month, 
    COUNT(*) AS total_users,  
    IFNULL(ROUND(SUM(CASE WHEN m1_time_spent >= 30 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2), 0) AS m1_retention,  
    IFNULL(ROUND(SUM(CASE WHEN m2_time_spent >= 30 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2), 0) AS m2_retention,  
    IFNULL(ROUND(SUM(CASE WHEN m3_time_spent >= 30 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2), 0) AS m3_retention  
FROM consolidated_usage  
GROUP BY registration_month;

########################################################################################################################
147 - SQL Champions
You are given a table named students with the following structure:
Table: students
+--------------+----------+
| COLUMN_NAME  | DATA_TYPE|
+--------------+----------+
| student_id   | INT      |
| skill        | VARCHAR  |  
+--------------+----------+
Each row represents a skill that a student knows. A student can appear multiple times in the table if they have multiple skills.

Write a SQL query to return the student_ids of students who only know the skill 'SQL'.  Sort the result by student id.

Expected Output
+------------+
| student_id |
+------------+
|          2 |
|          5 |
|          8 |
+------------+
SELECT student_id
FROM students
GROUP BY student_id
HAVING 
    COUNT(DISTINCT LOWER(skill)) = 1
    AND MIN(LOWER(skill)) = 'sql'
order by student_id;
########################################################################################################################
148 - Individual Contributors
You are given a table named employees with the following structure:
Table: employees
+--------------+----------+
| COLUMN_NAME  | DATA_TYPE|
+--------------+----------+
| employee_id  | INT      |
| name         | VARCHAR  |  
| manager_id   | INT      |
+--------------+----------+
Each row represents an employee. The manager_id column references the employee_id of their manager. 
The top-level manager(s) (e.g., CEO) will have NULL as their manager_id.

Write a SQL query to find employees who do not manage any other employees, ordered in ascending order of employee id.

Expected Output
+-------------+--------+------------+
| employee_id | name   | manager_id |
+-------------+--------+------------+
|           9 | Ivy    |          1 |
|          11 | Lily   |          4 |
|          13 | Nina   |          5 |
|          14 | Oscar  |          6 |
|          16 | Quincy |          7 |
|          17 | Rachel |          7 |
|          18 | Steve  |         20 |
+-------------+--------+------------+
SELECT *
FROM employees
WHERE employee_id NOT IN (
    SELECT DISTINCT manager_id
    FROM employees
    WHERE manager_id IS NOT NULL
)
order by employee_id;
########################################################################################################################
149 - Employees Not Promoted
The promotions table records all historical promotions of employees (an employee can appear multiple times).
Write a query to find all employees who were not promoted in the last 1 year from today. Display id ,
name and latest promotion date for those employees order by id.


Table: employees
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| id          | INT      |
| name        | VARCHAR  |  
+-------------+----------+
Table: promotions
+--------------+----------+
| COLUMN_NAME  | DATA_TYPE|
+--------------+----------+
|emp_id        | INT      |
|promotion_date| DATE     |  
+--------------+----------+

Expected Output
+------+-------+-----------------+
| id   | name  | last_promo_date |
+------+-------+-----------------+
|    4 | David | 2024-01-16      |
|    5 | Eva   | 2023-11-16      |
|    7 | Grace | 2023-09-16      |
|    8 | Hank  | 2023-01-16      |
|    9 | Ivy   | 2024-05-16      |
|   13 | Nina  | NULL            |
|   14 | Oscar | NULL            |
|   15 | Paul  | NULL            |
+------+-------+-----------------+
SELECT e.id, e.name, p.last_promo_date
FROM employees e
LEFT JOIN (
    SELECT emp_id, MAX(promotion_date) AS last_promo_date
    FROM promotions
    GROUP BY emp_id
) p ON e.id = p.emp_id
WHERE p.last_promo_date IS NULL OR p.last_promo_date < DATE_SUB(NOW(), INTERVAL 1 YEAR)
order by e.id;
########################################################################################################################
150 - Employees Current Salary
Hard - 40 Points
In your organization, each employee has a fixed joining salary recorded at the time they start. Over time, employees may receive one or more promotions,
each offering a certain percentage increase to their current salary.
Youre given two datasets:
employees :  contains each employee’s name and joining salary.
promotions:  lists all promotions that have occurred, including the promotion date and the percent increase granted during that promotion.

Your task is to write a SQL query to compute the current salary of every employee by applying each of their promotions increase round to 2 decimal places.
If an employee has no promotions, their current salary remains equal to the joining salary. Order the result by emp id.
	
Table: employees
+--------------+----------+
| COLUMN_NAME  | DATA_TYPE|
+--------------+----------+
| id            | INT     |
| name          | VARCHAR |  
|joining_salary | INT     |  
+--------------+----------+
Table: promotions
+----------------+----------+
| COLUMN_NAME    | DATA_TYPE|
+----------------+----------+
|emp_id          | INT      |
|promotion_date  | DATE     | 
|percent_increase| INT      |   
+--------------+------------+

Expected Output
+------+---------+----------------+----------------+
| id   | name    | initial_salary | current_salary |
+------+---------+----------------+----------------+
|    1 | Alice   |          50000 |          66000 |
|    2 | Bob     |          60000 |          69300 |
|    3 | Charlie |          70000 |        84892.5 |
|    4 | David   |          55000 |       96195.34 |
|    5 | Eva     |          65000 |          78650 |
|    6 | Frank   |          48000 |          55440 |
|    7 | Grace   |          72000 |          77040 |
|    8 | Henry   |          51000 |          51000 |
+------+---------+----------------+----------------+

WITH promotion_multipliers AS (
    SELECT 
        emp_id,
        EXP(SUM(LOG(1 + percent_increase/100))) AS total_multiplier          -- Calculate compounded multiplier for all promotions per employee
    FROM promotions
    GROUP BY emp_id                                                        -- Group by employee to accumulate multipliers
)
SELECT 
    e.id,
    e.name,
    e.joining_salary AS initial_salary,                                  -- Initial salary from employees table
    ROUND(e.joining_salary * IFNULL(pm.total_multiplier, 1), 2) AS current_salary  -- Calculate current salary applying promotion multiplier, default 1 if no promotions
FROM 
    employees e
LEFT JOIN 
    promotion_multipliers pm ON e.id = pm.emp_id                         -- Join promotion multipliers, preserve employees without promotions
ORDER BY 
    e.id;                                                                -- Order results by employee id

########################################################################################################################
151 - Flight Planner System
You are building a flight planner system for a travel application. The system stores data about flights between airports and users who want 
to travel between cities. The planner must help each user find the fastest possible flight route from their source city to their destination city.

Each route may consist of:
A direct flight, or
A two-leg journey with only one stopover at an intermediate city.

A stopover is allowed only if the connecting flight departs at or after the arrival time of the first flight. The second flight must depart 
from the airport where the first one landed. 

Write a SQL query that returns following columns, for each user:

user_id
trip_start_city
middle_city (NULL if its a direct flight)
trip_end_city
trip_time (Total journey duration in minutes)
flight_ids (semicolon-separated , eg: 1 for direct, or 3;5 for one-stop)
Return all possible valid routes, sorted by user_id and shortest duration.

Table: users
+-----------------+----------+
| COLUMN_NAME     | DATA_TYPE|
+-----------------+----------+
| id              | INT      |
| source_city     | VARCHAR  |  
| destination_city| VARCHAR  |  
+--------------+-------------+
Table: airports
+--------------+----------+
| COLUMN_NAME  | DATA_TYPE|
+--------------+----------+
| port_code    | VARCHAR  |
| city_name    | VARCHAR  | 
+-------------------------+
Table: flights
+--------------+----------+
| COLUMN_NAME  | DATA_TYPE|
+--------------+----------+
| flight_id    | VARCHAR  |
| start_port   | VARCHAR  | 
| end_port     | VARCHAR  | 
| start_time   | datetime | 
| end_time     | datetime | 
+-------------------------+

Expected Output
+---------+-----------------+---------------+---------------+-----------+------------+
| user_id | trip_start_city | middle_city   | trip_end_city | trip_time | flight_ids |
+---------+-----------------+---------------+---------------+-----------+------------+
|       1 | New York        | NULL          | Tokyo         |       720 | 1          |
|       1 | New York        | Los Angeles   | Tokyo         |       900 | 2;3        |
|       1 | New York        | Los Angeles   | Tokyo         |       900 | 4;9        |
|       1 | New York        | Los Angeles   | Tokyo         |       960 | 2;9        |
|       3 | New York        | Los Angeles   | Osaka         |       840 | 4;5        |
|       3 | New York        | Los Angeles   | Osaka         |       900 | 2;5        |
|       3 | New York        | San Francisco | Osaka         |       900 | 11;12      |
+---------+-----------------+---------------+---------------+-----------+------------+
WITH user_start_ports AS (
    SELECT u.user_id, a.port_code, a.city_name AS start_city
    FROM users u
    JOIN airports a ON a.city_name = u.source_city
),

-- Get all airports for each user's destination city
user_end_ports AS (
    SELECT u.user_id, a.port_code, a.city_name AS end_city
    FROM users u
    JOIN airports a ON a.city_name = u.destination_city
),

-- Get all valid direct flights for users from any source airport to any destination airport
direct_routes AS (
    SELECT 
        sp.user_id,
        sp.start_city AS trip_start_city,
        NULL AS middle_city,  -- Direct flights have no stopover city
        ep.end_city AS trip_end_city,
        TIMESTAMPDIFF(MINUTE, f.start_time, f.end_time) AS trip_time , -- Total time of journey
        CAST(f.flight_id AS CHAR) AS flight_ids -- Only one flight ID
    FROM flights f
    JOIN user_start_ports sp ON f.start_port = sp.port_code
    JOIN user_end_ports ep ON f.end_port = ep.port_code AND sp.user_id = ep.user_id
),

-- Get all valid one-stop flight routes
-- A valid connection must: 
-- 1. land and depart from the same airport
-- 2. second flight must start after (or at) the end time of the first flight
-- 3. total trip must start from user's source city and end at their destination city
one_stop_routes AS (
    SELECT 
        sp.user_id,
        sp.start_city AS trip_start_city,
        mid.city_name AS middle_city,  -- Stopover city
        ep.end_city AS trip_end_city,
        TIMESTAMPDIFF(MINUTE, f1.start_time, f2.end_time) AS trip_time,  -- Total time of journey
        CONCAT(f1.flight_id, ';', f2.flight_id) AS flight_ids  -- Combined flight IDs
    FROM flights f1
    JOIN flights f2 
        ON f1.end_port = f2.start_port
        AND f1.end_time <= f2.start_time
    JOIN user_start_ports sp ON f1.start_port = sp.port_code
    JOIN user_end_ports ep ON f2.end_port = ep.port_code AND sp.user_id = ep.user_id
    JOIN airports mid ON f1.end_port = mid.port_code  -- Determine middle city from flight connection
)

-- Combine direct and one-stop routes
SELECT * FROM direct_routes
UNION ALL
SELECT * FROM one_stop_routes
ORDER BY user_id, trip_time;

########################################################################################################################
152 - Active Viewers by Day
Medium - 20 Points
In a content platform, users (viewers) can read various articles, and each article may be written by one or more authors (co-authors). 
The platform tracks which articles a viewer reads on each date, and also maintains information about which authors contributed to which articles.
You are tasked with identifying the dates on which a viewer read multiple different articles, and those articles were authored by more than one
distinct author. Note that an article can be co-authored by multiple authors.
Return all (viewer_id, view_date) pairs where the viewer read **more than one unique article** on the same date, and those articles were written
by **at least two different authors**. Sort the result by both columns respectively. 

Table: articles
+--------------+----------+
| COLUMN_NAME  | DATA_TYPE|
+--------------+----------+
| article_id   | INT      |
| author_id    | INT      | 
+-------------------------+
Table: views
+--------------+----------+
| COLUMN_NAME  | DATA_TYPE|
+--------------+----------+
| viewer_id    | INT      | 
| view_date    | date     |
| article_id   | INT      | 
+-------------------------+
Hints
Expected Output
+-----------+------------+
| viewer_id | view_date  |
+-----------+------------+
|         1 | 2024-06-01 |
|         1 | 2024-06-05 |
|         4 | 2024-06-11 |
|         5 | 2024-06-07 |
|         6 | 2024-06-01 |
+-----------+------------+
-- Select viewer and date combinations
SELECT
    v.viewer_id,
    v.view_date
FROM
    views v
-- Join with articles to get author information for each viewed article
JOIN
    articles a ON v.article_id = a.article_id
-- Group by viewer and view date to analyze per day per viewer
GROUP BY
    v.viewer_id,
    v.view_date
-- Keep only those groups where:
-- 1. Viewer read more than one unique article
-- 2. Those articles were written by more than one distinct author
HAVING
    COUNT(DISTINCT v.article_id) > 1
    AND COUNT(DISTINCT a.author_id) > 1
-- Sort results for readability
ORDER BY
    v.viewer_id,
    v.view_date;

########################################################################################################################
153 - Grand Slam Titles
In professional tennis, there are four major tournaments that make up the Grand Slam: Wimbledon, French Open, US Open, and Australian Open.
Each year, these tournaments declare one winner, and winning any of them is a major achievement for a tennis player. 
In championships table the wimbledon, fr_open, us_open and au_open columns have the winner player id.
You are given data from a tennis database. Your task is to write a query to report the total number of Grand Slam tournaments won by each player. 
The result should include all players, even those who have never won a tournament. For such players, the count should be 0
Return the result with columns: player_id, player_name, and grand_slams_count. The result should be sorted by grand_slams_count in descending order.

Table: players
+--------------+----------+
| COLUMN_NAME  | DATA_TYPE|
+--------------+----------+
| player_id    | INT      |
| player_name  | varchar  | 
+-------------------------+
Table: championships
+--------------+----------+
| COLUMN_NAME  | DATA_TYPE|
+--------------+----------+
| year         | INT      | 
| view_date    | date     |
| article_id   | INT      | 
+-------------------------+
Hints
Expected Output
+-----------+-----------------+-------------------+
| player_id | player_name     | grand_slams_count |
+-----------+-----------------+-------------------+
|         1 | Novak Djokovic  |                12 |
|         2 | Rafael Nadal    |                 6 |
|         3 | Roger Federer   |                 2 |
|         5 | Daniil Medvedev |                 2 |
|         4 | Carlos Alcaraz  |                 1 |
|         6 | Jannik Sinner   |                 1 |
|         7 | Andy Murray     |                 0 |
+-----------+-----------------+-------------------+
WITH all_grand_slam_wins AS (
    SELECT wimbledon AS player_id FROM championships
    UNION ALL
    SELECT fr_open FROM championships
    UNION ALL
    SELECT us_open FROM championships
    UNION ALL
    SELECT au_open FROM championships
)
SELECT 
    p.player_id,
    p.player_name,
    COALESCE(COUNT(w.player_id), 0) AS grand_slams_count
FROM 
    players p
LEFT JOIN 
    all_grand_slam_wins w ON p.player_id = w.player_id
GROUP BY 
    p.player_id,
    p.player_name
ORDER BY 
    grand_slams_count DESC;

########################################################################################################################
154 - Student Pairs By Class
A school maintains a record of students SAT scores along with the class they belong to. The academic team wants to analyze which two students in each class have the closest SAT scores. 
This helps in grouping students with similar performance for peer learning programs.
Write a query to return, for each class, the pair of students with the smallest absolute difference in their SAT scores.
Return the class name, the two students names, and their absolute score difference. Order by class.
Note: In each pair, the student with the lexicographically smaller name (alphabetically first) should appear as student1. This helps in consistent comparison and verification of results.

Table: scores
+--------------+----------+
| COLUMN_NAME  | DATA_TYPE|
+--------------+----------+
| student_name | VARCHAR  | 
| class        | VARCHAR  |
| score        | INT      | 
+-------------------------+

Expected Output
+---------+----------+----------+------------+
| class   | student1 | student2 | score_diff |
+---------+----------+----------+------------+
| Class A | Bob      | Charlie  |          5 |
| Class B | Eva      | Frank    |          5 |
| Class C | Ian      | Judy     |         20 |
+---------+----------+----------+------------+
WITH paired_scores AS (
    SELECT 
        s1.class,
        s1.student_name AS student1,
        s2.student_name AS student2,
        ABS(s1.score - s2.score) AS score_diff
    FROM scores s1
    JOIN scores s2
        ON s1.class = s2.class
        AND s1.student_name < s2.student_name
),
ranked_pairs AS (
    SELECT *,
           RANK() OVER (PARTITION BY class ORDER BY score_diff) AS rnk
    FROM paired_scores
)
SELECT 
    class,
    student1,
    student2,
    score_diff
FROM ranked_pairs
WHERE rnk = 1
ORDER BY class;
########################################################################################################################
155 - Top 2 Scores per Student
Medium - 20 Points
You are given a table Students that stores each students subject-wise marks. Your task is to calculate the total marks of the top-performing subjects
for each student (sname), considering ties in marks.
A subject is considered a top-performing subject if its marks are among the top two distinct marks for that student.
If multiple subjects share the same marks, they should all be included if their marks fall within the top two distinct values.
Return each students name and the total marks of these top-performing subjects. order by student name.

Table: students
+--------------+----------+
| COLUMN_NAME  | DATA_TYPE|
+--------------+----------+
| student_name | VARCHAR  | 
| subject_name | VARCHAR  |
| marks        | INT      | 
+-------------------------+

Expected Output
+--------------+-----------------+
| student_name | total_top_marks |
+--------------+-----------------+
| Alice        |             260 |
| Bob          |             365 |
| Charlie      |             434 |
| David        |             158 |
| Emma         |             185 |
+--------------+-----------------+
WITH ranked_marks AS (
    SELECT
        student_name,
        marks,
        DENSE_RANK() OVER (PARTITION BY student_name ORDER BY marks DESC) AS rnk
    FROM students
)
SELECT
    student_name,
    SUM(marks) AS total_top_marks
FROM ranked_marks
WHERE rnk <= 2
GROUP BY student_name
ORDER BY student_name;
########################################################################################################################
156 - Inventory Reconciliation
A retail company tracks product scans using two systems:
System A (table1) logs scans when products arrive at the warehouse.
System B (table2) logs scans when products are shipped out.
Each scan logs only the product ids. Due to delays or duplicates, the number of scans per product can differ between systems.
Write a query to match scans from System A and System B by product ids and scan order (first from system A with first from first B, 
second from A with second from B, etc.). If a scan exists in only one system, show it with NULL in the unmatched column.

Example input

Table : table1 
val1 
1
1
2
Table : table2 
val2 
1
2
2
Example output:
+------+------+
| val1 | val2 |
+------+------+
| 1    | 1    | 
| 1    | null | 
| 2    | 2    | 
| null | 2    | 
+-------------+
Hints
Expected Output
+------+------+
| T1   | T2   |
+------+------+
| A    | A    |
| A    | A    |
| A    | NULL |
| B    | B    |
| B    | NULL |
| C    | C    |
| NULL | C    |
+------+------+
-- mysql 
WITH t1 AS (
    SELECT val1, 
           ROW_NUMBER() OVER (PARTITION BY val1 ORDER BY val1) AS rn
    FROM table1
),
t2 AS (
    SELECT val2, 
           ROW_NUMBER() OVER (PARTITION BY val2 ORDER BY val2) AS rn
    FROM table2
),
left_joined AS (
    SELECT t1.val1 AS T1, t2.val2 AS T2, t1.rn
    FROM t1
    LEFT JOIN t2 ON t1.val1 = t2.val2 AND t1.rn = t2.rn
),
right_joined AS (
    SELECT t1.val1 AS T1, t2.val2 AS T2, t2.rn
    FROM t2
    LEFT JOIN t1 ON t1.val1 = t2.val2 AND t1.rn = t2.rn
    WHERE t1.val1 IS NULL
),
combined AS (
    SELECT * FROM left_joined
    UNION ALL
    SELECT * FROM right_joined
)
SELECT T1, T2
FROM combined
ORDER BY COALESCE(T1, T2), rn;
########################################################################################################################
157 - Salary Growth Analysis
The HR analytics team wants to evaluate employee performance based on their salary progression and promotion history.
Write a query to return a summary for each employee with the following:

 1. `employee_id`
 2. `latest_salary`: most recent salary value
 3. `total_promotions`: number of times the employee got a promotion 
 4. `max_perc_change`: the maximum percentage increase between any two salary changes (round to 2 decimal places)
 5. `never_decreased`: 'Y' if salary never decreased, else 'N'
 6. `RankByGrowth`: rank of the employee based on salary growth (latest_salary / first_salary), tie-breaker = earliest join date

Table: employees
+---------------+----------+
| COLUMN_NAME   | DATA_TYPE|
+---------------+----------+
| employee_id   | INT      | 
| name          | VARCHAR  | 
| join_date     | DATE     | 
| department    | VARCHAR  |  
| intial_salary | INT      | 
+--------------------------+
Table: salary_history
+--------------+----------+
| COLUMN_NAME  | DATA_TYPE|
+--------------+----------+
| employee_id  | INT      | 
| change_date  | DATE     |
| salary       | INT      | 
| promotion    | VARCHAR  | 
+-------------------------+
Hints
Expected Output
+-------------+---------------+------------------+-----------------+-----------------+--------------+
| employee_id | latest_salary | total_promotions | max_perc_change | never_decreased | RankByGrowth |
+-------------+---------------+------------------+-----------------+-----------------+--------------+
|           1 |         70000 |                1 |           80.00 | N               |            2 |
|           2 |         68000 |                2 |           30.77 | Y               |            1 |
|           3 |         72000 |                1 |           10.77 | Y               |            5 |
|           4 |         49000 |                0 |            8.89 | Y               |            6 |
|           5 |         75000 |                2 |           20.97 | Y               |            4 |
|           6 |         75000 |                1 |           87.50 | N               |            3 |
|           7 |         90000 |                0 |            0.00 | Y               |            7 |
+-------------+---------------+------------------+-----------------+-----------------+--------------+
WITH salary_union AS (
    SELECT 
        employee_id,
        join_date AS change_date,
        initial_salary AS salary,
        'No' AS promotion
    FROM employees

    UNION ALL

    SELECT 
        employee_id,
        change_date,
        salary,
        promotion
    FROM salary_history
),

cte AS (
    SELECT 
        su.*,
        RANK() OVER (PARTITION BY employee_id ORDER BY change_date DESC) AS rn_desc,
        RANK() OVER (PARTITION BY employee_id ORDER BY change_date ASC) AS rn_asc,
        LEAD(salary) OVER (PARTITION BY employee_id ORDER BY change_date DESC) AS prev_salary
    FROM salary_union su
),

salary_growth_cte AS (
    SELECT 
        employee_id,
        MAX(CASE WHEN rn_desc = 1 THEN salary END) * 1.0 /
        MAX(CASE WHEN rn_asc = 1 THEN salary END) AS salary_growth,
        MIN(change_date) AS join_date
    FROM cte
    GROUP BY employee_id
),

decrease_flag AS (
    SELECT 
        employee_id,
        MAX(CASE WHEN prev_salary IS NOT NULL AND salary < prev_salary THEN 1 ELSE 0 END) AS has_decreased
    FROM cte
    GROUP BY employee_id
)

-- Final Output
SELECT 
    c.employee_id,
    MAX(CASE WHEN c.rn_desc = 1 THEN c.salary END) AS latest_salary,
    SUM(CASE WHEN c.promotion = 'Yes' THEN 1 ELSE 0 END) AS total_promotions,
    MAX(
  CASE 
    WHEN c.prev_salary IS NOT NULL AND c.prev_salary > 0 
    THEN ROUND((c.salary - c.prev_salary) * 100.0 / c.prev_salary, 2)
    ELSE 0.00
  END
) AS max_perc_change,

    CASE 
        WHEN d.has_decreased = 1 THEN 'N'
        ELSE 'Y'
    END AS never_decreased,

    ROW_NUMBER() OVER (
        ORDER BY sg.salary_growth DESC, sg.join_date ASC
    ) AS RankByGrowth

FROM cte c
JOIN salary_growth_cte sg 
    ON c.employee_id = sg.employee_id
JOIN decrease_flag d 
    ON c.employee_id = d.employee_id

GROUP BY 
    c.employee_id, 
    sg.salary_growth, 
    sg.join_date,
    d.has_decreased

ORDER BY 
    c.employee_id;

########################################################################################################################
158 - Customers with 3 Purchases

Find users who have made exactly three purchases, such that:
1. Their second purchase occurred within 7 days of the first, 
2. Their third purchase occurred at least 30 days after the second, and
3. There is no more purchase after that

Return all user_ids that match the above pattern along with their first_order_date, second_order_date, and third_order_date.

Table: orders
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| order_id    | INT      |
| user_id     | INT      | 
| order_date  | DATE     |
+-------------+----------+
Hints
Expected Output
+---------+------------------+-------------------+------------------+
| user_id | first_order_date | second_order_date | third_order_date |
+---------+------------------+-------------------+------------------+
|       1 | 2024-01-01       | 2024-01-05        | 2024-02-10       |
|       5 | 2024-02-01       | 2024-02-07        | 2024-03-15       |
|       8 | 2024-08-11       | 2024-08-11        | 2024-12-01       |
+---------+------------------+-------------------+------------------+
WITH ordered_purchases AS (
  SELECT
    user_id,
    order_date,
    ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY order_date) AS rn,
    COUNT(*) OVER (PARTITION BY user_id) AS total_orders
  FROM orders
),
pivoted AS (
  SELECT
    user_id,
    MAX(CASE WHEN rn = 1 THEN order_date END) AS first_order_date,
    MAX(CASE WHEN rn = 2 THEN order_date END) AS second_order_date,
    MAX(CASE WHEN rn = 3 THEN order_date END) AS third_order_date
  FROM ordered_purchases
  WHERE total_orders = 3
  GROUP BY user_id
)
SELECT *
FROM pivoted
WHERE DATEDIFF(second_order_date, first_order_date) <= 7 
  AND DATEDIFF(third_order_date, second_order_date) >= 30;
########################################################################################################################
159 - Department Salary Contribution
You are working as a data analyst for a large company that tracks employee salaries across multiple departments.
The leadership team wants to understand how much each department contributes to the company’s total payroll.
Write a SQL query to calculate the percentage of total salary contributed by each department. Round the result to 2 decimal places.

Table: employees
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| emp_id      | INT      |
| dept_id     | INT      | 
| salary      | INT      |
+-------------+----------+
Hints
Expected Output
+---------+-------------------------+
| dept_id | salary_contribution_pct |
+---------+-------------------------+
|      10 |                   14.44 |
|      20 |                   24.85 |
|      30 |                   13.49 |
|      40 |                   30.89 |
|      50 |                   16.33 |
+---------+-------------------------+
SELECT
  dept_id,
  ROUND(SUM(salary) * 100.0 / (SELECT SUM(salary) FROM employees), 2) AS salary_contribution_pct
FROM employees
GROUP BY dept_id
ORDER BY dept_id;
########################################################################################################################
160 - IPv4 Validator
You are given a table logins containing IP addresses as plain text strings.
Each row represents an IP address from a user login attempt. Your task is to validate whether the IP address is a valid IPv4 address or not based on the following criteria:


1- The IP address must contain exactly 4 parts, separated by 3 dots (.).
2- Each part must consist of only numeric digits (no letters or special characters).
3- Each numeric part must be within the inclusive range of 0 to 255.
4- No part should contain leading zeros unless the value is exactly 0.

 

Table: logins
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| ip_address  | VARCHAR  |
+-------------+----------+
Hints
Expected Output
+-----------------+----------+
| ip_address      | is_valid |
+-----------------+----------+
| 192.168.1.1     |        1 |
| 255.255.255.255 |        1 |
| 0.0.0.0         |        1 |
| 256.100.0.1     |        0 |
| 192.168.01.1    |        0 |
| 10.10.10        |        0 |
| abc.def.ghi.jkl |        0 |
| 1.2.3.4         |        1 |
| 172.016.254.1   |        0 |
| 192.168.1.300   |        0 |
| 123.045.067.089 |        0 |
| 127.0.0.10      |        1 |
+-----------------+----------+
SELECT 
  ip_address,
  CASE
    --  Not exactly 3 dots
    WHEN LENGTH(ip_address) - LENGTH(REPLACE(ip_address, '.', '')) != 3 THEN 0

    --  Any part is non-numeric
    WHEN NOT SUBSTRING_INDEX(ip_address, '.', 1) REGEXP '^[0-9]+$' THEN 0
    WHEN NOT SUBSTRING_INDEX(SUBSTRING_INDEX(ip_address, '.', 2), '.', -1) REGEXP '^[0-9]+$' THEN 0
    WHEN NOT SUBSTRING_INDEX(SUBSTRING_INDEX(ip_address, '.', 3), '.', -1) REGEXP '^[0-9]+$' THEN 0
    WHEN NOT SUBSTRING_INDEX(ip_address, '.', -1) REGEXP '^[0-9]+$' THEN 0

    --  Any part > 255
    WHEN CAST(SUBSTRING_INDEX(ip_address, '.', 1) AS UNSIGNED) > 255 THEN 0
    WHEN CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(ip_address, '.', 2), '.', -1) AS UNSIGNED) > 255 THEN 0
    WHEN CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(ip_address, '.', 3), '.', -1) AS UNSIGNED) > 255 THEN 0
    WHEN CAST(SUBSTRING_INDEX(ip_address, '.', -1) AS UNSIGNED) > 255 THEN 0

    --  Leading zeros (length check method)
    WHEN LENGTH(SUBSTRING_INDEX(ip_address, '.', 1)) != LENGTH(CAST(SUBSTRING_INDEX(ip_address, '.', 1) AS UNSIGNED)) THEN 0
    WHEN LENGTH(SUBSTRING_INDEX(SUBSTRING_INDEX(ip_address, '.', 2), '.', -1)) != LENGTH(CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(ip_address, '.', 2), '.', -1) AS UNSIGNED)) THEN 0
    WHEN LENGTH(SUBSTRING_INDEX(SUBSTRING_INDEX(ip_address, '.', 3), '.', -1)) != LENGTH(CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(ip_address, '.', 3), '.', -1) AS UNSIGNED)) THEN 0
    WHEN LENGTH(SUBSTRING_INDEX(ip_address, '.', -1)) != LENGTH(CAST(SUBSTRING_INDEX(ip_address, '.', -1) AS UNSIGNED)) THEN 0

    -- Passed all checks
    ELSE 1
  END AS is_valid
FROM logins;
########################################################################################################################

