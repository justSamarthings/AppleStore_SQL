CREATE TABLE applestore_description_cmbined AS

SELECT * FROM appleStore_description1

UNION ALL 

SELECT * FROM appleStore_description2

UNION ALL

SELECT * FROM appleStore_description3
  
UNION ALL 

SELECT * FROM appleStore_description4


**EXPLORATORY DATA ANALYSIS**

-- check the number of unique apps in both tables Apple StoreAppleStore

SELECT COUNT(DISTINCT id) AS UniqueAppIDs
FROM Applestore
 
SELECT COUNT(DISTINCT id) AS UniqueAppIDs
FROM applestore_description_combined

-- checking any missing value in the key Field 
SELECT COUNT(*) AS MissingValues
FROM AppleStore
WHERE track_name is null or user_rating is null or prime_genre is null or id is null

SELECT COUNT(*) AS MissingValues
FROM applestore_description_combined
WHERE app_desc is NULL

--find number of apps per genre 
SELECT prime_genre,  count(*) AS NumApps
FROM AppleStore
GROUP By prime_genre
ORDER BY NumApps DESC

--get an overview of the apps' rating 

SELECT min(user_rating) AS MinRating, 
	   max(user_rating) AS MaxRating, 
       avg(user_rating) as AverageRating
FROM AppleStore


**DATA ANALYSIS**

--Determine whether paid apps have higher rating than free apps

SELECT CASE 
		When price>0 THEN 'Paid'
        ELSE 'Free'
      END AS App_type,
      avg(user_rating) as Avg_rating
FROM AppleStore
GROUP by App_type

--Check if apps with more supported languages have higher rating 

SELECT CASE
		WHEN lang_num < 10 Then '<10 Languages'
        when lang_num BETWEEN 10 ANd 30 THEN '10-30 Language'
        ELSE '>30 Languages'
      END As language_bucket,
      avg(user_rating) as Avg_Rating
FROM AppleStore
GROUP BY language_bucket
ORDER BY Avg_RATING DESC

--Check genre with low rating 

SELECT prime_genre, ROUND(avg(user_rating),5) As Avg_rating
FROM AppleStore
GROUP bY prime_genre
order by Avg_rating
Limit 10 

--Ckeck if there is any correlation between the length of app description and user rating 

SELECT CASE
			WHEN length(B.app_desc) < 500 Then 'Short'
            WHEN length(B.app_desc) BETWEEN 500 and 1000 then 'Medium'
            else 'Large' END AS App_desc_size,
            ROUND(avg(A.user_rating),4) as App_rating
FROM 
	AppleStore AS A 
JOIN 
	applestore_description_combined As B 
On A.id = B.id
GROUP By App_desc_size
ORDER By App_rating DESC

--check the top-rated apps for each genre 

SELECT prime_genre, track_name, user_rating
FROM(
  SELECT prime_genre, track_name, user_rating,
  RANK() OVER(Partition By prime_genre order by user_rating DESC, rating_count_tot DESC) AS Rank
  FROM AppleStore
) AS a 
WHERE a.rank = 1