USE COUNTRY;


CREATE TABLE cities (
  name  VARCHAR (50) PRIMARY KEY,
  country_code VARCHAR(50),
  city_proper_pop REAL,
  metroarea_pop   REAL,
  urbanarea_pop   REAL
);


CREATE TABLE countries (
  code                  VARCHAR(50)     PRIMARY KEY,
  name                  VARCHAR (50),
  continent             VARCHAR(50),
  region                VARCHAR(50),
  surface_area          REAL,
  indep_year            INTEGER,
  local_name            VARCHAR(50),
  gov_form              VARCHAR(50),
  capital               VARCHAR(50),
  cap_long              REAL,
  cap_lat               REAL
);


CREATE TABLE languages (
  lang_id               INTEGER     PRIMARY KEY,
  code                  VARCHAR(50),
  name                  VARCHAR(250),
  percent               REAL,
  official              BOOLEAN
);

CREATE TABLE economies (
  econ_id               INTEGER     PRIMARY KEY,
  code                  VARCHAR(50),
  year                  INTEGER,
  income_group          VARCHAR(50),
  gdp_percapita         REAL,
  gross_savings         REAL,
  inflation_rate        REAL,
  total_investment      REAL,
  unemployment_rate     REAL,
  exports               REAL,
  imports               REAL
);

CREATE TABLE currencies (
  curr_id               INTEGER     PRIMARY KEY,
  code                  VARCHAR(50),
  basic_unit            VARCHAR(50),
  curr_code             VARCHAR(50),
  frac_unit             VARCHAR(50),
  frac_perbasic         REAL
);

CREATE TABLE populations (
  pop_id                INTEGER     PRIMARY KEY,
  country_code          VARCHAR(10),
  year                  INTEGER,
  fertility_rate        REAL,
  life_expectancy       REAL,
  size                  REAL
);

CREATE TABLE economies2015 (
  code                  VARCHAR(10)     PRIMARY KEY,
  year                  INTEGER,
  income_group          VARCHAR(50),
  gross_savings         REAL
);

CREATE TABLE economies2019 (
  code                  VARCHAR(10)     PRIMARY KEY,
  year                  INTEGER,
  income_group          VARCHAR(50),
  gross_savings         REAL
);


-- CREATE TABLE countries_plus (
--   name                  VARCHAR,
--   continent             VARCHAR,
--   code                  VARCHAR     PRIMARY KEY,
--   surface_area          REAL,
--   geosize_group         VARCHAR
-- );

CREATE TABLE eu_countries (
  code                  VARCHAR(50)     PRIMARY KEY,
  name                  VARCHAR(50)
);

-- Deriving some information about this data from the tables

-- inflation rate of the countries
-- countries with the highest inflation_rate in 2015
SELECT c.code as country_code, name, e.year, e.inflation_rate
FROM countries AS c
JOIN economies AS e
on c.code = e.code
WHERE year = 2015
ORDER BY e.inflation_rate DESC
LIMIT 20;

-- official languages of countries
SELECT c.name AS country, l.name AS language, official
FROM countries AS c
INNER JOIN languages AS l
USING (code);

SELECT c.name AS country, l.name AS language
FROM countries AS c
INNER JOIN languages AS l
USING(code)
ORDER BY country;

-- data exploration, finding relationship between infertility rate and unemployement rate


SELECT c.name, e.year, fertility_rate, unemployment_rate
FROM countries AS c
INNER JOIN populations AS p
ON c.code = p.country_code
JOIN economies e
USING (code)
-- ORDER BY fertility_rate DESC, unemployment_rate DESC
LIMIT 10;

-- comparing for two different years
SELECT name, e.year, fertility_rate, unemployment_rate
FROM countries AS c
INNER JOIN populations AS p
ON c.code = p.country_code
INNER JOIN economies AS e
ON c.code = e.code
AND p.year = e.year;

-- cities and country table
SELECT 
    c1.name AS city,
    code,
    c2.name AS country,
    region,
    city_proper_pop
FROM cities AS c1
INNER JOIN countries as C2
ON c1.country_code = c2.code
ORDER BY code DESC;

SELECT 
    c1.name AS city,
    code,
    c2.name AS country,
    region,
    city_proper_pop
FROM cities AS c1
LEFT JOIN countries as C2
ON c1.country_code = c2.code
ORDER BY code DESC;

-- countries gdp in 2010
SELECT name, region, gdp_percapita
FROM countries AS c
LEFT JOIN economies AS e
USING (code)
WHERE year  = 2010;

-- calculating the average gdp per capita for the region
SELECT region, AVG(gdp_percapita) AS avg_gdp
FROM countries AS c
LEFT JOIN economies AS e
USING(code)
WHERE year = 2010
GROUP BY region
ORDER BY avg_gdp
LIMIT 5;

-- countries and languages spoken
SELECT countries.name AS country, languages.name AS language, percent
FROM countries
LEFT JOIN languages
USING(code)
ORDER BY language;

-- currencies
SELECT name AS country, code, region, basic_unit
FROM countries
FULL Join currencies 
USING (code)
WHERE region = 'North America' OR name is Null
ORDER BY region;

SELECT 
	c1.name AS country, 
    region, 
    l.name AS language,
	basic_unit, 
    frac_unit
FROM countries as c1 
-- Full join with languages (alias as l)
FULL JOIN languages as l
USING (code)
-- Full join with currencies (alias as c2)
FULL JOIN currencies as c2
USING (code)
WHERE region LIKE 'M%esia';

SELECT c.name AS country, l.name AS language
FROM countries as c
-- Inner join countries as c with languages as l on code
INNER JOIN languages as l
USING (code)
WHERE c.code IN ('PAK','IND')
	AND l.code in ('PAK','IND');
    

SELECT c.name AS country, l.name AS language
FROM countries AS c        
CROSS JOIN languages as l
WHERE c.code in ('PAK','IND')
	AND l.code in ('PAK','IND');
 
 -- Life expectancy
SELECT 
	c.name AS country,
    region,
    life_expectancy AS life_exp
FROM countries AS c
-- Join to populations (alias as p) using an appropriate join
LEFT JOIN populations p
ON c.code = p.country_code
-- Filter for only results in the year 2010
WHERE year = 2010
ORDER by life_exp;


-- Select aliased fields from populations as p1
SELECT 
	p1.country_code, 
    p1.size AS size2010, 
    p2.size AS size2015
FROM populations AS p1
INNER JOIN populations AS p2
USING(country_code);


SELECT *
FROM economies2015
-- Set operation
UNION
-- Select all fields from economies2019
SELECT *
FROM economies2019
ORDER BY code, year;

SELECT code, year
FROM economies
UNION 
SELECT country_code, year
FROM populations
ORDER BY code, year;


-- unique languages here
SELECT DISTINCT(name) 
FROM languages
ORDER BY name;

SELECT DISTINCT name
FROM languages
WHERE code in
    (SELECT code
    FROM countries
    WHERE region = 'Middle East')
ORDER BY name;

SELECT DISTINCT(l.name)
FROM languages l
Left Join countries c
ON l.code = c.code
WHERE region = 'Middle East';

--  those populations where life expectancy is 1.15 times higher than average
SELECT *
FROM populations
WHERE life_expectancy > 1.15 *
  (SELECT AVG(life_expectancy)
   FROM populations
   WHERE year = 2015) 
	 AND year = 2015;
     
SELECT name, country_code, urbanarea_pop
FROM cities
-- Filter using a subquery on the countries table
WHERE name in 
(SELECT capital
FROM countries)
ORDER BY urbanarea_pop DESC;


-- Find top nine countries with the most cities in the database
SELECT countries.name AS country, COUNT(*) AS cities_num
FROM countries
LEFT JOIN cities
ON countries.code = cities.country_code
GROUP BY country
-- Order by count of cities as cities_num
ORDER BY cities_num DESC, country
LIMIT 9;


SELECT local_name, sub.lang_num
FROM countries,
    (SELECT code, COUNT(*) AS lang_num
     FROM languages
     GROUP BY code) AS sub
-- Where codes match    
WHERE countries.code = sub.code
ORDER BY lang_num DESC;


SELECT code, inflation_rate, unemployment_rate
FROM economies
WHERE year = 2015 
  AND code NOT IN
-- Subquery returning country codes filtered on gov_form
	(SELECT code 
  FROM countries
  WHERE gov_form like '%Monarchy%' OR gov_form like '%Republic%')
ORDER BY inflation_rate;



