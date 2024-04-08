-- look at linear regression for CPI , fuel price, unemployment
SELECT
    weekly_sales,
    CPI,
    fuel_price,
    unemployment
FROM
    walmart_table;
-- max and min
SELECT MAX(unemployment) AS max_unemployment_rate,
MIN(unemployment) AS min_unemployment_rate
FROM walmart_table;

-- create a new variable to see interaction between winter and temperature weekly sales
SELECT
  subquery.season,
  subquery.temperature,
  subquery.season * subquery.temperature AS interaction,
  subquery.weekly_sales
FROM (
  SELECT
    CASE
      WHEN MONTH(weekdate) IN (12, 1, 2) THEN 1
      WHEN MONTH(weekdate) IN (3, 4, 5) THEN 2
      WHEN MONTH(weekdate) IN (6, 7, 8) THEN 3
      WHEN MONTH(weekdate) IN (9, 10, 11) THEN 4
      ELSE 0
    END AS season,
    temperature,
    weekly_sales
  FROM
    walmart_table
) AS subquery;

-- interaction variable with CPI unemployment and weekly sales
SELECT weekly_sales, 
	CPI, 
    unemployment, 
    (CPI * unemployment) AS interaction_variable
FROM walmart_table;

