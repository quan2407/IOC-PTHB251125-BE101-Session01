-- Tạo bảng tài khoản
CREATE TABLE accounts (
                          account_id SERIAL PRIMARY KEY,
                          owner_name VARCHAR(100),
                          balance NUMERIC(10, 2)
);

-- Chèn dữ liệu mẫu cho tài khoản A và B
INSERT INTO accounts (owner_name, balance)
VALUES ('A', 500.00), ('B', 300.00);

BEGIN;
UPDATE accounts
SET balance = balance - 100.00
WHERE owner_name = 'A';

UPDATE accounts
SET balance = balance + 100.00
WHERE owner_name = 'B';

COMMIT;

SELECT * FROM accounts;


BEGIN;

UPDATE accounts
SET balance = balance - 100.00
WHERE owner_name = 'A';

UPDATE accounts
SET balance = balance + 100.00
WHERE owner_name = 'C';

ROLLBACK;

SELECT * FROM accounts;