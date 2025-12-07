create schema if not exists customers;
set search_path to customers;
CREATE TABLE OldCustomers
(
    id   SERIAL PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(50)
);

CREATE TABLE NewCustomers
(
    id   SERIAL PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(50)
);

INSERT INTO OldCustomers (name, city)
VALUES ('Nguyễn Văn A', 'Hanoi'),
       ('Trần Thị B', 'HCM'),
       ('Lê Văn C', 'Danang');

INSERT INTO NewCustomers (name, city)
VALUES ('Trần Thị B', 'HCM'),
       ('Phạm Văn D', 'Hanoi'),
       ('Hoàng Thị E', 'Hanoi');

SELECT name, city FROM OldCustomers
UNION
SELECT name, city FROM NewCustomers;

SELECT name, city FROM OldCustomers
INTERSECT
SELECT name, city FROM NewCustomers;

SELECT city, COUNT(*) AS customer_count
FROM (
         SELECT name, city FROM OldCustomers
         UNION
         SELECT name, city FROM NewCustomers
     ) AS all_customers
GROUP BY city;

SELECT city
FROM (
         SELECT name, city FROM OldCustomers
         UNION
         SELECT name, city FROM NewCustomers
     ) AS all_customers
GROUP BY city
HAVING COUNT(*) = (
    SELECT MAX(city_count)
    FROM (
             SELECT COUNT(*) AS city_count
             FROM (
                      SELECT name, city FROM OldCustomers
                      UNION
                      SELECT name, city FROM NewCustomers
                  ) AS combined_table
             GROUP BY city
         ) AS count_table
);