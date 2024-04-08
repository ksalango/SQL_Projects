SELECT * FROM kickstarter.country;
-- top 3 countries with most successful campaigns in terms of dollars (total amount pledged)

SELECT 
	c.country_id, 
	SUM(c.pledged) AS total_amount_pledged,
    ct.name AS country_name
FROM 
	campaign AS c
JOIN 
	country AS ct ON ct.id = c.country_id
GROUP BY 
	c.country_id
ORDER BY(2) DESC;

-- how many campaigns are in the US 
SELECT 
	COUNT(country_id) AS total_campaigns_US 
FROM 
	kickstarter.campaign
WHERE 
	country_id = 2;

-- how many successful/ unsuccessful campaings in the US
SELECT 
	outcome, 
    COUNT(country_id) AS campaigns_US 
FROM 
	kickstarter.campaign
WHERE 
	country_id = 2
GROUP BY outcome;

-- Top 3 countries with most successful tabletop games campaigns in terms of pledges
SELECT 
	c.country_id,
    SUM(c.pledged) AS amount_raised_tabletopgames, 
    ct.name AS country_name
FROM 
	campaign AS c
JOIN 
	country AS ct ON ct.id = c.country_id
WHERE 
	sub_category_id =14
GROUP BY 
	c.country_id
ORDER BY(2) DESC;

-- Top 3 countries with most successful campaigns in terms of number of campaigns backed
SELECT 
	c.country_id, 
    count(backers) AS campaigns_backed,
    ct.name AS country_name
FROM 
	campaign AS c
JOIN 
	country AS ct ON ct.id = c.country_id
WHERE 
	backers > 0
GROUP BY
	c.country_id
ORDER BY(2) DESC;



SELECT 
	c.country_id, 
    outcome, 
    count(backers) AS number_campaigns_backed, 
    sum(backers) AS total_backers, 
    ct.name
FROM 
	campaign AS c
JOIN 
	country AS ct ON ct.id = c.country_id
WHERE 
	backers > 0
GROUP BY 
	c.country_id, outcome 
ORDER BY(3) DESC;

USE kickstarter;

SELECT
    outcome,
    AVG(CASE WHEN outcome = 'successful' THEN goal END) AS average_successful_goal,
    AVG(CASE WHEN outcome = 'failed' THEN goal END) AS average_unsuccessful_goal,
    COUNT(*) AS count
FROM
    kickstarter.campaign
WHERE
    outcome IN ('successful', 'failed')
GROUP BY
    outcome;
    
-- does the goal set have an effect on the success/failure of campaign in U.S.
SELECT
    goal AS US_campaign_goal,
    outcome,
    COUNT(*) AS count
FROM
    kickstarter.campaign
WHERE
    country_id = 2
GROUP BY
    goal,
    outcome
ORDER BY 
	goal DESC;
    
-- calculate the means for goals in the US based on outcome

SELECT 
	outcome,
    AVG(goal) AS goal_mean
FROM 
	kickstarter.campaign
WHERE
	outcome IN ('successful', 'failed')
    AND country_id = 2
GROUP BY
	outcome;
    
-- sample size of groups (failed/successful)

SELECT 
	outcome,
    COUNT(*) AS sample_size
FROM
	kickstarter.campaign
WHERE
	country_id = 2
GROUP BY
	outcome; 
    
-- Standard deviation for 2 samples (success/failed) U.S.

SELECT
    outcome,
    STDDEV(goal) AS sample_standard_deviation
FROM
    kickstarter.campaign
WHERE
    outcome IN ('successful', 'failed')
    AND country_id = 2
GROUP BY
    outcome;
    
-- tabletop games goal 15000 and outcome



SELECT outcome, COUNT(*) AS count
FROM kickstarter.campaign
WHERE country_id = 2
  AND goal = 15000
  AND sub_category_id = 14
GROUP BY outcome;

SELECT * FROM kickstarter.campaign;

SELECT
	id,
    name, 
    launched-deadline AS campaign_length
FROM 
	kickstarter.campaign;

SELECT id, name, outcome, abs(datediff(launched,deadline)) AS campaign_length_days 
FROM kickstarter.campaign
ORDER BY(4) DESC;

-- are longer or shorter campaigns successful, 
-- short def as <30 days, long def as >30 days

SELECT
    campaign_duration,
    outcome,
    COUNT(*) AS count
FROM (
    SELECT
        c.*,
        CASE
            WHEN DATEDIFF(c.deadline, c.launched) <= 30 THEN 'Short'
            ELSE 'Long'
        END AS campaign_duration
    FROM
        kickstarter.campaign AS c
) AS subquery
GROUP BY
    campaign_duration,
    outcome
ORDER BY
    campaign_duration;

-- total amount of long and short campaigns
SELECT
    campaign_duration,
    COUNT(*) AS campaign_count
FROM
    (
    SELECT
        CASE
            WHEN ABS(DATEDIFF(launched, deadline)) <= 30 THEN 'Short'
            ELSE 'Long'
        END AS campaign_duration
    FROM
        kickstarter.campaign
    ) AS subquery
GROUP BY
    campaign_duration;

-- do longer or shorter campaigns raise more money? 

SELECT
    CASE
        WHEN ABS(DATEDIFF(launched, deadline)) <= 30 THEN 'Short'
        ELSE 'Long'
    END AS campaign_duration,
    SUM(pledged) AS total_amount_raisedUS
FROM
    kickstarter.campaign
WHERE country_id = 2
GROUP BY
    campaign_duration;
    
-- length of successful tabletop campaigns with goal of 15000 in the US

SELECT
    DATEDIFF(deadline, launched) AS campaign_length_15000
FROM
    kickstarter.campaign
WHERE
    sub_category_id = 14
    AND country_id = 2
    AND goal = 15000
    AND outcome = 'successful';
    
-- success rate of campaigns in the US with goal of 15 000 based on campaign length

SELECT
    CASE
        WHEN DATEDIFF(deadline, launched) <= 30 THEN 'Short'
        WHEN DATEDIFF(deadline, launched) > 30 THEN 'Long'
    END AS campaign_length,
    COUNT(*) AS total_campaigns,
    SUM(CASE WHEN outcome = 'successful' THEN 1 ELSE 0 END) AS successful_campaigns,
    SUM(CASE WHEN outcome = 'failed' THEN 1 ELSE 0 END) AS failed_campaigns,
    (SUM(CASE WHEN outcome = 'successful' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS success_rate
FROM
    kickstarter.campaign
WHERE
    goal = 15000
    AND sub_category_id = 14
    AND country_id = 2
GROUP BY
    campaign_length;

-- length of campaign in the US with 15 000 goal with outcome

SELECT
  DATEDIFF(deadline, launched) AS campaign_length,
  outcome
FROM
  kickstarter.campaign
WHERE
  goal = 15000
  AND country_id =2;

-- length of campaign in US with 15000 goal tabletop games

SELECT
  DATEDIFF(deadline, launched) AS campaign_length_tabletopgames,
  outcome
FROM
  kickstarter.campaign
WHERE
  goal = 15000
  AND country_id =2
  AND sub_category_id = 14;

-- length of campaign in US with 15000 goal tabletop games, including backers, look at engagement

SELECT
  DATEDIFF(deadline, launched) AS campaign_length_tabletopgames,
  outcome,
  backers
FROM
  kickstarter.campaign
WHERE
  goal = 15000
  AND country_id =2
  AND sub_category_id = 14;
  
-- campaign duration and outcome in the US (for graph)
-- are longer or shorter campaigns successful, 
-- short def as <30 days, long def as >30 days

SELECT
    campaign_duration,
    outcome,
    COUNT(*) AS count
FROM (
    SELECT
        c.*,
        CASE
            WHEN DATEDIFF(c.deadline, c.launched) <= 30 THEN 'Short'
            ELSE 'Long'
        END AS campaign_duration
    FROM
        kickstarter.campaign AS c
) AS subquery
WHERE country_id = 2
GROUP BY
    campaign_duration,
    outcome
ORDER BY
    campaign_duration;

-- total amount of long and short campaigns US
SELECT
    campaign_duration,
    COUNT(*) AS total_count
FROM (
    SELECT
        c.*,
        CASE
            WHEN DATEDIFF(c.deadline, c.launched) <= 30 THEN 'Short'
            ELSE 'Long'
        END AS campaign_duration
    FROM
        kickstarter.campaign AS c
    WHERE
        country_id = 2
) AS subquery
GROUP BY
    campaign_duration;
    
-- start and end date of data collection

SELECT
    MIN(launched) AS start_date,
    MAX(launched) AS end_date
FROM
    kickstarter.campaign;

-- majority length of campaigns in US with goal 15 000

SELECT
    DATEDIFF(deadline, launched) AS duration,
    COUNT(*) AS count
FROM
    kickstarter.campaign
WHERE
    country_id = 2
    AND goal = 150000
GROUP BY
    duration
ORDER BY
    count DESC
LIMIT 1;

-- duration of campaign and outcome

SELECT
    outcome,
    COUNT(*) AS count
FROM
    kickstarter.campaign
WHERE
    country_id = 2
    AND goal = 150000
    AND DATEDIFF(deadline, launched) = 30
GROUP BY
    outcome;
-- camapaign duration and avg backers, US tabletop games, goal 15 000
SELECT
  DATEDIFF(deadline, launched) AS campaign_duration,
  AVG(backers) AS average_backers
FROM
  kickstarter.campaign
WHERE
  sub_category_id = 14
  AND country_id = 2
  AND goal = 15000
  AND backers IS NOT NULL
GROUP BY
  campaign_duration
ORDER BY
  campaign_duration;

-- Query to compare campaign duration of 45 days with other durations
SELECT
  DATEDIFF(deadline, launched) AS campaign_duration,
  AVG(backers) AS average_backers,
  COUNT(*) AS campaign_count
FROM
  kickstarter.campaign
WHERE
  sub_category_id = 14
  AND country_id = 2
  AND goal = 15000
  AND backers IS NOT NULL
GROUP BY
  campaign_duration
HAVING
  campaign_duration <> 45 -- Exclude campaign duration of 45 days
ORDER BY
  campaign_duration;

-- mean goal of average successful boardgame campaigns in the US
SELECT AVG(goal) AS mean_goal_successful_USboardgames
FROM kickstarter.campaign
WHERE outcome = 'successful'
    AND country_id = 2
    AND sub_category_id = 14;
    
-- Average pledge/backer for successful boardgame campaings in the US

SELECT AVG(pledged / backers) AS average_pledge_per_backer
FROM kickstarter.campaign
WHERE country_id = 2
    AND sub_category_id = 14
    AND outcome = 'successful'
    AND goal < 60000;
    
-- average amount of backers for successful board game campaigns in US

SELECT AVG(backers) AS mean_backers
FROM kickstarter.campaign
WHERE outcome = 'successful'
    AND country_id = 2
    AND sub_category_id = 14
    AND goal < 60000;
    
-- outliers in goals set for boardgame campaigns in the US

SELECT
  goal,
  (goal - avg_goal) / NULLIF(stddev_goal, 0) AS z_score
FROM (
  SELECT
    goal,
    AVG(goal) AS avg_goal,
    STDDEV(goal) AS stddev_goal
  FROM
    kickstarter.campaign
  WHERE
    country_id = 2
    AND sub_category_id = 14
    AND outcome = 'successful'
    AND goal IS NOT NULL  
  GROUP BY
    goal
) AS subquery;


-- get goals for US successful boardgame campaigns to create histogram
SELECT
	goal AS tabletopgame_campaign_goal_US
FROM kickstarter.campaign
WHERE country_id = 2
	AND sub_category_id = 14
    AND outcome = 'successful';

-- exclude outliers from the avg goal of successful campaigns in the US
SELECT AVG(goal) AS mean_goal_successful_US_subcat14
FROM kickstarter.campaign
WHERE country_id = 2
    AND sub_category_id = 14
    AND outcome = 'successful'
    AND goal < 60000;
    
-- avg. pledge/backer with outlier data points removed

SELECT AVG(pledged / backers) AS average_pledge_per_backer
FROM kickstarter.campaign
WHERE country_id = 2
    AND sub_category_id = 14
    AND outcome = 'successful'
    AND goal < 60000;

-- avg backers/tabletop games campaigns in the US

SELECT AVG(backers) AS average_backers_per_campaign
FROM kickstarter.campaign
WHERE country_id = 2
    AND sub_category_id = 14
    AND outcome = 'successful'
    AND goal < 60000;

-- find relationship between backers and goal

SELECT 
	backers AS backers_for_tabletopgames_US,
    goal AS campaign_goal_tabletopgames_US
FROM 
	kickstarter.campaign
WHERE 
	country_id = 2
    AND sub_category_id = 14;

SELECT MAX(backers), goal
FROM 
	kickstarter.campaign
WHERE 
	country_id = 2
    AND sub_category_id = 14
GROUP BY goal;
    
-- what is the average amount of backers for tabletop campaigns in the US when the goal is 15 000

SELECT AVG(backers) AS average_backers_goal15000
FROM kickstarter.campaign
WHERE country_id = 2
    AND sub_category_id = 14
    AND outcome = 'successful'
    AND goal = 15000;

-- what is the average amount of backers for tabletop campaigns in the US when the goal is 15 000 (regardless of outcome)

SELECT AVG(backers) AS average_backers_goal15000
FROM kickstarter.campaign
WHERE country_id = 2
    AND sub_category_id = 14
    AND goal = 15000;
    
-- average pledge/ backer for successful tabletopgames US, goal; 15 000

SELECT
    SUM(pledged) / SUM(backers) AS average_pledge_per_backer15000
FROM
    kickstarter.campaign
WHERE
    country_id = 2
    AND sub_category_id = 14
    AND outcome = 'successful'
    AND goal = 15000;
    
SELECT
    SUM(pledged) / SUM(backers) AS average_pledge_per_backer
FROM
    kickstarter.campaign
WHERE
    country_id = 2
    AND sub_category_id = 14
    AND goal = 15000;


-- top/bottom 3 categories with most/least backers

SELECT 
	cat.id, 
    SUM(c.backers) AS total_backers,
    cat.name AS category_name
FROM 
	campaign AS c
JOIN 
	sub_category ON sub_category.id = c.sub_category_id
JOIN 
	category AS cat ON cat.id = sub_category.category_id
GROUP BY 
	cat.id
ORDER BY(2) DESC;

-- top/bottom 3 subcategories with most/least backers

SELECT 
	c.sub_category_id, 
    SUM(c.backers) AS total_backers, 
    sub_category.name AS subcategory_name
FROM 
	campaign AS c
JOIN 
	sub_category ON sub_category.id = c.sub_category_id
JOIN 
	category AS cat ON cat.id = sub_category.category_id
GROUP BY 
	c.sub_category_id
ORDER BY(2) DESC;

-- Top/ bottom 3 categories that have raised the most money

SELECT 
	cat.id, 
    SUM(c.pledged) AS total_pledged,
    cat.name AS category_name
FROM 
	campaign AS c
JOIN 
	sub_category ON sub_category.id = c.sub_category_id
JOIN 
	category AS cat ON cat.id = sub_category.category_id
GROUP BY 
	cat.id
ORDER BY(2) DESC;

-- Top/ bottom 3 sub categories that have raised the most money

SELECT 
	c.sub_category_id, 
    SUM(c.pledged) AS total_pledged, 
    sub_category.name AS subcategory_name
FROM 
	campaign AS c
JOIN 
	sub_category ON sub_category.id = c.sub_category_id
JOIN 
	category AS cat ON cat.id = sub_category.category_id
GROUP BY 
	c.sub_category_id
ORDER BY(2) DESC;

-- relationship between backers amount pledged and outcome
SELECT backers, pledged, outcome
FROM kickstarter.campaign
WHERE country_id = 2
  AND sub_category_id = 14
  AND goal = 15000;

SELECT backers, pledged, outcome
FROM kickstarter.campaign
WHERE country_id = 2
  AND goal = 15000;





