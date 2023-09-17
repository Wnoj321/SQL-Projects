--added this to circumvent errors enocountered when trying to upload data in order to match data types
IF OBJECT_ID('Power_Analysis', 'u') IS NOT NULL
	DROP TABLE Power_Analysis;
GO
-- The database I would like the table to be in.
USE SlingShotMkt
 go
--Created a table based off the excel.csv file with correct datatypes.
CREATE TABLE dbo.Power_Analysis (
	Name			VARCHAR(150),
	Sex				VARCHAR(150),
	Event			VARCHAR(150),
	Equipment		VARCHAR(150),
	Age				VARCHAR(150),
	Age_Class		VARCHAR(150),
	Division		VARCHAR(150),
	Bodyweight_Kg	FLOAT,
	Weight_Class	VARCHAR(150),
	Squat_1_Kg		FLOAT,
	Squat_2_Kg		FLOAT,
	Squat_3_Kg		FLOAT,
	Squat_4_Kg		FLOAT,
	Best_3_Squat_Kg	FLOAT,
	Bench_1_Kg		FLOAT,
	Bench__2_Kg		FLOAT,
	Bench_3_Kg		FLOAT,
	Bench_4_Kg		FLOAT,
	Best_3_Bench_Kg	FLOAT,
	Deadlift_1_Kg	FLOAT,
	Deadlift_2_Kg	FLOAT,
	Deadlift_3_Kg	FLOAT,
	Deadlift_4_Kg	FLOAT,
	Best_3_Deadlift_Kg	FLOAT,
	Total_Kg		FLOAT,
	Place			VARCHAR(150),
	Wilks			FLOAT,
	McCulloch		FLOAT,
	Glossbrenner	FLOAT,
	IPF_Points		FLOAT,
	Tested			VARCHAR(150),
	Country			VARCHAR(150),
	Federation		VARCHAR(150),
	DATE			DATE,
	Meet_Country	VARCHAR(150),
	Meet_State		VARCHAR(150),
	Meet_Name		VARCHAR(MAX),
);




-- Bulk insert to upload the excel.csv
BULK INSERT SlingShotMkt.dbo.Power_Analysis
FROM 'C:\Users\jonwi\OneDrive\Desktop\openpowerlifting.csv'
WITH (
	FORMAT='CSV',
	FIRSTROW=2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR ='\n',
	KEEPNULLS

);

--Basic query to look all the data
SELECT *
FROM Power_Analysis

--A query to find the appropriate population. The criteria for the desired population is that they are a male located in the United States, between the age of 18 and 40 and completed their bench presses between the year 2018 and 2019.
--The first query to get an idea of the desired population. 
SELECT Name, Weight_Class, Federation
FROM Power_Analysis
WHERE SEX = 'M'
	AND Country ='USA' 
	AND Age BETWEEN '18' AND '40'
	AND Federation IN ('IPF', 'USPA','USPF', 'USAPL')
	AND DATE BETWEEN '2018-01-01' AND '2020-01-01'

-- Now, I will find the average weight lifted in each weight class and federation along with converting it to pounds for ease of understanding. 

SELECT  Federation, 
		Weight_Class,
		ROUND(AVG(Best_3_Bench_Kg*2.2),0) AS Average_Bench_Weight_In_Pounds
FROM Power_Analysis
WHERE Sex = 'M' 
	AND Country = 'USA' 
	AND Federation IN ( 'IPF', 'USPA','USPF', 'USAPL')
	AND DATE BETWEEN '2018-01-01' AND '2020-01-01'
GROUP By Weight_Class, Federation
ORDER BY Federation, Weight_Class

--A similar query will be conducted to convert the lifters heaviest bench press to pounds
--try query without WHERE criteria
SELECT Name, 
	Federation, 	
	Country,Weight_Class,
	ROUND((Best_3_Bench_Kg*2.2),0) AS Bench_Weight_In_Pounds
FROM Power_Analysis
WHERE Sex = 'M' 
	AND Country = 'USA' 
	AND Federation IN ( 'IPF', 'USPA','USPF','USAPL') 
	AND DATE BETWEEN '2018-01-01' AND '2020-01-01'




  
