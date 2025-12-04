CREATE OR REPLACE VIEW vw_return_on_hype AS
WITH stream_totals AS (
    SELECT
        a.artist_id,
        a.artist_name,
        SUM(ds.streams) AS total_streams
    FROM daily_streams ds
    JOIN tracks t ON t.track_id = ds.track_id
    JOIN releases r ON r.release_id = t.release_id
    JOIN artists a ON a.artist_id = r.artist_id
    GROUP BY a.artist_id, a.artist_name
),
hype_totals AS (
    SELECT
        artist_id,
        SUM(social_impressions) AS total_impressions,
        SUM(mention_volume) AS total_mentions,
        AVG(sentiment_score) AS avg_sentiment_score
    FROM social_sentiment
    GROUP BY artist_id
)
SELECT
    s.artist_id,
    s.artist_name,
    s.total_streams,
    h.total_impressions,
    h.total_mentions,
    h.avg_sentiment_score,
    (s.total_streams::float / NULLIF(h.total_impressions, 0)) AS roh_score
FROM stream_totals s
JOIN hype_totals h USING (artist_id)
ORDER BY roh_score DESC;
