CREATE OR REPLACE VIEW vw_daily_artist_streams AS
SELECT
    a.artist_id,
    a.artist_name,
    ds.stream_date AS date,
    SUM(ds.streams) AS daily_streams
FROM daily_streams ds
JOIN tracks t ON t.track_id = ds.track_id
JOIN releases r ON r.release_id = t.release_id
JOIN artists a ON a.artist_id = r.artist_id
GROUP BY 1,2,3;

CREATE OR REPLACE VIEW vw_sentiment_streams AS
SELECT
    s.artist_id,
    a.artist_name,
    s.date,
    das.daily_streams,
    s.sentiment_score,
    s.social_impressions,
    s.mention_volume
FROM social_sentiment s
JOIN artists a ON a.artist_id = s.artist_id
JOIN vw_daily_artist_streams das
ON das.artist_id = s.artist_id AND das.date = s.date;

CREATE OR REPLACE VIEW vw_sentiment_streams_lag AS
SELECT
    artist_id,
    artist_name,
    date,
    daily_streams,
    sentiment_score,
    social_impressions,
    mention_volume,
    LAG(sentiment_score, 1) OVER (PARTITION BY artist_id ORDER BY date) AS sentiment_lag1,
    LAG(social_impressions, 1) OVER (PARTITION BY artist_id ORDER BY date) AS impressions_lag1,
    LAG(mention_volume, 1) OVER (PARTITION BY artist_id ORDER BY date) AS mentions_lag1
FROM vw_sentiment_streams;
