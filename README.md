# SQL - Data Jobs Analysis
## Purpose of Project
- To gain more experience with **SQL**
- Provides insights about what **skills** are needed to work in data science and **average salary** information for the data science field
- **Helpful for job seekers and businesses** curious about what other companies are paying for similar roles
## Software Used
In this project, I used **PostGreSQL** as my database management system. It is a free, open source software that I found supports SQL queries very well.

I also used **VS Code** to write queries and push to and pull to this repository.
## Dataset
The dataset consists of four tables:
- **job_postings_fact** - Contains job posting information of data jobs from 2023 (most recent dataset available)
- **company_dim** - Contains company information related to the job postings
- **skills_dim** - Contains all skill names extracted from job postings
- **skills_job_dim** - Contains all skill IDs associated with each job ID (for joining purposes)

The dataset comes from [Luke Barousse's SQL course](https://youtu.be/7mz73uXD9DA?si=4uMdfrLBoPFkLeTb).
# What questions are we answering?
### Query 1 - What are the top-paying data analyst roles?
```
/*
What are the top-paying jobs for my role?
- Role: Data Analyst
- Location: New York, NY or Remote (Anywhere)
*/

SELECT 
    job_postings_fact.job_title,
    company_dim.name AS company,
    job_postings_fact.salary_year_avg,
    job_postings_fact.job_location,
    job_postings_fact.job_posted_date
FROM job_postings_fact
LEFT JOIN company_dim ON
    company_dim.company_id = job_postings_fact.company_id
WHERE job_postings_fact.job_title_short = 'Data Analyst' AND
    job_postings_fact.job_location IN ('New York, NY', 'Anywhere') AND
    job_postings_fact.salary_year_avg IS NOT NULL
ORDER BY
    job_postings_fact.salary_year_avg DESC
LIMIT 20 -- Top 20 roles
```
### Query 2 - What are the skills required for these top-paying roles?
**Part 1 - Skills required for each top-paying role**
```
/*
What are the skills required for each top-paying role?
- Role: Data Analyst
- Location: New York, NY or Remote(Anywhere)
*/

WITH top_jobs AS (
    SELECT 
        job_postings_fact.job_id,
        job_postings_fact.job_title,
        job_postings_fact.salary_year_avg
    FROM job_postings_fact
    LEFT JOIN company_dim ON
        company_dim.company_id = job_postings_fact.company_id
    WHERE job_postings_fact.job_title_short = 'Data Analyst' AND
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


**Part 2 - Number of top-paying roles that require each skill**
```
/*
What are the skills required for these top-paying roles?
- Number of top-paying roles that require each skill
- Role: Data Analyst
- Location: New York, NY or Remote(Anywhere)
*/

WITH top_jobs AS (
    SELECT 
        job_postings_fact.job_id,
        job_postings_fact.job_title,
        job_postings_fact.salary_year_avg
    FROM job_postings_fact
    LEFT JOIN company_dim ON
        company_dim.company_id = job_postings_fact.company_id
    WHERE job_postings_fact.job_title_short = 'Data Analyst' AND
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


### Query 3 - What are the most in-demand skills for data analysts?
```
/*
What are the most in-demand skills for data analysts?
- Role: Data Analyst
- Location: New York, NY or Remote(Anywhere)
*/

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

### Query 4 - What are the highest-paying skills to learn? (top skills based on average salary)
```
/*
What are the highest-paying skills to learn? 
- (top skills based on average salary)
- Role: Data Analyst
- Location: New York, NY or Remote(Anywhere)
*/

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

### Query 5 - What are the most optimal skills to learn? (highest DEMAND and highest PAYING)
```
/*
What are the most optimal skills to learn?
- (highest PAYING and demand count of at least 50)
- Role: Data Analyst
- Location: New York, NY or Remote(Anywhere)
*/


SELECT 
    skills_dim.skill_id,
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

