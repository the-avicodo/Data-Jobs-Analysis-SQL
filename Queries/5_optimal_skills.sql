/*
What are the most optimal skills to learn?
- (highest PAYING and demand count of at least 50)
- Role: Data Analyst
- Location: New York, NY or Remote(Anywhere)
*/


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