# Cafe Sales Data Cleaning and Analysis

## Overview
This project focuses on cleaning and analyzing the Cafe Sales dataset, which contains various issues such as missing values, inconsistent data, and errors. The aim is to extract insights on sales performance, product popularity, customer behavior, and other trends related to the cafe business. 

The dataset is obtained from Kaggle, under the title [_Cafe Sales - Dirty Data for Cleaning Training_](https://www.kaggle.com/datasets/ahmedmohamed2003/cafe-sales-dirty-data-for-cleaning-training/data). It is intentionally "dirty" to provide an opportunity to practice cleaning techniques, data wrangling, and feature engineering. The dataset contains several data quality issues that need to be addressed before any meaningful analysis can be performed.

## Table of Contents
+ [Purpose](#purpose)
+ [About the Data](#about-the-data)
+ [Approach](#approach)
+ [Key Insights and Findings](#key-insights-and-findings)
+ [Code](#code)
  
## Purpose
The primary goal of this project is to demonstrate the data cleaning process, followed by exploratory data analysis (EDA) to uncover trends and insights about Cafe Sales. Specific objectives include:
+ Cleaning the dataset by handling missing values, correcting data types, and identifying and addressing outliers.
+ Analyzing sales trends, product performance, and customer behaviours.
  
## About the Data
The dataset was obtained from Kaggle, under the title [_Cafe Sales - Dirty Data for Cleaning Training_](https://www.kaggle.com/datasets/ahmedmohamed2003/cafe-sales-dirty-data-for-cleaning-training/data). This dataset contains transactions from a cafe’s sales in 2023. The data contains 8 columns and 9006 rows:
| Column                  | Description                                                                     | Example Values     |
| :---------------------- | :------------------------------------------------------------------------------ | :----------------- |
| Transaction ID          | unique identifier for each transaction                                          | TXN_1234567        |
| Item                    | name of the item purchased                                                      | Coffee, Sandwich   |
| Quantity                | quantity of the item purchased                                                  | 1, 3, UNKNOWN      |
| Price Per Unit          | price of a single unit of the item                                              | 2.00, 4.00         |
| Total Spent             | total amount spent on the transaction - calculated as Quantity * Price Per Unit | 8.00, 12.00        |
| Payment Method          | method of payment used                                                          | Cash, Credit Card  |
| Location                | location where the transaction occurred                                         | In-store, Takeaway |
| Transaction Date        | date of the transaction                                                         | 2023-01-01         |

## Approach
1. **Data Wrangling**: 
	Handling Missing Values: identify and handle missing values in `Item`, `Total Spent`, `Payment Method` etc… 
	Data Type Correction: ensure columns have the correct data types. E.g. `Transaction Date` is type date

2. **Feature Engineering**: 
	Add a new column named `Transaction Year` to give insight of sales in each year.
	Add a new column named `Transaction Month` to give insight of sales in each month of the year.
	Add a new column named `Transaction Day` to give insight of sales on each day of the month.
	Add a new column named `Day of Week` to give insight of sales on each day of the week.
	
3. **Exploratory Data Analysis (EDA)**:
	Perform EDA to uncover patterns, trends, and relationships in the data. Answer key questions, gain deeper insight, refine understanding of the dataset, and meet the aims of this project.

## Key Insights and Findings
**1. What are the top-selling products in the cafe?**
> Juice and Coffee are the top-selling products, with Juice leading, and together they account for approximately 30% of total sales.

**2. What is the trend in sales over the month of November 2023?**
> In November 2023, 56% of transactions were made using digital wallets, followed by Cash as the second most popular payment method, and Credit Card coming in third.

**3. How many unique payment methods does the data have?** 
> The data includes three payment methods: Cash, Credit Card, and Digital Wallet.

**4. Which payment methods are most commonly used by customers?**
> The most commonly used payment method is the Digital Wallet, which accounts for 55% of all transactions.

**5. What is the total revenue by month?** 
>	JAN = $6313.50 \
	FEB = $5917.50 \
	MAR = $6359.50 \
	APR = $6324.00 \
	MAY = $6109.50 \
	JUN = $6579.50 \
	JUL = $6303.00 \
	AUG = $6417.50 \
	SEP = $6087.00 \
	OCT = $6460.50 \
	NOV = $6245.50 \
	DEC = $6209.50

**6. What are the different locations? Which one is the most profitable?** 
> There are two locations: in-store and takeaway. In-store is significantly more profitable, contributing 70% of total sales, compared to takeaway.

## Code
For the rest of the code, check the [cafe_sales_cleaning_and_analysis.sql](https://github.com/osmanshd/cafe-sales-data-cleaning/blob/main/cafe_sales_cleaning_and_analysis.sql) file

```sql
## create database
CREATE DATABASE IF NOT EXISTS cafe_sales;

## create staging table 
CREATE TABLE sales_staging
LIKE sales;

INSERT sales_staging
SELECT *
FROM sales;
```
