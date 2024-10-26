create database Retail_Sales_Analysis;
use Retail_Sales_Analysis;

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
            

select * from retail_sales
order by transaction_id limit 100;

-- Data cleaning
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

-- delect null value
delete from retail_sales
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

select count(*) from retail_sales;

-- Data Exploration 

-- How many sales we have
select count(total_sale) from retail_sales;
select sum(total_sale) from retail_sales;

-- how many unique customern we have
select count(distinct customer_id) from retail_sales;

select distinct category from retail_sales;

-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
select * from retail_sales 
where sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 2 in the month of Nov-2022
SELECT * FROM retail_sales
WHERE category = 'Clothing'
AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11' AND quantity > 2;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select distinct category , sum(total_sale)as total_sales , count(*) as total_orders
from retail_sales
group by category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select  round(avg(age), 2) from retail_sales 
where category ='beauty';

select category , avg(age) from retail_sales 
where category ='beauty'
group by category;
 
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from retail_sales
where total_sale >=1000 
limit 10;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select  category,  gender ,  count(transaction_id) as total_trans 
from retail_sales group by gender, category
order by 1 ;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

WITH Monthly_Averages AS (
    SELECT 
        YEAR(sale_date) AS sale_year,
        MONTH(sale_date) AS sale_month,
        AVG(total_sale) AS average_sale
    FROM 
        retail_sales
    GROUP BY 
        YEAR(sale_date),
        MONTH(sale_date)
        )
SELECT 
    sale_year,
    sale_month,
    average_sale
FROM 
    Monthly_Averages
WHERE 
    (sale_year, average_sale) IN (
        SELECT 
            sale_year, 
            MAX(average_sale) 
        FROM 
            Monthly_Averages 
        GROUP BY 
            sale_year
    )
ORDER BY 
    sale_year;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
select customer_id , sum(total_sale) from retail_sales
group by customer_id -- group by 1
ORDER BY  sum(total_sale) DESC  -- ORDER BY 2 DESC 
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select  category , count(distinct customer_id) from retail_sales
group by 1;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift


