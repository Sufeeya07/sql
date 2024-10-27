create database Netflix_Data_Analysis;
use Netflix_Data_Analysis;

select * from netflix_titles;
select count(*) as Total_Content from netflix_titles;

-- 15 Business Problems & Solutions

-- 1. Count the number of Movies vs TV Shows
select type , count(*) 
from netflix_titles
group by type;

-- 2. Find the most common rating for movies and TV shows
select rating , type,  count(type)
from netflix_titles
group by rating, type;

-- 3. List all movies released in a specific year (e.g., 2020)
select type, title from netflix_titles
where release_year ='2020' and type='movie';

-- 4. Find the top 5 countries with the most content on Netflix

-- 5. Identify the longest movie
select max(duration )from netflix_titles;

select * from netflix_titles
where type='movie' 
and duration =(select max(duration )from netflix_titles);

-- 6. Find content added in the last 5 years
SELECT *
FROM netflix_titles
WHERE date_added >= DATE_SUB(CURDATE(), INTERVAL 5 YEAR);

SELECT *
FROM netflix_titles
WHERE STR_TO_DATE(date_added, '%M %d, %Y') >= DATE_SUB(CURDATE(), INTERVAL 2 YEAR);

-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
select  director from netflix_titles;

select * from netflix_titles
where director = 'Toshiya Shinohara';
 
select * from netflix_titles
where director like '%Toshiya Shinohara$'; -- If a movie has two directors

-- 8. List all TV shows with more than 5 seasons
select * from netflix
where type='Tv Show' and duration >'5 season';

-- 11. List all movies that are documentaries
SELECT * FROM netflix_titles
WHERE listed_in LIKE '%Documentaries%';

-- 12. Find all content without a director
select *  from netflix
where director is null;

-- 13. Find how many movies actor 'Salman Khan' appeared in last 5 years!
select * from netflix_titles
where type= 'movie' and cast like '% Koji Tsujitani%'AND 
	release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 5;


/*
Question 15:
Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.
*/

SELECT 
    category,
	TYPE,
    COUNT(*) AS content_count
FROM (
    SELECT 
		*,
        CASE 
            WHEN description LIKE '%kill%' OR description LIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix_titles
) AS categorized_content
GROUP BY 1,2
ORDER BY 2

