CREATE TABLE inventory
(
    product_id   SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    quantity     INT
);
INSERT INTO inventory (product_name, quantity)
VALUES ('Laptop ThinkPad', 50),
       ('Màn hình LCD 27 inch', 120),
       ('Bàn phím cơ RGB', 85),
       ('Chuột không dây quang', 300),
       ('Tai nghe Bluetooth', 450);

create or replace procedure check_stock(p_id INT, p_qty INT)
    language plpgsql
as $$

begin
    if p_qty > (select distinct inventory.quantity
                from inventory
                where product_id = p_id) then
        RAISE EXCEPTION 'Không đủ hàng trong kho';
    else
        RAISE NOTICE 'Đủ hàng trong kho';
    end if;
end;
$$;

call check_stock(1,60);
call check_stock(2,100);