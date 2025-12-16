CREATE TABLE Products
(
    product_id     SERIAL PRIMARY KEY,
    category_id    INT,
    price          NUMERIC,
    stock_quantity INT
);
-- Chuẩn bị 100 dòng dữ liệu mẫu
INSERT INTO Products (category_id, price, stock_quantity)
VALUES (1, 10.50, 100),
       (1, 20.00, 50),
       (1, 5.99, 200),
       (1, 15.75, 80),
       (1, 30.00, 20),
       (2, 45.00, 120),
       (2, 50.99, 90),
       (2, 35.50, 150),
       (2, 60.00, 30),
       (2, 40.25, 75),
       (3, 12.00, 180),
       (3, 22.50, 60),
       (3, 8.75, 250),
       (3, 18.99, 110),
       (3, 28.00, 40),
       (4, 70.00, 50),
       (4, 85.50, 25),
       (4, 65.99, 85),
       (4, 95.00, 15),
       (4, 75.20, 65),
       (5, 5.00, 300),
       (5, 10.00, 150),
       (5, 3.50, 400),
       (5, 12.99, 100),
       (5, 8.25, 220),
       (6, 150.00, 20),
       (6, 180.50, 10),
       (6, 130.75, 30),
       (6, 200.00, 5),
       (6, 165.99, 15),
       (7, 25.00, 140),
       (7, 35.99, 70),
       (7, 20.25, 190),
       (7, 40.00, 55),
       (7, 30.50, 95),
       (8, 9.50, 210),
       (8, 19.99, 130),
       (8, 4.00, 350),
       (8, 14.75, 90),
       (8, 24.50, 60),
       (9, 110.00, 40),
       (9, 135.50, 18),
       (9, 99.99, 55),
       (9, 150.00, 8),
       (9, 120.75, 35),
       (10, 6.50, 280),
       (10, 16.00, 120),
       (10, 2.99, 450),
       (10, 11.25, 95),
       (10, 21.00, 70),

-- Tiếp tục thêm các dòng ngẫu nhiên để đạt 100
       (1, 10.10, 10),
       (2, 45.45, 10),
       (3, 12.12, 10),
       (4, 70.70, 10),
       (5, 5.05, 10),
       (6, 150.15, 10),
       (7, 25.25, 10),
       (8, 9.09, 10),
       (9, 110.11, 10),
       (10, 6.06, 10),
       (1, 25.00, 150),
       (2, 55.00, 80),
       (3, 15.00, 200),
       (4, 80.00, 40),
       (5, 7.50, 350),
       (6, 170.00, 15),
       (7, 30.00, 100),
       (8, 15.00, 160),
       (9, 125.00, 30),
       (10, 10.00, 250),
       (1, 17.50, 90),
       (2, 48.00, 70),
       (3, 11.50, 220),
       (4, 72.00, 60),
       (5, 6.00, 320),
       (6, 155.00, 25),
       (7, 28.00, 110),
       (8, 10.50, 180),
       (9, 115.00, 45),
       (10, 8.00, 290),
       (1, 13.00, 130),
       (2, 42.00, 100),
       (3, 9.00, 240),
       (4, 68.00, 75),
       (5, 4.50, 380),
       (6, 140.00, 35),
       (7, 22.00, 160),
       (8, 7.00, 230),
       (9, 105.00, 50),
       (10, 5.50, 310),
       (1, 19.00, 70),
       (2, 52.00, 50),
       (3, 14.00, 170),
       (4, 78.00, 30),
       (5, 9.00, 250),
       (6, 190.00, 12),
       (7, 38.00, 85),
       (8, 17.00, 105),
       (9, 145.00, 20),
       (10, 14.00, 140);
CREATE INDEX idx_products_category
    ON Products (category_id);
-- Sort  (cost=2.26..2.26 rows=1 width=44) (actual time=0.029..0.030 rows=10.00 loops=1)
--   Sort Key: price
--   Sort Method: quicksort  Memory: 25kB
--   Buffers: shared hit=1
--   ->  Seq Scan on products  (cost=0.00..2.25 rows=1 width=44) (actual time=0.015..0.018 rows=10.00 loops=1)
--         Filter: (category_id = 5)
--         Rows Removed by Filter: 90
--         Buffers: shared hit=1
-- Planning:
--   Buffers: shared hit=53 read=2
-- Planning Time: 2.419 ms
-- Execution Time: 0.050 ms

CLUSTER Products USING idx_products_category;
-- Sort  (cost=2.42..2.44 rows=10 width=17) (actual time=0.025..0.026 rows=10.00 loops=1)
--   Sort Key: price
--   Sort Method: quicksort  Memory: 25kB
--   Buffers: shared hit=1
--   ->  Seq Scan on products  (cost=0.00..2.25 rows=10 width=17) (actual time=0.014..0.017 rows=10.00 loops=1)
--         Filter: (category_id = 5)
--         Rows Removed by Filter: 90
--         Buffers: shared hit=1
-- Planning:
--   Buffers: shared hit=27 read=3
-- Planning Time: 2.458 ms
-- Execution Time: 0.040 ms

CREATE INDEX idx_products_price
    ON Products (price);

EXPLAIN ANALYZE
SELECT *
FROM Products
WHERE category_id = 5
ORDER BY price;

