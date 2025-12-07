create schema if not exists sales;
set search_path to sales;


DROP TABLE IF EXISTS OrderDetail;
DROP TABLE IF EXISTS Product;

CREATE TABLE Product
(
    id       SERIAL PRIMARY KEY,
    name     VARCHAR(100),
    category VARCHAR(50),
    price    NUMERIC(10, 2)
);


CREATE TABLE OrderDetail
(
    id         SERIAL PRIMARY KEY,
    order_id   INT,
    product_id INT,
    quantity   INT
);

INSERT INTO Product (name, category, price)
VALUES ('Laptop Dell XPS', 'Electronics', 25000000),
       ('iPhone 15', 'Electronics', 30000000),
       ('Tủ lạnh Samsung', 'Appliances', 12000000),
       ('Máy giặt LG', 'Appliances', 10000000),
       ('Ghế công thái học', 'Furniture', 5000000),
       ('Bàn làm việc', 'Furniture', 2000000),
       ('Sản phẩm tồn kho', 'Furniture', 1000000);

INSERT INTO OrderDetail (order_id, product_id, quantity)
VALUES (1, 1, 2),
       (1, 2, 1),
       (2, 3, 3),
       (3, 4, 1),
       (4, 1, 1),
       (5, 5, 10);

SELECT
    p.name AS product_name,
    SUM(p.price * od.quantity) AS total_sales
FROM Product p
         JOIN OrderDetail od ON p.id = od.product_id
GROUP BY p.name;

SELECT
    p.category,
    AVG(p.price * od.quantity) AS avg_category_sales
FROM Product p
         JOIN OrderDetail od ON p.id = od.product_id
GROUP BY p.category;

SELECT
    p.category,
    AVG(p.price * od.quantity) AS avg_category_sales
FROM Product p
         JOIN OrderDetail od ON p.id = od.product_id
GROUP BY p.category
HAVING AVG(p.price * od.quantity) >= 20000000;

SELECT
    p.name,
    SUM(p.price * od.quantity) AS product_revenue
FROM Product p
         JOIN OrderDetail od ON p.id = od.product_id
GROUP BY p.name
HAVING SUM(p.price * od.quantity) > (
    SELECT AVG(p2.price * od2.quantity)
    FROM Product p2
             JOIN OrderDetail od2 ON p2.id = od2.product_id
);

SELECT
    p.name AS product_name,
    COALESCE(SUM(od.quantity), 0) AS total_quantity_sold
FROM Product p
         LEFT JOIN OrderDetail od ON p.id = od.product_id
GROUP BY p.name;