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
FROM walmart_table
ORDER BY weekly_sales DESC;

-- Season and corresponding weeklys Sales for ANOVA analysis
SELECT
    CASE
        WHEN MONTH(weekdate) IN (12, 1, 2) THEN 'Winter'
        WHEN MONTH(weekdate) IN (3, 4, 5) THEN 'Spring'
        WHEN MONTH(weekdate) IN (6, 7, 8) THEN 'Summer'
        WHEN MONTH(weekdate) IN (9, 10, 11) THEN 'Autumn'
        ELSE 'Unknown'
    END AS season,
    weekly_sales
FROM
    walmart_table
ORDER BY
    weekdate;
    
-- assign seasons a number to perform ANOVA/linear regression in excel
SELECT
    CASE
        WHEN MONTH(weekdate) IN (12, 1, 2) THEN 1
        WHEN MONTH(weekdate) IN (3, 4, 5) THEN 2
        WHEN MONTH(weekdate) IN (6, 7, 8) THEN 3
        WHEN MONTH(weekdate) IN (9, 10, 11) THEN 4
        ELSE 0
    END AS season_number,
    weekly_sales
FROM
    walmart_table
ORDER BY
    weekdate;

-- Holiday vs non holiday data for t test
SELECT weekly_sales, holiday_flag
FROM walmart_table
ORDER BY holiday_flag DESC;