CREATE OR REPLACE VIEW vw_user_cohorts AS
SELECT
    ac.user_id,
    ac.artist_id,
    ac.first_stream_date,
    CASE
        WHEN ac.first_stream_date <= DATE '2023-01-01' THEN 'Day One'
        WHEN ac.first_stream_date <= DATE '2023-06-01' THEN 'Early Adopter'
        WHEN ac.first_stream_date <= DATE '2024-01-01' THEN 'Viral Adopter'
        ELSE 'Late Majority'
    END AS cohort_group
FROM audience_cohorts ac;

CREATE OR REPLACE VIEW vw_cohort_growth AS
SELECT
    artist_id,
    cohort_group,
    DATE_TRUNC('month', first_stream_date) AS month,
    COUNT(*) AS users_joined
FROM vw_user_cohorts
GROUP BY artist_id, cohort_group, DATE_TRUNC('month', first_stream_date)
ORDER BY artist_id, month;

CREATE OR REPLACE VIEW vw_cohort_recency AS
SELECT
    cohort_group,
    COUNT(*) AS cohort_size,
    COUNT(*) FILTER (WHERE first_stream_date >= DATE '2024-06-01') AS recent_users,
    (COUNT(*) FILTER (WHERE first_stream_date >= DATE '2024-06-01')::float / COUNT(*)) AS recency_retention_proxy
FROM vw_user_cohorts
GROUP BY cohort_group
ORDER BY recency_retention_proxy DESC;
