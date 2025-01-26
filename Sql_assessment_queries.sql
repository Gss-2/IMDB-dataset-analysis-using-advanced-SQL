use imdb;
select * from director_mapping;
select * from genre;
select * from movie;
select * from names;
select * from ratings;
select * from role_mapping; 

-- 1. Count the total number of records in each table of the database.
SELECT 'movie' AS table_name, COUNT(*) AS total_records FROM movie
UNION ALL
SELECT 'director_mapping', COUNT(*) FROM director_mapping
UNION ALL
SELECT 'genre', COUNT(*) FROM genre
UNION ALL
SELECT 'ratings', COUNT(*) FROM ratings
UNION ALL
SELECT 'names', COUNT(*) FROM names
UNION ALL
SELECT 'role_mapping', COUNT(*) FROM role_mapping;


-- 2. Identify which columns in the movie table contain null values.
SELECT 
    SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS id_nulls,
    SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS title_nulls,
    SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS year_nulls,
    SUM(CASE WHEN date_published IS NULL THEN 1 ELSE 0 END) AS date_published_nulls,
    SUM(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS duration_nulls,
    SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS country_nulls,
    SUM(CASE WHEN worlwide_gross_income IS NULL THEN 1 ELSE 0 END) AS worldwide_gross_income_nulls,
    SUM(CASE WHEN languages IS NULL THEN 1 ELSE 0 END) AS languages_nulls,
    SUM(CASE WHEN production_company IS NULL THEN 1 ELSE 0 END) AS production_company_nulls
FROM movie;
 

-- 3. Determine the total number of movies released each year, and analyze how the trend changes month-wise. 
select year , month(date_published) as month , count(id) as Total_movies from movie
group by year , month
order by year , month ;

select year , count(id) as Total_movies from movie
group by year
order by Total_movies desc;


-- 4.How many movies were produced in either the USA or India in the year 2019?
select country , count(id) as Total_movies from movie
where country = "USA" or country = "India" and year ="2019"
group by country;

-- 5. List the unique genres in the dataset, and count how many movies belong exclusively to one genre
select distinct(genre) , count(movie_id) as total_movies from genre
group by genre
order by total_movies desc;

-- 6. Which genre has the highest total number of movies produced? 
select distinct(genre) , count(movie_id) as total_movies from genre
group by genre
order by total_movies desc
limit 1;

 -- 7. Calculate the average movie duration for each genre.
 select distinct(genre) , avg(duration) as avg_duration from genre
 join movie
 on movie.id = genre.movie_id
 group by genre
 order by avg_duration asc;
  
-- 8.Identify actors or actresses who have appeared in more than three movies with an average rating below 5.
SELECT n.name, COUNT(r.movie_id) AS movie_count
FROM role_mapping rm
JOIN names n ON rm.name_id = n.id
JOIN ratings r ON rm.movie_id = r.movie_id
WHERE rm.category IN ('actor', 'actress') 
  AND r.avg_rating < 5 
GROUP BY n.name
HAVING COUNT(r.movie_id) > 3  
ORDER BY movie_count DESC;


-- 9. Find the minimum and maximum values for each column in the ratings table, excluding the movie_id column. 
select max(avg_rating) as max_avg_rating , min(avg_rating) as min_avg_rating,
	  max(total_votes) as max_total_votes , min(total_votes) as min_total_votes,
      max(median_rating) as max_median_rating , min(median_rating) as min_median_rating
from ratings;

-- 10. Which are the top 10 movies based on their average rating? 
select movie.title as Movie , ratings.avg_rating as avg_movie_rating from movie
join ratings
on ratings.movie_id = movie.id
order by avg_movie_rating desc
limit 10;

-- 11. Summarize the ratings table by grouping movies based on their median ratings. 
SELECT r.median_rating, COUNT(r.movie_id) AS movie_count, 
       AVG(r.avg_rating) AS avg_of_avg_rating, 
       SUM(r.total_votes) AS total_votes
FROM ratings r
GROUP BY r.median_rating
ORDER BY r.median_rating;

-- 12. How many movies, released in March 2017 in the USA within a specific genre, had more than 1000 votes
SELECT COUNT(DISTINCT m.id) AS movie_count
FROM movie m
JOIN genre g ON m.id = g.movie_id
JOIN ratings r ON m.id = r.movie_id
WHERE m.date_published BETWEEN '2017-03-01' AND '2017-03-31'
  AND m.country = 'USA'
  AND g.genre = 'Drama'  
  AND r.total_votes > 1000;
-- 13. Find movies from each genre that begin with the word “The” and have an average rating greater than 8.
select m.title , g.genre , r.avg_rating 
From movie m
Join genre g on g.movie_id = m.id
Join ratings r on r.movie_id = m.id
where m.title like "The %" and r.avg_rating > 8
order by r.avg_rating desc;

-- 14.calculate the count Of the movies released between April 1, 2018, and April 1, 2019, how many received a median rating of 8? 
select count(m.id) as Total_movies
From movie m
Join ratings r on r.movie_id = m.id
where m.date_published between "2018-04-01" and "2019-04-01" and r.median_rating = "8";

-- 15. Do German movies receive more votes on average than Italian movies?
select avg(r.total_votes) as avg_german_votes , m.languages
From ratings r
Join movie m on m.id = r.movie_id
where m.languages = "German";
select avg(r.total_votes) as avg_italian_votes , m.languages
From ratings r
Join movie m on m.id = r.movie_id
where m.languages = "Italian";

-- No average votes of italian is more than average votes of german language movies.
-- 16. Identify the columns in the names table that contain null values. 
SELECT 
    SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS id_nulls,
    SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls,
    SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
    SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls
FROM names;
-- 17. Who are the top two actors whose movies have a median rating of 8 or higher? 
select n.name as actor_name, r.median_rating 
from director_mapping d
Join names n on n.id = d.name_id
Join ratings r on r.movie_id = d.movie_id
where r.median_rating >= 8
order by r.median_rating desc
limit 2;

-- 18. Which are the top three production companies based on the total number of votes their movies received?
select m.production_company as production_company , r.total_votes as Total_votes
From movie m
Join ratings r on r.movie_id = m.id
order by Total_votes desc
limit 3;

-- 19. How many directors have worked on more than three movies? 
SELECT COUNT(*) AS director_count
FROM (
    SELECT dm.name_id
    FROM director_mapping dm
    GROUP BY dm.name_id
    HAVING COUNT(dm.movie_id) > 3
) AS directors;

-- 20. Calculate the average height of actors and actresses separately. 
select rm.category , avg(n.height) as average_height
From role_mapping rm
Join names n on n.id = rm.name_id
WHERE rm.category IN ('actor', 'actress')
  AND n.height IS NOT NULL  
GROUP BY rm.category;

-- 21. List the 10 oldest movies in the dataset along with their title, country, and director. 
select  m.title as Movie_name ,n.name, m.date_published as date_of_published, m.country 
from director_mapping dm
Join names n on n.id = dm.name_id
Join movie m on m.id = dm.movie_id
order by date_published asc
limit 10;

-- 22. List the top 5 movies with the highest total votes, along with their genres.
select m.title as Movie_name , r.total_votes as Total_votes , g.genre as Genre_of_movie
From movie m
Join ratings r on r.movie_id = m.id
Join genre g on g.movie_id = m.id
order by Total_votes desc
limit 5;

-- 23. Identify the movie with the longest duration, along with its genre and production company. 
select m.title as Movie_name , m.duration as duration_of_movie , g.genre as Genre , m.production_company
From movie as m
Join genre as g on g.movie_id = m.id
order by duration desc
limit 1;

-- 24. Determine the total number of votes for each movie released in 2018. 
select m.title as Movie_name, m.year as Released_year_of_movie ,r.total_votes as Total_votes 
from movie m
join ratings r on r.movie_id = m.id
where m.year = "2018"
order by Total_votes desc;

-- 25. What is the most common language in which movies were produced? 

SELECT languages, COUNT(*) AS movie_count
FROM movie
GROUP BY languages
ORDER BY movie_count DESC LIMIT 1;




		



