/*----------------------------- Create a Database----------------------------------------------*/

CREATE DATABASE HR_Analytics;

/*----------------------------- Use a Specific Database------------------------------------------*/

USE HR_Analytics;

/*----------------------------- Creating a Table for Dataset-1:------------------------------------*/

DROP TABLE IF EXISTS HR_1;
CREATE TABLE HR_1(
Age	INT,
Attrition VARCHAR(225),	
BusinessTravel VARCHAR(225),
DailyRate INT,
Department VARCHAR(225),
DistanceFromHome INT,	
Education INT,
EducationField VARCHAR(225),
EmployeeCount INT,
EmployeeNumber INT,	
EnvironmentSatisfaction	INT,
Gender VARCHAR(225),
HourlyRate INT,
JobInvolvement INT,
JobLevel INT,
JobRole	VARCHAR(225),
obSatisfaction INT,
MaritalStatus VARCHAR(225)
);

/*----------------------------- Loading the Data in file ------------------------------------*/
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Data/hr_analytics/HR_1(Dataset_1).csv' INTO TABLE HR_1
FIELDS TERMINATED BY  ','
IGNORE 1 LINES;

/*---------------- To fetch all the data stored in the Specific table(HR-1):-------------------*/
SELECT*FROM HR_1;

/*--------------------------- ----creating a Table for Dataset-2-------------------------------*/

CREATE TABLE HR_2(
Employee_ID INT,
MonthlyIncome INT,
MonthlyRate	INT,
NumCompaniesWorked INT,
Over18	VARCHAR(225),
OverTime VARCHAR(225),	
PercentSalaryHike INT,
PerformanceRating INT,
RelationshipSatisfaction INT,	
StandardHours INT,
StockOptionLevel INT,
TotalWorkingYears INT,
TrainingTimesLastYear INT,	
WorkLifeBalance INT,	
YearsAtCompany INT,
YearsInCurrentRole INT,	
YearsSinceLastPromotion	INT,
YearsWithCurrManager INT
);

/*----------------------------- Loading the Data in file ------------------------------------*/
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Data/hr_analytics/HR_2(Dataset_2).csv' INTO TABLE HR_2
FIELDS TERMINATED BY ','
IGNORE 1 LINES;

/*---------------- To fetch all the data stored in the Specific table(HR-2):-------------------*/
SELECT * FROM  HR_2;

/*------------------- To Retrieve the list of tables in the database.--------------------------*/
-- To Retrieve the list of tables in the database.
SHOW TABLES;        -- It allows you to view the names of all the tables stored within a specific database.


/*---------------------------------------- QUESTIONS.------------------------------------------*/
# 1. Average Attrition rate for all Departments

SELECT 
    Department,
    COUNT(EmployeeNumber) AS emp_count,
    CONCAT(ROUND((count(attrition) / 25105) * 100, 2), '%') AS 'Attrition Rate' -- Attrition Count ("Yes")=25105
FROM hr_1
JOIN hr_2 
	ON EmployeeNumber = employee_id
WHERE attrition = 'yes'
GROUP BY Department
ORDER BY Department; 

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#2.Average Hourly rate of Male Research Scientist

SELECT 
    ROUND(AVG(HourlyRate),2) AS 'Average Hourly rate'
FROM hr_1
WHERE JobRole = 'Research Scientist' AND  Gender = 'Male';
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#3. Attrition Rate vs Monthy income stats

SELECT
    CASE
        WHEN MonthlyIncome <= 20000 THEN "10k-20K"
        WHEN MonthlyIncome <= 30000 THEN "20K-30K"
        WHEN MonthlyIncome <= 40000 THEN "30k-40K"
        WHEN MonthlyIncome <= 50000 THEN "40k-50K"
        ELSE "50k+"
    END AS Salary_Range,
    COUNT(*) AS 'Total Count'
FROM
    HR_1
JOIN
    HR_2 ON EmployeeNumber = Employee_ID
WHERE
    Attrition = "Yes"
GROUP BY
    Salary_Range;
 ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------       
#4.Department wise Average working years

SELECT 
    Department, ROUND(AVG(TotalWorkingYears),2) AS 'Average Working Hours'
FROM hr_1
JOIN hr_2 
	ON EmployeeNumber = Employee_ID
WHERE attrition = 'yes'
GROUP BY Department
ORDER BY Department;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#4.Job Role Vs Work life balance

/* if WorkLifeBalance = 1 then "Excellent"
if WorkLifeBalance = 2 then "Good"
if WorkLifeBalance = 3 then "Average"
if WorkLifeBalance = 4 then "Poor"*/

SELECT
    JobRole,
    SUM(CASE
        WHEN WorkLifeBalance = 1 THEN 1
        ELSE 0
    END) AS Excellent,
    SUM(CASE
        WHEN WorkLifeBalance = 2 THEN 1
        ELSE 0
    END) AS Good,
    SUM(CASE
        WHEN WorkLifeBalance = 3 THEN 1
        ELSE 0
    END) AS Average,
    SUM(CASE
        WHEN WorkLifeBalance = 4 THEN 1
        ELSE 0
    END) AS Poor
FROM
    HR_1
JOIN
    HR_2 ON EmployeeNumber = Employee_ID
GROUP BY
    JobRole;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#5.Attrition rate Vs Year since last promotion relation

SELECT 
    YearsSinceLastPromotion,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS AttritionCount,
  CONCAT(ROUND((SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100),2),'%') AS AttritionRate
FROM 
   hr_1
JOIN hr_2
	ON EmployeeNumber = Employee_ID
GROUP BY 
    YearsSinceLastPromotion
ORDER BY yearssinceLastpromotion;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
