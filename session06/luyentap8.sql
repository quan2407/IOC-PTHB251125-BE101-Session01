set search_path to orders;

CREATE TABLE IF NOT EXISTS Customer (
                                        id SERIAL PRIMARY KEY,
                                        name VARCHAR(100)
);

SELECT
    c.name AS customer_name,
    SUM(o.total_amount) AS total_spent
FROM Customer c
         JOIN Orders o ON c.id = o.customer_id
GROUP BY c.name
ORDER BY total_spent DESC;

SELECT c.name, SUM(o.total_amount) AS max_spent
FROM Customer c
         JOIN Orders o ON c.id = o.customer_id
GROUP BY c.name
HAVING SUM(o.total_amount) = (
    SELECT MAX(total_spent)
    FROM (
             SELECT SUM(total_amount) AS total_spent
             FROM Orders
             GROUP BY customer_id
         ) AS aggregated_orders
);

SELECT c.name AS customer_name
FROM Customer c
         LEFT JOIN Orders o ON c.id = o.customer_id
WHERE o.id IS NULL;

SELECT
    c.name AS customer_name,
    SUM(o.total_amount) AS customer_total_spent
FROM Customer c
         JOIN Orders o ON c.id = o.customer_id
GROUP BY c.name
HAVING SUM(o.total_amount) > (
    SELECT AVG(total_spent)
    FROM (
             SELECT SUM(total_amount) AS total_spent
             FROM Orders
             GROUP BY customer_id
         ) AS aggregated_customer_spent
);