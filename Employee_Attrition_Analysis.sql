CREATE DATABASE Project;

SELECT * INTO Project.dbo.HRDATA
FROM LearnbayProject.dbo.HRDATA;

USE Project;

SELECT * FROM HRDATA;

--1. Checking the total attrition count.
SELECT Attrition, COUNT(Attrition) AS 'TOTAL_COUNT' FROM HRDATA
GROUP BY Attrition;
-- >> There are 237 employees who left the company out of total 1470 <<



--2. TOTAL NO. OF EMPLOYEES AND TOTAL NO. OF PEOPLE WHO ARE LEAVING THE COMPANY
SELECT COUNT(*) AS 'total_emp', (SELECT COUNT(Attrition) FROM HRDATA WHERE Attrition='YES') AS 'attrition_count' FROM HRDATA;



--3. Out of the people who are leaving, how many of them are doing Overtime?
SELECT overtime, COUNT(*) AS 'total_employees' FROM HRDATA    -- Another way of doing it
WHERE Attrition = 'YES'
GROUP BY OverTime;
-- >> Out of 237 employees leaving the company, 127 people work over-time which is almost 50% of the Attrition count.
-- There is no Positive relationship seen between these two factors.
-- >> We observe that, over-time doesn't directly affect the attrition rate. <<



--4. Presence of relation between Performance Ratings and Attrition.
SELECT PerformanceRating, COUNT(*) AS 'Total_employees' FROM HRDATA
WHERE Attrition = 'Yes'
GROUP BY PerformanceRating;
--- >> Employees who have got lower ratings has high attrition and vice-versa. Negative correlation between PerformanceRating and Attrition <<



--5. Presence of relation between Percentage of Salary Hike and Attrition.
SELECT PercentSalaryHike, COUNT(*) AS 'Total_employees_Leaving' FROM HRDATA
WHERE Attrition = 'Yes'
GROUP BY PercentSalaryHike
ORDER BY Total_employees_Leaving DESC;
-- >> We see a Negative correlation between Salary Hike And Attrition. Employees getting a less Salary hike has the higher Attrition count.



--6. Attrition based on Age brackets.
-- Age brackets are 18-29, 30-39, 40-49, 50-59, 60 or above.

SELECT CASE WHEN Age BETWEEN 18 AND 29 THEN '18-29'
			WHEN Age BETWEEN 30 AND 39 THEN '30-39'
			WHEN Age BETWEEN 40 AND 49 THEN '40-49'
			WHEN Age BETWEEN 50 AND 59 THEN '50-59'
			ELSE '60 or above'
		END AS 'Age_brackets' , COUNT(*) AS 'Attrition_count'
FROM HRDATA
WHERE Attrition = 'Yes'
GROUP BY CASE WHEN Age BETWEEN 18 AND 29 THEN '18-29'
			  WHEN Age BETWEEN 30 AND 39 THEN '30-39'
			  WHEN Age BETWEEN 40 AND 49 THEN '40-49'
			  WHEN Age BETWEEN 50 AND 59 THEN '50-59'
			  ELSE '60 or above'
		END
ORDER BY Attrition_count DESC;
-- >> We see Attrition rate in the highest among people between the age 18-39 and it decreases as the Age increases.
-- >> It can be assumed as people tend to switch jobs less as they grow older and prefers stability. <<


-- 7. Relationship between Environment, Job and Relationship Satisfaction where the monthly income of employees is greater than the avg monthly income.

SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS  -- Checking the data type of 'MonthlyIncome' column
WHERE TABLE_NAME = 'HRDATA' AND COLUMN_NAME = 'MonthlyIncome';

ALTER TABLE HRDATA					-- Changing the data type to INT
ALTER COLUMN MONTHLYINCOME INT;

SELECT EnvironmentSatisfaction, JobSatisfaction, RelationshipSatisfaction, COUNT(*) AS 'Attrition_count' FROM HRDATA
WHERE MonthlyIncome > (SELECT AVG(MonthlyIncome) FROM HRDATA) AND Attrition = 'YES'
GROUP BY EnvironmentSatisfaction, JobSatisfaction, RelationshipSatisfaction
ORDER BY attrition_count DESC;

--8. Relation between Promotion and Attrition
-- Creating buckets for YearsSinceLastPromotion

SELECT CASE WHEN YearsSinceLastPromotion BETWEEN 0 AND 3 THEN '0-3'
			WHEN YearsSinceLastPromotion BETWEEN 4 AND 7 THEN '4-7'
			WHEN YearsSinceLastPromotion BETWEEN 8 AND 10 THEN '8-10'
			ELSE 'Above 10 years'
	   END AS 'Promotion year range', COUNT(*) AS 'Attrition_Count'
FROM HRDATA
WHERE Attrition = 'Yes'
GROUP BY CASE WHEN YearsSinceLastPromotion BETWEEN 0 AND 3 THEN '0-3'
			WHEN YearsSinceLastPromotion BETWEEN 4 AND 7 THEN '4-7'
			WHEN YearsSinceLastPromotion BETWEEN 8 AND 10 THEN '8-10'
			ELSE 'Above 10 years'
	   END
ORDER BY Attrition_Count DESC;

--9. Attrition based of Job role and Department

SELECT Department, JobRole, COUNT(*) AS 'Attrition_Count' FROM HRDATA
WHERE Attrition = 'Yes'
GROUP BY Department, JobRole
ORDER BY Attrition_Count DESC;

--10. Attrition based on Gender and Business Travel
SELECT BusinessTravel, Gender, COUNT(*) AS 'Attrition_Count' FROM HRDATA
WHERE Attrition = 'Yes'
GROUP BY BusinessTravel, Gender
ORDER BY Attrition_Count DESC;

--11. Attrition based on Marital Status
SELECT MaritalStatus, COUNT(*) AS 'Attrition_Count' FROM HRDATA
WHERE Attrition = 'Yes'
GROUP BY MaritalStatus
ORDER BY Attrition_Count DESC;


--12. Attrition based on Income brackets in $
SELECT CASE WHEN MonthlyIncome BETWEEN 1000 AND 5000 THEN '$1000-$5000'
			WHEN MonthlyIncome BETWEEN 5001 AND 10000 THEN '$5001-$10000'
			WHEN MonthlyIncome BETWEEN 10001 AND 15000 THEN '$10001-$15000'
			ELSE 'Above $15000'
		END AS 'Income_Range', COUNT(*) AS 'Attrition_Count'
FROM HRDATA
WHERE Attrition = 'Yes'
GROUP BY CASE WHEN MonthlyIncome BETWEEN 1000 AND 5000 THEN '$1000-$5000'
			WHEN MonthlyIncome BETWEEN 5001 AND 10000 THEN '$5001-$10000'
			WHEN MonthlyIncome BETWEEN 10001 AND 15000 THEN '$10001-$15000'
			ELSE 'Above $15000'
		END
ORDER BY Attrition_Count DESC;

--13. Work-Life Balance

SELECT WorkLifeBalance, COUNT(*) AS 'Attrition_Count' FROM HRDATA
WHERE Attrition = 'Yes'
GROUP BY WorkLifeBalance
ORDER BY Attrition_Count DESC;

-- Dropping irrelevant columns
ALTER TABLE HRDATA
DROP COLUMN EmployeeCount, EmployeeNumber, Over18, StandardHours;

SELECT * FROM HRDATA;

