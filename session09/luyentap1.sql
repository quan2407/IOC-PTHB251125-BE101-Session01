DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
                        order_id SERIAL PRIMARY KEY,
                        customer_id INT,
                        order_date DATE,
                        total_amount DECIMAL(10, 2)
);
INSERT INTO Orders (customer_id, order_date, total_amount) -- Bỏ cột order_id khỏi danh sách
SELECT
    (random() * 999 + 1)::int,   -- customer_id (Ngẫu nhiên từ 1 đến 1000)
    (NOW() - (random() * 365 * 3)::int * interval '1 day')::date, -- order_date (3 năm qua)
    ROUND((random() * 9900 + 100)::numeric, 2) -- total_amount (100.00 đến 10000.00)
FROM generate_series(1, 100000); -- Giữ generate_series(1, 100000) để tạo ra 100,000 hàng

-- Seq Scan on orders  (cost=0.00..1791.56 rows=462 width=28) (actual time=0.042..6.083 rows=95.00 loops=1)
--   Filter: (customer_id = 100)
--   Rows Removed by Filter: 99905
--   Buffers: shared hit=637
-- Planning:
--   Buffers: shared hit=8
-- Planning Time: 0.120 ms
-- Execution Time: 6.103 ms

CREATE INDEX idx_customer_id ON Orders (customer_id);
-- Bitmap Heap Scan on orders  (cost=8.17..642.51 rows=500 width=28) (actual time=0.782..0.862 rows=95.00 loops=1)
--   Recheck Cond: (customer_id = 100)
--   Heap Blocks: exact=91
--   Buffers: shared hit=91 read=2
--   ->  Bitmap Index Scan on idx_customer_id  (cost=0.00..8.04 rows=500 width=0) (actual time=0.520..0.520 rows=95.00 loops=1)
--         Index Cond: (customer_id = 100)
--         Index Searches: 1
--         Buffers: shared read=2
-- Planning:
--   Buffers: shared hit=15 read=1
-- Planning Time: 1.595 ms
-- Execution Time: 1.164 ms

EXPLAIN ANALYZE
SELECT * FROM Orders WHERE customer_id = 100;