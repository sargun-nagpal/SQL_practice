-- WINDOW FUNCTIONS << with SUM(), AVG(), ..., RANK(), LEAD(), LAG() >>

-- Running sum over durations (D1, D1+D2, D1+D2+D3, ...)
SELECT start_time, duration_seconds,
       SUM(duration_seconds) OVER (ORDER BY start_time) AS running_total
  FROM tutorial.dc_bikeshare_q1_2012

-- PARTITION & ORDER
SELECT start_terminal,
       duration_seconds,
       SUM(duration_seconds) OVER
         (PARTITION BY start_terminal ORDER BY start_time) -- Starts afresh for each start_terminal
         AS running_total
  FROM tutorial.dc_bikeshare_q1_2012
 WHERE start_time < '2012-01-08'
 
-- Exp- Show the duration of each ride as a percentage of the total time accrued by riders from each start_terminal
SELECT start_terminal,
       duration_seconds,
       SUM(duration_seconds) OVER (PARTITION BY start_terminal) AS start_terminal_sum,
       (duration_seconds/SUM(duration_seconds) OVER (PARTITION BY start_terminal))*100 AS pct_of_total_time
  FROM tutorial.dc_bikeshare_q1_2012
 WHERE start_time < '2012-01-08'
 ORDER BY 1, 4 DESC
 
 -- Other Functions - MAX, AVG, COUNT etc can be used in the window too.
  
 -- ROW_NUMBER() - row nums for each partition
 SELECT start_terminal,
       start_time,
       duration_seconds,
       ROW_NUMBER() OVER (PARTITION BY start_terminal
                          ORDER BY start_time)
                    AS row_number
  FROM tutorial.dc_bikeshare_q1_2012
 WHERE start_time < '2012-01-08'
 
 
-- RANK & DENSE_RANK - order of values. 
-- RANK skips ranks (1,2,2,2,5); DENSE_RANK does not (1,2,2,2,3)
SELECT start_terminal,
       duration_seconds,
       RANK() OVER (PARTITION BY start_terminal
                    ORDER BY start_time)
              AS rank
  FROM tutorial.dc_bikeshare_q1_2012
 WHERE start_time < '2012-01-08'
 

-- Q** Show the 5 longest rides from each starting terminal, ordered by terminal, and 
--      longest to shortest rides within each terminal.
---- Cant groupby terminal, as multiple values reqd for each terminal
    -- Need to use Window function over terminals with RANK

-- xx - Doesnt work: Normally you can't refer to field aliases in the WHERE clause - use Subquery
SELECT start_terminal,
      duration_seconds,
      RANK() OVER (PARTITION BY start_terminal ORDER BY duration_seconds DESC) AS ranks
FROM tutorial.dc_bikeshare_q1_2012
WHERE ranks <= 5 --- DOESNT WORK as 'ranks' cant be referred to with WHERE: https://stackoverflow.com/questions/8370114/referring-to-a-column-alias-in-a-where-clause
ORDER BY start_terminal, ranks -- 'ranks' can be used with ORDER BY though

-- SOL (Subquery)
SELECT *
  FROM (
        SELECT start_terminal,
               start_time,
               duration_seconds AS trip_time,
               RANK() OVER (PARTITION BY start_terminal ORDER BY duration_seconds DESC) AS rank
          FROM tutorial.dc_bikeshare_q1_2012
               ) sub
 WHERE sub.rank <= 5
 
 
 
-- LEAD & LAG -  LAG pulls from previous rows and LEAD pulls from following rows
SELECT start_terminal,
       duration_seconds,
       LAG(duration_seconds, 1) OVER (PARTITION BY start_terminal ORDER BY duration_seconds) AS lag,
       LEAD(duration_seconds, 1) OVER (PARTITION BY start_terminal ORDER BY duration_seconds) AS lead
  FROM tutorial.dc_bikeshare_q1_2012
 WHERE start_time < '2012-01-08'
 ORDER BY start_terminal, duration_seconds
 
-- Difference bw rows
SELECT start_terminal,
       duration_seconds,
       duration_seconds - LAG(duration_seconds, 1) OVER
         (PARTITION BY start_terminal ORDER BY duration_seconds)
         AS difference
  FROM tutorial.dc_bikeshare_q1_2012
 WHERE start_time < '2012-01-08'
 ORDER BY start_terminal, duration_seconds
 
---------------------------------------------------------------------------
 
--- EXPLAIN- (Query cost analysis)
 EXPLAIN
SELECT *
  FROM benn.sample_event_table
 WHERE event_date >= '2014-03-01'
   AND event_date < '2014-04-01'
 LIMIT 100