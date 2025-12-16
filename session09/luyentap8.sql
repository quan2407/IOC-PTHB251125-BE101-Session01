CREATE TABLE Customers
(
    customer_id SERIAL PRIMARY KEY,         -- ID Khách hàng
    name        VARCHAR(100) NOT NULL,      -- Tên khách hàng
    total_spent NUMERIC(12, 2) DEFAULT 0.00 -- Tổng số tiền đã chi tiêu (khởi tạo bằng 0)
);


CREATE TABLE Orders
(
    order_id     SERIAL PRIMARY KEY,      -- ID Đơn hàng
    customer_id  INT            NOT NULL, -- ID Khách hàng (Khóa ngoại)
    total_amount NUMERIC(10, 2) NOT NULL, -- Tổng số tiền của đơn hàng

    -- Định nghĩa Khóa ngoại
    FOREIGN KEY (customer_id) REFERENCES Customers (customer_id)
);

INSERT INTO Customers (name)
VALUES ('Nguyễn Văn Phúc'), -- customer_id = 1
       ('Trần Thị Thảo'),   -- customer_id = 2
       ('Lê Hoàng Long'),   -- customer_id = 3
       ('Phạm Thu Hương'); -- customer_id = 4

INSERT INTO Orders (customer_id, total_amount)
VALUES
-- Khách hàng Phúc (ID 1): Tổng 100 + 50.50 = 150.50
(1, 100.00),
(1, 50.50),

-- Khách hàng Thảo (ID 2): Tổng 250.75
(2, 250.75),

-- Khách hàng Long (ID 3): Tổng 10 + 30 + 5 = 45.00
(3, 10.00),
(3, 30.00),
(3, 5.00),

-- Khách hàng Hương (ID 4): Tổng 500.00 (Đơn hàng lớn)
(4, 500.00),

-- Khách hàng Phúc (ID 1): Thêm một đơn nữa
(1, 10.00);

UPDATE Customers c
SET total_spent = sub.total_amount_sum
FROM (
         SELECT customer_id, SUM(total_amount) AS total_amount_sum
         FROM Orders
         GROUP BY customer_id
     ) AS sub
WHERE c.customer_id = sub.customer_id;

-- Các khách hàng không có đơn hàng sẽ giữ nguyên giá trị DEFAULT (0.00)

CREATE OR REPLACE PROCEDURE add_order_and_update_customer(
    p_customer_id INT,
    p_amount NUMERIC
)
    LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO Orders (customer_id, total_amount)
    VALUES (p_customer_id, p_amount);

    UPDATE Customers
    SET total_spent = total_spent + p_amount
    WHERE customer_id = p_customer_id;

    RAISE NOTICE 'Thêm đơn hàng cho Khách hàng ID % thành công. Tổng chi tiêu mới đã được cập nhật.', p_customer_id;
END;
$$;