# 📊 User Login Tracking - SQL Project

## 🧾 Description

This project simulates a user login tracking system using SQL. It includes realistic user data, login sessions, and advanced queries for analyzing user behavior and session statistics over time.

---

## 🗃️ Database Schema

### `USERS` Table

| Column      | Type         | Description                    |
|-------------|--------------|--------------------------------|
| `USER_ID`   | INT          | Primary key (User identifier)  |
| `USER_NAME` | VARCHAR(20)  | Name of the user               |
| `USER_STATUS` | VARCHAR(20) | Status of the user (e.g., Active, Inactive) |

### `LOGINS` Table

| Column           | Type      | Description                               |
|------------------|-----------|-------------------------------------------|
| `USER_ID`        | INT       | Foreign key referencing `USERS.USER_ID`   |
| `LOGIN_TIMESTAMP`| DATETIME  | Date and time of the login session        |
| `SESSION_ID`     | INT       | Primary key (Unique session identifier)   |
| `SESSION_SCORE`  | INT       | Score assigned to the session             |

---

## 📥 Sample Data

- 10 users with varied statuses  
- Dozens of login sessions across multiple months and quarters  
- Data spans from 2023 to 2024

---

## 📌 Key SQL Queries

### 🔍 Inactive Users (Last 5 Months)
Identifies users who haven't logged in within the last five months.

### 🗓️ Sessions by Quarter
Counts the number of sessions and unique users for each quarter using `DATETRUNC`.

### 👥 Active in Jan 2024, Inactive in Nov 2023
Displays users who logged in during January 2024 but not in November 2023.

### 📈 Quarterly Session Growth
Calculates quarter-over-quarter growth using `LAG()` and window functions.

### 🏅 Top Users by Day
Finds the user with the highest total session score for each day.

### 📆 Daily Login Streaks
Lists users who logged in every day between their first login and today.

### 📅 Days Without Logins
Shows all days where no login activity occurred.

---

## 🧠 Concepts Used

- SQL joins and aggregations
- Common Table Expressions (CTEs)
- Window functions: `ROW_NUMBER()`, `LAG()`
- Date functions: `DATEADD`, `DATEDIFF`, `DATETRUNC`, `GETDATE()`
- Recursive CTEs for date generation

---

## 🚀 How to Use

1. Run the schema creation script to set up the database.
2. Insert the sample data.
3. Execute the queries for insights and analysis.

---

## 📊 Applications

- Track and analyze user activity
- Detect retention trends and usage drop-offs
- Build dashboards for login/session metrics
- Support decision-making with clean insights

---

## 👨‍💻 Author

**Bilal Boudjema **  
SQL Explorer | BI Developer  
📧 pro.bilal.boudjema@gmail.com • 

---

