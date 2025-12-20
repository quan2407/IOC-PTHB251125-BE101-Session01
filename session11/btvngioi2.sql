-- Tạo bảng tài khoản
CREATE TABLE accounts (
                          account_id SERIAL PRIMARY KEY,
                          owner_name VARCHAR(100),
                          balance NUMERIC(10, 2) CHECK (balance >= 0) -- Ràng buộc không cho số dư âm
);

-- Tạo bảng lịch sử giao dịch
CREATE TABLE transactions (
                              transaction_id SERIAL PRIMARY KEY,
                              account_id INT REFERENCES accounts(account_id),
                              amount NUMERIC(10, 2),
                              transaction_type VARCHAR(20), -- 'WITHDRAW' hoặc 'DEPOSIT'
                              created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Chèn dữ liệu mẫu
INSERT INTO accounts (owner_name, balance) VALUES ('Nguyen Van A', 1000.00);

BEGIN;

UPDATE accounts
SET balance = balance - 200.00
WHERE account_id = 1 AND balance >= 200.00;
INSERT INTO transactions (account_id, amount, transaction_type)
VALUES (1, 200.00, 'WITHDRAW');
COMMIT;

SELECT * FROM accounts;
SELECT * FROM transactions;

BEGIN;

UPDATE accounts
SET balance = balance - 200.00
WHERE account_id = 1;

INSERT INTO transactions (account_id, amount, transaction_type)
VALUES (999, 200.00, 'WITHDRAW');

ROLLBACK;

SELECT * FROM accounts;
SELECT * FROM transactions;


SELECT
    a.owner_name,
    a.balance AS current_balance,
    SUM(t.amount) AS total_withdrawn,
    (a.balance + SUM(t.amount)) AS initial_amount
FROM accounts a
         JOIN transactions t ON a.account_id = t.account_id
GROUP BY a.account_id, a.owner_name, a.balance;