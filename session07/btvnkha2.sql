CREATE TABLE customer (
                          customer_id SERIAL PRIMARY KEY,
                          full_name VARCHAR(100),
                          email VARCHAR(100),
                          phone VARCHAR(15)
);

CREATE TABLE orders (
                        order_id SERIAL PRIMARY KEY,
                        customer_id INT REFERENCES customer(customer_id),
                        total_amount DECIMAL(10,2),
                        order_date DATE
);

-- 1. Thêm dữ liệu vào bảng customer
INSERT INTO customer (full_name, email, phone)
VALUES
    ('Nguyen Van A', 'nguyenvana@example.com', '0901234567'),
    ('Tran Thi B', 'tranthib@example.com', '0912345678'),
    ('Le Van C', 'levanc@example.com', '0987654321');

-- 2. Thêm dữ liệu vào bảng orders
-- Giả sử customer_id lần lượt là 1, 2, 3 sau khi chạy lệnh trên
INSERT INTO orders (customer_id, total_amount, order_date)
VALUES
    (1, 150.50, '2023-10-01'), -- Đơn hàng của Nguyễn Văn A
    (1, 50.00, '2023-10-05'),  -- Đơn hàng thứ 2 của Nguyễn Văn A
    (2, 300.00, '2023-10-02'), -- Đơn hàng của Trần Thị B
    (3, 75.25, '2023-10-03');  -- Đơn hàng của Lê Văn C

create view v_order_summary as
SELECT full_name, total_amount, order_date
FROM customer c JOIN orders o on c.customer_id = o.customer_id;

select * from v_order_summary;

create view v_monthly_sales as
SELECT SUM(total_amount)
FROM orders;

-- Xóa view v_order_summary
DROP VIEW IF EXISTS v_order_summary;

-- Xóa view v_monthly_sales
DROP VIEW IF EXISTS v_monthly_sales;


-- DROP VIEW: Chỉ xóa định nghĩa (công thức) của View khỏi hệ thống. Không ảnh hưởng đến dữ liệu hay dung lượng ổ cứng.
-- DROP MATERIALIZED VIEW: Xóa định nghĩa VÀ xóa cả dữ liệu vật lý đang chiếm dụng trên ổ cứng.