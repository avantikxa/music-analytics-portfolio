CREATE OR REPLACE VIEW vw_weekly_source_mix AS
WITH weekly AS (
    SELECT
        a.artist_id,
        a.artist_name,
        r.release_id,
        r.release_name,
        FLOOR((ds.stream_date - r.release_date) / 7)::int AS week_index,
        SUM(ds.streams) AS weekly_streams,
        SUM(ds.streams * s.active_search_pct) AS active_search_streams,
        SUM(ds.streams * s.user_playlist_pct) AS user_playlist_streams,
        SUM(ds.streams * s.algorithmic_playlist_pct) AS algo_playlist_streams
    FROM daily_streams ds
    JOIN tracks t ON t.track_id = ds.track_id
    JOIN releases r ON r.release_id = t.release_id
    JOIN artists a ON a.artist_id = r.artist_id
    JOIN streaming_source_simulated s ON s.track_id = t.track_id
    WHERE ds.stream_date >= r.release_date
    GROUP BY 1,2,3,4,5
)
SELECT
    artist_id,
    artist_name,
    release_id,
    release_name,
    week_index,
    weekly_streams,
    active_search_streams,
    user_playlist_streams,
    algo_playlist_streams,
    active_search_streams / NULLIF(weekly_streams, 0)::float AS active_search_pct,
    user_playlist_streams / NULLIF(weekly_streams, 0)::float AS user_playlist_pct,
    algo_playlist_streams / NULLIF(weekly_streams, 0)::float AS algo_playlist_pct
FROM weekly
WHERE week_index >= 0
ORDER BY artist_name, release_name, week_index;
