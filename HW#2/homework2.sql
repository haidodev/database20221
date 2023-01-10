CREATE TABLE actor(
    id INT,
    fname VARCHAR(20),
    lname VARCHAR(20),
    gender CHAR(1)
    CONSTRAINT actor_pk PRIMARY KEY (id),
    CONSTRAINT actor_gender CHECK (gender='F' OR gender='M')
);
CREATE TABLE movie(
    id INT,
    name VARCHAR(50),
    year INT,
    rank INT
    CONSTRAINT movie_pk PRIMARY KEY (id)
);
CREATE TABLE director(
    id INT,
    fname VARCHAR(20),
    lanem VARCHAR(20),
    CONSTRAINT director_pk PRIMARY KEY(id)
)
CREATE TABLE cast(
    pid INT,
    mid INT,
    role VARCHAR(20),
    CONSTRAINT cast_actor_ref FOREIGN KEY (pid) REFERENCES actor(id),
    CONSTRAINT cast_movie_ref FOREIGN KEY (mid) REFERENCES movie(id)
)
CREATE TABLE movie_director(
    did INT,
    mid INT,
    CONSTRAINT movie_director_director_ref FOREIGN KEY (did) REFERENCES director(id),
    CONSTRAINT movie_director_movie_ref FOREIGN KEY (mid) REFERENCES movie(id)
)

--1
SELECT DISTINCT actor_2021.id
FROM movie, 
    cast, 
    (SELECT actor.id
        FROM actor, cast, movie
        WHERE movie.year = 2021
            AND cast.pid = actor.id
            AND cast.mid = movie.id
    ) AS actor_2021
WHERE movie.year = 2020
    AND cast.pid = actor_2021.id
    AND cast.mid = movie.id;


SELECT actor.id
FROM actor, cast, movie
WHERE movie.year = 2021
    AND cast.pid = actor.id
    AND cast.mid = movie.id
INTERSECT
SELECT DISTINCT actor_2021.id
FROM movie, cast, actor
WHERE movie.year = 2020
    AND cast.pid = actor_2021.id
    AND cast.mid = movie.id;

--2
SELECT movie.name
FROM movie,
    (SELECT movie.year, movie.ranking
    FROM movie
    WHERE movie.name = 'Shrek') AS sherk_movie
WHERE movie.year = sherk_movie.year 
    AND movie.rank > sherk_movie.rank;

--3 
SELECT director.id, director.fname, director.lname
FROM movie, director, movie_director
WHERE movie.year = YEAR(GETDATE()) - 1
    AND movie_director.did = director.id
    AND movie_director.mid = movie.id
GROUP BY director.id, director.fname, director.lname
HAVING COUNT(*) > 3;

--4
SELECT actor.fname, actor.lname
FROM actor, movie, cast
WHEN movie.name = 'GULLIVER''s travel'
    AND actor.id = cast.pid
    AND movie.id = cast.mid;

--5
SELECT director.id, director.fname, director.lname, COUNT(*) AS movie_directed
FROM movie, director, movie_director
WHERE movie.year = 2021
    AND movie_director.did = director.id
    AND movie_director.mid = movie.id
GROUP BY director.id, director.fname, director.lname
ORDER BY movie_directed DESC;

--6
SELECT actor.id
FROM actor, cast, movie_director
WHERE actor.id = cast.pid
    AND movie_director.mid = cast.mid
GROUP BY actor.id
HAVING COUNT(DISTINCT movie_director.did) >= 10;

--7
SELECT DISTINCT actor.id, actor.fname, actor.lname
FROM actor, 
EXCEPT 
SELECT DISTINCT actor.id, actor.fname, actor.lname
FROM  actor, movie, cast
WHERE actor.id = cast.pid
    AND movie.id = cast.mid
    AND movie.year >= 2020;

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