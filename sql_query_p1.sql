-- Create a Databse using this query
CREATE DATABASE `sql_projects_p2`;

-- Use this created database using this query
USE `sql_projects_p2`;

-- Check the table is not exists then creata 
DROP TABLE IF EXISTS `retail_sales`;
CREATE TABLE `retail_sales`(
     transaction_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(20),
    category VARCHAR(20),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);

-- Show the table details
SELECT * FROM `retail_sales`;

-- Set the Limit of tabele list
SELECT * FROM `retail_sales` LIMIT 10;

-- Check the total count of table column
SELECT COUNT(*) FROM `retail_sales`;

-- Check the table column data value is Null
SELECT * FROM `retail_sales` WHERE transaction_id IS NULL;

-- Check which columns or rows have NULL values
SELECT *
FROM `retail_sales`
WHERE transaction_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR customer_id IS NULL
   OR gender IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;

-- Delet which column or row have Null value

DELETE FROM `retail_sales` WHERE
transaction_id IS NULL
OR sale_date IS NULL
OR sale_time IS NULL
OR customer_id IS NULL
OR gender IS NULL
OR category IS NULL
OR quantity IS NULL
OR price_per_unit IS NULL
OR cogs IS NULL
OR total_sale IS NULL;

--- Data Exploration

--- How many sales we have?
SELECT COUNT(*) AS total_sale FROM `retail_sales`;


--- How many customers or unique customers we have?
SELECT COUNT (customer_id) AS total_sale FROM `retail_sales`;

---Unique
SELECT COUNT(DISTINCT customer_id) AS total_sale FROM `retail_sales`;


--- How many category or unique category we have?
SELECT category FROM `retail_sales`;

---Unique
SELECT DISTINCT category FROM `retail_sales`;



----Data Analysis & Bussiness Key Problems & Answers

--Q.1 Write a SQL query to retrive all the columns for sales made in '2022-07-07'.
SELECT * FROM `retail_sales` WHERE sale_date = '2022-07-07';


--Q.2 Write a SQL query to retrive all the transaction where the category is 'Clothing' & the qantity sold is more than 10 in the month of Nov-2022.

--Query 1: Summing Quantity for "Clothing" Category in 2023
SELECT
    category, 
    SUM(quantity) AS total_quantity
FROM `retail_sales`
WHERE category = 'Clothing'
  AND DATE_FORMAT(sale_date, '%Y') = '2023';

--Query 2: Select All Columns for "Clothing" Category in 2025
SELECT * 
FROM `retail_sales`
WHERE category = 'Clothing'
  AND DATE_FORMAT(sale_date, '%Y') = '2025';


--Q.3 Write a SQl query to calculate the total sales (total_sales) for each category.
Select category, SUM(total_sale) AS net_sale,
COUNT (*) AS total_orders
FROM `retail_sales`
GROUP BY 1;


--Q.4 Write a SQL query to find the average gender of customers who purchased items from the 'Clothing' category.
SELECT gender, COUNT(*) AS gender_count
FROM `retail_sales`
WHERE category = 'Clothing'
GROUP BY 1;


--Q.5 Write a SQL query to find all transactions where the total_sale is greater then 1000.
SELECT * FROM `retail_sales` WHERE total_sale > 1000;


--Q.6 Write a SQL query to find the total number of transaction (transaction_id) made by each gender in each category.
SELECT category, gender, COUNT(*)
AS total_tramsaction FROM `retail_sales` GROUP BY category, gender
ORDER BY 1;


--Q.7 Write a SQL query to calculate the average for each month. Find out best selling month in each year.
SELECT * FROM
(
SELECT 
YEAR(sale_date) AS year,
MONTH(sale_date) AS month,
AVG(total_sale) AS avg_sale,
RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS rank
FROM `retail_sales` 
GROUP BY 1, 2
) AS t1
WHERE rank = 1;


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales.
SELECT
customer_id,
SUM(total_sale) AS total_sales
FROM `retail_sales`
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT category,
COUNT(DISTINCT customer_id) AS count_unique_customer
FROM `retail_sales`
GROUP BY category;


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon <=12, Afternoon Between 12 & 17, Evening > 17).
WITH hourly_sale
AS(
    SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN  12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
        END AS shift
        FROM retail_sales
)
SELECT 
shift,
COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;

