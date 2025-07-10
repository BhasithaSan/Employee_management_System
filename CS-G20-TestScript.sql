-- Set output buffer for DBMS_OUTPUT
SET SERVEROUTPUT ON;

-- Test: Generate payroll for an existing employee
BEGIN
    payroll_pkg.generate_payroll(101); -- Use a valid emp_id from dummy data
END;
/

-- Test: Get net salary for the employee
DECLARE
    v_net_salary NUMBER;
BEGIN
    v_net_salary := payroll_pkg.get_net_salary(101);
    DBMS_OUTPUT.PUT_LINE('Net Salary: ' || NVL(TO_CHAR(v_net_salary), 'No record found'));
END;
/

-- Optional: Test for non-existing employee (to test error handling)
BEGIN
    payroll_pkg.generate_payroll(9999); -- Emp ID that doesn't exist
END;
/

-- Optional: Query the log to verify logging worked
-- Note: This is SQL, not PL/SQL
SELECT * FROM payroll_log ORDER BY log_time DESC;
