Bellabeat Google Capstone — Smart Device Usage Analysis 🌿

   

This project is my Google Data Analytics Capstone, following the official 6-step process (Ask → Prepare → Process → Analyze → Share → Act).
I analyzed Fitbit smart device usage data to uncover user activity, sleep, and calorie patterns, explored correlations, built a simple predictive model, and created marketing recommendations for Bellabeat.


---

1️⃣ ASK — Defining the Business Task

Goal: Analyze non-Bellabeat smart device usage data to discover user habits and provide high-level marketing recommendations for Bellabeat.

Stakeholders:

Urška Sršen — Cofounder & Chief Creative Officer

Sando Mur — Cofounder & Mathematician

Bellabeat Marketing Analytics Team


Guiding Questions:

1. What are the key trends in steps, sleep, calories, and activity intensity?


2. How do usage patterns differ between weekdays and weekends?


3. Are there distinct types of users based on activity level?


4. How do metrics like steps, calories, and sleep relate to each other?


5. Which insights can help shape Bellabeat’s marketing strategy?




---

2️⃣ PREPARE — Understanding the Data

Dataset:
FitBit Fitness Tracker Data (Kaggle) — 18 CSV files containing daily, hourly, and minute-level data from ~30 anonymous users in 2016.

Tools Used:

Google BigQuery — storage, cleaning, joins, and SQL analysis

Python (pandas, seaborn, scikit-learn) — exploratory analysis, correlations, simple model

Tableau — dashboard and visualization for stakeholders


Data Limitations:

Small sample size (≈30 users) → not representative of all smart device users

No demographic details (age, gender, location, income)

Data is from 2016 → usage patterns may have changed

Some self-reported metrics (e.g., sleep) may be inaccurate



---

3️⃣ PROCESS — Cleaning & Merging Data

I focused on two key CSVs:

dailyActivity_merged.csv — steps, distances, active/sedentary minutes, calories

sleepDay_merged.csv — minutes asleep, time in bed


Cleaning Steps in BigQuery:

Checked for nulls and duplicates

Standardized date formats

Removed duplicate rows

Joined daily activity and sleep data on user ID and date

Exported the cleaned dataset for analysis


The result: daily_activity_sleep_cleaned.csv — my primary analysis dataset.


---

4️⃣ ANALYZE — Finding Insights

Descriptive Statistics:

Average daily steps, calories burned, sedentary minutes, and minutes asleep

Distribution of activity levels across days


Key Analyses:

Weekday vs. Weekend Trends — calculated average steps and sleep by day of week

Correlation Analysis — examined relationships between steps, calories, sedentary minutes, and sleep

Simple Predictive Model — linear regression to predict calories burned from steps


Notable Findings:

Strong positive correlation between steps and calories burned

Sedentary minutes make up the largest portion of the day for most users

Potential link between higher activity and improved sleep

Step counts vary across the week — possible drop on weekends



---

5️⃣ SHARE — Visualizing Results

I built a Tableau Dashboard to present:

KPI Tiles: Avg. daily steps, sleep minutes, sedentary minutes

Bar Chart: Avg. steps by day of week

Scatter Plot: Very active minutes vs. minutes asleep

Pie Chart: Distribution of users by activity segment (Sedentary / Lightly Active / Fairly Active / Very Active)

Tree Map: Average daily minutes spent in different activity intensities


These visuals allow stakeholders to filter by user segment and explore trends interactively.


---

6️⃣ ACT — Recommendations

Based on the analysis, I recommend:

1. Break up sedentary time
Introduce “move reminders” in the Bellabeat app to encourage users to stand and move throughout the day.


2. Link activity to sleep quality
Launch educational content: “Move More, Sleep Better”, highlighting the connection between activity and rest.


3. Weekend activity challenges
Create a “Weekend Warrior” campaign with in-app challenges to maintain activity levels on weekends.


4. Personalized goals by user segment
Use onboarding data to classify users and send tailored step goals and nudges.



> All recommendations are made acknowledging dataset limitations (size, demographics, year collected).




---

📂 Project Structure

bellabeat_google_capstone/
├── README.md
├── 00_data/
│ ├── original_data/ # Raw Kaggle CSVs
│ └── processed_data/ # Cleaned datasets
├── 01_scripts/
│ ├── sql/ # BigQuery SQL scripts
│ └── python/ # Python analysis scripts/notebooks
├── 02_visualizations/
│ ├── images/ # Charts & plots
│ └── Bellabeat_Dashboard.twbx # Tableau dashboard
└── 03_report/
    └── Bellabeat_Case_Study_Presentation.pptx


---

🔁 Reproducibility

To reproduce my results:

1. BigQuery

Upload the original CSVs to your dataset

Run the SQL cleaning/merge script

Export the cleaned table as CSV



2. Python

Load the cleaned CSV

Run descriptive statistics, correlations, and the regression model

Save visualizations to /02_visualizations/images/



3. Tableau

Connect to the cleaned CSV

Recreate the dashboard with KPIs, trends, and user segments





---

📜 License & Attribution

Code: MIT License

Data: Fitbit Fitness Tracker Data (Kaggle, educational use)



---

This project showcases data cleaning, SQL analysis, Python EDA, correlation analysis, regression modeling, and interactive dashboarding — all following Google’s structured analysis process
