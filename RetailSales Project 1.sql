create table retail_sales (
transactions_id int  PRIMARY KEY,
sale_date	date,
sale_time	time,
customer_id int,
gender	varchar(15),
age	int,
category varchar(15),
quantity int,
price_per_unit float,
cogs	float,
total_sale float
);

select * from retail_sales;
limit 10

select  count(*)
from retail_sales;--count all rows

select * from retail_sales
where transactions_id IS NULL;

select * from retail_sales
where sale_date IS null;


--to check multiple columns containig null values at once
select * from retail_sales
where 
transactions_id IS NULL
OR 
sale_date IS NULL
OR 
sale_time  IS NULL
OR 
gender IS NULL 
OR 
category is NULL 
OR 
customer_id IS NULL 
OR 
quantity IS NULL
OR 
price_per_unit IS NULL 
OR 
cogs IS NULL
OR  
total_sale IS NULL;


--DELETE NULL ROWS 
delete from retail_sales
WHERE
    transactions_id IS NULL
    OR 
    sale_date IS NULL
OR 
sale_time  IS NULL
OR 
gender IS NULL 
OR 
category is NULL 
OR 
customer_id IS NULL 
OR 
quantity IS NULL
OR 
price_per_unit IS NULL 
OR 
cogs IS NULL
OR  
total_sale IS NULL;

--Data exploration 
--how many sales we have ?
SELECT count(*) as total_sales from retail_sales ;

--how many customers we have 
select count(*) as customer_id from retail_sales;
--how many unique customers means no duplicates
select count(distinct customer_id) from retail_sales;

--how manY Categories we have 
select count(distinct category)from retail_sales;

--Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
--Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
--Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
--Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
--Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
--Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
--Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
--Q.8 Write a SQL query to find the top 5 customers based on the highest total sales
--Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
--Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

--1.Answer 
select * from retail_sales
where sale_date = '2022-11-05';
--2.Answer 
select* from retail_sales
where category = 'Clothing'
AND 
TO_CHAR(sale_date , 'YYYY-MM') = '2022-11'
AND quantity >= 4;
--3.Answer> Write a SQL query to calculate the total sales (total_sale) for each category.
select 
category,
SUM (total_sale) as net_sale,
count(*) as total_orders
from retail_sales
group by 1; 

--4.Answer> Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select 
ROUND(AVG(age),2) as customer_avg_age 
from retail_sales 
where category='Beauty';

--5.Answer>Write a SQL query to find all transactions where the total_sale is greater than 1000.
select 
transactions_id
from retail_sales 
where  total_sale > 1000;

--6.Answer>Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select 
     category, gender,
	 count(*) as total_transactions
	 from retail_sales
group by category, gender  
order by 1 ;
--7.Answer>Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
select * from 
(
select  
EXTRACT(YEAR FROM sale_date) as year ,
EXTRACT(MONTH  FROM sale_date) as month,
AVG(total_sale)  AS avg_sale,
RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date)ORDER BY AVG (total_sale)DESC )AS RANK--rank() is used to extract max sale from month by each year 
from retail_sales 
group by 1,2
) AS t1
where rank = 1


--8.Answer> Write a SQL query to find the top 5 customers based on the highest total sales
SELECT
    customer_id,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

--9.Answer>Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT
    category,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;

-- Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale AS (                                          -- 1
    SELECT *,                                                  -- 2
        CASE                                                   -- 3
            WHEN EXTRACT(HOUR FROM sale_time) <= 12 THEN 'Morning'                -- 4
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 13 AND 17 THEN 'Afternoon'  -- 5
            ELSE 'Evening'                                     -- 6
        END AS shift                                           -- 7
    FROM retail_sales                                          -- 8
)                                                              -- 9
SELECT
    shift,
    COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;

select * from retail_sales ;
