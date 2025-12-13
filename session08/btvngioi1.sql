CREATE TABLE employees (
                           emp_id SERIAL PRIMARY KEY,
                           emp_name VARCHAR(100),
                           job_level INT,
                           salary NUMERIC
);

-- Chèn 4 dòng dữ liệu mẫu
INSERT INTO employees (emp_name, job_level, salary) VALUES
                                                        ('Nguyễn Văn A', 3, 60000000),
                                                        ('Trần Thị B', 1, 25000000),
                                                        ('Lê Hoàng C', 3, 120000000),
                                                        ('Phạm Quang D', 2, 38500000);

CREATE OR REPLACE PROCEDURE adjust_salary(p_emp_id INT, OUT p_new_salary NUMERIC)
language plpgsql
as $$
    DECLARE
        p_job_level int;
        p_salary    numeric;
    begin
        SELECT employees.job_level,
               salary
        INTO p_job_level,p_salary
        FROM employees
        WHERE emp_id = p_emp_id;
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Nhân viên với ID % không tồn tại ', p_emp_id;
        END IF;
        IF p_job_level = 3 THEN
            p_new_salary := p_salary * 1.15;
        ELSIF p_job_level = 2 THEN
            p_new_salary := p_salary * 1.1;
        ELSIF p_job_level = 1 THEN
            p_new_salary := p_salary * 1.05;
        ELSE
            RAISE EXCEPTION 'Level % không tồn tại chỉ từ level 1-3', p_job_level;
        END IF;
        UPDATE employees
        SET salary = p_new_salary
        WHERE emp_id = p_emp_id;
    end;
$$;

DO $$
    DECLARE
        new_sal NUMERIC;
    BEGIN
        CALL adjust_salary(3, new_sal);
        RAISE NOTICE 'New salary: %', new_sal;
    END $$;
