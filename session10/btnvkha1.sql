CREATE TABLE products
(
    id            SERIAL PRIMARY KEY,
    name          VARCHAR(255)   NOT NULL,
    price         DECIMAL(10, 2) NOT NULL,
    last_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO products (name, price)
VALUES ('Laptop Dell XPS', 25000000.00),
       ('iPhone 15 Pro', 28000000.00),
       ('Bàn phím cơ AKKO', 1500000.00),
       ('Chuột Logitech MX Master 3S', 2200000.00),
       ('Màn hình LG 27 inch 4K', 8500000.00);

create or replace function update_last_modified()
returns trigger as $$
    begin
        new.last_modified = current_timestamp;
        return new;
    end;
    $$ language plpgsql;

create or replace trigger trg_update_last_modified
before update on products
for each row
execute function update_last_modified();

update products set price = 2000000
where id = 1;