-- JOINS

SELECT *
  FROM benn.college_football_players players
  JOIN benn.college_football_teams teams -- (default: Inner Join)
    ON teams.school_name = players.school_name

-- Avg weight of player in each team conference
SELECT teams.conference AS conference,
      AVG(players.weight) AS average_weight
  FROM benn.college_football_players players -- players = Alias of 1st table
  JOIN benn.college_football_teams teams  -- teams = Alias of 2nd table
    ON teams.school_name = players.school_name
GROUP BY teams.conference
ORDER BY AVG(players.weight) DESC

-- LEFT JOIN/ LEFT OUTER JOIN
SELECT COUNT(companies.permalink) AS companies_rowcount,
      COUNT(acquisitions.company_permalink) AS acquisitions_rowcount
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_acquisitions acquisitions
    ON companies.permalink = acquisitions.company_permalink
    
-- Count the number of unique companies and unique acquired companies by state. Do not include 
-- results for which there is no state data. Order by the no of acquired companies.
SELECT country_code, state_code,
        COUNT(DISTINCT(companies.permalink)) AS comp,
        COUNT(DISTINCT(acquisitions.company_permalink)) AS comp_acq
FROM tutorial.crunchbase_companies companies
JOIN tutorial.crunchbase_acquisitions acquisitions
ON companies.permalink = acquisitions.company_permalink
WHERE state_code IS NOT NULL
GROUP BY country_code, state_code
ORDER BY comp DESC

-- * Filter a table before joining using AND (Note that WHERE will filter the joined tables)
SELECT companies.permalink AS companies_permalink,
      companies.name AS companies_name,
      acquisitions.company_permalink AS acquisitions_permalink,
      acquisitions.acquired_at AS acquired_date
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_acquisitions acquisitions
    ON companies.permalink = acquisitions.company_permalink
  AND acquisitions.company_permalink != '/company/1000memories' -- Can also be used to join on multiple keys
ORDER BY 1

SELECT companies.permalink,
      companies.name,
      companies.status,
      COUNT(investments.investor_permalink) AS investors
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_investments_part1 investments
    ON companies.permalink = investments.company_permalink
  AND investments.funded_year > companies.founded_year + 5 -- Conditional joining
GROUP BY 1,2, 3


-- Outer Join
SELECT COUNT(CASE WHEN companies.permalink IS NOT NULL AND acquisitions.company_permalink IS NULL
                  THEN companies.permalink ELSE NULL END) AS companies_only,
      COUNT(CASE WHEN companies.permalink IS NOT NULL AND acquisitions.company_permalink IS NOT NULL
                  THEN companies.permalink ELSE NULL END) AS both_tables,
      COUNT(CASE WHEN companies.permalink IS NULL AND acquisitions.company_permalink IS NOT NULL
                  THEN acquisitions.company_permalink ELSE NULL END) AS acquisitions_only
  FROM tutorial.crunchbase_companies companies
  FULL JOIN tutorial.crunchbase_acquisitions acquisitions
    ON companies.permalink = acquisitions.company_permalink

-- Self Join
SELECT DISTINCT japan_investments.company_name,
      japan_investments.company_permalink
  FROM tutorial.crunchbase_investments_part1 japan_investments
  JOIN tutorial.crunchbase_investments_part1 gb_investments -- Same table, diff alias
    ON japan_investments.company_name = gb_investments.company_name
  AND gb_investments.investor_country_code = 'GBR'
  AND gb_investments.funded_at > japan_investments.funded_at
WHERE japan_investments.investor_country_code = 'JPN'
ORDER BY 1


-- UNION ALL (concat)
SELECT *
  FROM tutorial.crunchbase_investments_part1

UNION ALL

SELECT *
  FROM tutorial.crunchbase_investments_part2