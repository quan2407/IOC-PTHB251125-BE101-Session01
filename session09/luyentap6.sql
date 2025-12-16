CREATE TABLE Products
(
    product_id  SERIAL PRIMARY KEY,      -- ID sản phẩm, khóa chính
    name        VARCHAR(255)   NOT NULL, -- Tên sản phẩm
    price       NUMERIC(10, 2) NOT NULL, -- Giá sản phẩm
    category_id INT            NOT NULL  -- ID danh mục sản phẩm
);

INSERT INTO Products (name, price, category_id)
VALUES ('Laptop Gaming X', 1200.00, 1),
       ('Bàn Phím Cơ A', 85.50, 2),
       ('Chuột Không Dây B', 25.99, 2),
       ('Máy Ảnh DSLR Z', 950.00, 3),
       ('Ống Kính 50mm', 350.00, 3),
       ('Áo Thun Cotton', 15.00, 4),
       ('Quần Jeans Slim', 45.99, 4),
       ('Sách Lập Trình Python', 30.75, 5),
       ('Tiểu Thuyết Tình Cảm', 18.00, 5),
       ('Tai Nghe Bluetooth Pro', 150.00, 1);

create or replace procedure update_product_price(p_category_id INT, p_increase_percent NUMERIC)
language plpgsql
as $$
    DECLARE
        r RECORD;
        v_new_price NUMERIC;
    begin
        FOR r IN
            SELECT product_id,name, price
            FROM Products
            WHERE category_id = p_category_id
            LOOP
                v_new_price := r.price * (1 + (p_increase_percent / 100));

                UPDATE Products
                SET price = v_new_price
                WHERE product_id = r.product_id;
                RAISE NOTICE 'Sản phẩm ID: %, Tên: % đã cập nhật từ % lên %',
                    r.product_id, r.name, r.price, v_new_price;

            END LOOP;
end;
    $$;
CALL update_product_price(1, 10);