CREATE TABLE Sales
(
    sale_id     SERIAL PRIMARY KEY,      -- ID giao dịch, khóa chính
    customer_id INT            NOT NULL, -- ID khách hàng
    amount      NUMERIC(10, 2) NOT NULL, -- Số tiền giao dịch
    sale_date   DATE           NOT NULL  -- Ngày giao dịch
);

INSERT INTO Sales (customer_id, amount, sale_date)
VALUES
-- Khách hàng 101 - Giao dịch nhiều nhất
(101, 50.00, '2025-10-01'),
(101, 25.99, '2025-10-01'),
(101, 300.75, '2025-10-03'),
(101, 75.25, '2025-10-05'),
(101, 50.00, '2025-12-07'),

-- Các Khách hàng khác
(102, 120.50, '2025-10-01'),
(103, 50.00, '2025-10-02'),
(104, 300.75, '2025-10-02'),
(102, 88.00, '2025-10-02'),
(105, 15.00, '2025-10-03'),
(103, 120.50, '2025-10-03'),

-- Các giao dịch lớn/nhỏ
(106, 450.00, '2025-10-04'), -- Lớn nhất
(107, 10.99, '2025-10-04'),  -- Nhỏ nhất
(108, 220.00, '2025-10-05'),
(109, 50.00, '2025-10-05'),

-- Giao dịch Tháng 11 và Tháng 12
(102, 25.99, '2025-11-06'),
(110, 88.00, '2025-11-06'),
(104, 450.00, '2025-12-07'),
(105, 75.25, '2025-12-07'),
(102, 10.99, '2025-12-07');

create or replace procedure calculate_total_sales(start_date DATE, end_date DATE, OUT total NUMERIC)
    language plpgsql
as $$
begin
    SELECT sum(Sales.amount)
    INTO total
    FROM Sales
    WHERE sale_date BETWEEN start_date AND end_date;
    IF total IS NULL THEN
        total := 0;
    END IF;
end;
$$;

CALL calculate_total_sales('2025-10-01', '2025-10-31', 0);

DO $$
    DECLARE
        result_total NUMERIC;
    BEGIN
        CALL calculate_total_sales('2025-10-01', '2025-10-31', result_total);
        RAISE NOTICE 'Tổng doanh số tháng 10: %', result_total;
    END $$;