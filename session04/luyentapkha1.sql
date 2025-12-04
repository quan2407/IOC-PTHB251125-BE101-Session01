create schema if not exists student;
set search_path to student;

CREATE TABLE IF NOT EXISTS students
(
    id    SERIAL PRIMARY KEY,
    name  VARCHAR(50),
    age   INT,
    major VARCHAR(50),
    gpa   DECIMAL(3, 2)
);

INSERT INTO students (name, age, major, gpa)
VALUES ('An', 20, 'CNTT', 3.5),
       ('Bình', 21, 'Toán', 3.2),
       ('Cường', 22, 'CNTT', 3.8),
       ('Dương', 20, 'Vật Lý', 3.0),
       ('Em', 21, 'CNTT', 2.9);

-- Thêm sinh viên mới:
-- Thêm sinh viên mới: "Hùng", 23 tuổi, chuyên ngành "Hóa học", GPA 3.4
INSERT INTO students (name, age, major, gpa)
VALUES ('Hùng', 23, 'Hóa học', 3.4);

---

-- Cập nhật GPA của sinh viên "Bình" thành 3.6
UPDATE students
SET gpa = 3.6
WHERE name = 'Bình';

---

-- Xóa sinh viên có GPA thấp hơn 3.0
DELETE
FROM students
WHERE gpa < 3.0;

---

-- Liệt kê tất cả sinh viên, chỉ hiển thị tên và chuyên ngành, sắp xếp theo GPA giảm dần
SELECT students.name, students.major
FROM students
ORDER BY gpa desc;

---

-- Liệt kê tên sinh viên duy nhất có chuyên ngành "CNTT"
-- (Chú ý: Dựa vào câu lệnh gốc, đây là tìm sinh viên chuyên ngành 'CNTT' và chỉ lấy 1 kết quả đầu tiên)
SELECT *
FROM students
WHERE major = 'CNTT'
LIMIT 1;

---

-- Liệt kê sinh viên có GPA từ 3.0 đến 3.6
SELECT *
FROM students
WHERE gpa BETWEEN 3.0 AND 3.6;

---

-- Liệt kê sinh viên có tên bắt đầu bằng chữ 'C' (sử dụng LIKE/ILIKE)
SELECT *
FROM students
WHERE name ILIKE 'C%';

---

-- Hiển thị 3 sinh viên đầu tiên theo thứ tự tên tăng dần (Sắp xếp và giới hạn)
SELECT *
FROM students
ORDER BY name
LIMIT 3;

-- Hoặc lấy từ sinh viên thứ 2 đến thứ 4 bằng LIMIT và OFFSET
SELECT *
FROM students
LIMIT 3 OFFSET 1;