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
5-
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
9
########################################################################################################################
10
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

########################################################################################################################

########################################################################################################################

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
