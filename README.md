# sql_employeeDB_analysis
# Employee Salary Analysis Project

## Overview
This project uses SQL to analyze employee salaries across departments.  
It demonstrates subqueries, CTEs, self-joins, and window functions with real-world style problems.

## Database Setup
```sql
USE DASH_DB2;

CREATE TABLE Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(250) NOT NULL,
    DeptID INT NULL,
    Salary INT NULL,
    HireDate DATE NULL,
    ManagerID INT NULL
);

-- Insert sample data
INSERT INTO Employees (EmployeeID, FullName, DeptID, Salary, HireDate, ManagerID) VALUES
(1, 'Owens, Kristy', 1, 35000, '2018-01-22', 3),
(2, 'Adams, Jennifer', 1, 55000, '2017-10-25', 5),
(3, 'Smith, Brad', 1, 110000, '2015-02-02', 7),
(4, 'Ford, Julia', 2, 75000, '2019-08-30', 5),
(5, 'Lee, Tom', 2, 110000, '2018-10-11', 7),
(6, 'Jones, David', 3, 85000, '2012-03-15', 5),
(7, 'Miller, Bruce', 1, 100000, '2014-11-08', NULL),
(9, 'Peters, Joe', 3, 11000, '2020-03-09', 5),
(10, 'Joe, Alan', 3, 11500, '2020-03-09', 5),
(11, 'Clark, Kelly', 2, 11500, '2020-03-09', 5);
```

## Key Highlights
- Highest and second-highest salaries per department  
- Employees below/above department averages  
- Comparing employee salaries with managers  
- Salary differences using window functions  
- Top percentile earners per department  
- Ranking departments by % of employees over 100K  

## Example Query

Find top departments by percentage of employees earning more than 100K:

```sql
SELECT 
      DeptID,
      100.0 * SUM(CASE WHEN Salary > 100000 THEN 1 ELSE 0 END) / COUNT(*) AS Prcnt_of_employee
FROM Employees
GROUP BY DeptID
HAVING COUNT(*) > 2
ORDER BY Prcnt_of_employee DESC;
```
This project showcases practical SQL problem solving using advanced techniques like CTEs, subqueries, and window functions.
