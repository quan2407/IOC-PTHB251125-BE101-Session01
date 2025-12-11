CREATE TABLE post (
                      post_id SERIAL PRIMARY KEY,
                      user_id INT NOT NULL,
                      content TEXT,
                      tags TEXT[],
                      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                      is_public BOOLEAN DEFAULT TRUE
);

CREATE TABLE post_like (
                           user_id INT NOT NULL,
                           post_id INT NOT NULL,
                           liked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                           PRIMARY KEY (user_id, post_id)
);
-- 1. Xóa dữ liệu cũ (nếu có) để làm sạch
TRUNCATE TABLE post, post_like RESTART IDENTITY;

-------------------------------------------------------
-- 2. TẠO DỮ LIỆU "RÁC" (BULK DATA) - Khoảng 100.000 dòng
-- Mục đích: Làm đầy bảng để Index thấy sự khác biệt so với quét thường
-------------------------------------------------------
INSERT INTO post (user_id, content, tags, created_at, is_public)
SELECT
    (random() * 1000 + 1)::INT, -- Random user_id từ 1 đến 1000
    -- Tạo nội dung ngẫu nhiên
    md5(random()::text) || ' ' || md5(random()::text),
    -- Tạo tag ngẫu nhiên
    CASE
        WHEN random() < 0.3 THEN ARRAY['food', 'life']
        WHEN random() < 0.6 THEN ARRAY['tech', 'code']
        ELSE ARRAY['sport', 'gym']
        END,
    -- Random thời gian trong vòng 1 năm qua
    NOW() - (random() * (INTERVAL '365 days')),
    -- 80% là Public, 20% là Private
    (random() > 0.2)
FROM generate_series(1, 100000);


-------------------------------------------------------
-- 3. TẠO DỮ LIỆU ĐẶC BIỆT ĐỂ TEST TỪNG TRƯỜNG HỢP
-------------------------------------------------------

-- A. Dữ liệu test cho trường hợp: LIKE '%du lịch%' (Index Lower)
-- Chèn khoảng 500 bài viết có chứa từ "du lịch" viết hoa thường lộn xộn
INSERT INTO post (user_id, content, tags, created_at, is_public)
SELECT
    (random() * 1000 + 1)::INT,
    'Hôm nay gia đình đi Du Lịch tại ' || md5(random()::text), -- Nội dung chứa từ khóa
    ARRAY['travel', 'family'],
    NOW() - (random() * INTERVAL '30 days'),
    TRUE
FROM generate_series(1, 500);


-- B. Dữ liệu test cho trường hợp: tags @> ARRAY['travel'] (GIN Index)
-- Chèn khoảng 1000 bài viết có tag 'travel'
INSERT INTO post (user_id, content, tags, created_at, is_public)
SELECT
    (random() * 1000 + 1)::INT,
    'Bài viết về du lịch bụi ' || i,
    ARRAY['travel', 'backpacking', 'cheap'], -- Chứa tag 'travel'
    NOW() - (random() * INTERVAL '60 days'),
    TRUE
FROM generate_series(1, 1000) i;


-- C. Dữ liệu test cho trường hợp: User 1, 2, 3 (Composite Index)
-- Chèn nhiều bài viết cho user_id = 1, 2, 3 để test sắp xếp thời gian
INSERT INTO post (user_id, content, tags, created_at, is_public)
SELECT
    1, -- User ID cụ thể
    'Bài đăng của User 1 số ' || i,
    ARRAY['daily'],
    NOW() - (i * INTERVAL '1 hour'), -- Thời gian lùi dần đều
    TRUE
FROM generate_series(1, 50) i; -- 50 bài cho user 1

INSERT INTO post (user_id, content, tags, created_at, is_public)
SELECT 2, 'Post user 2 '||i, ARRAY['news'], NOW() - (i * INTERVAL '2 hour'), TRUE FROM generate_series(1, 50) i;

INSERT INTO post (user_id, content, tags, created_at, is_public)
SELECT 3, 'Post user 3 '||i, ARRAY['meme'], NOW() - (i * INTERVAL '30 minutes'), TRUE FROM generate_series(1, 50) i;

-- D. Dữ liệu test cho: Bài mới trong 7 ngày (Partial Index)
-- Đảm bảo có dữ liệu RẤT MỚI (hôm nay, hôm qua)
INSERT INTO post (user_id, content, tags, created_at, is_public)
SELECT
    555,
    'Tin tức nóng hổi vừa thổi vừa ăn ' || i,
    ARRAY['hot', 'news'],
    NOW() - (i * INTERVAL '10 minutes'), -- Rất mới
    TRUE
FROM generate_series(1, 100) i;

-------------------------------------------------------
-- 4. INSERT DỮ LIỆU VÀO BẢNG post_like (Cho đủ bộ)
-------------------------------------------------------
INSERT INTO post_like (user_id, post_id, liked_at)
SELECT
    (random() * 1000 + 1)::INT, -- Random User
    (random() * 100000 + 1)::INT, -- Random Post
    NOW()
FROM generate_series(1, 5000)
ON CONFLICT DO NOTHING; -- Bỏ qua nếu trùng lặp


CREATE INDEX idx_post_content_lower
    ON post(LOWER(content));

EXPLAIN ANALYZE
SELECT * FROM post
WHERE is_public = TRUE AND content ILIKE '%du lịch%';

-- Seq Scan on post  (cost=0.00..3264.88 rows=1486 width=120) (actual time=16.242..16.502 rows=1500.00 loops=1)
--   Filter: (tags @> '{travel}'::text[])
--   Rows Removed by Filter: 100250
--   Buffers: shared hit=1999
-- Planning:
--   Buffers: shared hit=78
-- Planning Time: 1.325 ms
-- Execution Time: 16.562 ms

CREATE INDEX idx_post_tags ON post USING GIN (tags);
-- Bitmap Heap Scan on post  (cost=24.57..1980.12 rows=1486 width=120) (actual time=0.104..0.219 rows=1500.00 loops=1)
--   Recheck Cond: (tags @> '{travel}'::text[])
--   Heap Blocks: exact=31
--   Buffers: shared hit=33
--   ->  Bitmap Index Scan on idx_post_tags  (cost=0.00..24.20 rows=1486 width=0) (actual time=0.085..0.085 rows=1500.00 loops=1)
--         Index Cond: (tags @> '{travel}'::text[])
--         Index Searches: 1
--         Buffers: shared hit=2
-- Planning:
--   Buffers: shared hit=22
-- Planning Time: 1.048 ms
-- Execution Time: 0.792 ms

EXPLAIN ANALYZE
SELECT * FROM post WHERE tags @> ARRAY['travel'];



-- Seq Scan on post  (cost=0.00..3773.62 rows=1981 width=120) (actual time=0.019..21.686 rows=2045.00 loops=1)
--   Filter: (is_public AND (created_at >= (now() - '7 days'::interval)))
--   Rows Removed by Filter: 99705
--   Buffers: shared hit=1993
-- Planning:
--   Buffers: shared hit=7
-- Planning Time: 0.163 ms
-- Execution Time: 21.762 ms

CREATE INDEX idx_post_recent_public
    ON post(created_at DESC)
    WHERE is_public = TRUE;
-- Bitmap Heap Scan on post  (cost=39.65..2132.89 rows=1981 width=120) (actual time=0.373..1.269 rows=2045.00 loops=1)
--   Recheck Cond: ((created_at >= (now() - '7 days'::interval)) AND is_public)
--   Heap Blocks: exact=1136
--   Buffers: shared hit=1136 read=7
--   ->  Bitmap Index Scan on idx_post_recent_public  (cost=0.00..39.15 rows=1981 width=0) (actual time=0.251..0.251 rows=2045.00 loops=1)
--         Index Cond: (created_at >= (now() - '7 days'::interval))
--         Index Searches: 1
--         Buffers: shared read=7
-- Planning:
--   Buffers: shared hit=18 read=1
-- Planning Time: 0.982 ms
-- Execution Time: 1.337 ms

EXPLAIN ANALYZE
SELECT * FROM post
WHERE is_public = TRUE AND created_at >= NOW() - INTERVAL '7 days';




-- Limit  (cost=3399.73..3399.76 rows=10 width=120) (actual time=41.962..41.965 rows=10.00 loops=1)
--   Buffers: shared read=1993
--   ->  Sort  (cost=3399.73..3400.62 rows=355 width=120) (actual time=41.960..41.961 rows=10.00 loops=1)
--         Sort Key: created_at DESC
--         Sort Method: top-N heapsort  Memory: 26kB
--         Buffers: shared read=1993
--         ->  Seq Scan on post  (cost=0.00..3392.06 rows=355 width=120) (actual time=0.920..41.748 rows=407.00 loops=1)
-- "              Filter: (user_id = ANY ('{1,2,3}'::integer[]))"
--               Rows Removed by Filter: 101343
--               Buffers: shared read=1993
-- Planning Time: 0.286 ms
-- Execution Time: 42.003 ms

CREATE INDEX idx_post_user_recent
    ON post(user_id, created_at DESC);
-- Limit  (cost=937.01..937.03 rows=10 width=120) (actual time=0.547..0.549 rows=10.00 loops=1)
--   Buffers: shared hit=323 read=4
--   ->  Sort  (cost=937.01..937.89 rows=355 width=120) (actual time=0.546..0.547 rows=10.00 loops=1)
--         Sort Key: created_at DESC
--         Sort Method: top-N heapsort  Memory: 26kB
--         Buffers: shared hit=323 read=4
--         ->  Bitmap Heap Scan on post  (cost=16.00..929.33 rows=355 width=120) (actual time=0.209..0.489 rows=407.00 loops=1)
-- "              Recheck Cond: (user_id = ANY ('{1,2,3}'::integer[]))"
--               Heap Blocks: exact=323
--               Buffers: shared hit=323 read=4
--               ->  Bitmap Index Scan on idx_post_user_recent  (cost=0.00..15.91 rows=355 width=0) (actual time=0.128..0.128 rows=407.00 loops=1)
-- "                    Index Cond: (user_id = ANY ('{1,2,3}'::integer[]))"
--                     Index Searches: 1
--                     Buffers: shared read=4
-- Planning:
--   Buffers: shared hit=22 read=1
-- Planning Time: 1.036 ms
-- Execution Time: 0.626 ms

EXPLAIN ANALYZE
SELECT * FROM post
WHERE user_id IN (1, 2, 3)
ORDER BY created_at DESC
LIMIT 10;