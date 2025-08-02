/*The first 10 users on the platform*/

select top 10 * from users 
order by created_dat 

-- --------------------------------------------------------------------------------------------------------------

/* Total number of registrations*/

select COUNT(id) as number_of_registrations from users
-- --------------------------------------------------------------------------------------------------------------
/*The day of the week most users register on*/
set language english;
select top 1 DATENAME(WEEKDAY,created_dat) as Day_name , count(*) as number_of_regidtrations 
from users
group by DATENAME(WEEKDAY,created_dat)
order by number_of_regidtrations DESC

select * from users
------------------------------------------------------------------------------------------------------------------
/* The users who have never posted a photo*/

select users.id, users.username from users 
left join photos  on users.id=photos.user_id --allows to keep all users, even those who haven't posted any photos
where user_id IS NULL 

-- --------------------------------------------------------------------------------------------------------------

/* The most likes on a single photo*/
	select * from likes
	select top 1 photo_id,  COUNT(*)  as numbre_likes from likes
	group by photo_id
	order by numbre_likes DESC
-- --------------------------------------------------------------------------------------------------------------

/* The number of photos posted by most active users*/ --who posted most photos
select  top 5 username, 
COUNT(photos.image_url) as number_photos_posted from photos 
join users on photos.user_id= users.id
group by username
order by number_photos_posted DESC

-- --------------------------------------------------------------------------------------------------------------

/* The total number of posts*/
select COUNT(*) as total_number_posts from photos


-- --------------------------------------------------------------------------------------------------------------

/* The total number of users with posts*/

select COUNT (*) as total_number_with_posts from users 
left join photos on users.id = photos.user_id
where user_id is not null

-- --------------------------------------------------------------------------------------------------------------

/* The usernames with numbers as ending*/
select username from users 
where username like '%[0-9]'

-- --------------------------------------------------------------------------------------------------------------

/*The usernames with charachter as ending*/
select username from users 
where username like '%[a-zA-Z]'

-- --------------------------------------------------------------------------------------------------------------
/*the number of usernames that start with A*/
select COUNT (*) as number_users_startA from users 
where username like 'A%'
-- --------------------------------------------------------------------------------------------------------------
/*The most popular tag names by usage*/
select top 5 tag_name, COUNT (*) as number_usage from photo_tags
join tags  on photo_tags.tag_id  = tags.id
group by tag_name
order by number_usage DESC
-- --------------------------------------------------------------------------------------------------------------

/*The most popular tag names by likes*/
select top 5 T.tag_name,
COUNT (L.photo_id) as number_likes 
from photo_tags PT
join likes L on L.photo_id = PT.photo_id
join tags T on PT.tag_id = T.id
group by tag_name
order by number_likes DESC

-- --------------------------------------------------------------------------------------------------------------
/*The users who have liked every single photo on the site*/
select U.username, 
COUNT (L.user_id) as total_likes_by_user 
from users U
join likes L on U.id = L.user_id 
group by username 
having COUNT (L.user_id) = (select COUNT(*) from photos)
order by total_likes_by_user DESC
-- --------------------------------------------------------------------------------------------------------------

/*Total number of users without comments*/
select COUNT(*) as number_users_whithut_comments
from users U
left join comments C on U.id=C.user_id
where C.user_id is null 

-- --------------------------------------------------------------------------------------------------------------

/*the percentage of users who have either never commented on a photo or likes every photo*/
select 
CAST (
COUNT ( distinct eligible_users.user_id) *100
/COUNT (U.id) AS decimal (5,2) )as percentage_users

FROM users U
left join (
--- Subquery to display users without comments
select U1.id as user_id
from users U1
left join comments C on U1.id=C.user_id
where C.user_id is null 
union 
------ Subquery to display users who liked every photo
select L.user_id 
from likes L
group by L.user_id
having COUNT (L.user_id) = (select COUNT(*) from photos))as eligible_users on U.id = eligible_users.user_id

-- --------------------------------------------------------------------------------------------------------------
select * 
from photos

/*Clean URLs of photos posted on the platform*/
select id, image_url,
---supprimé le protocole 
replace(replace (image_url,'http://', ''), 'https://','') AS cleaned_url
from photos 

-- --------------------------------------------------------------------------------------------------------------

/*The average time on the platform */

select 
ROUND(AVG(DATEDIFF(day,created_dat,GETDATE() )/365.25),2) as average_time 
from users