CREATE OR REPLACE VIEW vw_catalog_stickiness AS
WITH track_level AS (
    SELECT
        r.release_id,
        r.release_name,
        t.track_id,
        t.is_single,
        SUM(ds.streams) AS total_track_streams
    FROM daily_streams ds
    JOIN tracks t ON t.track_id = ds.track_id
    JOIN releases r ON r.release_id = t.release_id
    GROUP BY r.release_id, r.release_name, t.track_id, t.is_single
),
album_level AS (
    SELECT
        release_id,
        release_name,
        SUM(total_track_streams) AS album_total_streams,
        SUM(total_track_streams) FILTER (WHERE is_single = 0) AS deep_cut_streams
    FROM track_level
    GROUP BY release_id, release_name
)
SELECT
    release_id,
    release_name,
    album_total_streams,
    deep_cut_streams,
    (deep_cut_streams::float / album_total_streams) AS css_score
FROM album_level
ORDER BY css_score DESC;
