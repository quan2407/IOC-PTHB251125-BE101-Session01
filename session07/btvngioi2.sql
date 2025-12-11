CREATE TABLE customer
(
    customer_id SERIAL PRIMARY KEY,
    full_name   VARCHAR(100),
    region      VARCHAR(50)
);

CREATE TABLE orders
(
    order_id     SERIAL PRIMARY KEY,
    customer_id  INT REFERENCES customer (customer_id),
    total_amount DECIMAL(10, 2),
    order_date   DATE,
    status       VARCHAR(20)
);

CREATE TABLE product
(
    product_id SERIAL PRIMARY KEY,
    name       VARCHAR(100),
    price      DECIMAL(10, 2),
    category   VARCHAR(50)
);

CREATE TABLE order_detail
(
    order_id   INT REFERENCES orders (order_id),
    product_id INT REFERENCES product (product_id),
    quantity   INT
);
-- 1. Thêm dữ liệu bảng Customer
INSERT INTO customer (full_name, region)
VALUES ('Nguyen Van A', 'Ha Noi'),
       ('Tran Thi B', 'Ho Chi Minh'),
       ('Le Van C', 'Da Nang'),
       ('Pham Thi D', 'Can Tho');

-- 2. Thêm dữ liệu bảng Product
INSERT INTO product (name, price, category)
VALUES ('Laptop Dell XPS', 25000000.00, 'Electronics'),
       ('iPhone 15', 30000000.00, 'Electronics'),
       ('Ao Thun Basic', 150000.00, 'Fashion'),
       ('Giay Sneakers', 1200000.00, 'Fashion'),
       ('Ban Phim Co', 2500000.00, 'Electronics');

-- 3. Thêm dữ liệu bảng Orders
-- (Giả sử ID customer lần lượt là 1, 2, 3...)
INSERT INTO orders (customer_id, total_amount, order_date, status)
VALUES (1, 27500000.00, '2023-10-01', 'Completed'), -- Khách 1 mua
       (2, 30000000.00, '2023-10-02', 'Shipped'),   -- Khách 2 mua
       (1, 150000.00, '2023-10-05', 'Pending'),     -- Khách 1 mua tiếp
       (3, 1200000.00, '2023-10-06', 'Cancelled');
-- Khách 3 mua

-- 4. Thêm dữ liệu bảng Order_detail
-- (Liên kết đơn hàng với sản phẩm cụ thể)
INSERT INTO order_detail (order_id, product_id, quantity)
VALUES (1, 1, 1), -- Đơn 1 mua 1 Laptop
       (1, 5, 1), -- Đơn 1 mua thêm 1 Bàn phím
       (2, 2, 1), -- Đơn 2 mua 1 iPhone
       (3, 3, 1), -- Đơn 3 mua 1 Áo thun
       (4, 4, 1); -- Đơn 4 mua 1 Giày

CREATE VIEW v_revenue_by_region AS
SELECT
    c.region,
    SUM(o.total_amount) AS total_revenue
FROM customer c
         JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.region;

SELECT * FROM v_revenue_by_region
ORDER BY total_revenue DESC
LIMIT 3;

CREATE MATERIALIZED VIEW mv_monthly_sales AS
SELECT
    DATE_TRUNC('month', order_date) AS month,
    SUM(total_amount) AS monthly_revenue
FROM orders
GROUP BY DATE_TRUNC('month', order_date);

CREATE OR REPLACE VIEW v_pending_orders AS
SELECT order_id, customer_id, total_amount, status
FROM orders
WHERE status = 'Pending'
        WITH CHECK OPTION;

UPDATE v_pending_orders
SET status = 'Completed'
WHERE order_id = 3;

CREATE VIEW v_revenue_above_avg AS
SELECT
    region,
    total_revenue
FROM
    v_revenue_by_region
WHERE
    total_revenue > (SELECT AVG(total_revenue) FROM v_revenue_by_region);