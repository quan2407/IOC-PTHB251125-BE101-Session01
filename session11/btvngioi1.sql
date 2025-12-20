-- 1. Bảng sản phẩm
CREATE TABLE products (
                          product_id SERIAL PRIMARY KEY,
                          product_name VARCHAR(100),
                          price NUMERIC(10, 2),
                          stock_quantity INT
);

-- 2. Bảng đơn hàng
CREATE TABLE orders (
                        order_id SERIAL PRIMARY KEY,
                        customer_name VARCHAR(100),
                        order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                        total_amount NUMERIC(10, 2) DEFAULT 0
);

-- 3. Bảng chi tiết đơn hàng
CREATE TABLE order_items (
                             item_id SERIAL PRIMARY KEY,
                             order_id INT REFERENCES orders(order_id),
                             product_id INT REFERENCES products(product_id),
                             quantity INT,
                             price_at_time NUMERIC(10, 2)
);

-- Chèn dữ liệu mẫu
INSERT INTO products (product_name, price, stock_quantity)
VALUES ('Laptop Dell', 2000.00, 10),
       ('Chuột Logitech', 50.00, 5);



BEGIN;

INSERT INTO orders (customer_name) VALUES ('Nguyen Van A') RETURNING order_id;

UPDATE products SET stock_quantity = stock_quantity - 2 WHERE product_id = 1;
INSERT INTO order_items (order_id, product_id, quantity, price_at_time) VALUES (1, 1, 2, 2000.00);

UPDATE products SET stock_quantity = stock_quantity - 1 WHERE product_id = 2;
INSERT INTO order_items (order_id, product_id, quantity, price_at_time) VALUES (1, 2, 1, 50.00);
UPDATE orders SET total_amount = 4050.00 WHERE order_id = 1;

COMMIT;

SELECT * FROM products;
SELECT * FROM orders;
SELECT * FROM order_items;


UPDATE products SET stock_quantity = 0 WHERE product_id = 2;

BEGIN;

INSERT INTO orders (customer_name) VALUES ('Nguyen Van B');


UPDATE products SET stock_quantity = stock_quantity - 2 WHERE product_id = 1;

ROLLBACK;

SELECT * FROM products;
