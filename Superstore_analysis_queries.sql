-- Superstore Sales Analysis

-- 01: Data Inspection
create database superstore_sales_dataset;
use superstore_sales_dataset;

-- Inspect the imported dataset
select * from superstore_sales;

-- Investigate repeated Order ID + Product Name combinations.
SELECT `Order ID`,`Product Name`,COUNT(*) AS row_count FROM superstore_sales 
GROUP BY
    `Order ID`,
    `Product Name`
HAVING COUNT(*) > 1
ORDER BY row_count DESC;

-- 02: Overall Performance

-- Baseline dataset and business KPIs
select 
count(*) as total_rows,
count(distinct(`order id`)) as total_orders,
round(sum(`sales`),2) as total_sales,
round(sum(`profit`),2) as total_profit,
round(sum(`profit`)/NULLIF(SUM(`Sales`), 0) * 100,2) as profit_margin
from superstore_sales;

-- 03: Time Trend Analysis

-- Yearly performance
select year(`order date`) as order_year,
round(sum(`sales`),2) as total_sales,
round(sum(`profit`),2) as total_profit,
round((sum(`profit`)/sum(`sales`)*100),2) as profit_margin
from superstore_sales 
group by year(`order date`)
order by year(`order date`); 

-- Monthly performance
select year(`order date`) as order_year,
month(`order date`) as order_month,
round(sum(`sales`),2) as total_sales,
round(sum(`profit`),2) as total_profit,
round((sum(`profit`)/sum(`sales`)*100),2) as profit_margin
from superstore_sales 
group by year(`order date`), month(`order date`)
order by year(`order date`), month(`order date`);

-- Compare each calendar month with the same month in the previous year.
-- This is year-over-year (YoY) comparison by month.
WITH monthly_data AS (
  SELECT YEAR(`order date`) AS order_year,
         MONTH(`order date`) AS order_month,
         SUM(sales) AS total_sales,
         SUM(profit) AS total_profit
  FROM superstore_sales
  GROUP BY YEAR(`order date`), MONTH(`order date`)
),
monthly_comparison AS (
  SELECT order_year, order_month, total_sales, total_profit,
         LAG(total_sales)  OVER (PARTITION BY order_month ORDER BY order_year) AS previous_year_sales,
         LAG(total_profit) OVER (PARTITION BY order_month ORDER BY order_year) AS previous_year_profit
  FROM monthly_data
)
SELECT order_year, order_month,
       ROUND(total_sales, 2) AS total_sales,
       ROUND(previous_year_sales, 2) AS previous_year_sales,
       ROUND((total_sales - previous_year_sales) / NULLIF(previous_year_sales, 0) * 100, 2) AS sales_growth_pct,
       ROUND(total_profit, 2) AS total_profit,
       ROUND(previous_year_profit, 2) AS previous_year_profit,
       ROUND((total_profit - previous_year_profit) / NULLIF(ABS(previous_year_profit), 0) * 100, 2) AS profit_growth_pct
FROM monthly_comparison
ORDER BY order_year, order_month;

-- 04: Category and Subcategory Analysis

-- Category performance by year
select year(`order date`)as order_year, category,
round(sum(sales),2)as total_sales, round(sum(profit),2)as total_profit,
round((sum(profit)/sum(sales))*100,2) as profit_margin,
sum(quantity) as quantity
from superstore_sales
group by category,year(`order date`)
order by  order_year,category;

-- Subcategory performance by year
select year(`order date`)as order_year, category,sub-category,
round(sum(sales),2)as total_sales, round(sum(profit),2)as total_profit,
round((sum(profit)/sum(sales))*100,2) as profit_margin,
sum(quantity) as quantity
from superstore_sales
group by category,sub-category,year(`order date`)
order by  order_year,category;

-- Category performance by year, including average discount
select year(`order date`)as order_year, category,
round(sum(sales),2)as total_sales, round(sum(profit),2)as total_profit,
round((sum(profit)/sum(sales))*100,2) as profit_margin,
sum(quantity) as quantity,
round(avg(discount)*100,2) as avg_discount
from superstore_sales
group by category,year(`order date`)
order by  order_year,category;

-- Subcategory performance by year, including average discount
select year(`order date`)as order_year,category,`sub-category`,
round(sum(sales),2)as total_sales, round(sum(profit),2)as total_profit,
round((sum(profit)/sum(sales))*100,2) as profit_margin,
sum(quantity) as quantity,
round(avg(discount)*100,2) as avg_discount
from superstore_sales
group by category,`sub-category`,year(`order date`)
order by order_year,category;

-- 05: Discount Analysis

-- Discount-band performance of specific sub-categories in 2014 and 2015
SELECT YEAR(`Order Date`) AS order_year,
    CASE
        WHEN Discount = 0 THEN '0% discount'
        WHEN Discount <= 0.20 THEN '1-20% discount'
        WHEN Discount <= 0.50 THEN '21-50% discount'
        ELSE '>50% discount'
    END AS discount_band,
    COUNT(*) AS order_lines,
    SUM(Quantity) AS total_quantity,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(SUM(Profit) / NULLIF(SUM(Sales), 0) * 100, 2) AS profit_margin,
    ROUND(AVG(Discount) * 100, 2) AS avg_discount_pct
FROM superstore_sales
WHERE YEAR(`Order Date`) IN (2014, 2015)
  AND `Sub-Category` = 'Binders'
GROUP BY
    YEAR(`Order Date`),
    CASE
        WHEN Discount = 0 THEN '0% discount'
        WHEN Discount <= 0.20 THEN '1-20% discount'
        WHEN Discount <= 0.50 THEN '21-50% discount'
        ELSE '>50% discount'
    END
ORDER BY order_year, MIN(Discount);

SELECT YEAR(`Order Date`) AS order_year,
    CASE
        WHEN Discount = 0 THEN '0% discount'
        WHEN Discount <= 0.20 THEN '1-20% discount'
        WHEN Discount <= 0.50 THEN '21-50% discount'
        ELSE '>50% discount'
    END AS discount_band,
    COUNT(*) AS order_lines,
    SUM(Quantity) AS total_quantity,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(
        SUM(Profit) / NULLIF(SUM(Sales), 0) * 100, 2
    ) AS profit_margin,
    ROUND(AVG(Discount) * 100, 2) AS avg_discount_pct
FROM superstore_sales
WHERE YEAR(`Order Date`) IN (2014, 2015)
  AND `Sub-Category` = 'Machines'
GROUP BY
    YEAR(`Order Date`),
    CASE
        WHEN Discount = 0 THEN '0% discount'
        WHEN Discount <= 0.20 THEN '1-20% discount'
        WHEN Discount <= 0.50 THEN '21-50% discount'
        ELSE '>50% discount'
    END
ORDER BY order_year, MIN(Discount);

SELECT
    YEAR(`Order Date`) AS order_year,
    CASE
        WHEN Discount = 0 THEN '0% discount'
        WHEN Discount <= 0.20 THEN '1-20% discount'
        WHEN Discount <= 0.50 THEN '21-50% discount'
        ELSE '>50% discount'
    END AS discount_band,
    COUNT(*) AS order_lines,
    SUM(Quantity) AS total_quantity,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(
        SUM(Profit) / NULLIF(SUM(Sales), 0) * 100, 2
    ) AS profit_margin,
    ROUND(AVG(Discount) * 100, 2) AS avg_discount_pct
FROM superstore_sales
WHERE YEAR(`Order Date`) IN (2014, 2015)
  AND `Sub-Category` = 'Bookcases'
GROUP BY
    YEAR(`Order Date`),
    CASE
        WHEN Discount = 0 THEN '0% discount'
        WHEN Discount <= 0.20 THEN '1-20% discount'
        WHEN Discount <= 0.50 THEN '21-50% discount'
        ELSE '>50% discount'
    END
ORDER BY order_year, MIN(Discount);

-- Discount-band performance of specific sub-categories in 2016 and 2017
SELECT
    YEAR(`Order Date`) AS order_year,
    CASE
        WHEN Discount = 0 THEN '0% discount'
        WHEN Discount <= 0.2 THEN '1-20% discount'
        WHEN Discount <= 0.5 THEN '21-50% discount'
        ELSE 'Above 50% discount'
    END AS discount_band,
    COUNT(*) AS order_lines,
    SUM(Quantity) AS total_quantity,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(
        SUM(Profit) / NULLIF(SUM(Sales), 0) * 100, 2
    ) AS profit_margin,
    ROUND(AVG(Profit), 2) AS avg_profit_per_line
FROM superstore_sales
WHERE `Sub-Category` = 'Binders'
  AND YEAR(`Order Date`) IN (2016, 2017)
GROUP BY
    YEAR(`Order Date`),
    CASE
        WHEN Discount = 0 THEN '0% discount'
        WHEN Discount <= 0.2 THEN '1-20% discount'
        WHEN Discount <= 0.5 THEN '21-50% discount'
        ELSE 'Above 50% discount'
    END
ORDER BY order_year, discount_band;

SELECT
    YEAR(`Order Date`) AS order_year,
    CASE
        WHEN Discount = 0 THEN '0% discount'
        WHEN Discount <= 0.2 THEN '1-20% discount'
        WHEN Discount <= 0.5 THEN '21-50% discount'
        ELSE 'Above 50% discount'
    END AS discount_band,
    COUNT(*) AS order_lines,
    SUM(Quantity) AS total_quantity,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(
        SUM(Profit) / NULLIF(SUM(Sales), 0) * 100, 2
    ) AS profit_margin,
    ROUND(AVG(Profit), 2) AS avg_profit_per_line
FROM superstore_sales
WHERE `Sub-Category` = 'Machines'
  AND YEAR(`Order Date`) IN (2016, 2017)
GROUP BY
    YEAR(`Order Date`),
    CASE
        WHEN Discount = 0 THEN '0% discount'
        WHEN Discount <= 0.2 THEN '1-20% discount'
        WHEN Discount <= 0.5 THEN '21-50% discount'
        ELSE 'Above 50% discount'
    END
ORDER BY order_year, discount_band;

SELECT
    YEAR(`Order Date`) AS order_year,
    CASE
        WHEN Discount = 0 THEN '0% discount'
        WHEN Discount <= 0.2 THEN '1-20% discount'
        WHEN Discount <= 0.5 THEN '21-50% discount'
        ELSE 'Above 50% discount'
    END AS discount_band,
    COUNT(*) AS order_lines,
    sum(quantity) as quantity,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(
        SUM(Profit) / NULLIF(SUM(Sales), 0) * 100, 2
    ) AS profit_margin,
    ROUND(AVG(Discount) * 100, 2) AS avg_discount_pct
FROM superstore_sales
WHERE `Sub-Category` = 'Tables'
  AND YEAR(`Order Date`) IN (2016, 2017)
GROUP BY
    YEAR(`Order Date`),
    CASE
        WHEN Discount = 0 THEN '0% discount'
        WHEN Discount <= 0.2 THEN '1-20% discount'
        WHEN Discount <= 0.5 THEN '21-50% discount'
        ELSE 'Above 50% discount'
    END
ORDER BY order_year, discount_band;