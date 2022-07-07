-- BASICS (101)

SELECT year, month, month_name
FROM tutorial.us_housing_units
WHERE year<>1968 -- Not equal to: <> or !=

SELECT west AS West_Region, -- Name columns
      south AS South_Region
  FROM tutorial.us_housing_units
  LIMIT 10 -- Limit no. of rows

SELECT * -- All cols
  FROM tutorial.us_housing_units
WHERE month_name > 'January'

SELECT *
FROM tutorial.us_housing_units
WHERE west > midwest + northeast

-- LIKE keyword
SELECT *
  FROM tutorial.billboard_top_100_year_end
WHERE "group" LIKE 'Snoop%' -- % implies 0 or more characters

-- ILIKE - Case insensitive LIKE
SELECT *
  FROM tutorial.billboard_top_100_year_end
WHERE artist ILIKE 'dr_ke' -- _ implies 1 character
 
 -- IN keyword
SELECT *
  FROM tutorial.billboard_top_100_year_end
WHERE artist IN ('Taylor Swift', 'Usher', 'Ludacris')

-- IS NOT NULL -- non null values
SELECT *
  FROM tutorial.billboard_top_100_year_end
WHERE artist IS NOT NULL

-- ORDER BY
SELECT *
  FROM tutorial.billboard_top_100_year_end
ORDER BY year_rank DESC, year