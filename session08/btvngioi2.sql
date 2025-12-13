CREATE TABLE products
(
    id               SERIAL PRIMARY KEY,
    name             VARCHAR(100),
    price            NUMERIC,
    discount_percent INT
);
INSERT INTO products (name, price, discount_percent)
VALUES ('Laptop Gaming ABC', 25000000, 10),
       ('Điện Thoại XYZ', 12500000, 60),
       ('Chuột Không Dây M2', 450000, 0),
       ('Màn Hình 27 Inch', 6800000, 20),
       ('Bàn Phím Cơ A5', 1800000, 15);

create or replace procedure calculate_discount(p_id INT, OUT p_final_price NUMERIC)
    language plpgsql
as $$
DECLARE
    p_price            NUMERIC;
    p_discount_percent INT;
begin
    SELECT price, discount_percent
    INTO p_price, p_discount_percent
    FROM products
    WHERE id = p_id;

    IF p_discount_percent > 50 THEN
        p_discount_percent := 50;
    end if;
    p_final_price := p_price - (p_price * p_discount_percent / 100);
    UPDATE products
    SET price = p_final_price
    WHERE id = p_id;
end;
$$;

DO
$$
    DECLARE
        p_final_price NUMERIC;
    BEGIN
        CALL calculate_discount(2, p_final_price);
        RAISE NOTICE 'New price: %', p_final_price;
    END
$$;