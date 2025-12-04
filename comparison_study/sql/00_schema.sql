-- Artists table
CREATE TABLE artists (
    artist_id INT PRIMARY KEY,
    artist_name TEXT
);

-- Releases table
CREATE TABLE releases (
    release_id INT PRIMARY KEY,
    artist_id INT REFERENCES artists (artist_id),
    release_name TEXT,
    release_type TEXT,
    release_date DATE
);

-- Tracks table
CREATE TABLE tracks (
    track_id INT PRIMARY KEY,
    release_id INT REFERENCES releases (release_id),
    track_name TEXT,
    is_single INT
);

-- Daily Streams table
CREATE TABLE daily_streams (
    track_id INT REFERENCES tracks (track_id),
    stream_date DATE,
    streams INT
);

-- Social Sentiment
CREATE TABLE social_sentiment (
    artist_id INT REFERENCES artists (artist_id),
    date DATE,
    sentiment_score FLOAT,
    social_impressions BIGINT,
    mention_volume BIGINT
);

-- Audience Cohorts
CREATE TABLE audience_cohorts (
    user_id INT,
    artist_id INT REFERENCES artists (artist_id),
    first_stream_date DATE,
    cohort_label TEXT
);

-- User History
CREATE TABLE user_history (
    user_id INT,
    artist_id INT REFERENCES artists (artist_id),
    streamed_previous_album INT,
    streamed_new_album INT,
    streams INT
);

-- Streaming Source Split
CREATE TABLE streaming_source_simulated (
    track_id INT,
    active_search_pct FLOAT,
    algorithmic_playlist_pct FLOAT,
    user_playlist_pct FLOAT
);
