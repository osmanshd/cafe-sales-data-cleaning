/*
Cafe Sales Data Cleaning and Analysis 
*/

## create database
CREATE DATABASE IF NOT EXISTS cafe_sales;

## create staging table 
CREATE TABLE sales_staging
LIKE sales;

INSERT sales_staging
SELECT *
FROM sales;

## data cleaning 

# Standardize Data
-- trim off leading & trailing whitespaces in item name
UPDATE sales_staging 
SET item = TRIM(item);

# Handle missing & incorrect values
-- Fill in missing & incorrect numeric values with mode
-- Total Spent
UPDATE sales_staging
SET `Total Spent` = (SELECT `Total Spent` 
					FROM (
					-- finds the mode
					SELECT `Total Spent`
					FROM sales_staging
					WHERE `Total Spent` != 'ERORR' AND `Total Spent` != 'UNKNOWN' AND `Total Spent` != '' AND `Total Spent` IS NOT NULL
					GROUP BY `Total Spent`
					ORDER BY COUNT(`Total Spent`) DESC
					LIMIT 1
					) AS total_mode
				) 
WHERE `Total Spent` = 'ERROR' OR `Total Spent` = 'UNKNOWN' OR `Total Spent` = '' OR `Total Spent` IS NULL;
-- convert 'Total Spent' to double data type
ALTER TABLE sales_staging
MODIFY COLUMN `Total Spent` DOUBLE;

-- Fill in missing & incorrect categorical values with mode 
-- Item 
UPDATE sales_staging
SET Item = (SELECT Item 
			FROM (
				-- finds the mode
				SELECT Item
				FROM sales_staging
				WHERE Item != 'ERORR' AND Item != 'UNKNOWN' AND Item != '' AND Item IS NOT NULL
				GROUP BY Item
				ORDER BY COUNT(Item) DESC
				LIMIT 1
				) AS item_mode
			) 
WHERE Item = 'ERROR' OR Item = 'UNKNOWN' OR Item = '' OR Item IS NULL;

-- Payment Method
UPDATE sales_staging
SET `Payment Method` = (SELECT `Payment Method` 
						FROM (
							-- finds the mode
                            SELECT `Payment Method`
							FROM sales_staging
							WHERE (`Payment Method` != 'ERROR' AND `Payment Method` != 'UNKNOWN' 
									AND `Payment Method` != '' AND `Payment Method` IS NOT NULL)
							GROUP BY `Payment Method`
							ORDER BY COUNT(`Payment Method`) DESC
							LIMIT 1
							) AS payment_mode
						) 
WHERE `Payment Method` = 'ERROR' OR `Payment Method` = 'UNKNOWN' OR `Payment Method` = '' OR `Payment Method` IS NULL;

-- Location
UPDATE sales_staging
SET Location = (SELECT Location 
				FROM (
					-- finds the mode
					SELECT Location
					FROM sales_staging
					WHERE (Location != 'ERROR' AND Location != 'UNKNOWN' AND Location != '' AND Location IS NOT NULL)
					GROUP BY Location
					ORDER BY COUNT(Location) DESC
					LIMIT 1
					) AS location_mode
				) 
WHERE Location = 'ERROR' OR Location = 'UNKNOWN' OR Location = '' OR Location IS NULL;

# Date Consistency 
-- replace invalid entries with NULL
UPDATE sales_staging 
SET `Transaction Date` = NULL
WHERE `Transaction Date` = 'ERROR' OR `Transaction Date` = 'UNKNOWN' OR `Transaction Date` = '' OR `Transaction Date` IS NULL;

-- convert 'Transaction Date' to date data type
ALTER TABLE sales_staging
MODIFY COLUMN `Transaction Date` DATE;

# Price Consistency 
-- ensure all prices match menu prices 
UPDATE sales_staging
SET Item = (
CASE
	WHEN `Price Per Unit` = 2 THEN 'Coffee'
    WHEN `Price Per Unit` = 1.5 THEN 'Tea'
    WHEN `Price Per Unit` = 5 THEN 'Salad'
    WHEN `Price Per Unit` = 1 THEN 'Cookie'
    ELSE Item
END);

# Feature Engineering
-- add new columns called 'Transaction Year', 'Transaction Month', 'Transaction Day', 'Day of Week' to give insight into sale date
-- Year
ALTER TABLE sales_staging
ADD COLUMN `Transaction Year` INT;
UPDATE sales_staging
SET `Transaction Year` = YEAR(`Transaction Date`);

-- Month
ALTER TABLE sales_staging
ADD COLUMN `Transaction Month` INT;
UPDATE sales_staging
SET `Transaction Month` = MONTH(`Transaction Date`);

-- Day
ALTER TABLE sales_staging
ADD COLUMN `Transaction Day` INT;
UPDATE sales_staging
SET `Transaction Day` = DAY(`Transaction Date`);

-- Day of Week
ALTER TABLE sales_staging
ADD COLUMN `Day of Week` varchar(15);
UPDATE sales_staging
SET `Day of Week` = DAYNAME(`Transaction Date`);

-- --------------------------------------------------------------------
-- ---------------------------- Questions ------------------------------
-- --------------------------------------------------------------------
-- 1) What are the top-selling products in the cafe?
SELECT Item, COUNT(Item) AS ct
FROM sales_staging
GROUP BY Item
ORDER BY ct DESC;

-- 2) What is the trend in sales over the month of November 2023?
SELECT `Payment Method`, SUM(`Total Spent`) AS total
FROM sales_staging
WHERE `Transaction Date` LIKE "2023-11-%"
GROUP BY `Payment Method`;

-- 3) How many unique payment methods does the data have?
SELECT DISTINCT `Payment Method`
FROM sales_staging;

-- 4) Which payment methods are most commonly used by customers?
SELECT `Payment Method`, COUNT(`Payment Method`) AS ct
FROM sales_staging
GROUP BY `Payment Method`
ORDER BY ct DESC;

-- 5) What is the total revenue by month? 
SELECT `Transaction Month` AS month, SUM(`Total Spent`) AS total_revenue
FROM sales_staging
GROUP BY month
ORDER BY month;

-- 6) What are the different locations? Which one is the most profitable?
SELECT Location, COUNT(Location) AS ct
FROM sales_staging
GROUP BY Location
ORDER BY ct DESC;