-- Retail-Sales-Analysis-SQL-Project--P1

CREATE DATABASE sql_project_p2;

-- Create TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
            (
                transaction_id INT PRIMARY KEY,	
                sale_date DATE,	 
                sale_time TIME,	
                customer_id	INT,
                gender	VARCHAR(15),
                age	INT,
                category VARCHAR(15),	
                quantity	INT,
                price_per_unit FLOAT,	
                cogs	FLOAT, 
                total_sale FLOAT
            );

SELECT * FROM retail_sales
LIMIT 10;


SELECT 
    COUNT(*) 
FROM retail_sales;

-- Data Cleaning
SELECT * FROM retail_sales
WHERE transactions_id IS NULL

SELECT * FROM retail_sales
WHERE sale_date IS NULL

SELECT * FROM retail_sales
WHERE sale_time IS NULL

SELECT * FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
-- 
DELETE FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
-- Data Exploration

-- How many sales we have?
SELECT COUNT(*) as total_sale FROM retail_sales

-- How many uniuque customers we have ?

SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sales

SELECT DISTINCT category FROM retail_sales;

-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)


 -- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'

SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

SELECT * 
	-- category,
	-- SUM(quantity)
FROM retail_sales
WHERE 
	category = 'Clothing' 
AND 
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
AND
	quantity >= 4;
-- group by 1;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT 
	category,
	SUM(total_sale) AS net_sale,
	COUNT(*) AS total_order
FROM retail_sales
group by 1;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT 
	category,
	ROUND(AVG(age),2)
	FROM retail_sales
WHERE category = 'Beauty'
GROUP BY 1
;

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000

SELECT * FROM retail_sales
WHERE total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT 
	category,
	gender,
	COUNT(*) AS total_transt
FROM retail_sales
GROUP BY 
	category,
	gender
order by 1;
	
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

Select 
	year,
	month,
	each_month_sale
FROM 
(
--WITH rank_sale AS (
SELECT
	EXTRACT(YEAR FROM sale_date) as year,
	EXTRACT(Month FROM sale_date) as month,
	AVG(total_sale) as each_month_sale,
RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as total_rank
FROM retail_sales
GROUP BY 
	EXTRACT(YEAR FROM sale_date),
	EXTRACT(Month FROM sale_date)
--)
) AS rank_sale
-- select * from rank_sale
WHERE total_rank = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT 
	customer_id,
	SUM(total_sale) as total_sales
	FROM retail_sales
GROUP BY 1
ORDER BY total_sales DESC
limit 5
;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT 
	category,
	COUNT(distinct customer_id) AS unique_customer
FROM retail_sales
GROUP BY 
	category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

SELECT * FROM retail_sales;

WITH hour_shift AS
(
SELECT *,
	CASE
	WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
	WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
ELSE 'Evening'
END AS shift
FROM retail_sales
)
SELECT 
	shift,
	COUNT(*) AS total_sales
FROM hour_shift
GROUP BY shift;
