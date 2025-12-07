create schema if not exists orders;
set search_path to orders;
create table if not exists OrderInfo(
    id SERIAL PRIMARY KEY ,
    customer_id INT,
    order_date DATE,
    total NUMERIC(10,2),
    status VARCHAR(20)
);

INSERT INTO OrderInfo (customer_id, order_date, total, status)
VALUES
    (1, '2024-10-05', 600000.00, 'Completed'),
    (2, '2024-10-12', 150000.00, 'Pending'),
    (1, '2024-09-25', 1200000.00, 'Shipped'),
    (3, '2024-11-01', 450000.00, 'Completed'),
    (4, '2024-10-20', 800000.00, 'Cancelled');

SELECT * FROM OrderInfo
WHERE total > 500000;

SELECT * FROM OrderInfo
WHERE order_date BETWEEN '2024-10-01' AND '2024-10-31';

SELECT * FROM OrderInfo
WHERE status <> 'Completed';

SELECT * FROM OrderInfo
ORDER BY order_date DESC
LIMIT 2;