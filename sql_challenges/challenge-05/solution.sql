-- try it 5
select shape from my_brick_collection
UNION
select shape from your_brick_collection
order  by shape;

SELECT shape 
FROM my_brick_collection
UNION ALL
SELECT shape 
FROM your_brick_collection
ORDER BY shape;

-- try it 11
select shape from my_brick_collection
INTERSECT
select shape from your_brick_collection;

SELECT colour 
FROM my_brick_collection
MINUS
SELECT colour 
FROM your_brick_collection
ORDER BY colour;