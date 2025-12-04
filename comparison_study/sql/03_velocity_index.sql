CREATE OR REPLACE VIEW vw_velocity_index AS
WITH daily AS (
    SELECT
        r.release_id,
        r.release_name,
        ds.stream_date,
        SUM(ds.streams) AS daily_streams
    FROM daily_streams ds
    JOIN tracks t ON t.track_id = ds.track_id
    JOIN releases r ON r.release_id = t.release_id
    GROUP BY r.release_id, r.release_name, ds.stream_date
),
cumulative AS (
    SELECT
        release_id,
        release_name,
        stream_date,
        SUM(daily_streams)
            OVER (PARTITION BY release_id ORDER BY stream_date) AS cum_streams
    FROM daily
),
total AS (
    SELECT
        release_id,
        release_name,
        MAX(cum_streams) AS total_streams
    FROM cumulative
    GROUP BY release_id, release_name
),
threshold AS (
    SELECT
        c.release_id,
        c.release_name,
        MIN(c.stream_date) AS date_reached_threshold
    FROM cumulative c
    JOIN total t USING (release_id, release_name)
    WHERE c.cum_streams >= t.total_streams * 0.20
    GROUP BY c.release_id, c.release_name
)
SELECT
    t.release_id,
    t.release_name,
    t.total_streams,
    threshold.date_reached_threshold,
    (threshold.date_reached_threshold - r.release_date) AS days_to_20pct,
    (t.total_streams::float /
        NULLIF((threshold.date_reached_threshold - r.release_date), 0)) AS velocity_index
FROM total t
JOIN releases r ON r.release_id = t.release_id
JOIN threshold ON threshold.release_id = t.release_id
ORDER BY velocity_index DESC;
