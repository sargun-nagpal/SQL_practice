-- DATA WRANGLING (Strings)

-- LEFT/RIGHT part of string
SELECT incidnt_num,
       date,
       LEFT(date, 10) AS cleaned_date -- Till 10th char
  FROM tutorial.sf_crime_incidents_2014_01

  
-- TRIM (leading/trailing/both '' FROM str_col)
SELECT location, 
       TRIM(both '()' FROM location) AS trimmed_loc -- (abcd) -> abcd
  FROM tutorial.sf_crime_incidents_2014_01
  
SELECT location,
       TRIM(leading '()' FROM location) AS trimmed_loc -- (abcd) -> abcd)
  FROM tutorial.sf_crime_incidents_2014_01
  

-- POSITION (str.find -- 0 if not present)
SELECT incidnt_num,
       descript,
       POSITION('A' IN descript) AS a_position
  FROM tutorial.sf_crime_incidents_2014_01

-- OR STRPOS  
SELECT incidnt_num,
       descript,
       STRPOS(descript, 'A') AS a_position
  FROM tutorial.sf_crime_incidents_2014_01


-- SUBSTR
SELECT incidnt_num,
       date,
       SUBSTR(date, 4, 2) AS day -- SUBSTR(str, start, num_chars)
  FROM tutorial.sf_crime_incidents_2014_01
  
  
-- CONCAT
SELECT incidnt_num,
       date,
       LEFT(date, 10) AS cleaned_date,
       day_of_week,
       CONCAT(day_of_week, ', ', LEFT(date, 10)) AS day_and_date
  FROM tutorial.sf_crime_incidents_2014_01

-- or use ||
SELECT incidnt_num,
       day_of_week,
       LEFT(date, 10) AS cleaned_date,
       day_of_week || ', ' || LEFT(date, 10) AS day_and_date
  FROM tutorial.sf_crime_incidents_2014_01
  
  
---- * Cleaning Dates (Convert to YYYY-MM-DD & typecast to ::date)
SELECT incidnt_num,
       date,
       (SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) || '-' || SUBSTR(date, 4, 2))::date AS cleaned_date
  FROM tutorial.sf_crime_incidents_2014_01


-- COALESCE - Fill Missing Values 
SELECT incidnt_num,
       descript,
       COALESCE(descript, 'No Description') AS non_null_descript
  FROM tutorial.sf_crime_incidents_cleandate
 ORDER BY descript DESC