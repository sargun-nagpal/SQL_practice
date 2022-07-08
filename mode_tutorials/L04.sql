-- DATETIME & Typecasting

-- Typecast data type
SELECT CAST(funding_total_usd AS varchar) AS funding_total_usd_string, -- Format 1
      founded_at_clean::varchar AS founded_at_string -- Format 2 (easier)
  FROM tutorial.crunchbase_companies_clean_date


-- DATETIME in SQL (Formatted as YYYY-MM-DD)

SELECT companies.permalink,
      companies.founded_at_clean,
      acquisitions.acquired_at_cleaned,
      acquisitions.acquired_at_cleaned - companies.founded_at_clean::timestamp AS time_to_acquisition  
      --Diff bw dates stored as INTERVAL datatype (days)
  FROM tutorial.crunchbase_companies_clean_date companies
  JOIN tutorial.crunchbase_acquisitions_clean_date acquisitions
    ON acquisitions.company_permalink = companies.permalink
WHERE founded_at_clean IS NOT NULL
 

-- Adding time interval
SELECT companies.permalink,
      companies.founded_at_clean,
      companies.founded_at_clean::timestamp + INTERVAL '1 week' AS plus_one_week
                                        -- or INTERVAL '5 days' or '6 months' or '30 seconds'
  FROM tutorial.crunchbase_companies_clean_date companies
WHERE founded_at_clean IS NOT NULL

-- Current date/time
SELECT CURRENT_DATE AS date, -- 2022-07-07 00:00:00 (Only date with start of day time)
       CURRENT_TIME AS time, -- 13:03:47 (Only time)
       CURRENT_TIMESTAMP AS timestamp, -- 2022-07-07 13:03:47 (Date + Time)
       CURRENT_TIMESTAMP AT TIME ZONE 'IST' AS timestamp_ist, -- 2022-07-07 15:03:47
       NOW() AS now -- 2022-07-07 13:03:47

SELECT companies.permalink,
      companies.founded_at_clean,
      NOW() - companies.founded_at_clean::timestamp AS founded_time_ago
  FROM tutorial.crunchbase_companies_clean_date companies
WHERE founded_at_clean IS NOT NULL
ORDER BY founded_time_ago


-- Q *[IMP]- Get the number of companies acquired within 3 years, 5 years, and 10 years of being founded (in 3 separate cols). 
---     Include a column for total companies acquired as well. Group by category and limit to only rows with a founding date.
SELECT companies.category_code,
      COUNT(CASE WHEN acquisitions.acquired_at_cleaned <= companies.founded_at_clean::timestamp + INTERVAL '3 years'
                      THEN 1 ELSE NULL END) AS acquired_3_yrs,
      COUNT(CASE WHEN acquisitions.acquired_at_cleaned <= companies.founded_at_clean::timestamp + INTERVAL '5 years'
                      THEN 1 ELSE NULL END) AS acquired_5_yrs,
      COUNT(CASE WHEN acquisitions.acquired_at_cleaned <= companies.founded_at_clean::timestamp + INTERVAL '10 years'
                      THEN 1 ELSE NULL END) AS acquired_10_yrs,
      COUNT(1) AS total
  FROM tutorial.crunchbase_companies_clean_date companies
  JOIN tutorial.crunchbase_acquisitions_clean_date acquisitions
    ON acquisitions.company_permalink = companies.permalink
WHERE founded_at_clean IS NOT NULL
GROUP BY 1
ORDER BY 5 DESC


---- * Cleaning Dates (Convert to YYYY-MM-DD & typecast to ::date)
SELECT incidnt_num,
       date,
       (SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) || '-' || SUBSTR(date, 4, 2))::date AS cleaned_date
  FROM tutorial.sf_crime_incidents_2014_01


-- EXTRACT elements from Dates
SELECT cleaned_date,
       EXTRACT('year'   FROM cleaned_date) AS year,
       EXTRACT('month'  FROM cleaned_date) AS month,
       EXTRACT('day'    FROM cleaned_date) AS day,
       EXTRACT('hour'   FROM cleaned_date) AS hour,
       EXTRACT('minute' FROM cleaned_date) AS minute,
       EXTRACT('second' FROM cleaned_date) AS second,
       EXTRACT('decade' FROM cleaned_date) AS decade,
       EXTRACT('dow'    FROM cleaned_date) AS day_of_week
  FROM tutorial.sf_crime_incidents_cleandate					