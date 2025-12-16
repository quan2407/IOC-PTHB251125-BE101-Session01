DROP TABLE IF EXISTS Users;

CREATE TABLE Users (
                       user_id SERIAL PRIMARY KEY,
                       email VARCHAR(255) UNIQUE,
                       username VARCHAR(100)
);

INSERT INTO Users (email, username)
SELECT
    'user_' || gs || '@example.com' AS email,
    'User Name ' || gs AS username
FROM generate_series(1, 100000) AS gs;

-- Index Scan using users_email_key on users  (cost=0.41..8.43 rows=1 width=738) (actual time=0.022..0.023 rows=1.00 loops=1)
--   Index Cond: ((email)::text = 'user_50000@example.com'::text)
--   Index Searches: 1
--   Buffers: shared hit=4
-- Planning:
--   Buffers: shared hit=2
-- Planning Time: 0.105 ms
-- Execution Time: 0.034 ms

CREATE INDEX idx_email_hash ON Users USING HASH (email);
-- Index Scan using idx_email_hash on users  (cost=0.00..8.02 rows=1 width=738) (actual time=0.017..0.019 rows=1.00 loops=1)
--   Index Cond: ((email)::text = 'user_50000@example.com'::text)
--   Index Searches: 1
--   Buffers: shared hit=3
-- Planning Time: 0.074 ms
-- Execution Time: 0.032 ms

EXPLAIN ANALYZE
SELECT * FROM Users WHERE email = 'user_50000@example.com';
