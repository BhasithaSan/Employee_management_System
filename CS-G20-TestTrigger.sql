-- Test: Insert payroll with invalid date range (Should Fail)
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Test 1: Insert payroll with invalid date range ---');
    INSERT INTO Payroll (
        emp_id, pay_period_start_date, pay_period_end_date,
        basic_salary, allowances, deductions, tax_amount, net_salary,
        payment_date, payment_method
    ) VALUES (
        101, DATE '2025-05-15', DATE '2025-05-01', -- End before Start
        5000, 500, 200, 370, 4930,
        SYSDATE, 'Bank Transfer'
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

-- Test: Insert payroll with negative net salary (Should Fail)
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Test 2: Insert payroll with negative net salary ---');
    INSERT INTO Payroll (
        emp_id, pay_period_start_date, pay_period_end_date,
        basic_salary, allowances, deductions, tax_amount, net_salary,
        payment_date, payment_method
    ) VALUES (
        101, DATE '2025-05-01', DATE '2025-05-31',
        5000, 500, 200, 370, -100, -- Invalid net salary
        SYSDATE, 'Cash'
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

-- Test: Valid payroll insert (Should Pass)
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Test 3: Valid payroll insert ---');
    INSERT INTO Payroll (
        emp_id, pay_period_start_date, pay_period_end_date,
        basic_salary, allowances, deductions, tax_amount, net_salary,
        payment_date, payment_method
    ) VALUES (
        101, DATE '2025-05-01', DATE '2025-05-31',
        5000, 500, 200, 370, 4930,
        SYSDATE, 'Cash'
    );
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Payroll record inserted successfully.');
END;
/
---newline---