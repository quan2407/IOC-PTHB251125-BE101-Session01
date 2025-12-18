-- Tạo bảng sản phẩm
CREATE TABLE products
(
    id    SERIAL PRIMARY KEY,
    name  VARCHAR(255) NOT NULL,
    stock INTEGER DEFAULT 0
);

-- Tạo bảng đơn hàng
CREATE TABLE orders
(
    id         SERIAL PRIMARY KEY,
    product_id INTEGER REFERENCES products (id),
    quantity   INTEGER NOT NULL
);
-- Thêm sản phẩm
INSERT INTO products (name, stock)
VALUES ('iPhone 15', 50),
       ('MacBook M3', 20),
       ('AirPods Pro', 100);

-- Thêm đơn hàng mẫu
INSERT INTO orders (product_id, quantity)
VALUES (1, 2), -- Đặt 2 chiếc iPhone 15
       (3, 5); -- Đặt 5 chiếc AirPods Pro


CREATE OR REPLACE FUNCTION order_change()
    returns trigger as
$$
declare
begin
    IF (TG_OP = 'INSERT') THEN
        UPDATE products
        SET stock = stock - NEW.quantity
        WHERE id = NEW.product_id;
        RETURN NEW;
    elsif (TG_OP = 'UPDATE') THEN
        UPDATE products
        SET stock = stock + OLD.quantity - new.QUANTITY
        WHERE id = NEW.product_id;
        RETURN NEW;
    elsif (TG_OP = 'DELETE') THEN
        UPDATE products
        SET stock = stock + OLD.quantity
        WHERE id = OLD.product_id;
        RETURN OLD;
    END IF;
end;
$$ language plpgsql;

CREATE OR REPLACE TRIGGER trg_order_change
AFTER INSERT OR UPDATE OR DELETE ON orders
FOR EACH ROW
EXECUTE FUNCTION order_change();

-- 1. Test INSERT: Đặt 10 iPhone (Stock 50 -> 40)
INSERT INTO orders (product_id, quantity) VALUES (1, 10);

-- 2. Test UPDATE: Sửa từ 10 thành 15 (Stock 40 -> 35)
UPDATE orders SET quantity = 15 WHERE id = 3; -- Giả sử ID đơn mới là 3

-- 3. Test DELETE: Hủy đơn 15 cái (Stock 35 -> 50)
DELETE FROM orders WHERE id = 3;