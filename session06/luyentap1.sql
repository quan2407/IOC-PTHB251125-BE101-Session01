create schema if not exists products;
set search_path to products;
create table if not exists Product(
    id SERIAL PRIMARY KEY ,
    name VARCHAR(100),
    category VARCHAR(50),
    price NUMERIC(10,2),
    stock INT
);

INSERT INTO Product (name, category, price, stock)
VALUES
    ('Laptop Dell XPS 13', 'Electronics', 1200.00, 15),
    ('iPhone 15 Pro Max', 'Smartphone', 1450.50, 30),
    ('Bàn phím cơ Logitech', 'Accessories', 85.99, 100),
    ('Tai nghe Sony WH-1000XM5', 'Audio', 349.00, 25),
    ('Màn hình LG UltraGear', 'Electronics', 270.00, 10);

SELECT *
FROM Product
ORDER BY price DESC
LIMIT 3;

SELECT * FROM Product
WHERE category = 'Electronics' AND price <10000000;

SELECT *
FROM Product
ORDER BY stock;

