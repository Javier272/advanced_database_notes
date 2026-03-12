-- try it 3
select b.*,
       count(*) over (
         partition by SHAPE
       ) bricks_per_shape,
       median ( weight ) over (
         partition by WEIGHT
       ) median_weight_per_shape
from   bricks b
order  by shape, weight, brick_id;

-- try it 5
select b.brick_id, b.weight,
       round ( avg ( weight ) over (
         order by WEIGHT
       ), 2 ) running_average_weight
from   bricks b
order  by brick_id;


-- try it 9

select b.*,
       min(colour) over (
         order by brick_id
         rows between 2 preceding and 1 preceding
       ) first_colour_two_prev,
       count(*) over (
         order by weight
         range between current row and 1 following
       ) count_values_this_and_next
from   bricks b
order  by weight;

-- try it 11

with totals as (
  select b.*,
         sum(weight) over (
           partition by shape
         ) weight_per_shape,
         sum(weight) over (
           order by brick_id
           rows between unbounded preceding and current row
         ) running_weight_by_id
  from   bricks b
)
select *
from totals
where weight_per_shape > 4
  and running_weight_by_id > 4
order by brick_id;

-- DataLemur
SELECT 
    d.department_name,
    e.name,
    e.salary
FROM (
    SELECT 
        name,
        salary,
        department_id,
        ROW_NUMBER() OVER (
            PARTITION BY department_id
            ORDER BY salary DESC, name ASC
        ) AS rn
    FROM employee
) e
JOIN department d 
    ON e.department_id = d.department_id
WHERE rn <= 3
ORDER BY 
    d.department_name ASC,
    e.salary DESC,
    e.name ASC;