-- 1. Insert into Department
INSERT INTO Department VALUES (1, 'HR');
INSERT INTO Department VALUES (2, 'Finance');
INSERT INTO Department VALUES (3, 'Engineering');
INSERT INTO Department VALUES (4, 'Marketing');
INSERT INTO Department VALUES (5, 'Sales');
INSERT INTO Department VALUES (6, 'Support');

-- 2. Insert into Jobs
INSERT INTO Jobs VALUES (1, 'HR Manager', 5000, 10000);
INSERT INTO Jobs VALUES (2, 'Finance Analyst', 4000, 9000);
INSERT INTO Jobs VALUES (3, 'Software Engineer', 6000, 12000);
INSERT INTO Jobs VALUES (4, 'Marketing Executive', 4500, 8500);
INSERT INTO Jobs VALUES (5, 'Sales Rep', 3500, 7000);
INSERT INTO Jobs VALUES (6, 'Support Agent', 3000, 6500);

-- 3. Insert into Employee (manager_id = NULL for top-level managers)
INSERT INTO Employee VALUES (101, 'Alice Johnson', 'alice@company.com', TO_DATE('2020-01-15', 'YYYY-MM-DD'), 9000, 1, 1, NULL); -- HR Manager
INSERT INTO Employee VALUES (102, 'Bob Smith', 'bob@company.com', TO_DATE('2020-03-10', 'YYYY-MM-DD'), 8000, 2, 2, NULL); -- Finance Analyst Manager
INSERT INTO Employee VALUES (103, 'Charlie Lee', 'charlie@company.com', TO_DATE('2021-05-20', 'YYYY-MM-DD'), 7000, 3, 3, 101); -- Software Engineer under Alice
INSERT INTO Employee VALUES (104, 'Dana Scott', 'dana@company.com', TO_DATE('2022-02-11', 'YYYY-MM-DD'), 5000, 4, 4, 101); -- Marketing under Alice
INSERT INTO Employee VALUES (105, 'Eve Ray', 'eve@company.com', TO_DATE('2021-09-05', 'YYYY-MM-DD'), 4500, 5, 5, 102); -- Sales Rep under Bob
INSERT INTO Employee VALUES (106, 'Frank Chen', 'frank@company.com', TO_DATE('2023-01-18', 'YYYY-MM-DD'), 4000, 6, 6, 102); -- Support Agent under Bob

-- 4. Insert into Payroll
INSERT INTO Payroll (emp_id, pay_period_start_date, pay_period_end_date, basic_salary, allowances, deductions, tax_amount, net_salary, payment_date, payment_method)
VALUES (101, TO_DATE('2024-04-01', 'YYYY-MM-DD'), TO_DATE('2024-04-30', 'YYYY-MM-DD'), 9000, 500, 200, 300, 9000, TO_DATE('2024-05-01', 'YYYY-MM-DD'), 'Bank Transfer');

INSERT INTO Payroll VALUES (DEFAULT, 102, TO_DATE('2024-04-01','YYYY-MM-DD'), TO_DATE('2024-04-30','YYYY-MM-DD'), 8000, 400, 150, 250, 8000, TO_DATE('2024-05-01','YYYY-MM-DD'), 'Cheque');

INSERT INTO Payroll VALUES (DEFAULT, 103, TO_DATE('2024-04-01','YYYY-MM-DD'), TO_DATE('2024-04-30','YYYY-MM-DD'), 7000, 300, 100, 200, 7000, TO_DATE('2024-05-01','YYYY-MM-DD'), 'UPI');

INSERT INTO Payroll VALUES (DEFAULT, 104, TO_DATE('2024-04-01','YYYY-MM-DD'), TO_DATE('2024-04-30','YYYY-MM-DD'), 5000, 250, 100, 150, 5000, TO_DATE('2024-05-01','YYYY-MM-DD'), 'Cash');

INSERT INTO Payroll VALUES (DEFAULT, 105, TO_DATE('2024-04-01','YYYY-MM-DD'), TO_DATE('2024-04-30','YYYY-MM-DD'), 4500, 200, 50, 100, 4500, TO_DATE('2024-05-01','YYYY-MM-DD'), 'Bank Transfer');

INSERT INTO Payroll VALUES (DEFAULT, 106, TO_DATE('2024-04-01','YYYY-MM-DD'), TO_DATE('2024-04-30','YYYY-MM-DD'), 4000, 100, 50, 100, 4000, TO_DATE('2024-05-01','YYYY-MM-DD'), 'Cheque');


SELECT * FROM Payroll;