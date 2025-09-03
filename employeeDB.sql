USE DASH_DB2;

CREATE TABLE [Employees](
							[EmployeeID] [int] IDENTITY(1,1) NOT NULL,
							[FullName] [nvarchar](250) NOT NULL,
							[DeptID] [int] NULL,
							[Salary] [int] NULL,
							[HireDate] [date] NULL,
							[ManagerID] [int] NULL
						) ;

INSERT [dbo].[Employees] ([EmployeeID], [FullName], [DeptID], [Salary], [HireDate], [ManagerID]) VALUES (1, 'Owens, Kristy', 1, 35000, '2018-01-22' , 3);
INSERT [dbo].[Employees] ([EmployeeID], [FullName], [DeptID], [Salary], [HireDate], [ManagerID]) VALUES (2, 'Adams, Jennifer', 1, 55000, '2017-10-25' , 5);
INSERT [dbo].[Employees] ([EmployeeID], [FullName], [DeptID], [Salary], [HireDate], [ManagerID]) VALUES (3, 'Smith, Brad', 1, 110000, '2015-02-02' , 7);
INSERT [dbo].[Employees] ([EmployeeID], [FullName], [DeptID], [Salary], [HireDate], [ManagerID]) VALUES (4, 'Ford, Julia', 2, 75000, '2019-08-30' , 5);
INSERT [dbo].[Employees] ([EmployeeID], [FullName], [DeptID], [Salary], [HireDate], [ManagerID]) VALUES (5, 'Lee, Tom', 2, 110000, '2018-10-11' , 7);
INSERT [dbo].[Employees] ([EmployeeID], [FullName], [DeptID], [Salary], [HireDate], [ManagerID]) VALUES (6, 'Jones, David', 3, 85000, '2012-03-15' , 5);
INSERT [dbo].[Employees] ([EmployeeID], [FullName], [DeptID], [Salary], [HireDate], [ManagerID]) VALUES (7, 'Miller, Bruce', 1, 100000, '2014-11-08' , NULL);
INSERT [dbo].[Employees] ([EmployeeID], [FullName], [DeptID], [Salary], [HireDate], [ManagerID]) VALUES (9, 'Peters, Joe', 3, 11000, '2020-03-09' , 5);
INSERT [dbo].[Employees] ([EmployeeID], [FullName], [DeptID], [Salary], [HireDate], [ManagerID]) VALUES (10, 'Joe, Alan', 3, 11500, '2020-03-09' , 5);
INSERT [dbo].[Employees] ([EmployeeID], [FullName], [DeptID], [Salary], [HireDate], [ManagerID]) VALUES (11, 'Clark, Kelly', 2, 11500, '2020-03-09' , 5);


SELECT * FROM Employees;

-- Analysis

/* 1. Find employees with highest salary in a department.

 Hint-  1) Find maximum salary in each department and then find the employee whose salary is equal to the maximum salary.
        2) Use of sub-query and Inner Join */

Select EmployeeID, Emp.DeptID, Salary 
from Employees Emp
INNER JOIN 
			(Select DeptID, Max(Salary) as MaxSalary from Employees 
			 Group BY DeptID ) MaxSalEMp 
ON Emp.DeptID = MaxSalEmp.DeptID
AND Emp.Salary = MaxSalEmp.MaxSalary


-- Find 2nd highest salary

SELECT MAX(Salary) AS SecondHighestSalary
FROM Employees
WHERE Salary < (SELECT MAX(Salary) FROM Employees);

-- show the name and other ddetails with 2nd highest salary

SELECT EmployeeID, FullName, Salary
FROM Employees
WHERE Salary = (
    SELECT MAX(Salary)
    FROM Employees
    WHERE Salary < (SELECT MAX(Salary) FROM Employees)
);

-- OR (Using CTE) Using this we can find Nth Salary, juzt change the rnk value at last.

WITH SalaryRank AS 
				   (SELECT EmployeeID, FullName, Salary,
						   DENSE_RANK() OVER (ORDER BY Salary DESC) AS rnk
					FROM Employees)
SELECT EmployeeID, FullName, Salary
FROM SalaryRank
WHERE rnk = 2;



/* 2. Find employees with salary lesser than department average 

 Hint- 1) Find maximum salary in each department and then find the employee whose salary is equal to the maximum salary.
       2) Use of sub-query and Inner Join */

Select EmployeeID, Emp.DeptID, Salary 
from Employees Emp
INNER JOIN 
			(Select DeptID, Avg(Salary) as AvgSalary from Employees 
			 Group BY DeptID ) AvgSalEMp 
ON Emp.DeptID = AvgSalEmp.DeptID
AND Emp.Salary < AvgSalEmp.AvgSalary


/* 3. Find employees with less than average salary in dept but more than average of ANY other Depts

   Hint- 1) First part of the query is same as Problem Statement 2.
         2) Find employees with less than average salary in dept but more than average of ANY other Depts
         3) Use of ANY to calculate the second logic.
         4) Find employees with less than average salary in dept but more than average of ANY other Depts */

Select EmployeeID, Emp.DeptID, Salary 
from Employees Emp
INNER JOIN 
			(Select DeptID, Avg(Salary) as AvgSalary from Employees 
			 Group BY DeptID ) AvgSalEMp 
ON Emp.DeptID = AvgSalEmp.DeptID
AND Emp.Salary < AvgSalEmp.AvgSalary
WHERE Emp.Salary > ANY (Select Avg(Salary) from Employees Group By DeptID) 


/* 4. Find employees with same salary

	Hint - 1) Create two instances of Employees table and self join to compare salaries between different rows.
		   2) Fetch rows with same salary from both instances.
		   3) Eliminate records for same employeeid from both instances. */

SELECT Emp1.EmployeeID, Emp1.Salary
FROM Employees Emp1
INNER JOIN Employees Emp2
ON Emp1.Salary = Emp2.Salary
AND Emp1.EmployeeID <> Emp2.EmployeeID


/* 5.  Find Dept where none of the employees has salary greater than their manager's salary

 Hint - 1) Use self join to find employee and manager's salary.
		2) Find departments where any employee has salary greater than his manager's salary.
		3) Use NOT IN to find departments which are not part of the list in Hint Step -2. 
		   This gives the remaining list of departments which do not have any employee whose salary is greater than his manager's salary. */

SELECT DISTINCT DeptID
FROM Employees
WHERE DeptID NOT IN (
				SELECT Emp.DeptID 
				FROM Employees Emp
				INNER JOIN Employees Mgr
				ON Emp.ManagerID = Mgr.EmployeeID
				WHERE Emp.Salary > Mgr.Salary )


--Find employee and their manager's name

SELECT 
    e.EmployeeID AS EmployeeID,
    e.FullName  AS EmployeeName,
    m.EmployeeID AS ManagerID,
    m.FullName  AS ManagerName
FROM Employees e
LEFT JOIN Employees m
    ON e.ManagerID = m.EmployeeID
ORDER BY e.EmployeeID;


/* 6.  Find difference between employee salary and average salary of department

Hint - 1) Use aggregate functions to find average salary for each department.
	   2) Use the above calculation in Select query and do a final calculation by subtracting it from employee salary. 
		  This query can be written as a Single Select Statement. */

SELECT EmployeeID, Salary, DeptID,
       AVG(Salary) OVER (PARTITION BY DeptID),
       Salary - AVG(Salary) OVER (PARTITION BY DeptID) AS DiffSal
FROM Employees;


/* 7.  Find Employees whose salary is in top 2 percentile in department

Hint - 1) Use aggregate function - Percent_Rank().
       2) Filter employees whose Percent_Rank() is greater than 0.98.  */

SELECT EmployeeID, FullName, DeptID, Salary
FROM 
    (SELECT EmployeeID, FullName, DeptID, Salary,
	 PERCENT_RANK() OVER (PARTITION BY DeptID ORDER BY Salary DESC) AS Percentile
     FROM dbo.Employees) AS Emp
WHERE Emp.Percentile > 0.98;

--OR

SELECT EmployeeID, FullName, DeptID, Salary
FROM 
    (SELECT EmployeeID, FullName, DeptID, Salary,
            NTILE(100) OVER (PARTITION BY DeptID ORDER BY Salary DESC) AS PercentileBucket
    FROM Employees) AS Emp
WHERE PercentileBucket <= 2;  -- top 2%


/* 8.  Find Employees who earn more than every employee in dept no 2

Hint - 1) List salaries of all employees in the department.
       2) Use ALL to compare employee salary with all values in the list above. */

Select * from Employees where salary > ALL (select salary from Employees where deptid=2);

--OR

/* Hint - 1) Find maximum salary in each department.
          2) Filter records where employee salary is greater than maximum salary calculated in Step 1 above. */

Select * from employees where salary > (select max(salary) from employees where deptid=2)


/* 9. Department names(with employee name) with more than or equal to 2 employees whose salary greater than 90% of respective department average salary

Hint - 1) Find average salary of department.
       2) Count employees whose salary is greater then 90% of average salary calculated in Step 1 above.
       3) Filter departments where the count in step 2 above is greater than or equal to 2. */

SELECT DeptID, FullName, Salary
FROM 
    (SELECT EmployeeID, FullName, DeptID, Salary,
           AVG(Salary * 1.0) OVER (PARTITION BY DeptID) AS DeptAvg,
           SUM(CASE WHEN Salary > 0.9 * AVG(Salary * 1.0) OVER (PARTITION BY DeptID) 
                    THEN 1 ELSE 0 END) OVER (PARTITION BY DeptID) AS HighEarnersCount
    FROM Employees) AS Emp
WHERE HighEarnersCount >= 2
  AND Salary > 0.9 * DeptAvg
ORDER BY DeptID, FullName;

/*  Step-by-step explanation

- Partitioning by DeptID (per department analysis)

   PARTITION BY DeptID tells SQL to calculate values separately for each department.
   That way, averages and counts are only compared within the same department, not across the whole company.

- Finding the department average salary: Query

AVG(Salary * 1.0) OVER (PARTITION BY DeptID) AS DeptAvg

  AVG() is an aggregate function, but here it’s used as a window function.
  Salary * 1.0 ensures SQL does floating-point division (not integer division).
  This gives each row the average salary of its department (e.g., every employee in Dept 1 gets the same DeptAvg).

- Counting employees above 90% of department average: Query

SUM(CASE WHEN Salary > 0.9 * DeptAvg 
         THEN 1 ELSE 0 END
) OVER (PARTITION BY DeptID) AS HighEarnersCount

  CASE WHEN ... THEN 1 ELSE 0 END - marks employees as 1 if their salary is greater than 90% of dept average, otherwise 0.
  SUM(...) OVER (PARTITION BY DeptID) - adds up those 1s within each department, giving the count of “high earners” in that dept.
  This is more efficient than doing a separate GROUP BY and joining back.

- Filtering results: Query

WHERE HighEarnersCount >= 2
  AND Salary > 0.9 * DeptAvg


  HighEarnersCount >= 2 - keep only departments where at least 2 employees are above 90% of the department average.
  Salary > 0.9 * DeptAvg - ensures we return only those qualifying employees, not everyone in the department.

- Final selection

  The outer SELECT keeps only the required columns: DeptID, FullName, Salary.
  ORDER BY DeptID, FullName makes output sorted neatly within departments.

- Why use this approach?

	Compact: Everything is calculated in one pass of the table, no need for multiple CTEs or joins.
	Readable: Business logic is easy to see - “find dept avg, count employees > 90% of avg, filter where count > = 2”.
	Flexible: You can change the threshold (90%) or required count (2) with minimal edits.
	Window functions: They let you mix aggregate-style calculations (AVG, SUM) with row-level detail without losing per-employee info. */


/* 10.  Select Top 3 departments with at least two employees and rank them according to the percentage of their employees making over 100K in salary

Hint -  1) Count employees making over 100K salary.
		2) Calculate percentage by dividing by total number of employees in the relative department.
		3) Order by the percentage calculated in Step 2 above.
		4) Use TOP to filter top 2 departments. */

SELECT 
      deptid, 
	  100 * SUM(CASE WHEN salary > 100000 THEN 1 ELSE 0 END) / COUNT(employeeid) AS Prcnt_of_employee
FROM employees
GROUP BY deptid
HAVING COUNT(*) > 2
ORDER BY Prcnt_of_employee DESC;

/*  Explanation

- SUM(CASE WHEN Salary > 100000 THEN 1 ELSE 0 END)
Counts employees in the department earning more than 100K.

- COUNT(EmployeeID)
Total employees in that department.

- Division
SUM(...) / COUNT(...) gives the ratio of employees >100K.
Multiplying by 100 turns it into a percentage.
Note: In SQL Server, both SUM and COUNT are integers.
If no cast is done, integer division will truncate decimals (e.g., 1/3 = 0 not 0.33).
To fix, force decimal arithmetic with * 1.0 or CAST:

100.0 * SUM(CASE WHEN Salary > 100000 THEN 1 ELSE 0 END) / COUNT(*) 

- HAVING COUNT(*) > 2
Ensures only departments with at least 3 employees are included.

- ORDER BY 2 DESC
Sorts results by the percentage (column #2) from highest to lowest. */