SELECT DISTINCT city
FROM STATION
WHERE city REGEXP '^[aeiou]';
-- Retrieve distinct cities from the STATION table that start with a vowel
s
SELECT DISTINCT city
FROM STATION
WHERE city REGEXP '^[aeiou]' and city regexp '[aeiou]$';
-- This query retrieves distinct cities from the "STATION" table that both start with a vowel (^[aeiou]) and
-- end with a vowel ([aeiou]$). The AND operator is used to combine the two regular expression conditions.


-- in the start and the end of ant city name
SELECT DISTINCT city
FROM STATION
WHERE NOT city REGEXP '^[aeiou]' and NOT city regexp '[aeiou]$';

-- This query will retrieve the names of students who have marks greater than 75 and then sort them based
-- on the last three characters of their names. If there are ties in the last three characters, the sorting
-- will be done based on the "id" column.
SELECT NAME
FROM students
WHERE MARKS > 75
ORDER BY (RIGHT(NAME, 3)), id;


--In this query, MAX(LAT_N) retrieves the maximum latitude value, MIN(LAT_N) retrieves the minimum latitude value,
-- MIN(LONG_W) retrieves the minimum longitude value, and MAX(LONG_W) retrieves the maximum longitude value from the "STATION" table.
--The ABS function is used to get the absolute value of the differences between these values. Finally, the sum
--of the absolute differences is calculated and returned as the result.
SELECT ABS (MAX(LAT_N) - MIN(LAT_N)) +  ABS (MIN(LONG_W) - MAX(LONG_W))
FROM STATION;

-- Retrieve the sum of the population from the CITY table
SELECT SUM(POPULATION)
FROM CITY
-- Filter the rows based on the value in the DISTRICT column, specifically 'California'
WHERE DISTRICT = 'California';

-- Retrieve the average population from the CITY table
SELECT AVG(POPULATION)
FROM CITY
-- Filter the rows based on the value in the DISTRICT column, specifically 'California'
WHERE DISTRICT = 'California';


-- Retrieve the sum of the population from the CITY table
SELECT SUM(POPULATION)
FROM CITY
-- Filter the rows based on the value in the COUNTRYCODE column, specifically 'JPN'
WHERE COUNTRYCODE = 'JPN';


-- Retrieve the rounded average salary and subtract the rounded average salary without zeros
SELECT ROUND(AVG(SALARY)) - ROUND(AVG(REPLACE(SALARY, 0, "")))
FROM EMPLOYEES;


-- Calculate earnings and count based on salary and months, then retrieve the highest result
SELECT (salary * months) as earnings, COUNT(*)
FROM Employee
GROUP BY earnings
ORDER BY earnings DESC
LIMIT 1;


-- Retrieve the rounded maximum latitude (LAT_N) that is less than 137.2345
SELECT ROUND(MAX(LAT_N), 4)
FROM STATION
WHERE LAT_N < 137.2345;


MEDIAN

-- Calculate the middle row number by dividing the total row count by 2 and rounding down
SET @row_n = (SELECT CAST(FLOOR(COUNT(*)/2) AS SIGNED) FROM STATION);

-- Prepare a statement to select the latitude value rounded to 4 decimal places from the station table
-- The statement orders the rows by latitude and retrieves only 1 row, starting from the middle row determined by @row_n
PREPARE STMT FROM 'SELECT ROUND(LAT_N,4) FROM STATION ORDER BY LAT_N LIMIT 1 OFFSET ?';

-- Execute the prepared statement using the middle row number (@row_n) as the offset parameter
EXECUTE STMT USING @row_n;


-- Select the continent from the COUNTRY table and calculate the rounded-down average population of cities
-- Join the COUNTRY and CITY tables based on the CountryCode column
-- Group the result by continent
SELECT COUNTRY.Continent, FLOOR(AVG(CITY.Population))
FROM COUNTRY
         INNER JOIN CITY ON CITY.CountryCode = COUNTRY.Code
GROUP BY COUNTRY.Continent;


-- Select the name if the grade is greater than or equal to 8, otherwise select NULL
-- Also select the grade and marks columns
-- Retrieve data from the STUDENTS and GRADES tables
-- Filter the results to include only rows where the marks are within the specified range
-- Sort the results in descending order by grade and then by name
SELECT IF(GRADE < 8, NULL, NAME), GRADE, MARKS
FROM STUDENTS
         JOIN GRADES
WHERE MARKS BETWEEN MIN_MARK AND MAX_MARK
ORDER BY GRADE DESC, NAME;


-- Select the sum of the population from the CITY table
-- Join the CITY and COUNTRY tables based on the CountryCode column
-- Filter the result to include only rows where the continent is 'ASIA'
SELECT SUM(CITY.POPULATION)
FROM CITY
         INNER JOIN COUNTRY ON CITY.CountryCode = COUNTRY.Code
WHERE COUNTRY.CONTINENT = 'ASIA';




-- Select the name of cities from the CITY table
-- Join the CITY and COUNTRY tables based on the CountryCode column
-- Filter the result to include only rows where the continent is 'AFRICA'
SELECT CITY.NAME
FROM CITY
         INNER JOIN COUNTRY ON CITY.CountryCode = COUNTRY.Code
WHERE COUNTRY.CONTINENT = 'AFRICA';


-- Advance join
-- Select the ID, age, coins needed, and power from the WANDS and WANDS_PROPERTY tables
-- Join the WANDS and WANDS_PROPERTY tables based on the CODE column
-- Filter the result to include only rows where the wand is not evil and the coins needed is the minimum value for the corresponding power and age combination
-- Sort the result in descending order by power and then by age
SELECT W.ID, P.AGE, W.COINS_NEEDED, W.POWER
FROM WANDS AS W
         JOIN WANDS_PROPERTY AS P
              ON (W.CODE = P.CODE)
WHERE P.IS_EVIL = 0 AND W.COINS_NEEDED = (SELECT MIN(COINS_NEEDED)
                                          FROM WANDS AS X
                                                   JOIN WANDS_PROPERTY AS Y
                                                        ON (X.CODE = Y.CODE)
                                          WHERE X.POWER = W.POWER AND Y.AGE = P.AGE)
ORDER BY W.POWER DESC, P.AGE DESC;