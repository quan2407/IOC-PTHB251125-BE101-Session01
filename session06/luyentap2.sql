create schema if not exists employees;
set search_path to employees;

create table if not exists Employee (
    id SERIAL PRIMARY KEY ,
    full_name VARCHAR(100),
    department VARCHAR(50),
    salary NUMERIC(10,2),
    hire_date DATE
);

INSERT INTO Employee (full_name, department, salary, hire_date)
VALUES
    ('Ngô Tuyết Anh', 'IT', 13000000.00, '2023-07-20'),
    ('Đặng Văn Chung', 'HR', 6500000.00, '2024-02-14'),
    ('Trần Khánh Linh', 'Marketing', 9200000.00, '2023-04-28'),
    ('Vũ Minh Đức', 'Finance', 10500000.00, '2024-01-01'),
    ('Lý Thị Ánh', 'IT', 11500000.00, '2023-10-10'),
    ('Hồ Văn Hiệp', 'HR', 7000000.00, '2024-03-01');

UPDATE Employee
SET salary = salary * 1.10
WHERE department = 'IT';

DELETE FROM Employee
WHERE salary < 6000000.00;

SELECT id, full_name, department, salary
FROM Employee
WHERE full_name ILIKE '%an%';

SELECT id, full_name, department, hire_date
FROM Employee
WHERE hire_date BETWEEN '2023-01-01' AND '2023-12-31';