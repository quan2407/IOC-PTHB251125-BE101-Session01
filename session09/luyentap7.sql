CREATE TABLE Customers
(
    customer_id SERIAL PRIMARY KEY,    -- ID khách hàng, khóa chính
    name        VARCHAR(100) NOT NULL, -- Tên khách hàng
    email       VARCHAR(100) UNIQUE    -- Email (đảm bảo duy nhất)
);

CREATE TABLE Orders
(
    order_id    SERIAL PRIMARY KEY,      -- ID đơn hàng, khóa chính
    customer_id INT            NOT NULL, -- ID khách hàng (khóa ngoại)
    amount      NUMERIC(10, 2) NOT NULL, -- Tổng số tiền đơn hàng
    order_date  DATE           NOT NULL, -- Ngày đặt hàng

    -- Định nghĩa Khóa ngoại
    FOREIGN KEY (customer_id) REFERENCES Customers (customer_id)
);

INSERT INTO Customers (name, email)
VALUES ('Nguyễn Văn A', 'a.nguyen@example.com'),
       ('Trần Thị B', 'b.tran@example.com'),
       ('Lê Hoàng C', 'c.le@example.com'),
       ('Phạm Minh D', 'd.pham@example.com'),
       ('Vũ Kim E', 'e.vu@example.com'),
       ('Đặng Thanh F', 'f.dang@example.com'); -- customer_id 6 (chưa có đơn hàng)

INSERT INTO Orders (customer_id, amount, order_date)
VALUES
-- Khách hàng A (ID 1)
(1, 50.00, '2025-11-01'),
(1, 150.99, '2025-11-15'),

-- Khách hàng B (ID 2)
(2, 25.50, '2025-11-02'),
(2, 300.00, '2025-12-05'),
(2, 45.75, '2025-12-06'),

-- Khách hàng C (ID 3)
(3, 100.00, '2025-11-05'),
(3, 10.99, '2025-12-10'),

-- Khách hàng D (ID 4)
(4, 75.25, '2025-11-20'),

-- Khách hàng E (ID 5)
(5, 500.00, '2025-12-01'), -- Đơn hàng lớn
(5, 12.50, '2025-12-02');

create or replace procedure add_order(p_customer_id INT, p_amount NUMERIC)
language plpgsql
as $$
    DECLARE
        cus_exists boolean;
    begin
    SELECT EXISTS(
        SELECT 1
        FROM Customers
        where customer_id = p_customer_id
    ) INTO cus_exists;
    IF cus_exists THEN
        INSERT INTO Orders (customer_id, amount, order_date) VALUES (p_customer_id,p_amount,CURRENT_DATE);
    ELSE
        RAISE EXCEPTION 'LỖI: Customer ID % không tồn tại trong bảng Customers.', p_customer_id;
    END IF ;
end;
$$;

CALL add_order(1, 99.99);
CALL add_order(999, 123.45);