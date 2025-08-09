-- ============================================================
-- Bellabeat Capstone — Clean join + helper tables
-- Project: endless-ripple-465615-b4
-- Dataset: Bellabeat
-- Sources: dailyActivity, sleepDay
-- NOTE: ActivityDate and SleepDay are already DATE types.
-- ============================================================

-- 1) Quick health checks
SELECT
  'dailyActivity' AS table_name,
  COUNT(*) AS row_count,
  SUM(CASE WHEN TotalSteps IS NULL THEN 1 ELSE 0 END) AS null_TotalSteps,
  SUM(CASE WHEN Calories IS NULL THEN 1 ELSE 0 END) AS null_Calories
FROM `endless-ripple-465615-b4.Bellabeat.dailyActivity`;

SELECT
  'sleepDay' AS table_name,
  COUNT(*) AS row_count,
  SUM(CASE WHEN TotalMinutesAsleep IS NULL THEN 1 ELSE 0 END) AS null_MinAsleep,
  SUM(CASE WHEN TotalTimeInBed IS NULL THEN 1 ELSE 0 END) AS null_TimeInBed
FROM `endless-ripple-465615-b4.Bellabeat.sleepDay`;

-- Duplicates per Id + date in each table (should be 0; if not, we de-dup in the views)
SELECT Id, ActivityDate, COUNT(*) AS dup_cnt
FROM `endless-ripple-465615-b4.Bellabeat.dailyActivity`
GROUP BY Id, ActivityDate
HAVING COUNT(*) > 1
ORDER BY dup_cnt DESC;

SELECT Id, SleepDay AS ActivityDate, COUNT(*) AS dup_cnt
FROM `endless-ripple-465615-b4.Bellabeat.sleepDay`
GROUP BY Id, ActivityDate
HAVING COUNT(*) > 1
ORDER BY dup_cnt DESC;

-- 2) Clean views (distinct rows, correct types already)
CREATE OR REPLACE VIEW `endless-ripple-465615-b4.Bellabeat.v_activity_clean` AS
SELECT DISTINCT
  CAST(Id AS INT64) AS Id,
  ActivityDate, -- already DATE
  CAST(TotalSteps AS INT64) AS TotalSteps,
  CAST(TotalDistance AS FLOAT64) AS TotalDistance,
  CAST(TrackerDistance AS FLOAT64) AS TrackerDistance,
  CAST(LoggedActivitiesDistance AS FLOAT64) AS LoggedActivitiesDistance,
  CAST(VeryActiveDistance AS FLOAT64) AS VeryActiveDistance,
  CAST(ModeratelyActiveDistance AS FLOAT64) AS ModeratelyActiveDistance,
  CAST(LightActiveDistance AS FLOAT64) AS LightActiveDistance,
  CAST(SedentaryActiveDistance AS FLOAT64) AS SedentaryActiveDistance,
  CAST(VeryActiveMinutes AS INT64) AS VeryActiveMinutes,
  CAST(FairlyActiveMinutes AS INT64) AS FairlyActiveMinutes,
  CAST(LightlyActiveMinutes AS INT64) AS LightlyActiveMinutes,
  CAST(SedentaryMinutes AS INT64) AS SedentaryMinutes,
  CAST(Calories AS INT64) AS Calories,
  CAST(`Total Active Minutes` AS INT64) AS TotalActiveMinutes
FROM `endless-ripple-465615-b4.Bellabeat.dailyActivity`;

CREATE OR REPLACE VIEW `endless-ripple-465615-b4.Bellabeat.v_sleep_clean` AS
SELECT DISTINCT
  CAST(Id AS INT64) AS Id,
  SleepDay AS ActivityDate, -- already DATE; rename for the join
  CAST(TotalSleepRecords AS INT64) AS TotalSleepRecords,
  CAST(TotalMinutesAsleep AS INT64) AS TotalMinutesAsleep,
  CAST(TotalTimeInBed AS INT64) AS TotalTimeInBed,
  CAST(TotalTimeToFallAsleep AS INT64) AS TotalTimeToFallAsleep
FROM `endless-ripple-465615-b4.Bellabeat.sleepDay`;

-- 3) Joined daily table
CREATE OR REPLACE TABLE `endless-ripple-465615-b4.Bellabeat.daily_activity_sleep` AS
SELECT
  a.Id,
  a.ActivityDate,
  a.TotalSteps,
  a.TotalDistance,
  a.TrackerDistance,
  a.LoggedActivitiesDistance,
  a.VeryActiveDistance,
  a.ModeratelyActiveDistance,
  a.LightActiveDistance,
  a.SedentaryActiveDistance,
  a.VeryActiveMinutes,
  a.FairlyActiveMinutes,
  a.LightlyActiveMinutes,
  a.SedentaryMinutes,
  a.Calories,
  a.TotalActiveMinutes,
  s.TotalSleepRecords,
  s.TotalMinutesAsleep,
  s.TotalTimeInBed,
  s.TotalTimeToFallAsleep
FROM `endless-ripple-465615-b4.Bellabeat.v_activity_clean` a
LEFT JOIN `endless-ripple-465615-b4.Bellabeat.v_sleep_clean` s
USING (Id, ActivityDate);

-- Ensure uniqueness (one row per user per day)
CREATE OR REPLACE TABLE `endless-ripple-465615-b4.Bellabeat.daily_activity_sleep` AS
SELECT *
FROM (
  SELECT
    *,
    ROW_NUMBER() OVER (PARTITION BY Id, ActivityDate ORDER BY ActivityDate) AS rn
  FROM `endless-ripple-465615-b4.Bellabeat.daily_activity_sleep`
)
WHERE rn = 1;

-- 4) Helper tables
-- Weekday trends
CREATE OR REPLACE TABLE `endless-ripple-465615-b4.Bellabeat.weekday_trends` AS
SELECT
  FORMAT_DATE('%A', ActivityDate) AS day_of_week,
  AVG(TotalSteps) AS avg_steps,
  AVG(Calories) AS avg_calories,
  AVG(TotalMinutesAsleep) AS avg_sleep_minutes,
  AVG(SedentaryMinutes) AS avg_sedentary_minutes
FROM `endless-ripple-465615-b4.Bellabeat.daily_activity_sleep`
GROUP BY day_of_week;

-- Step segments
CREATE OR REPLACE TABLE `endless-ripple-465615-b4.Bellabeat.user_step_segments` AS
SELECT
  Id,
  AVG(TotalSteps) AS avg_daily_steps,
  CASE
    WHEN AVG(TotalSteps) < 5000 THEN 'Sedentary'
    WHEN AVG(TotalSteps) BETWEEN 5000 AND 7499 THEN 'Lightly Active'
    WHEN AVG(TotalSteps) BETWEEN 7500 AND 9999 THEN 'Fairly Active'
    ELSE 'Very Active'
  END AS step_segment
FROM `endless-ripple-465615-b4.Bellabeat.daily_activity_sleep`
GROUP BY Id;

-- 5) QA
SELECT 'daily_activity_sleep' AS table_name, COUNT(*) AS row_count
FROM `endless-ripple-465615-b4.Bellabeat.daily_activity_sleep`;

SELECT
  SUM(CASE WHEN ActivityDate IS NULL THEN 1 ELSE 0 END) AS null_date,
  SUM(CASE WHEN TotalSteps IS NULL THEN 1 ELSE 0 END) AS null_steps,
  SUM(CASE WHEN Calories IS NULL THEN 1 ELSE 0 END) AS null_calories
FROM `endless-ripple-465615-b4.Bellabeat.daily_activity_sleep`;

SELECT * 
FROM `endless-ripple-465615-b4.Bellabeat.daily_activity_sleep`
ORDER BY ActivityDate, Id
LIMIT 20;
