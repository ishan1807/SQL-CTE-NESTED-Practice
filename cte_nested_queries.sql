-- 📌 SQL Practice: CTEs & Nested Queries

-- Create and Use Database
CREATE DATABASE CTE_P;
USE CTE_P;

-- 📂 Rename and Setup Tables
ALTER TABLE `employeeid-name-department-salary-managerid`
RENAME TO Employees_Table;

ALTER TABLE `saleid-productid-quantitysold-saledate-totalprice`
RENAME TO Sales_Table;

-- 🔎 View Data
SELECT * FROM Employees_Table;
SELECT * FROM Sales_Table;

-- Check for Invalid Salary Values
SELECT salary
FROM Employees_Table
WHERE salary REGEXP '[^0-9]';

DESCRIBE Employees_Table;


/* =============================================================
   🟢 CTE (Common Table Expressions) Practice
   ============================================================= */

-- Q1️⃣: Find the department with the highest average salary
WITH Avg_Salary AS (
    SELECT department, AVG(salary) AS Average_Salary
    FROM Employees_Table
    GROUP BY department
)
SELECT *
FROM Avg_Salary
ORDER BY Average_Salary DESC
LIMIT 1;


-- Q2️⃣: Recursive CTE - Display Employee Hierarchy
-- (Employee Name, Manager, and Level)
WITH RECURSIVE EmployeeHierarchy AS (
    SELECT Name, ManagerID, 1 AS Level
    FROM Employees_Table
    WHERE ManagerID IS NULL   -- Top-level (no manager)

    UNION ALL

    SELECT e.Name, e.ManagerID, eh.Level + 1
    FROM Employees_Table e
    INNER JOIN EmployeeHierarchy eh ON e.ManagerID = eh.Name
)
SELECT * FROM EmployeeHierarchy;


/* =============================================================
   🔵 Nested Queries Practice
   ============================================================= */

-- Q1️⃣: Employees earning less than the second highest salary
SELECT Name, Salary
FROM Employees_Table
WHERE Salary < (
    SELECT MAX(Salary)
    FROM Employees_Table
    WHERE Salary < (
        SELECT MAX(Salary) FROM Employees_Table
    )
);

-- Q2️⃣: Product IDs with sales above average sale quantity
SELECT Product_ID
FROM Sales_Table
WHERE Quantity_Sold > (
    SELECT AVG(Quantity_Sold) FROM Sales_Table
);

-- Q3️⃣: Departments with NO employee earning above 70,000
SELECT Department
FROM Employees_Table
WHERE Department NOT IN (
    SELECT Department
    FROM Employees_Table
    WHERE Salary > 70000
);
