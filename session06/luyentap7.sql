create schema if not exists company;
set search_path to company;


CREATE TABLE Department
(
    id   SERIAL PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE Employee
(
    id            SERIAL PRIMARY KEY,
    full_name     VARCHAR(100),
    department_id INT, -- Khóa ngoại
    salary        NUMERIC(10, 2)
);


INSERT INTO Department (name)
VALUES ('IT'),
       ('HR'),
       ('Marketing'),
       ('Sales');

INSERT INTO Employee (full_name, department_id, salary)
VALUES ('Nguyễn Văn A', 1, 15000000),
       ('Trần Thị B', 2, 8000000),
       ('Lê Văn C', 1, 12000000),
       ('Phạm Minh D', 3, 9000000),
       ('Hoàng Thị E', 1, 20000000);

SELECT
    Employee.full_name,
    Department.name AS department_name
FROM Employee
         INNER JOIN Department ON Employee.department_id = Department.id;

SELECT
    Department.name AS department_name,
    AVG(Employee.salary) AS avg_salary
FROM Department
         JOIN Employee ON Department.id = Employee.department_id
GROUP BY Department.name;

SELECT
    Department.name AS department_name,
    AVG(Employee.salary) AS avg_salary
FROM Department
         JOIN Employee ON Department.id = Employee.department_id
GROUP BY Department.name
HAVING AVG(Employee.salary) >= 10000000;

SELECT Department.name AS department_name
FROM Department
         LEFT JOIN Employee ON Department.id = Employee.department_id
WHERE Employee.id IS NULL;