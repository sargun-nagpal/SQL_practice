-- Aggregate Functions: COUNT, SUM, MIN, MAX, AVG
-- GROUPBY, HAVING, ORDER BY, CASE, DISTINCT

SELECT COUNT(*)
  FROM tutorial.aapl_historical_stock_price

SELECT COUNT(high) AS high_count -- (Non-null count of col)
  FROM tutorial.aapl_historical_stock_price
  
SELECT SUM(volume)
  FROM tutorial.aapl_historical_stock_price

-- Q: Calculate the average opening price
SELECT SUM(open)/COUNT(open) AS average_open
FROM tutorial.aapl_historical_stock_price

SELECT MIN(volume) AS min_volume,
      MAX(volume) AS max_volume
  FROM tutorial.aapl_historical_stock_price

SELECT AVG(high) -- [Ignores NULLS: Does not treat them as 0]
  FROM tutorial.aapl_historical_stock_price


-- GROPUBY
SELECT year,
      COUNT(*) AS count
  FROM tutorial.aapl_historical_stock_price
GROUP BY year

SELECT year,
      month,
      COUNT(*) AS count
  FROM tutorial.aapl_historical_stock_price
GROUP BY year, month


-- Q- Calculate the total number of shares traded each month. Order results chronologically.
SELECT year, month, SUM(volume) AS shares_traded
FROM tutorial.aapl_historical_stock_price
GROUP BY year, month
ORDER BY year, month

-- Q- Write a query to calculate the average daily price change in Apple stock, grouped by year.
SELECT year, AVG(close-open) AS avg_change
FROM tutorial.aapl_historical_stock_price
GROUP BY year
ORDER BY year

-- Q- Write a query that calculates the lowest and highest prices each month.
SELECT month, year, MIN(low), MAX(high)
FROM tutorial.aapl_historical_stock_price
GROUP BY year, month
ORDER BY year, month


-- HAVING - "clean" way to filter a query that has been aggregated, but also commonly done 
--              using a <Subquery>.
-- HAVING vs WHERE: HAVING is applied on groups while WHERE is applied on indv rows; 
--                  WHERE is applied before aggregation, while HAVING is applied after aggregation.
-- Order of queries: SELECT, FROM, WHERE, GROUP BY, HAVING
SELECT year,
      month,
      MAX(high) AS month_high
  FROM tutorial.aapl_historical_stock_price
GROUP BY year, month
HAVING MAX(high) > 400
ORDER BY year, month


-- CASE - if/else of SQL;
-- CASE WHEN __ THEN __ ELSE __ END
SELECT player_name,
      year,
      CASE WHEN year = 'SR' THEN 'yes'
            ELSE 'no' END AS is_a_senior
  FROM benn.college_football_players


-- Q- Write a query that includes a column that is flagged "yes" when a player is from California,
--  and sort the results with those players first.
SELECT *,
      CASE WHEN school_name ILIKE '%California%' THEN 'yes'
            ELSE NULL END AS cal_player
FROM benn.college_football_players
ORDER BY cal_player


SELECT player_name,
      weight,
      CASE WHEN weight > 250 THEN 'over 250'
            WHEN weight > 200 AND weight <= 250 THEN '201-250'
            WHEN weight > 175 AND weight <= 200 THEN '176-200'
            ELSE '175 or under' END AS weight_group
  FROM benn.college_football_players

SELECT CASE WHEN year = 'FR' THEN 'FR'
            WHEN year = 'SO' THEN 'SO'
            WHEN year = 'JR' THEN 'JR'
            WHEN year = 'SR' THEN 'SR'
            ELSE 'No Year Data' END AS year_group,
            COUNT(*) AS count
  FROM benn.college_football_players
GROUP BY year_group

-- Q* Write a query that counts the number of 300lb+ players for each of the following 
--    regions: West Coast (CA, OR, WA), Texas, and Other (everywhere else).
SELECT CASE WHEN state IN ('GA', 'OR', 'WA') THEN 'West Coast'
            WHEN state = 'TX' THEN 'Texas'
            ELSE 'Other' END AS roi,
        COUNT(*)
FROM  benn.college_football_players
WHERE weight > 300
GROUP BY roi


-- DISTINCT - Unique values

SELECT DISTINCT month
  FROM tutorial.aapl_historical_stock_price
  
SELECT DISTINCT year, month -- Unique pairs
  FROM tutorial.aapl_historical_stock_price
ORDER BY year, month

SELECT COUNT(DISTINCT month) AS unique_months
  FROM tutorial.aapl_historical_stock_price