/*
What are the most in-demand skills for my role?
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
    job_postings_fact.job_title_short = 'Data Analyst'
GROUP BY
    skill_name
ORDER BY 
    demand_count DESC
LIMIT 10

