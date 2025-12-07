create schema if not exists customers;
set search_path to customers;

create table if not exists Customer (
    id SERIAL PRIMARY KEY ,
    name VARCHAR(100) ,
    email VARCHAR(100) ,
    phone VARCHAR(20) ,
    points INT
);

INSERT INTO Customer (name, email, phone, points)
VALUES
    ('Nguyễn Văn An', 'an.nguyen@example.com', '0901111111', 150),
    ('Trần Thị Bình', 'binh.tran@example.com', '0902222222', 300),
    ('Lê Văn Cường', NULL, '0903333333', 50), -- Không có email
    ('Phạm Minh Dũng', 'dung.pham@example.com', '0904444444', 500),
    ('Hoàng Thị E', 'e.hoang@example.com', '0905555555', 200),
    ('Vũ Văn F', 'f.vu@example.com', '0906666666', 120),
    ('Nguyễn Văn An', 'an.new@example.com', '0907777777', 80);

SELECT DISTINCT name
FROM Customer;

SELECT * FROM Customer
WHERE email IS NULL;

SELECT * FROM Customer
ORDER BY points DESC
LIMIT 3 OFFSET 1;

SELECT * FROM Customer
ORDER BY name DESC;