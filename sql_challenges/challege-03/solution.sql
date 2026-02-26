-- lession 10
SELECT Years_employed FROM employees ORDER BY Years_employed DESC LIMIT 1;

SELECT Role, AVG(Years_employed) FROM employees group by Role;

SELECT Building,SUM(Years_employed) FROM employees group by Building;

-- lession 11
SELECT COUNT(*) AS total_artists FROM employees WHERE Role = 'Artist';

SELECT Role, count(*) AS number_employes FROM employees group by Role;

SELECT SUM(Years_employed) FROM employees WHERE Role='Engineer';

-- try-it
select COUNT(DISTINCT SHAPE) AS number_of_shapes,
       STDDEV(DISTINCT WEIGHT) AS distinct_weight_stddev
from   bricks;


SELECT shape, SUM(weight) AS shape_weight
FROM   bricks
GROUP BY shape;


SELECT shape, SUM(weight)
FROM   bricks
GROUP  BY shape
HAVING SUM(weight) < 4;
