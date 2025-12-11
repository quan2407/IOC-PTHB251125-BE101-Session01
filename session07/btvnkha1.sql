
CREATE TABLE book (
                      book_id SERIAL PRIMARY KEY,
                      title VARCHAR(255),
                      author VARCHAR(100),
                      genre VARCHAR(50),
                      price DECIMAL(10,2),
                      description TEXT,
                      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
TRUNCATE TABLE book RESTART IDENTITY;

INSERT INTO book (title, author, genre, price, description)
SELECT
    'Book Title ' || md5(random()::text), -- Tên sách ngẫu nhiên
    CASE
        WHEN random() < 0.3 THEN 'J.K. Rowling' -- Tạo nhiều sách cho Rowling để test
        WHEN random() < 0.6 THEN 'Tolkien'
        ELSE 'Author ' || (random() * 1000)::INT
        END,
    CASE
        WHEN random() < 0.2 THEN 'Fantasy' -- Tạo nhiều sách Fantasy để test Cluster
        WHEN random() < 0.4 THEN 'Sci-Fi'
        ELSE 'Romance'
        END,
    (random() * 100)::DECIMAL(10,2),
    'Description content with keywords like magic, dragon and adventure ' || md5(random()::text)
FROM generate_series(1, 500000);

-- Seq Scan on book  (cost=0.00..19408.00 rows=208583 width=179) (actual time=0.010..46.875 rows=209686.00 loops=1)
--   Filter: ((author)::text = 'Tolkien'::text)
--   Rows Removed by Filter: 290314
--   Buffers: shared hit=13158
-- Planning:
--   Buffers: shared hit=7
-- Planning Time: 0.525 ms
-- Execution Time: 52.504 ms


create index if not exists idx_book_author on book(author);
EXPLAIN ANALYZE SELECT * FROM book WHERE author = 'Tolkien';
-- Bitmap Heap Scan on book  (cost=2336.94..18102.23 rows=208583 width=179) (actual time=6.795..37.398 rows=209686.00 loops=1)
--   Recheck Cond: ((author)::text = 'Tolkien'::text)
--   Heap Blocks: exact=13158
--   Buffers: shared hit=13158 read=180
--   ->  Bitmap Index Scan on idx_book_author  (cost=0.00..2284.80 rows=208583 width=0) (actual time=5.398..5.398 rows=209686.00 loops=1)
--         Index Cond: ((author)::text = 'Tolkien'::text)
--         Index Searches: 1
--         Buffers: shared read=180
-- Planning:
--   Buffers: shared hit=17 read=1
-- Planning Time: 0.920 ms
-- Execution Time: 42.970 ms



create index if not exists idx_book_genre on book(genre);

-- Bitmap Heap Scan on book  (cost=1112.32..15515.32 rows=99600 width=179) (actual time=4.890..36.791 rows=100249.00 loops=1)
--   Recheck Cond: ((genre)::text = 'Fantasy'::text)
--   Heap Blocks: exact=13155
--   Buffers: shared hit=7335 read=5907
--   ->  Bitmap Index Scan on idx_book_genre  (cost=0.00..1087.42 rows=99600 width=0) (actual time=3.544..3.544 rows=100249.00 loops=1)
--         Index Cond: ((genre)::text = 'Fantasy'::text)
--         Index Searches: 1
--         Buffers: shared read=87
-- Planning:
--   Buffers: shared hit=17 read=1
-- Planning Time: 0.908 ms
-- Execution Time: 39.669 ms

EXPLAIN ANALYZE SELECT * FROM book WHERE genre = 'Fantasy';


-- Gather  (cost=1000.00..16762.27 rows=1 width=179) (actual time=50.011..54.982 rows=1.00 loops=1)
--   Workers Planned: 2
--   Workers Launched: 2
--   Buffers: shared hit=6840 read=6318
--   ->  Parallel Seq Scan on book  (cost=0.00..15762.17 rows=1 width=179) (actual time=23.520..23.529 rows=0.33 loops=3)
--         Filter: ((title)::text = 'Book Title c05210c8a15f81c99481935c494168b9'::text)
--         Rows Removed by Filter: 166666
--         Buffers: shared hit=6840 read=6318
-- Planning:
--   Buffers: shared hit=6 dirtied=1
-- Planning Time: 0.527 ms
-- Execution Time: 55.015 ms


CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE EXTENSION IF NOT EXISTS btree_gin;
CREATE INDEX idx_book_title_trgm
    ON book USING GIN (title);
-- Bitmap Heap Scan on book  (cost=21.35..25.37 rows=1 width=179) (actual time=0.027..0.028 rows=1.00 loops=1)
--   Recheck Cond: ((title)::text = 'Book Title c05210c8a15f81c99481935c494168b9'::text)
--   Heap Blocks: exact=1
--   Buffers: shared hit=5
--   ->  Bitmap Index Scan on idx_book_title_trgm  (cost=0.00..21.35 rows=1 width=0) (actual time=0.018..0.019 rows=1.00 loops=1)
--         Index Cond: ((title)::text = 'Book Title c05210c8a15f81c99481935c494168b9'::text)
--         Index Searches: 1
--         Buffers: shared hit=4
-- Planning:
--   Buffers: shared hit=17
-- Planning Time: 0.906 ms
-- Execution Time: 0.053 ms

EXPLAIN ANALYZE
SELECT * FROM book WHERE title = 'Book Title c05210c8a15f81c99481935c494168b9';

-- Seq Scan on book  (cost=0.00..19408.00 rows=99600 width=179) (actual time=0.023..56.446 rows=100249.00 loops=1)
--   Filter: ((genre)::text = 'Fantasy'::text)
--   Rows Removed by Filter: 399751
--   Buffers: shared hit=6765 read=6393
-- Planning Time: 0.107 ms
-- Execution Time: 59.317 ms


-- Bitmap Heap Scan on book  (cost=1112.32..15515.32 rows=99600 width=179) (actual time=4.614..26.091 rows=100249.00 loops=1)
--   Recheck Cond: ((genre)::text = 'Fantasy'::text)
--   Heap Blocks: exact=13155
--   Buffers: shared hit=13242
--   ->  Bitmap Index Scan on idx_book_genre  (cost=0.00..1087.42 rows=99600 width=0) (actual time=3.141..3.141 rows=100249.00 loops=1)
--         Index Cond: ((genre)::text = 'Fantasy'::text)
--         Index Searches: 1
--         Buffers: shared hit=87
-- Planning Time: 0.106 ms
-- Execution Time: 28.891 ms

cluster book using idx_book_genre;
-- Bitmap Heap Scan on book  (cost=1112.32..15515.32 rows=99600 width=179) (actual time=2.545..12.382 rows=100249.00 loops=1)
--   Recheck Cond: ((genre)::text = 'Fantasy'::text)
--   Heap Blocks: exact=2639
--   Buffers: shared read=2726
--   ->  Bitmap Index Scan on idx_book_genre  (cost=0.00..1087.42 rows=99600 width=0) (actual time=2.247..2.247 rows=100249.00 loops=1)
--         Index Cond: ((genre)::text = 'Fantasy'::text)
--         Index Searches: 1
--         Buffers: shared read=87
-- Planning:
--   Buffers: shared hit=35 read=4
-- Planning Time: 1.779 ms

EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM book WHERE genre = 'Fantasy';



