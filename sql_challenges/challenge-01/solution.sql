-- lesson 1
SELECT title FROM movies;

SELECT director FROM movies;

SELECT title, director FROM movies;

SELECT title, year FROM movies;

SELECT * FROM movies;

-- lesion 2
SELECT * FROM movies WHERE id=6;

SELECT * FROM Movies WHERE Year BETWEEN 2000 and 2010;

SELECT * FROM movies WHERE Year NOT BETWEEN 2000 and 2010;

SELECT * FROM movies WHERE id <= 5;

-- lessin 3
SELECT * FROM movies WHERE title LIKE 'Toy Story%';

SELECT * FROM movies WHERE Director LIKE 'John Lasseter%';

SELECT * FROM movies WHERE Director NOT LIKE 'John Lasseter%';

SELECT * FROM movies WHERE Title LIKE 'WALL%';

--lession 4
SELECT DISTINCT Director FROM movies ORDER BY Director ASC;

SELECT * FROM movies ORDER BY Year DESC LIMIT 4;

SELECT * FROM movies ORDER BY Title ASC  LIMIT 5;

SELECT * FROM movies ORDER BY Title ASC LIMIT 5 OFFSET 5;

--lesion 5
SELECT * FROM north_american_cities WHERE Country = 'Canada';

SELECT * FROM north_american_cities WHERE Country = 'United States' ORDER BY Latitude DESC;

SELECT city, country, population, latitude, longitude FROM north_american_cities WHERE longitude < -87.6298 ORDER BY longitude ASC;

SELECT * FROM north_american_cities WHERE Country = 'Mexico' ORDER BY Population DESC LIMIT 2;

SELECT city, population FROM north_american_cities WHERE country = 'United States' ORDER BY population DESC LIMIT 2 OFFSET 2;
