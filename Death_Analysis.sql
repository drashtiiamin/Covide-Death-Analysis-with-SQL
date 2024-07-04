USE COVID;

SELECT * FROM death;

#find total number of deaths
select count(total_deaths) AS Deaths
from death;

#find total number of deaths by date
select date, count(*) AS Deaths
from death 
group by date
order by date;

#Analyze deaths by LOCATION
SELECT location, count(*) AS Deaths
from death
group by location;

#Analyze deaths percentage by location
SELECT location, round((sum(total_deaths)/sum(population)),5)*100 as percent_of_death, sum(population)
from death
group by location;

#find how many new cases occur in the month of may 2020
SELECT new_cases, date 
FROM death
WHERE date BETWEEN '5/1/20' AND '5/31/20'; #date is text format 

#let's change date column data-type from text to date

SET SQL_SAFE_UPDATES = 0;
ALTER TABLE death ADD COLUMN new_date DATE; #add new column
UPDATE death set new_date = STR_TO_DATE(date,'%m/%d/%y'); #transfer data from date to new_date
SELECT new_date, date from death LIMIT 10; #check the result
ALTER TABLE death DROP COLUMN date; #delete date column
ALTER TABLE death CHANGE COLUMN new_date date DATE; #chnage name of new_date column to date with DATE datatype
SET SQL_SAFE_UPDATES = 1;

#now to retrive date we can use this function month() and year()
SELECT new_cases, date, continent
from death
where MONTH(date) = 5 AND YEAR(date) = 2020;

#Trend Analysis(daily, weekly, monthly)
SELECT new_cases, date, continent
from death
where continent = 'Europe' AND date = '2020-05-01';

#count daily difference of new cases
SELECT 
  new_cases, 
  date, 
  continent,
  new_cases - LAG(new_cases,1) OVER (PARTITION BY continent ORDER BY date) AS daily_difference
FROM death
WHERE date BETWEEN '2020-05-01' AND '2020-05-31'
ORDER BY date;

#give row number table
SELECT *, 
ROW_NUMBER() OVER(PARTITION BY continent ORDER BY new_cases DESC) AS raw_no
From death;

#Calculate total death PERCENT based on location
with CTE_deathrate AS(
SELECT date, location, SUM(total_deaths) AS total_deaths, SUM(total_cases) AS total_cases, ROUND((SUM(total_deaths)/SUM(total_cases))*100,2) AS Percent_of_death
from death
group by location, date
)
#Analysis of hospitalization and death rate
SELECT d.hosp_patients, c.Percent_of_death, c.date, c.location
from death d
join CTE_deathrate c
ON d.date = c.date AND d.location=c.location;



   

















	









