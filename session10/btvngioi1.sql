CREATE TABLE employees
(
    id       SERIAL PRIMARY KEY,
    name     VARCHAR(255) NOT NULL,
    position VARCHAR(100),
    salary   DECIMAL(15, 2)
);
CREATE TABLE employees_log
(
    log_id      SERIAL PRIMARY KEY,
    employee_id INTEGER,
    operation   VARCHAR(10), -- Ghi INSERT, UPDATE hoặc DELETE
    old_data    JSONB,       -- Dữ liệu cũ
    new_data    JSONB,       -- Dữ liệu mới
    change_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO employees (name, position, salary)
VALUES ('Lê Minh Tâm', 'Backend Developer', 25000000.00),
       ('Nguyễn Thu Thảo', 'Project Manager', 35000000.00),
       ('Hoàng Anh Tuấn', 'UI/UX Designer', 22000000.00);

create or replace function employee_changes_log()
    returns trigger as
$$
begin
    IF (tg_op = 'INSERT') then
        insert into employees_log (employee_id, operation, old_data, new_data)
        values (new.id, 'INSERT', NULL, to_jsonb(new));
        return new;
    elsif (tg_op = 'UPDATE') then
        insert into employees_log (employee_id, operation, old_data, new_data)
        values (new.id, 'UPDATE', to_jsonb(new), to_jsonb(old));
        return new;

    elsif (tg_op = 'DELETE') then
        insert into employees_log (employee_id, operation, old_data, new_data)
        values (old.id, 'DELETE', to_jsonb(old), null);
        return old;
    end if;
    RETURN NULL;
end;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_emp_changes
after insert or update or delete on employees
for each row
execute function employee_changes_log();

-- 1. Thêm một nhân viên mới (INSERT)
INSERT INTO employees (name, position, salary)
VALUES ('Phạm Minh Đức', 'Data Analyst', 20000000.00);

-- 2. Tăng lương cho nhân viên có ID = 1 (UPDATE)
UPDATE employees
SET salary = 28000000.00
WHERE id = 1;

-- 3. Xóa nhân viên có ID = 2 (DELETE)
DELETE FROM employees
WHERE id = 2;