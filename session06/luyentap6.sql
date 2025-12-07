set search_path to orders;

create table Orders(
    id SERIAL PRIMARY KEY ,
    customer_id INT,
    order_date DATE,
    total_amount NUMERIC(10,2)
);

INSERT INTO Orders (customer_id, order_date, total_amount)
VALUES
    (1, '2023-01-15', 15000000.00),
    (2, '2023-03-20', 25000000.00),
    (1, '2023-06-10', 12000000.00),
    (3, '2024-02-05', 5000000.00),
    (4, '2024-04-12', 2000000.00),
    (2, '2024-08-20', 8000000.00),
    (5, '2023-11-25', 5000000.00),
    (3, '2024-09-09', 1500000.00),
    (1, '2023-12-30', 40000000.00),
    (4, '2024-10-10', 3000000.00);

SELECT
    SUM(total_amount) AS total_revenue,
    COUNT(id) AS total_orders,
    AVG(total_amount) AS average_order_value
FROM Orders;

SELECT
    EXTRACT(YEAR FROM order_date) AS order_year,
    SUM(total_amount) AS year_revenue
FROM Orders
GROUP BY EXTRACT(YEAR FROM order_date);

SELECT
    EXTRACT(YEAR FROM order_date) AS order_year,
    SUM(total_amount) AS year_revenue
FROM Orders
GROUP BY EXTRACT(YEAR FROM order_date)
HAVING SUM(total_amount) > 50000000;

SELECT * FROM Orders
ORDER BY total_amount DESC
LIMIT 5;