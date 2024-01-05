SELECT TOP 10 *
FROM Maven..stolen_vehicles

SELECT *
FROM Maven..locations

SELECT *
FROM Maven..make_details



-- 1. Vehicle Theft Analysis
--- I. Number of vehicles stolen

SELECT COUNT (vehicle_id) no_of_stolen_vehicles
FROM Maven..stolen_vehicles

--- II. Most frequently stolen vehicle

SELECT TOP 5 vehicle_type, count (*) most_frequently_stolen_vehicle
FROM Maven..stolen_vehicles
GROUP BY vehicle_type
ORDER BY  most_frequently_stolen_vehicle DESC


--- III. Most frequently stolen vehicle color

SELECT TOP 5 color, COUNT (*) Most_Frequently_Stolen_Color
FROM Maven..stolen_vehicles
GROUP BY color
ORDER BY Most_Frequently_Stolen_Color DESC
---------------------------------------------------------------------------------------------------------------------

-- 2. Make analysis
--- I. Most stolen vehicle type by region

SELECT TOP 5 vehicle_type, region, COUNT (*) theft_count 
FROM Maven..stolen_vehicles sv
JOIN Maven..locations loc
ON sv.location_id = loc.location_id
GROUP BY vehicle_type, region
ORDER BY  theft_count DESC

--- II. Most stolen vehicle by model year

SELECT TOP 10 model_year, COUNT(*) AS theft_count
FROM Maven..stolen_vehicles
GROUP BY model_year
ORDER BY theft_count DESC

---------------------------------------------------------------------------------------------------------------------


-- 3. Time Analysis
--- I. What months are vehicles most often stolen?

SELECT DATEPART(YEAR, date_stolen) theft_year,
       DATENAME(MONTH, date_stolen) theft_month,
       COUNT(*) theft_count
FROM Maven..stolen_vehicles
GROUP BY DATEPART(YEAR, date_stolen), 
         DATENAME(MONTH, date_stolen)
ORDER BY theft_count DESC


--- II. What day of the week are vehicles most often and least often stolen?

SELECT DATENAME(WEEKDAY, date_stolen) theft_day_of_week,
       COUNT(*) theft_count
FROM Maven..stolen_vehicles
GROUP BY DATENAME(WEEKDAY, date_stolen)
ORDER BY theft_count DESC


--- III. Months with the  most and least vehicle theft count using CTE

WITH Month_Most_Stolen AS (
     SELECT TOP 1 
     DATENAME(MONTH, date_stolen) AS theft_month,
     COUNT(*) AS theft_count
     FROM Maven..stolen_vehicles
     GROUP BY DATENAME(MONTH, date_stolen)
     ORDER BY theft_count DESC

),
Month_Least_Stolen AS (
     SELECT TOP 1
     DATENAME(MONTH, date_stolen) AS theft_month,
     COUNT(*) AS theft_count
     FROM Maven..stolen_vehicles
     GROUP BY DATENAME(MONTH, date_stolen)
     ORDER BY theft_count 
)
SELECT 'Month with Highest Vehicle Theft Count' AS category,
       theft_month, theft_count
FROM Month_Most_Stolen
UNION ALL
SELECT 'Month with Least Vehicle Theft Count' AS category, 
       theft_month, theft_count
FROM Month_Least_Stolen
--------------------------------------------------------------------------------------------------------------------


-- 4. What is the average age of stolen veicles? Does this vary based on the vehicle type?

SELECT vehicle_type, AVG(DATEDIFF(year, model_year, 
GETDATE())) AS average_age_by_type
FROM Maven..stolen_vehicles
GROUP BY vehicle_type;
---------------------------------------------------------------------------------------------------------------------

-- 5. Geographcal analysis
---  Which regions have the most and least number of stolen vehicles?
--- What are the characteristics of these regions

WITH Most_Stolen AS (
    SELECT TOP 1 
	loc.region, COUNT(*) AS stolen_vehicle_count
    FROM Maven..stolen_vehicles sv
    JOIN Maven..locations loc ON sv.location_id = loc.location_id
    GROUP BY loc.region
    ORDER BY stolen_vehicle_count DESC
    
),
Least_Stolen AS (
    SELECT TOP 1
	loc.region, COUNT(*) AS stolen_vehicle_count
    FROM Maven..stolen_vehicles sv
    JOIN Maven..locations loc ON sv.location_id = loc.location_id
    GROUP BY loc.region
    ORDER BY stolen_vehicle_count ASC
    
)
SELECT 'Region with Most Stolen Vehicles' AS category, region, stolen_vehicle_count
FROM Most_Stolen
UNION ALL
SELECT 'Region with Least Stolen Vehicles' AS category, region, stolen_vehicle_count
FROM Least_Stolen
















