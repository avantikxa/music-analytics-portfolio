CREATE OR REPLACE VIEW vw_weekly_decay AS
WITH base AS (
    SELECT
        r.artist_id,
        r.release_id,
        r.release_name,
        FLOOR((ds.stream_date - r.release_date) / 7)::int AS week_index,
        ds.stream_date,
        ds.streams
    FROM daily_streams ds
    JOIN tracks t ON t.track_id = ds.track_id
    JOIN releases r ON r.release_id = t.release_id
    WHERE ds.stream_date >= r.release_date
)
SELECT
    artist_id,
    release_id,
    release_name,
    week_index,
    MIN(base.stream_date) AS week_start,
    SUM(base.streams) AS weekly_streams
FROM base
GROUP BY artist_id, release_id, release_name, week_index
ORDER BY release_id, week_index;

CREATE OR REPLACE VIEW vw_decay_normalized AS
WITH base AS (
    SELECT *,
           MAX(weekly_streams) OVER (PARTITION BY release_id) AS peak_streams
    FROM vw_weekly_decay
)
SELECT
    artist_id,
    release_id,
    release_name,
    week_index,
    week_start,
    weekly_streams,
    peak_streams,
    (weekly_streams::float / peak_streams) * 100 AS pct_of_peak
FROM base
ORDER BY release_id, week_index;
