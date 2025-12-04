create schema if not exists product;
set search_path to product;

CREATE TABLE IF NOT EXISTS products
(
    id       SERIAL PRIMARY KEY,
    name     VARCHAR(50),
    category VARCHAR(50),
    price    DECIMAL(10, 2),
    stock    INT
);
INSERT INTO products (name, category, price, stock)
VALUES ('Laptop Dell', 'Electronics', 1500.00, 5),
       ('Chuột Logitech', 'Electronics', 25.50, 50),
       ('Bàn phím Razer', 'Electronics', 120.00, 20),
       ('Tủ lạnh LG', 'Home Appliances', 800.00, 3),
       ('Máy giặt Samsung', 'Home Appliances', 600.00, 2);
-- Thêm sản phẩm mới: 'Điều hòa Panasonic', category 'Home Appliances', giá 400.00, stock 10
INSERT INTO products (name, category, price, stock)
VALUES ('Điều hòa Panasonic', 'Home Appliances', 400.00, 10);
-- Cập nhật stock của 'Laptop Dell' thành 7
UPDATE products
SET stock = 7
WHERE name = 'Laptop Dell';
-- Xóa các sản phẩm có stock bằng 0 (nếu có)
DELETE
FROM products
WHERE stock = 0;
-- Liệt kê tất cả sản phẩm theo giá tăng dần
SELECT *
FROM products
ORDER BY price ASC;
-- Liệt kê danh mục duy nhất của các sản phẩm (DISTINCT)
SELECT DISTINCT category
FROM products;
-- Liệt kê sản phẩm có giá từ 100 đến 1000
SELECT *
FROM products
WHERE price BETWEEN 100.00 AND 1000.00;
-- Liệt kê các sản phẩm có tên chứa 'LG' hoặc 'Samsung' (sử dụng LIKE/ILIKE)
SELECT *
FROM products
WHERE name ILIKE '%LG%'
   OR name ILIKE '%Samsung%';
-- Lấy sản phẩm thứ 2 đến thứ 3 bằng LIMIT 2 và OFFSET 1
SELECT *
FROM products
ORDER BY price DESC -- Cần sắp xếp để OFFSET có ý nghĩa
LIMIT 2 OFFSET 1;