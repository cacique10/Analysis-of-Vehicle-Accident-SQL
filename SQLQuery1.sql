use vehiclesaccidents;

select * from accident;
select * from vehicle;


-- How many accidents have occurred in urban areas versus rural areas?
select Area, 
count(AccidentIndex) as 'Total Accidents' 
from accident
group by Area;



-- Which day of the week has the highest number of accidents?
select day, count(AccidentIndex) as 'Total Accidents'
from accident
group by day
order by 'Total Accidents' DESC;



-- What is the average age of vehicles involved in accidents based on their type?
SELECT VehicleType, count(AccidentIndex) as 'Total Accidents',
avg(AgeVehicle) as 'Average Year'
from vehicle
where AgeVehicle IS NOT NULL
group by VehicleType
order by 'Total Accidents' DESC;



-- Can we identify any trends in accidents based on the age of vehicles involved?
Select AgeGroup, count(AccidentIndex) as 'Total Accidents',
avg(AgeVehicle) as 'Average year'
from (
select AccidentIndex, AgeVehicle,
	CASE 
		When AgeVehicle Between 0 and 5 THEN 'New'
		When AgeVehicle Between 6 and 10 THEN 'Regular'
		Else 'Old'
	END AS 'AgeGroup'
	from vehicle
) as SubQuery
group by AgeGroup;



--Question 5: Are there any specific weather conditions that contribute to severe accidents?

declare @Severity varchar(100)
SET @Severity = 'Fatal'

select WeatherConditions,
count(Severity) as 'Total Accidents'
from accident
where Severity = @Severity
group by WeatherConditions
order by 'Total Accidents' DESC;



--Question 6: Do accidents often involve impacts on the left-hand side of vehicles?
select LeftHand,count(AccidentIndex) as 'Total Accidents'
from vehicle
group by LeftHand
having LeftHand IS NOT NULL;




--Question 7: Are there any relationships between journey purposes and the severity of accidents?
select count(A.Severity) as 'Total Accidents', V.JourneyPurpose,
case
	when count(A.Severity) Between 0 and 1000 then 'Low'
	when count(A.Severity) Between 1001 and 3000 then 'Average'
	else 'High'
end as 'Level'
from accident A
join vehicle V on V.AccidentIndex = A.AccidentIndex
group by V.JourneyPurpose
order by 'Total Accidents' DESC;



--Question 8: Calculate the average age of vehicles involved in accidents , considering Day light and point of impact:

declare @impact varchar(100)
declare @light varchar(100)
set @impact = 'Nearside'
set @light = 'Daylight'

select a.LightConditions, avg(v.AgeVehicle) as 'Average Year', v.PointImpact
from accident A
join vehicle V on v.AccidentIndex = a.AccidentIndex
group by a.LightConditions, v.PointImpact
having v.PointImpact = @impact and a.LightConditions = @light;