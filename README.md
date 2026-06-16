# SQL - Data Jobs Analysis
## Purpose of Project
- To gain more experience with **SQL**
- Provides insights about what **skills** are needed to work in data science and **average salary** information for the data science field
- **Helpful for job seekers and businesses** curious about what other companies are paying for similar roles
## Software Used
In this project, I used **PostGreSQL** as my database management system. It is a free, open source software that I found supports SQL queries very well.

I also used **VS Code** to write queries and push to and pull from this repository.
## Dataset
The dataset consists of four tables:
- **job_postings_fact** - Contains job posting information of data jobs from 2023 (most recent dataset available)
- **company_dim** - Contains company information related to the job postings
- **skills_dim** - Contains all skill names extracted from job postings
- **skills_job_dim** - Contains all skill IDs associated with each job ID (for joining purposes)

The dataset comes from [Luke Barousse's SQL course](https://youtu.be/7mz73uXD9DA?si=4uMdfrLBoPFkLeTb). 
# Analysis
Role of Interest: **Data Analyst**  
Desired Job Location: **New York, NY** or **Remote** (Anywhere)

### Questions to Answer
- What are the top-paying data analyst roles?
- What are the skills required for these top-paying roles?
- What are the most in-demand skills for data analysts?
- What are the highest-paying skills to learn? (top skills based on average salary)
- What are the most optimal skills to learn? (highest DEMAND and highest PAYING)

In each query, I filtered the data to analyze rows that matched my desired job title and job location.
```
WHERE
    job_postings_fact.job_title_short = 'Data Analyst' AND
    job_postings_fact.job_location IN ('New York, NY', 'Anywhere')
```

### Query 1 - What are the top-paying data analyst roles?
```
SELECT 
    job_postings_fact.job_title,
    company_dim.name AS company,
    job_postings_fact.salary_year_avg,
    job_postings_fact.job_location,
    job_postings_fact.job_posted_date::DATE
FROM job_postings_fact
LEFT JOIN company_dim ON
    company_dim.company_id = job_postings_fact.company_id
WHERE
    job_postings_fact.job_title_short = 'Data Analyst' AND
    job_postings_fact.job_location IN ('New York, NY', 'Anywhere') AND
    job_postings_fact.salary_year_avg IS NOT NULL
ORDER BY
    job_postings_fact.salary_year_avg DESC
LIMIT 20 -- Top 20 roles
```
Results:

<img width="800" height="420" alt="image" src="https://github.com/user-attachments/assets/8b7eedd9-5454-4b48-b47d-1795d5d2724d" />

### Query 2 - What are the skills required for these top-paying roles?
**Part 1 - Skills required for each top-paying role**
```
WITH top_jobs AS (
    SELECT 
        job_postings_fact.job_id,
        job_postings_fact.job_title,
        job_postings_fact.salary_year_avg
    FROM job_postings_fact
    LEFT JOIN company_dim ON
        company_dim.company_id = job_postings_fact.company_id
    WHERE
        job_postings_fact.job_title_short = 'Data Analyst' AND
        job_postings_fact.job_location IN ('New York, NY', 'Anywhere') AND
        job_postings_fact.salary_year_avg IS NOT NULL
    ORDER BY
        job_postings_fact.salary_year_avg DESC
    LIMIT 20 -- Top 20 roles
)

SELECT 
    top_jobs.job_title,
    top_jobs.salary_year_avg,
    skills_dim.skills
FROM top_jobs
INNER JOIN skills_job_dim ON
        skills_job_dim.job_id = top_jobs.job_id
INNER JOIN skills_dim ON
    skills_dim.skill_id = skills_job_dim.skill_id
```
Results:

<img width="400" height="420" alt="image" src="https://github.com/user-attachments/assets/05355c12-172b-4846-9011-d53afcfea8de" />



**Part 2 - Number of top-paying roles that require each skill**
```
WITH top_jobs AS (
    SELECT 
        job_postings_fact.job_id,
        job_postings_fact.job_title,
        job_postings_fact.salary_year_avg
    FROM job_postings_fact
    LEFT JOIN company_dim ON
        company_dim.company_id = job_postings_fact.company_id
    WHERE
        job_postings_fact.job_title_short = 'Data Analyst' AND
        job_postings_fact.job_location IN ('New York, NY', 'Anywhere') AND
        job_postings_fact.salary_year_avg IS NOT NULL
    ORDER BY
        job_postings_fact.salary_year_avg DESC
    LIMIT 20 -- Top 20 roles
)

SELECT 
    skills_dim.skills,
    COUNT(skills_dim.skills)
FROM top_jobs
INNER JOIN skills_job_dim ON
        skills_job_dim.job_id = top_jobs.job_id
INNER JOIN skills_dim ON
    skills_dim.skill_id = skills_job_dim.skill_id
GROUP BY
    skills_dim.skills
ORDER BY
    count DESC
```
Results:

<img width="333" height="318" alt="image" src="https://github.com/user-attachments/assets/26e175f5-1500-494b-b38c-6ff5e8b90f2c" />


### Query 3 - What are the most in-demand skills for data analysts?
Results show that SQL, Excel, and Python were the most in-demand skills for data analyst positions in 2023 that were remote or in New York, NY. Tableau and Power BI were 4th and 5th.
```
SELECT
    skills_dim.skills AS skill_name,
    COUNT(skills_dim.skills) AS demand_count
FROM job_postings_fact
LEFT JOIN skills_job_dim ON
    skills_job_dim.job_id = job_postings_fact.job_id
LEFT JOIN skills_dim ON
    skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    job_postings_fact.job_title_short = 'Data Analyst' AND
    job_location IN ('New York, NY', 'Anywhere')
GROUP BY
    skill_name
ORDER BY 
    demand_count DESC
LIMIT 10 -- Top 10 skills by demand
```
Results:

<img width="334" height="322" alt="image" src="https://github.com/user-attachments/assets/0d5a3627-bf97-4138-9693-54f231ffcab3" />


### Query 4 - What are the highest-paying skills to learn? (top skills based on average salary)
Results show that Bitbucket, Neo4j, and Cassandra were the highest-paying skills. However, this query doesn't consider how many jobs require these skills.
```
SELECT 
    skills AS skill,
    ROUND(AVG(salary_year_avg),0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON
    skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON
    skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    job_postings_fact.job_title_short = 'Data Analyst' AND
    job_postings_fact.job_location IN ('New York, NY', 'Anywhere') AND
    job_postings_fact.salary_year_avg IS NOT NULL
GROUP BY
    skill
ORDER BY
    avg_salary DESC
LIMIT 10 -- Top 10 skills by average salary
```
Results:

<img width="327" height="318" alt="image" src="https://github.com/user-attachments/assets/3e09c336-2bab-4ad6-a193-8ba050e7706d" />


### Query 5 - What are the most optimal skills to learn? (highest DEMAND and highest PAYING)
I chose to filter the results to skills with a **demand count of at least 50** to avoid including skills that are less likely to be required in data analyst job postings. This results set combines queries 3 and 4 by weighing **BOTH** **skill demand** and **average salary**.

Results show that cloud-related skills like Snowflake, AWS, and Go had the highest average salaries, with Python as the 4th-highest. Python's demand count was over twice the demand count of all top 3 optimal skills combined.

Important to note that the top 5 highest-paying skills from query 4 are not among the optimal skills because their demand counts were lower than 50.
```
SELECT 
    skills_dim.skills,
    ROUND(AVG(salary_year_avg),0) AS avg_salary,
    COUNT(skills_dim.skill_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON
    skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON
    skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    job_postings_fact.job_title_short = 'Data Analyst' AND
    job_postings_fact.job_location IN ('New York, NY', 'Anywhere') AND
    job_postings_fact.salary_year_avg IS NOT NULL
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(skills_dim.skill_id) >= 50
    -- Only include skills with a demand count of 50 or greater
ORDER BY
    avg_salary DESC,
    demand_count DESC
```
Results:

<img width="400" height="390" alt="image" src="https://github.com/user-attachments/assets/43c498f6-f60e-4653-93c2-dbbf992aeae9" />


# Conclusion
For 2023 data analyst roles that are remote or located in New York:
Most in-demand skills:
- Excel
- SQL
- Python

Highest paying skills:
- Bitbucket
- Neo4j
- Cassandra

Most optimal skills to learn (Highest paying skills with demand count of at 50):
- Snowflake (demand: 50+)
- AWS (demand: 50+)
- Go (demand: 50+)
- Python (demand: **300+**)

Assuming that the skills required today for data analyst positions are similar to 2023, if your main goal is to land your first data analyst job, then learning the most in-demand skills first increases your chances. If your goal is to increase your salary in the data analysis field, then learning an optimal skill like Snowflake, Go, AWS, or Python would most likely be your best option.

I'd like to perform this analysis with data from 2025 to see how skills and average salaries of data analyst positions have changed since 2023.

Thank you for reading.
