create schema if not exists customersales;
set search_path to customersales;
CREATE TABLE IF NOT EXISTS customers
(
    customer_id   SERIAL PRIMARY KEY,
    customer_name VARCHAR(100),
    city          VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS orders
(
    order_id     SERIAL PRIMARY KEY,
    customer_id  INT REFERENCES customers (customer_id),
    order_date   DATE,
    total_amount NUMERIC(10, 2)
);

CREATE TABLE IF NOT EXISTS order_items
(
    item_id      SERIAL PRIMARY KEY,
    order_id     INT REFERENCES orders (order_id),
    product_name VARCHAR(100),
    quantity     INT,
    price        NUMERIC(10, 2)
);
INSERT INTO customers (customer_id, customer_name, city)
VALUES
    (1, 'Nguyễn Văn A', 'Hà Nội'),
    (2, 'Trần Thị B', 'Đà Nẵng'),
    (3, 'Lê Văn C', 'Hồ Chí Minh'),
    (4, 'Phạm Thị D', 'Hà Nội');

-- Sử dụng cột total_amount để khớp với cấu trúc bảng đã tạo
INSERT INTO orders (order_id, customer_id, order_date, total_amount)
VALUES
    (101, 1, '2024-12-20', 3000),
    (102, 2, '2025-01-05', 1500),
    (103, 1, '2025-02-10', 2500),
    (104, 3, '2025-02-15', 4000),
    (105, 4, '2025-03-01', 800);

INSERT INTO order_items (item_id, order_id, product_name, quantity, price)
VALUES
    (1, 101, 'Laptop Gaming', 2, 1500),
    (2, 102, 'Laptop Gaming', 1, 1500), -- Product ID 1
    (3, 103, 'Máy ảnh EOS', 5, 500),    -- Product ID 3
    (4, 104, 'Smart TV', 4, 1000),       -- Product ID 2
    (5, 105, 'Smart TV', 1, 800);
-- a. Hiển thị danh sách tất cả các đơn hàng với các cột:
--    Tên khách (customer_name), Ngày đặt hàng (order_date), Tổng tiền (total_amount)
SELECT customer_name,order_date,total_amount
FROM customers c
JOIN orders o on c.customer_id = o.customer_id;

-- a. Tính các thông tin tổng hợp:
--    Tổng doanh thu (SUM), Trung bình (AVG), Lớn nhất (MAX),
--    Nhỏ nhất (MIN), Số lượng đơn hàng (COUNT)
SELECT sum(total_amount), avg(total_amount), max(total_amount), min(total_amount),count(order_id)
FROM orders;
-- a. Tính tổng doanh thu theo từng thành phố (GROUP BY city)
-- b. Chỉ hiển thị những thành phố có tổng doanh thu lớn hơn 10.000 (HAVING > 10000)
SELECT city,sum(total_amount)
FROM customers c
         JOIN orders o on c.customer_id = o.customer_id
group by city
HAVING sum(total_amount) > 10000;
-- a. Liệt kê tất cả các sản phẩm đã bán, kèm:
--    Tên khách hàng, Ngày đặt hàng, Số lượng và giá
--    (JOIN 3 bảng customers, orders, order_items)
select customer_name,order_date,quantity,price
from customers c
join orders o on c.customer_id = o.customer_id
join order_items oi on o.order_id = oi.order_id;
-- YÊU CẦU 5: Subquery
-- a. Tìm tên khách hàng có tổng doanh thu cao nhất.
-- b. Gợi ý: Dùng SUM(total_amount) trong subquery để tìm MAX
SELECT c.customer_name
FROM customers c
         JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name
HAVING SUM(o.total_amount) = (
    SELECT SUM(total_amount)
    FROM orders
    GROUP BY customer_id
    ORDER BY SUM(total_amount) DESC
    LIMIT 1
);


