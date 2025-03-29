-- SQL Retail Sales Analysis - P1
CREATE DATABASE sql_project_p2;


-- Create TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
            (
                transactions_id INT PRIMARY KEY,
              sales_date DATE,
              sales_time TIME,
              customer_id INT,  
              gender VARCHAR(15),  
              age INT,
              category VARCHAR(15), 
              quantiy INT,
              price_per_unit FLOAT,
              cogs FLOAT,
              total_sale FLOAT
          );

SELECT * FROM retail_sales
LIMIT 10

SELECT
COUNT(*)
FROM retail_sales

-- DATA CLEANING
SELECT * FROM retail_sales
WHERE transactions_id IS NULL

SELECT * FROM retail_sales
WHERE
     transactions_id IS NULL
     OR
   sales_date IS NULL
   OR
   sales_time IS NULL
   OR 
   gender IS NULL
   OR
   category IS NULL
   OR
   quantiy IS NULL
   OR 
   cogs IS NULL
   OR
   total_sale IS NULL
   
DELETE FROM retail_sales
WHERE
     transactions_id IS NULL
     OR
   sales_date IS NULL
   OR
   sales_time IS NULL
   OR 
   gender IS NULL
   OR
   category IS NULL
   OR
   quantiy IS NULL
   OR 
   cogs IS NULL
   OR
   total_sale IS NULL
   
   
-- Data Exploration
SELECT COUNT(*) as tatal_sale FROM retail_sales
 
--how many customers we have

SELECT COUNT(DISTINCT customer_id) as tatal_sale FROM retail_sales

SELECT COUNT(DISTINCT category) as tatal_sale FROM retail_sales

SELECT DISTINCT category FROM retail_sales

--Data analysis & Business Key Problems & Answers
-- Q.1 Write a SQL quary to Retrive all columns for sales made on '2022-11-05'

SELECT * 
FROM retail_sales
WHERE sales_date = '2022-11-05';

--Q.2

SELECT * 
    FROM retail_sales
    WHERE category = 'Clothing' 
      AND
    TO_CHAR(sales_date,'YYYY-MM') = '2022-11'
    AND
    quantiy >= 4

--Q.3

SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1

--Q.4

SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'

--Q.5

SELECT * FROM retail_sales
WHERE total_sale > 1000 

--Q.6

SELECT 
category,
gender,
COUNT(*) as total_trans
FROM retail_sales
GROUP
BY
category,
gender
ORDER BY 1

--Q.7

SELECT 
year,
month,
avg_sale
FROM
(
SELECT
 EXTRACT(YEAR FROM sales_date) as year,
 EXTRACT(MONTH FROM sales_date) as month,
 AVG(total_sale) as avg_sale,
 RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sales_date) ORDER BY AVG(total_sale) DESC) as rank
 FROM retail_sales
 GROUP BY 1, 2
) as t1
WHERE rank = 1
--ORDER BY 1, 3 DESC

--Q.8

SELECT
customer_id,
SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

--Q.9

SELECT
category,
COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category

--Q.10

WITH hourly_sale
AS
(
SELECT *,
    CASE
	    WHEN EXTRACT(HOUR FROM sales_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sales_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift
FROM retail_sales
)
SELECT 
    shift,
	COUNT(*) as total_orders
FROM hourly_sale
GROUP BY shift