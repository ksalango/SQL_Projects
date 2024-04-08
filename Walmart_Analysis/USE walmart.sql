USE walmart; 

-- which year had the highest sales
SELECT 
	YEAR(weekdate) AS sales_year,
    SUM(weekly_sales) AS total_sales
FROM walmart_table
GROUP BY sales_year
ORDER BY total_sales DESC;

-- number of stores in analyisis
SELECT COUNT(distinct store) AS store_count
FROM walmart_table;

-- max and min CPI grouped by year
SELECT MAX(CPI), YEAR(weekdate) AS year_max_cpi
FROM walmart_table
GROUP BY year_max_cpi;

SELECT MIN(CPI), YEAR(weekdate) AS year_min_cpi
FROM walmart_table
GROUP BY year_min_cpi;

-- week with max cpi in each year-is it a holiday? 
SELECT t.CPI AS max_cpi, YEAR(t.weekdate) AS year_max_cpi, t.weekdate, t.holiday_flag
FROM walmart_table AS t
JOIN (
    SELECT YEAR(weekdate) AS year_max_cpi, MAX(CPI) AS max_cpi
    FROM walmart_table
    GROUP BY YEAR(weekdate)
) AS subquery
ON YEAR(t.weekdate) = subquery.year_max_cpi AND t.CPI = subquery.max_cpi;

-- 
SELECT
  holiday_flag,
  AVG(CASE WHEN holiday_flag = 1 THEN CPI END) AS avg_cpi_holiday,
  AVG(CASE WHEN holiday_flag = 0 THEN CPI END) AS avg_cpi_non_holiday,
  AVG(CASE WHEN holiday_flag = 1 THEN weekly_sales END) AS avg_sales_holiday,
  AVG(CASE WHEN holiday_flag = 0 THEN weekly_sales END) AS avg_sales_non_holiday
FROM walmart_table
GROUP BY holiday_flag;

USE walmart;

-- look at seasonality and sales (graph in tableau)

SELECT YEAR(weekdate) AS year, MONTH(weekdate) As month, SUM(weekly_sales)
FROM walmart_table
GROUP BY year, month
ORDER BY year, month; 

-- look at sales during holidays vs non holiday 

SELECT 
  YEAR(weekdate) AS year,
  MONTH(weekdate) AS month, 
    SUM(weekly_sales) AS total_sales, 
    holiday_flag
FROM walmart_table
GROUP BY year, month, holiday_flag
ORDER BY year, month ;

-- Average sales during a holiday and avg. sales non holiday

SELECT 
    CASE 
        WHEN holiday_flag = 1 THEN 'Holiday'
        ELSE 'Non-Holiday'
    END AS period_type,
    AVG(weekly_sales) AS average_sales
FROM walmart_table
GROUP BY period_type;

-- look at average sales during different holidays
SELECT 
    WEEK(weekdate) AS holiday_week,
    AVG(weekly_sales) AS average_sales
FROM walmart_table
WHERE holiday_flag = 1
GROUP BY holiday_week
ORDER BY average_sales DESC;

-- average sales for season
SELECT
    CASE
        WHEN MONTH(weekdate) IN (6, 7, 8) THEN 'Summer'
        WHEN MONTH(weekdate) IN (9, 10, 11) THEN 'Autumn'
        WHEN MONTH(weekdate) IN (12, 1, 2) THEN 'Winter'
        WHEN MONTH(weekdate) IN (3, 4, 5) THEN 'Spring'
        ELSE 'Unknown'
    END AS season,
    AVG(weekly_sales) AS average_sales
FROM walmart_table
GROUP BY season
ORDER BY average_sales DESC;

-- temperature and sales
SELECT weekdate, weekly_sales, temperature
FROM walmart_table;





