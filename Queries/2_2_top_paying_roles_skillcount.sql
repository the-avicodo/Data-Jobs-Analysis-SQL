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