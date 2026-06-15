/*
What are the highest-paying skills to learn? (top skills based on average salary)
*/
--NEEDS TO EDIT


SELECT 
    skills AS skill,
    ROUND(AVG(salary_year_avg),0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON
    skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON
    skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    job_postings_fact.salary_year_avg IS NOT NULL
    AND job_title_short = 'Data Analyst'
GROUP BY
    skill
ORDER BY
    avg_salary DESC
LIMIT 10

