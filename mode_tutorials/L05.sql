--- SUB-QUERIES

-- Example 1 - How many incidents happen, on average, on a Friday in December?
SELECT * FROM tutorial.sf_crime_incidents_2014_01

        -- Think of inner query first: No. of incidents on each date.
SELECT day_of_week,
        date,
        COUNT(incidnt_num) AS incidents
    FROM tutorial.sf_crime_incidents_2014_01
    GROUP BY 1,2

SELECT LEFT(sub.date, 2) AS cleaned_month,
      sub.day_of_week,
      AVG(sub.incidents) AS average_incidents
  FROM (
        SELECT day_of_week,
              date,
              COUNT(incidnt_num) AS incidents
          FROM tutorial.sf_crime_incidents_2014_01
        GROUP BY 1,2
      ) sub
GROUP BY 1,2
ORDER BY 1,2


-- Example 2A -- Records of the earliest date
SELECT *
  FROM tutorial.sf_crime_incidents_2014_01
 WHERE Date = (SELECT MIN(date)
                 FROM tutorial.sf_crime_incidents_2014_01
              )

-- Example 2b -- Records of earliest 5 dates
--              (Subquery works with multiple results returned from inner query when IN is used)
SELECT *
  FROM tutorial.sf_crime_incidents_2014_01
 WHERE Date IN (SELECT date
                 FROM tutorial.sf_crime_incidents_2014_01
                ORDER BY date
                LIMIT 5
              )
              
-- Example 2C - Same as 2B, but with JOIN
SELECT *
  FROM tutorial.sf_crime_incidents_2014_01 incidents
  JOIN ( SELECT date
           FROM tutorial.sf_crime_incidents_2014_01
          ORDER BY date
          LIMIT 5
       ) sub
    ON incidents.date = sub.date
    

-- Example 3 - Rank the table according to how many incidents were reported in a given day  
SELECT incidents.*,
       sub.incidents AS incidents_that_day
  FROM tutorial.sf_crime_incidents_2014_01 incidents
  JOIN ( SELECT date,
          COUNT(incidnt_num) AS incidents
           FROM tutorial.sf_crime_incidents_2014_01
          GROUP BY 1
       ) sub
    ON incidents.date = sub.date
 ORDER BY sub.incidents DESC, time
 
 
 -- Q- Display all rows from the 3 categories with the fewest incidents.
 -- SOL1
SELECT * 
  FROM tutorial.sf_crime_incidents_2014_01 incidents
  WHERE category IN (
      SELECT category
      FROM tutorial.sf_crime_incidents_2014_01 incidents
      GROUP BY category
      ORDER BY COUNT(incidnt_num)
      LIMIT 3
  )
-- SOL2 (JOIN)
SELECT incidents.*,
        incident_counts.inc_cnt AS total_incidents_in_category
  FROM tutorial.sf_crime_incidents_2014_01 incidents
  JOIN (
      SELECT category, COUNT(incidnt_num) AS inc_cnt
      FROM tutorial.sf_crime_incidents_2014_01 incidents
      GROUP BY category
      ORDER BY inc_cnt
      LIMIT 3
  ) incident_counts
  ON incidents.category = incident_counts.category