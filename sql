-- COUNT UNIQUE IDS --

SELECT COUNT(DISTINCT id) AS unique_user_count

FROM 'endless-ripple-465615-b4.Daily_Activity.Activity'

-- TOTAL STEPS PER USER TOP 10 --

SELECT
Id
SUM(TotalSteps) AS total_steps
FROM endless-ripple-465615-b4.Daily_Activity.Activity
GROUP BY
Td
ORDER BY
total_steps DESC
LIMIT 10;


-- AVERAGE ACTIVE MINUTES PER USER --

SELECT
Id
AVG(VeryActiveMinutes +
FairlyActiveMinutes +
LightlyActiveMinutes) AS avg_active_minutes
FROM endless-ripple-465615-b4.Daily_Activity. Activity
GROUP BY
Id
ORDER BY
avg_active_minutes DESC


-- PERCENT OF DAYS USER MET 10000 STEPS GOAL --

SELECT
Id
100 * COUNTIF(TotalSteps >=
10000) / COUNT(*) AS pct_goal_met
FROM endless-ripple-465615-b4.Daily_Activity.Activity'

GROUP BY
Id
ORDER BY
pct_goal_met DESC

-- STEP TREND ORDERED BY DAY OF WEEK --

SELECT
FORMAT_DATE('%A', ActivityDate) AS day_of_week,
ROUND(AVG(TotalSteps)) AS avg_steps
FROM endless-ripple-465615-b4.Daily_Activity. Activity'
GROUP BY
day_of_week
ORDER BY
avg_steps DESC

