CREATE TABLE Sales (
                       sale_id SERIAL PRIMARY KEY,      -- ID giao dịch, khóa chính
                       customer_id INT NOT NULL,       -- ID khách hàng
                       product_id INT NOT NULL,        -- ID sản phẩm
                       sale_date DATE NOT NULL,        -- Ngày giao dịch
                       amount NUMERIC(10, 2) NOT NULL  -- Số tiền giao dịch (tối đa 10 chữ số, 2 chữ số thập phân)
);

INSERT INTO Sales (customer_id, product_id, sale_date, amount) VALUES
-- Ngày 2025-10-01
(101, 1001, '2025-10-01', 50.00),
(102, 1002, '2025-10-01', 120.50),
(101, 1003, '2025-10-01', 25.99),

-- Ngày 2025-10-02
(103, 1001, '2025-10-02', 50.00),
(104, 1004, '2025-10-02', 300.75),
(102, 1005, '2025-10-02', 88.00),

-- Ngày 2025-10-03
(105, 1006, '2025-10-03', 15.00),
(103, 1002, '2025-10-03', 120.50),
(101, 1004, '2025-10-03', 300.75),

-- Ngày 2025-10-04
(106, 1007, '2025-10-04', 450.00),
(107, 1008, '2025-10-04', 10.99),

-- Ngày 2025-10-05
(101, 1009, '2025-10-05', 75.25),
(108, 1010, '2025-10-05', 220.00),
(109, 1001, '2025-10-05', 50.00),

-- Ngày 2025-10-06 (Tháng 11)
(102, 1003, '2025-11-06', 25.99),
(110, 1005, '2025-11-06', 88.00),

-- Ngày 2025-10-07
(104, 1007, '2025-12-07', 450.00),
(105, 1009, '2025-12-07', 75.25),

-- Giao dịch cho khách hàng lặp lại (101) và sản phẩm lặp lại (1001)
(101, 1001, '2025-12-07', 50.00),
(102, 1008, '2025-12-07', 10.99);

CREATE VIEW CustomerSales as
SELECT customer_id, SUM(amount) total_amount
FROM Sales
group by customer_id;

SELECT * FROM CustomerSales WHERE total_amount > 1000;
