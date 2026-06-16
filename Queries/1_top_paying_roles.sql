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
    job_postings_fact.job_posted_date::DATE
FROM job_postings_fact
LEFT JOIN company_dim ON
    company_dim.company_id = job_postings_fact.company_id
WHERE job_postings_fact.job_title_short = 'Data Analyst' AND
    job_postings_fact.job_location IN ('New York, NY', 'Anywhere') AND
    job_postings_fact.salary_year_avg IS NOT NULL
ORDER BY
    job_postings_fact.salary_year_avg DESC
LIMIT 20 -- Top 20 roles


