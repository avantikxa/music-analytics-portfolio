WITH base AS (
    SELECT
        release_id,
        release_name,
        week_index,
        pct_of_peak
    FROM vw_decay_normalized
)
SELECT
    release_name,
    MIN(week_index) AS hype_half_life_week
FROM base
WHERE pct_of_peak <= 50
GROUP BY release_name
ORDER BY hype_half_life_week;
