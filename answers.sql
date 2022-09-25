SHOW DATABASES;
USE ig_clone;
SHOW TABLES;

-- Part A (Marketing)
-- Question 1 : Find the 5 oldest users of the Instagram from the database provided
SELECT * FROM users
ORDER BY created_at
LIMIT 5;


-- Question 2 : Find the users who have never posted a single photo on Instagram
SELECT 
id, 
username
FROM users
WHERE id NOT IN (SELECT user_id FROM photos);


-- Question 3 : Identify the winner of the contest (user who gets the most likes on a single photo) and provide their details to the team.
SELECT
users.username AS Name, 
likes.photo_id AS photo_id,
COUNT(likes.photo_id) AS photo_like_count
FROM users
INNER JOIN photos
ON users.id = photos.user_id
INNER JOIN likes
ON photos.id = likes.photo_id
GROUP BY likes.photo_id
ORDER BY photo_like_count DESC
LIMIT 1;


-- Question 4 : Identify and suggest the top 5 most commonly used hashtags on the platform

SELECT
tags.id,
tag_name,
COUNT(tag_name) AS tag_count
FROM tags
INNER JOIN photo_tags
ON tags.id = photo_tags.tag_id
GROUP BY tag_name
ORDER BY tag_count DESC
LIMIT 5;


-- Question 5 : What day of the week most users register on?
SELECT
WEEKDAY(created_at) AS weekday,
COUNT(WEEKDAY(created_at)) AS freq
FROM users
GROUP BY weekday
ORDER BY freq DESC
LIMIT 3; 

-- Part B (Investor Metrics)
-- Question 1 : Provide how many times does average user post on Instagram. Also, provide the total number of photos on Instagram/total number of users

with t1 as
	(select
	user_id,
	count(user_id) as number_of_posts
	from photos
	group by user_id)
select
avg(number_of_posts) as avg_number_of_posts,
count(user_id) as total_users
from t1;



-- Question 2 : Provide data on users (bots) who have liked every single photo on the site.
SELECT
likes.user_id,
COUNT(DISTINCT photo_id) AS number_of_photos_liked
FROM likes
INNER JOIN photos
ON likes.photo_id = photos.id
GROUP BY user_id
HAVING COUNT(DISTINCT photo_id) = (SELECT COUNT(DISTINCT id) FROM photos) ;

