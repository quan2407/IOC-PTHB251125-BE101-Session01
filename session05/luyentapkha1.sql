create schema if not exists sales;
set search_path to sales;

-- Tạo bảng products (Nếu chưa tồn tại)
CREATE TABLE IF NOT EXISTS products
(
    product_id   SERIAL PRIMARY KEY,
    product_name VARCHAR(50),
    category     VARCHAR(50)
);

-- Chèn dữ liệu vào bảng products (product_id sẽ được tự động gán 1, 2, 3, 4)
INSERT INTO products (product_name, category)
VALUES ('Laptop Dell', 'Electronics'),
       ('Iphone 15', 'Electronics'),
       ('Bàn học gỗ', 'Furniture'),
       ('Ghế xoay', 'Furniture');
-- Tạo bảng orders (Nếu chưa tồn tại)
CREATE TABLE IF NOT EXISTS orders
(
    order_id    INT PRIMARY KEY, -- Không phải SERIAL
    product_id  INT,
    quantity    INT,
    total_price INT,
    -- Thêm ràng buộc khóa ngoại (Foreign Key)
    CONSTRAINT fk_product
        FOREIGN KEY (product_id)
            REFERENCES products (product_id)
);

-- Chèn dữ liệu vào bảng orders, bao gồm cả cột order_id để khớp với hình ảnh
INSERT INTO orders (order_id, product_id, quantity, total_price)
VALUES (101, 1, 2, 2200),
       (102, 2, 3, 3300),
       (103, 3, 5, 2500),
       (104, 4, 4, 1600),
       (105, 1, 1, 1100);

-- Tính tổng doanh thu (total_sales) và tổng số lượng (total_quantity) cho từng danh mục
SELECT
    SUM(total_price) AS total_sales,
    SUM(quantity) AS total_quantity
FROM
    orders o
        JOIN
    products p on o.product_id = p.product_id
GROUP BY
    category;

-- Chỉ hiển thị những nhóm có tổng doanh thu lớn hơn 2000
SELECT
    SUM(total_price) AS total_sales,
    SUM(quantity) AS total_quantity
FROM
    orders o
        JOIN
    products p on o.product_id = p.product_id
GROUP BY
    category
HAVING
    SUM(total_price) > 2000;

-- Sắp xếp kết quả theo tổng doanh thu giảm dần
SELECT
    SUM(total_price) AS total_sales,
    SUM(quantity) AS total_quantity
FROM
    orders o
        JOIN
    products p on o.product_id = p.product_id
GROUP BY
    category
HAVING
    SUM(total_price) > 2000
ORDER BY
    SUM(total_price) DESC;