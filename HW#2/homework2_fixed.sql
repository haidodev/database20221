--3 
SELECT director.id, director.fname, director.lname
FROM movie, director, movie_director
WHERE movie.year = YEAR(GETDATE()) - 1
    AND movie_director.did = director.id
    AND movie_director.mid = movie.id
GROUP BY director.id, director.fname, director.lname
HAVING COUNT(*) > 3;

--8
-- SELECT movie.id, movie.name 
-- FROM movie
-- JOIN cast ON cast.mid=movie.id
-- JOIN actor ON cast.pid=actor.id
-- GROUP BY movie.id
-- HAVING SUM(CASE WHEN actor.gender = 'M' THEN 1 ELSE 0 END) < SUM(CASE WHEN actor.gender = 'F' THEN 1 ELSE 0 END);


--8
SELECT movie.id
FROM movie 
    JOIN 
        (SELECT mid, COUNT(*) AS male
        FROM cast, actor
        WHERE cast.pid = actor.id
            AND actor.gender = 'M'
        GROUP BY cast.mid) AS male_actor
    ON movie.id = male_actor.mid,
    JOIN
        (SELECT mid, COUNT(*) AS female
        FROM cast, actor
        WHERE cast.pid = actor.id
            AND actor.gender = 'F'
        GROUP BY cast.mid) AS female_actor
    ON movie.id = female_actor.mid,
WHERE male < female;

--9 

SELECT CONCAT(male.fname, ' ', male.lname) AS male_fullname, CONCAT(female.fname, ' ', female.lname)  AS female_fullname, COUNT(*)
FROM actor AS male, actor AS female, cast male_cast, cast female_cast
WHERE
    male_cast = female_cast
    AND male_cast.pid = male.id
    AND female_cast.pid = female.id
    AND male.gender = 'M'
    AND female.gender = 'F'
GROUP BY male.id, female.id, male_fullname, female_fullname
HAVING COUNT(*) > 0
ORDER BY 3 DESC;


--10 
-- SELECT TOP 1 movie.year, count(*)
-- FROM movie
-- GROUP BY movie.year
-- ORDER BY 2 DESC;

SELECT movie.year, COUNT(*)
FROM movie
GROUP BY movie.year
HAVING COUNT(*) >= ALL(SELECT COUNT(*) FROM movie GROUP BY year);