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

