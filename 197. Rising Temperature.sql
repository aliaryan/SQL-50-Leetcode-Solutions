-- Difficulty: Easy
-- ```
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | id            | int     |
-- | recordDate    | date    |
-- | temperature   | int     |
-- +---------------+---------+
-- id is the column with unique values for this table.
-- This table contains information about the temperature on a certain day.

-- ```

-- Write a solution to find all dates' `Id` with higher temperatures compared to its previous dates (yesterday).

-- Table: `Weather`

-- Return the result table in **any order**.

-- The result format is in the following example.

-- **Example 1:**

-- ```
-- Input:
-- Weather table:
-- +----+------------+-------------+
-- | id | recordDate | temperature |
-- +----+------------+-------------+
-- | 1  | 2015-01-01 | 10          |
-- | 2  | 2015-01-02 | 25          |
-- | 3  | 2015-01-03 | 20          |
-- | 4  | 2015-01-04 | 30          |
-- +----+------------+-------------+
-- Output:
-- +----+
-- | id |
-- +----+
-- | 2  |
-- | 4  |
-- +----+
-- Explanation:
-- In 2015-01-02, the temperature was higher than the previous day (10 -> 25).
-- In 2015-01-04, the temperature was higher than the previous day (20 -> 30).
-- ```

sql
SELECT
W1.ID
FROM WEATHER W1
JOIN WEATHER W2
ON W1.RECORDDATE=W2.RECORDDATE + INTERVAL 1 DAY
WHERE W1.TEMPERATURE > W2.TEMPERATURE


-- Solution:

-- Use self join with next day temperature and then add a where condition to filter out the temperature with the ids with higher temperature.

-- - The **`JOIN`** condition **`W1.RECORD_DATE = W2.RECORD_DATE + INTERVAL 1 DAY`** assumes that **`RECORD_DATE`** is a date field and that you have consecutive dates. This condition joins each record in **`W1`** with its previous day's record in **`W2`**.
-- - The **`WHERE`** clause compares the temperature of each date (**`W1`**) with the temperature of the previous date (**`W2`**).

-- Note: This query assumes that you have a continuous series of dates. If there are missing dates, the **`JOIN`** condition will need to be adjusted accordingly. Also, adjust the **`INTERVAL 1 DAY`** part if your data does not have daily records or uses a different date format.

-- ## To make it work for non consecutive dates:

-- A more efficient approach, especially for larger datasets, would be to use a self-join with a row numbering strategy. This method involves assigning a row number to each entry in the dataset based on the **`RECORD_DATE`** and then joining the table with itself based on these row numbers. Here's how you can do it:

-- 1. First, create a temporary table or a Common Table Expression (CTE) where you assign a row number to each record ordered by **`RECORD_DATE`**.
-- 2. Then, perform a self-join on this temporary table or CTE to pair each row with its preceding row.
-- 3. Finally, select the records where the temperature is greater than in the preceding row.

-- Here's the SQL query using a CTE for better readability:


WITH PreviousWeatherData AS
(
    SELECT 
        id,
        recordDate,
        temperature, 
        LAG(temperature, 1) OVER (ORDER BY recordDate) AS PreviousTemperature,
        LAG(recordDate, 1) OVER (ORDER BY recordDate) AS PreviousRecordDate
    FROM 
        Weather
)
SELECT 
    id 
FROM 
    PreviousWeatherData
WHERE 
    temperature > PreviousTemperature
AND 
    recordDate = PreviousRecordDate + interval 1 DAY


-- In this step, we create a Common Table Expression (CTE) named `PreviousWeatherData` using a `WITH` clause. Inside this CTE, we are selecting all the rows from the "Weather" table along with two additional columns:

-- 1. `PreviousTemperature`: The temperature from the previous day, which is obtained using the `LAG()` function with an offset of 1, ordered by `recordDate`.
-- 2. `PreviousRecordDate`: The record date of the previous day, similarly obtained using the `LAG()` function with an offset of 1, ordered by `recordDate`.

-- This setup helps us associate each record with the respective details from the previous day in the same row.

-- In this step, we execute a query on the `PreviousWeatherData` CTE with two conditions in the WHERE clause to filter the required IDs:

-- 1. `temperature > PreviousTemperature`: This condition filters for the days where the temperature was higher than the previous day's temperature.
-- 2. `recordDate = DATE_ADD(PreviousRecordDate, INTERVAL 1 DAY)`: This condition ensures that we are comparing consecutive days. It uses the `DATE_ADD()` function to add an interval of 1 day to the `PreviousRecordDate` and checks if it equals the current `recordDate`.

-- By combining these two conditions with an `AND` clause, we ensure that we only select the IDs where both conditions are met, which are the days when the temperature is higher than the day before.