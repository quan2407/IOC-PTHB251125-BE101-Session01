set search_path to school;
ALTER TABLE students
    ALTER COLUMN birth_year TYPE integer
        USING EXTRACT(YEAR FROM birth_year)::integer;

INSERT INTO students (full_name, gender, birth_year, major, gpa)
VALUES ('Nguyễn Văn A', 'Nam', 2002, 'CNTT', 3.6),
       ('Trần Thị Bích Ngọc', 'Nữ', 2001, 'Kinh tế', 3.2),
       ('Lê Quốc Cường', 'Nam', 2003, 'CNTT', 2.7),
       ('Phạm Minh Anh', 'Nữ', 2000, 'Luật', 3.9),
       ('Nguyễn Văn A', 'Nam', 2002, 'CNTT', 3.6),
       ('Lưu Đức Tài', 'Nam', 2004, 'Cơ khí', NULL),
       ('Võ Thị Thu Hằng', 'Nữ', 2001, 'CNTT', 3.0);

-- Chèn dữ liệu mới:
-- Thêm sinh viên “Phan Hoàng Nam”, giới tính Nam, sinh năm 2003, ngành CNTT, GPA 3.8
INSERT INTO students(full_name, birth_year, gender, major, gpa)
VALUES ('Phan Hoàng Nam', 2003,'Nam','CNTT',3.8);

---

-- Cập nhật dữ liệu:
-- Sinh viên “Lê Quốc Cường” vừa cải thiện học lực, cập nhật gpa = 3.4
UPDATE students
SET gpa = 3.4
WHERE full_name = 'Lê Quốc Cường';

---

-- Xóa dữ liệu:
-- Xóa tất cả sinh viên có gpa IS NULL
DELETE FROM students
WHERE gpa IS NULL ;

---

-- Truy vấn cơ bản:
-- Hiển thị sinh viên có gpa >= 3.0, chỉ lấy 3 kết quả đầu tiên
SELECT * FROM students
WHERE gpa >= 3.0
LIMIT 3;

---

-- Loại bỏ trùng lặp:
-- Liệt kê danh sách ngành học duy nhất
SELECT major
FROM students
GROUP BY major;

---

-- Sắp xếp:
-- Hiển thị sinh viên ngành CNTT, sắp xếp giảm dần theo GPA, sau đó tăng dần theo tên
SELECT * FROM students
WHERE major = 'CNTT'
ORDER BY gpa DESC , full_name;

---

-- Tìm kiếm:
-- Tìm sinh viên có tên bắt đầu bằng “Nguyễn”
SELECT * FROM students
WHERE full_name LIKE 'Nguyễn%';

---

-- Khoảng giá trị:
-- Hiển thị sinh viên có năm sinh từ 2001 đến 2003
SELECT * FROM students
WHERE birth_year BETWEEN 2001 AND 2003;
