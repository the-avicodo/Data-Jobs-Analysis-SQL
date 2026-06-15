/*
What are the skills required for these top-paying roles?
*/
WITH top_jobs AS (
    SELECT 
        job_postings_fact.job_id,
        job_postings_fact.job_title,
        job_postings_fact.salary_year_avg
    FROM 
        job_postings_fact
    WHERE 
        job_postings_fact.job_title_short = 'Data Analyst' AND 
        job_postings_fact.salary_year_avg IS NOT NULL
    ORDER BY 
        job_postings_fact.salary_year_avg DESC
    LIMIT 10
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




