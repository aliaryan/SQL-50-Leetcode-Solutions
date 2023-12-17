-- Difficulty: Easy
-- Table: Users

-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | user_id     | int     |
-- | user_name   | varchar |
-- +-------------+---------+
-- user_id is the primary key (column with unique values) for this table.
-- Each row of this table contains the name and the id of a user.
 

-- Table: Register

-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | contest_id  | int     |
-- | user_id     | int     |
-- +-------------+---------+
-- (contest_id, user_id) is the primary key (combination of columns with unique values) for this table.
-- Each row of this table contains the id of a user and the contest they registered into.
 

-- Write a solution to find the percentage of the users registered in each contest rounded to two decimals.

-- Return the result table ordered by percentage in descending order. In case of a tie, order it by contest_id in ascending order.

-- The result format is in the following example.
SELECT
contest_id,
ROUND(COUNT(DISTINCT USER_ID)*100/(SELECT COUNT(USER_ID) FROM USERS),2) AS percentage
FROM
USERS U
LEFT JOIN REGISTER R
USING(USER_ID)
WHERE contest_id IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC,1
