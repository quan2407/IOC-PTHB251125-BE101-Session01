-- Tạo bảng khách hàng
CREATE TABLE customers
(
    id           SERIAL PRIMARY KEY,
    name         VARCHAR(255) NOT NULL,
    credit_limit DECIMAL(15, 2)
);

-- Tạo bảng đơn hàng
CREATE TABLE orders
(
    id           SERIAL PRIMARY KEY,
    customer_id  INTEGER REFERENCES customers (id),
    order_amount DECIMAL(15, 2),
    order_date   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- Thêm dữ liệu khách hàng
INSERT INTO customers (name, credit_limit)
VALUES ('Nguyễn Văn A', 50000000.00),
       ('Trần Thị B', 30000000.00),
       ('Lê Văn C', 10000000.00);

-- Thêm dữ liệu đơn hàng
INSERT INTO orders (customer_id, order_amount)
VALUES (1, 1500000.00),
       (1, 2300000.00),
       (2, 500000.00),
       (3, 12000000.00);

create or replace function check_credit_limit()
    returns trigger as $$
declare
    cus_order_amount decimal(15, 2);
    cus_credit_limit decimal(15, 2);
begin
    select customers.credit_limit
    into cus_credit_limit
    from customers
    where id = new.customer_id;

    select coalesce(sum(order_amount),0) into cus_order_amount
    from orders
    where customer_id = new.customer_id;
    cus_order_amount := cus_order_amount + new.order_amount;
    if (cus_credit_limit - cus_order_amount < 0) then
        raise exception 'Credit limit is not enoufgh';
    end if;
    return new;
end;
$$ language plpgsql;

create or replace trigger trg_check_credit
before insert on orders
for each row
execute function check_credit_limit();

INSERT INTO orders (customer_id, order_amount)
VALUES (1, 1500000.00);

INSERT INTO orders (customer_id, order_amount)
VALUES (1, 50000000.00);