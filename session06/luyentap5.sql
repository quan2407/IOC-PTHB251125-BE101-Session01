create schema if not exists courses;
set search_path to courses;

create table if not exists Courses(
    id SERIAL PRIMARY KEY ,
    title VARCHAR(100) ,
    instructor VARCHAR(50) ,
    price NUMERIC(10,2),
    duration INT
);

INSERT INTO Courses (title, instructor, price, duration)
VALUES
    ('Nhập môn Lập trình Python', 'Nguyễn Văn A', 450000.00, 20),
    ('SQL Server từ cơ bản đến nâng cao', 'Trần Thị B', 1200000.00, 35),
    ('Khóa học Demo trải nghiệm', 'Admin', 0.00, 2),
    ('Lập trình Web Fullstack', 'Lê Văn C', 2500000.00, 60),
    ('Tối ưu hóa truy vấn SQL', 'Phạm D', 800000.00, 15),
    ('Thiết kế đồ họa Photoshop', 'Hoàng E', 600000.00, 25),
    ('Demo tính năng mới', 'Tester', 100000.00, 1);

UPDATE Courses
SET price = price * 1.15
WHERE duration > 30;

DELETE FROM Courses
WHERE title LIKE '%Demo%';

SELECT * FROM Courses
WHERE title ILIKE '%sql%';

SELECT * FROM Courses
WHERE price BETWEEN 500000 AND 2000000
ORDER BY price DESC
LIMIT 3;