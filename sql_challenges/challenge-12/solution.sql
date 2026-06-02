-- excercise 1

WITH TeamStats AS (
    SELECT 
        t.id, 
        t.name AS team_name,
        COUNT(DISTINCT u.id) AS team_size,
        COUNT(CASE WHEN ts.status = 'completed' THEN ts.id END) AS completed_tasks
    FROM teams t
    LEFT JOIN users u ON t.id = u.team_id
    LEFT JOIN tasks ts ON u.id = ts.assigned_to
    GROUP BY t.id, t.name
),
VelocityCalc AS (
    SELECT 
        team_name, 
        team_size, 
        completed_tasks,
        CASE WHEN team_size > 0 THEN ROUND(completed_tasks / team_size, 2) ELSE 0 END AS velocity
    FROM TeamStats
)
SELECT 
    v.team_name,
    v.team_size,
    v.completed_tasks,
    v.velocity,
    CASE 
        WHEN v.velocity < (SELECT AVG(velocity) FROM VelocityCalc) THEN 'Below Average' 
        ELSE 'Above/Eq Average' 
    END AS performance_flag
FROM VelocityCalc v
ORDER BY v.velocity DESC;



-- exercise 2

WITH TaskLateness AS (
    SELECT 
        priority,
        CASE WHEN TRUNC(completed_at) <= due_date THEN 1 ELSE 0 END AS is_on_time,
        CASE WHEN TRUNC(completed_at) > due_date 
             THEN (CAST(completed_at AS DATE) - due_date) * 24 
             ELSE 0 END AS hours_late
    FROM tasks
    WHERE status = 'completed' 
      AND due_date IS NOT NULL
)
SELECT 
    priority,
    COUNT(*) AS total_evaluated,
    SUM(is_on_time) AS on_time_count,
    ROUND(SUM(is_on_time) / COUNT(*) * 100, 2) AS on_time_delivery_pct,
    ROUND(AVG(NULLIF(hours_late, 0)), 1) AS avg_lateness_hours
FROM TaskLateness
GROUP BY priority
ORDER BY on_time_delivery_pct ASC;




--exercise 3

SELECT 
    t.name AS team_name,
    COUNT(ts.id) AS total_tasks,
    COUNT(CASE WHEN ts.status IN ('open', 'in_progress', 'blocked') THEN 1 END) AS active_tasks,
    ROUND(
        COUNT(CASE WHEN ts.status = 'completed' THEN 1 END) * 100 / 
        NULLIF(COUNT(CASE WHEN ts.status != 'cancelled' THEN 1 END), 0)
    , 2) AS completion_rate_pct,
    CASE 
        WHEN COUNT(CASE WHEN ts.status IN ('open', 'in_progress', 'blocked') THEN 1 END) > 10 THEN 'Overloaded'
        WHEN COUNT(CASE WHEN ts.status IN ('open', 'in_progress', 'blocked') THEN 1 END) >= 5 THEN 'Healthy'
        ELSE 'Underutilized'
    END AS health_score
FROM teams t
LEFT JOIN users u ON u.team_id = t.id
LEFT JOIN tasks ts ON ts.assigned_to = u.id
GROUP BY t.id, t.name
ORDER BY active_tasks DESC;




-- exercise 4


WITH ResTimes AS (
    SELECT 
        priority,
        (EXTRACT(DAY FROM (completed_at - created_at)) * 24 +
         EXTRACT(HOUR FROM (completed_at - created_at)) +
         EXTRACT(MINUTE FROM (completed_at - created_at)) / 60) AS res_hours
    FROM tasks
    WHERE status = 'completed' 
      AND completed_at IS NOT NULL
)
SELECT 
    priority,
    COUNT(*) AS completed_task_count,
    ROUND(AVG(res_hours), 1) AS avg_res_hours,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY res_hours), 1) AS median_res_hours,
    ROUND(MIN(res_hours), 1) AS fastest_hours,
    ROUND(MAX(res_hours), 1) AS slowest_hours,
    CASE 
        WHEN priority = 'critical' AND AVG(res_hours) <= 24 THEN 'Target Met'
        WHEN priority = 'high' AND AVG(res_hours) <= 72 THEN 'Target Met'
        WHEN priority = 'medium' AND AVG(res_hours) <= 168 THEN 'Target Met'
        WHEN priority = 'low' AND AVG(res_hours) <= 336 THEN 'Target Met'
        ELSE 'Target Missed'
    END AS sla_status
FROM ResTimes
GROUP BY priority
ORDER BY 
    CASE priority WHEN 'critical' THEN 1 WHEN 'high' THEN 2 WHEN 'medium' THEN 3 ELSE 4 END;




-- exercise 5


WITH OverdueTasks AS (
    SELECT 
        ts.title,
        NVL(u.full_name, 'Unassigned') AS assignee,
        NVL(t.name, 'No Team') AS team_name,
        ts.priority,
        ts.due_date,
        TRUNC(SYSDATE) - ts.due_date AS days_overdue,
        CASE 
            WHEN ts.priority = 'critical' AND (TRUNC(SYSDATE) - ts.due_date) > 0 THEN 'CRITICAL'
            WHEN ts.priority = 'high' AND (TRUNC(SYSDATE) - ts.due_date) > 2 THEN 'HIGH'
            WHEN ts.priority = 'medium' AND (TRUNC(SYSDATE) - ts.due_date) > 5 THEN 'MEDIUM'
            ELSE 'LOW'
        END AS severity
    FROM tasks ts
    LEFT JOIN users u ON ts.assigned_to = u.id
    LEFT JOIN teams t ON u.team_id = t.id
    WHERE ts.due_date < TRUNC(SYSDATE)
      AND ts.status NOT IN ('completed', 'cancelled')
      AND ts.due_date IS NOT NULL
)
SELECT 
    CASE WHEN GROUPING(severity) = 1 THEN 'SUMMARY (ALL)' ELSE severity END AS severity,
    title,
    assignee,
    team_name,
    priority,
    due_date,
    ROUND(AVG(days_overdue), 1) AS days_overdue,
    COUNT(*) AS count_of_tasks
FROM OverdueTasks
GROUP BY GROUPING SETS (
    (severity, title, assignee, team_name, priority, due_date),
    ()
)
ORDER BY 
    CASE severity 
        WHEN 'CRITICAL' THEN 1 
        WHEN 'HIGH' THEN 2 
        WHEN 'MEDIUM' THEN 3 
        WHEN 'LOW' THEN 4 
        ELSE 5 
    END, 
    days_overdue DESC;




-- exercise 6

SELECT 
    u.full_name,
    COUNT(ts.id) AS total_completed,
    SUM(CASE ts.priority 
        WHEN 'critical' THEN 5
        WHEN 'high' THEN 3
        WHEN 'medium' THEN 2
        WHEN 'low' THEN 1
        ELSE 0 
    END) AS weighted_productivity_score
FROM users u
JOIN tasks ts ON ts.assigned_to = u.id
WHERE ts.status = 'completed'
GROUP BY u.id, u.full_name
ORDER BY weighted_productivity_score DESC;




--excercise 7

SELECT 
    t.name AS team_name,
    COUNT(ts.id) AS total_valid_tasks,
    COUNT(CASE WHEN ts.status = 'completed' THEN 1 END) AS completed_tasks,
    ROUND(
        COUNT(CASE WHEN ts.status = 'completed' THEN 1 END) * 100.0 / 
        NULLIF(COUNT(CASE WHEN ts.status != 'cancelled' THEN 1 END), 0)
    , 2) AS team_efficiency_pct
FROM teams t
LEFT JOIN users u ON u.team_id = t.id
LEFT JOIN tasks ts ON ts.assigned_to = u.id
GROUP BY t.id, t.name
ORDER BY team_efficiency_pct DESC NULLS LAST;