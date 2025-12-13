CREATE TABLE order_detail
(
    id           SERIAL PRIMARY KEY,
    order_id     INT,
    product_name VARCHAR(100),
    quantity     INT,
    unit_price   NUMERIC
);
-- Chèn các mặt hàng cho Order 1001 và Order 1002
INSERT INTO order_detail (order_id, product_name, quantity, unit_price)
VALUES (1001, 'Chuột không dây quang', 2, 25.50), -- Order 1001, mặt hàng thứ 2
       (1002, 'Màn hình LCD 27 inch', 1, 299.99), -- Order 1002, mặt hàng thứ 1
       (1002, 'Cáp HDMI 2m', 3, 5.00),            -- Order 1002, mặt hàng thứ 2
       (1003, 'Tai nghe Bluetooth', 5, 45.00);
-- Order 1003, mặt hàng thứ 1
create or replace procedure calculate_order_total(order_id_input INT, OUT total NUMERIC)
    language plpgsql
as $$
begin
select distinct SUM(order_detail.quantity * order_detail.unit_price) into total
    from order_detail
    where order_detail.order_id = order_id_input;

IF total ISNULL THEN
    total := 0;
end if;
end;
$$;

call calculate_order_total(1002,null);