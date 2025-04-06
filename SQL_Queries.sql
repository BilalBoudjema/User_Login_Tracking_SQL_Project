-- Create a table to store user information
CREATE TABLE users (
    USER_ID INT PRIMARY KEY,
    USER_NAME VARCHAR(20) NOT NULL,
    USER_STATUS VARCHAR(20) NOT NULL
);

-- Create a table to store login sessions
CREATE TABLE logins (
    USER_ID INT,
    LOGIN_TIMESTAMP DATETIME NOT NULL,
    SESSION_ID INT PRIMARY KEY,
    SESSION_SCORE INT,
    FOREIGN KEY (USER_ID) REFERENCES USERS(USER_ID)
);

-- Insert sample users into the 'users' table
INSERT INTO USERS VALUES (1, 'Alice', 'Active');
INSERT INTO USERS VALUES (2, 'Bob', 'Inactive');
INSERT INTO USERS VALUES (3, 'Charlie', 'Active');
INSERT INTO USERS VALUES (4, 'David', 'Active');
INSERT INTO USERS VALUES (5, 'Eve', 'Inactive');
INSERT INTO USERS VALUES (6, 'Frank', 'Active');
INSERT INTO USERS VALUES (7, 'Grace', 'Inactive');
INSERT INTO USERS VALUES (8, 'Heidi', 'Active');
INSERT INTO USERS VALUES (9, 'Ivan', 'Inactive');
INSERT INTO USERS VALUES (10, 'Judy', 'Active');

-- Insert login session data with unique SESSION_IDs
INSERT INTO LOGINS VALUES (1, '2023-07-15 09:30:00', 1001, 85);
INSERT INTO LOGINS VALUES (2, '2023-07-22 10:00:00', 1002, 90);
INSERT INTO LOGINS VALUES (3, '2023-08-10 11:15:00', 1003, 75); -- Ensure SESSION_ID 1003 is unique
INSERT INTO LOGINS VALUES (4, '2023-08-20 14:00:00', 1004, 88);
INSERT INTO LOGINS VALUES (5, '2023-09-05 16:45:00', 1005, 82);
INSERT INTO LOGINS VALUES (6, '2023-10-12 08:30:00', 1006, 77);
INSERT INTO LOGINS VALUES (7, '2023-11-18 09:00:00', 1007, 81);
INSERT INTO LOGINS VALUES (8, '2023-12-01 10:30:00', 1008, 84);
INSERT INTO LOGINS VALUES (9, '2023-12-15 13:15:00', 1009, 79);

-- Insert logins for Q1 2024
INSERT INTO LOGINS VALUES (1, '2024-01-10 07:45:00', 1011, 86);
INSERT INTO LOGINS VALUES (2, '2024-01-25 09:30:00', 1012, 89);
INSERT INTO LOGINS VALUES (3, '2024-02-05 11:00:00', 1013, 78);
INSERT INTO LOGINS VALUES (4, '2024-03-01 14:30:00', 1014, 91);
INSERT INTO LOGINS VALUES (5, '2024-03-15 16:00:00', 1015, 83);
INSERT INTO LOGINS VALUES (6, '2024-04-12 08:00:00', 1016, 80);
INSERT INTO LOGINS VALUES (7, '2024-05-18 09:15:00', 1017, 82);
INSERT INTO LOGINS VALUES (8, '2024-05-28 10:45:00', 1018, 87);
INSERT INTO LOGINS VALUES (9, '2024-06-15 13:30:00', 1019, 76);
INSERT INTO LOGINS VALUES (10, '2024-06-25 15:00:00', 1010, 92);
INSERT INTO LOGINS VALUES (10, '2024-06-26 15:45:00', 1020, 93);
INSERT INTO LOGINS VALUES (10, '2024-06-27 15:00:00', 1021, 92);
INSERT INTO LOGINS VALUES (10, '2024-06-28 15:45:00', 1022, 93);

-- Additional login entries for detailed testing and analysis
INSERT INTO LOGINS VALUES (1, '2024-01-10 07:45:00', 1101, 86);
INSERT INTO LOGINS VALUES (3, '2024-01-25 09:30:00', 1102, 89);
INSERT INTO LOGINS VALUES (5, '2024-01-15 11:00:00', 1103, 78);
INSERT INTO LOGINS VALUES (2, '2023-11-10 07:45:00', 1201, 82);
INSERT INTO LOGINS VALUES (4, '2023-11-25 09:30:00', 1202, 84);
INSERT INTO LOGINS VALUES (6, '2023-11-15 11:00:00', 1203, 80);

-- Display users who have not logged in for the past 5 months
SELECT l.USER_ID, u.USER_NAME, GETDATE() AS TODAY_DATE, MAX(LOGIN_TIMESTAMP) AS LAST_LOGIN
FROM LOGINS l
JOIN USERS u ON l.USER_ID = u.USER_ID
GROUP BY l.USER_ID, u.USER_NAME
HAVING MAX(LOGIN_TIMESTAMP) < DATEADD(MONTH, -5, CAST(GETDATE() AS DATE)); 
-- Using CAST to ignore time and compare only the date

-- Count of sessions and users per quarter, along with first login date in that quarter
SELECT 
    DATETRUNC(quarter, MIN(LOGIN_TIMESTAMP)) AS first_quarter_date_session,
    COUNT(*) AS session_count,
    COUNT(DISTINCT USER_ID) AS user_count
FROM logins 
GROUP BY DATEPART(quarter , LOGIN_TIMESTAMP);

-- Show users who logged in during January 2024 but did not log in during November 2023
SELECT DISTINCT user_id 
FROM logins
WHERE LOGIN_TIMESTAMP BETWEEN '2024-01-01' AND '2024-01-31'
AND user_id NOT IN (
    SELECT user_id 
    FROM logins 
    WHERE LOGIN_TIMESTAMP BETWEEN '2023-11-01' AND '2023-11-30'
);

-- Percentage change in the number of sessions compared to the previous quarter
WITH cte AS (
    SELECT 
        DATETRUNC(quarter, MIN(LOGIN_TIMESTAMP)) AS first_quarter_date_session,
        COUNT(*) AS session_count,
        COUNT(DISTINCT USER_ID) AS user_count
    FROM logins 
    GROUP BY DATEPART(quarter , LOGIN_TIMESTAMP)
)
SELECT *,
       LAG(session_count, 1) OVER (ORDER BY first_quarter_date_session) AS previous_session_count,
       (session_count - LAG(session_count, 1) OVER (ORDER BY first_quarter_date_session)) * 100.0 
       / NULLIF(LAG(session_count, 1) OVER (ORDER BY first_quarter_date_session), 0) AS percentage_change
FROM cte;

-- Display the user with the highest total session score for each day
WITH cte AS (
    SELECT 
        user_id,
        CAST(login_timestamp AS DATE) AS login_date,
        SUM(session_score) AS score
    FROM logins
    GROUP BY user_id, CAST(login_timestamp AS DATE)
)
SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY login_date ORDER BY score DESC) AS rn
    FROM cte
) a
WHERE rn = 1;

-- Display users who logged in every single day since their first login
SELECT 
    user_id,
    MIN(CAST(LOGIN_TIMESTAMP AS DATE)) AS first_login,
    DATEDIFF(DAY, MIN(CAST(LOGIN_TIMESTAMP AS DATE)), GETDATE()) + 1 AS number_of_days_required,
    COUNT(DISTINCT CAST(LOGIN_TIMESTAMP AS DATE)) AS number_of_login_days
FROM logins
GROUP BY user_id
HAVING DATEDIFF(DAY, MIN(CAST(LOGIN_TIMESTAMP AS DATE)), GETDATE()) + 1 = COUNT(DISTINCT CAST(LOGIN_TIMESTAMP AS DATE))
ORDER BY user_id;

-- Identify the dates where there were no login sessions at all
WITH cte AS (
    SELECT 
        CAST(MIN(LOGIN_TIMESTAMP) AS DATE) AS first_date,
        CAST(GETDATE() AS DATE) AS last_date
    FROM logins
    UNION ALL
    SELECT 
        DATEADD(DAY, 1, first_date), 
        last_date
    FROM cte
    WHERE first_date < last_date
)
SELECT * 
FROM cte
WHERE first_date NOT IN (
    SELECT DISTINCT CAST(LOGIN_TIMESTAMP AS DATE) FROM logins
)
OPTION (MAXRECURSION 0); -- Use MAXRECURSION with caution: ensure recursion ends within valid limits
