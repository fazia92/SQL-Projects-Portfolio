ALTER TABLE uber ADD Pickup_Time_clean DATETIME;

UPDATE uber
SET Pickup_Time_clean = TRY_CONVERT(DATETIME, Pickup_Time, 103);

UPDATE uber
SET Pickup_Time_clean = TRY_PARSE(Pickup_Time AS DATETIME USING 'en-US');  -- pour format jour/mois/année

SELECT * FROM UBER

ALTER TABLE uber ADD DROP_OFF_Time_clean DATETIME;

UPDATE uber
SET DROP_OFF_Time_clean = TRY_CONVERT(DATETIME, DROP_OFF_Time, 103);

UPDATE uber
SET DROP_OFF_Time_clean = TRY_PARSE(Drop_Off_Time AS DATETIME USING 'en-US');  -- pour format jour/mois/année

ALTER TABLE UBER DROP COLUMN Pickup_Time
ALTER TABLE UBER DROP COLUMN Drop_Off_Time

ALTER TABLE UBER 
ADD CONSTRAINT PK_UBER PRIMARY KEY (Trip_ID);


/* Total bookings*/
select count (*) as total_bookings from uber

/* total miles */
select sum(trip_distance) as total_miles from uber 

/* distance moyenne par trajet */
select AVG (trip_distance) as average_miles from uber

/* durée moyenne des trajet*/

ALTER TABLE UBER ADD BOOKING_TIME Float  --- adding a column
update uber 
set BOOKING_TIME = DATEDIFF(MINUTE, Pickup_Time_clean, Drop_Off_Time_clean) --- calculate the diffrence

select AVG(BOOKING_TIME) as average_time from uber 

/* nombre de trajet par type de véhicule*/
select Vehicle, COUNT(*) as bookings from uber 
GROUP BY Vehicle
order by bookings DESC

/* nombre de trajet par type de payement */
 select Payment_type, count(*) as bookings from uber 
 group by payment_type 
 order by bookings DESC

/* recette total*/
alter table uber add total_revenu float
update uber 
set total_revenu = fare_amount+Surge_Fee

select SUM(total_revenu) as total_revenu from uber

/* recette total par mode de payement */
select payment_type, round(sum(total_revenu), 2) as total_revenu from uber 
group by payment_type
order by total_revenu DESC

/* top 5 des trajet les plus long*/
select top 5 *  from uber 
order by total_revenu DESC

/* nombre de trajet par jour de semaine*/
SET LANGUAGE English;
select datename(weekday, Pickup_Time_clean) as Day, count(*) as bookings from uber 
group by datename(weekday, Pickup_Time_clean)
order by bookings DESC

/* separer les trajet nuit et jour*/
alter table uber add trip_type VARCHAR(100)

update uber 
set trip_type = case when DATEPART(HOUR, Pickup_Time_clean) >18 OR DATEPART(HOUR, Pickup_Time_clean) < 5 then 'Night_trip'
					else 'day_trip' 
					END 

select trip_type, count(*) as bookings , round(sum(trip_distance),2) as trip_distance from uber 
group by trip_type 
order by bookings DESC


/* group by par véhicule (bookings, total revenu, average revenu, average distance*/
select Vehicle, COUNT(*) as bookings, round( sum(total_revenu),2) as total_revenu, round(AVG(total_revenu),2) as average_revenu
from uber 
GROUP BY Vehicle
order by bookings DESC

/*--------------------------------------------jointure-----------------------------------------------*/
select * from location

/*bookings par city*/
select city as CITY , COUNT(*) as bookings from  uber  
join LOCATION on UBER.DOLocationID= Location.LocationID
group by City 
order by bookings DESC


/*Nombre de trajets entre deux localisations (ville de départ ➝ ville d’arrivée)*/
select loc_UP.City as pickup_city, loc_DO.City as dropoff_city, COUNT(*) as booking from uber 
join LOCATION as loc_UP on uber.PULocationID=loc_UP.LocationID
join LOCATION AS Loc_DO on uber.DOLocationID= Loc_DO.LocationID
group by loc_UP.City,loc_DO.City
ORDER BY BOOKING DESC

/*Recette totale par ville de départ*/
select city , round(SUM(total_revenu),2) as total_revenu from uber 
join LOCATION on uber.PULocationID= LOCATION.LocationID
group by City 
order by total_revenu  DESC

/*Nombre de trajets au départ de chaque ville par heure*/
select LOCATION.city , uber.trip_type, COUNT(*) as booking from uber 
join LOCATION on uber.PULocationID=location.LocationID
group by city, trip_type
order by booking DESC



