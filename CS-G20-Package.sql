CREATE OR REPLACE PACKAGE payroll_pkg AS
    PROCEDURE generate_payroll(p_emp_id NUMBER);
    FUNCTION get_net_salary(p_emp_id NUMBER) RETURN NUMBER;
END payroll_pkg;
/
CREATE OR REPLACE PACKAGE BODY payroll_pkg AS

    PROCEDURE log_payroll_activity(p_emp_id NUMBER) IS
        CURSOR emp_cursor IS
            SELECT emp_id, emp_name
            FROM Employee
            WHERE emp_id = p_emp_id;
    
        emp_rec emp_cursor%ROWTYPE;
        v_error_msg VARCHAR2(400);
        message VARCHAR2(400):= 'Test log';
    BEGIN
        OPEN emp_cursor;
        FETCH emp_cursor INTO emp_rec;
        
        IF emp_cursor%NOTFOUND THEN
             message := 'No employee found for ID: ' || p_emp_id;
        ELSE
            message := 'Payroll processed for ' || emp_rec.emp_name || 
            ' (ID: ' || emp_rec.emp_id || ') on ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS');
        END IF;
    
        CLOSE emp_cursor;
    
        -- Insert using EXACT column names from your table definition
        INSERT INTO payroll_log (log_time, log_message)
        VALUES (SYSTIMESTAMP, message);
        
    EXCEPTION
        WHEN OTHERS THEN
            -- Secondary attempt if first fails (for debugging)
            BEGIN
                v_error_msg := 'Error in logging: ' || SQLERRM;
                
                INSERT INTO payroll_log (log_time, log_message)
                VALUES (SYSTIMESTAMP, v_error_msg);
                
                EXCEPTION
                    WHEN OTHERS THEN
                        NULL; -- Final fallback to prevent procedure failure
            END;
    END log_payroll_activity;

    -- Private function to calculate tax (unchanged from your original)
    FUNCTION cal_tax(p_basic_salary NUMBER) RETURN NUMBER IS
        v_tax NUMBER;
    BEGIN
        IF p_basic_salary > 100000 THEN
            v_tax := p_basic_salary * 0.6;
        ELSIF p_basic_salary > 50000 THEN
            v_tax := p_basic_salary * 0.3;
        ELSE
            v_tax := p_basic_salary * 0.05;
        END IF;
        RETURN v_tax;
    END cal_tax;
    
    -- Private function to calculate deductions (unchanged)
    FUNCTION cal_deduction(p_basic_salary NUMBER) RETURN NUMBER IS
        v_epf NUMBER;
        v_insurance NUMBER;
    BEGIN
        IF p_basic_salary > 100000 THEN
            v_epf := p_basic_salary * 0.10;
            v_insurance := p_basic_salary * 0.15;
        ELSIF p_basic_salary > 50000 THEN
            v_epf := p_basic_salary * 0.12;
            v_insurance := p_basic_salary * 0.12;
        ELSE
            v_epf := p_basic_salary * 0.11;
            v_insurance := p_basic_salary * 0.10;
        END IF;
        RETURN v_epf + v_insurance;
    END cal_deduction;
    
    -- Private function to calculate allowances (with fixed 0.8 to 0.08)
    FUNCTION cal_allowance(p_basic_salary NUMBER) RETURN NUMBER IS
        v_transport_allowance NUMBER;
        v_food_allowances NUMBER := 100;
        v_medical_allowances NUMBER;
    BEGIN
        IF p_basic_salary > 100000 THEN
           v_transport_allowance := p_basic_salary * 0.08;
           v_medical_allowances := p_basic_salary * 0.12;
        ELSIF p_basic_salary > 50000 THEN
            v_transport_allowance := p_basic_salary * 0.06;
            v_medical_allowances := p_basic_salary * 0.10;
        ELSE
            v_transport_allowance := p_basic_salary * 0.05;
            v_medical_allowances := p_basic_salary * 0.08; -- Fixed from 0.8 to 0.08
        END IF;
        RETURN v_transport_allowance + v_medical_allowances + v_food_allowances;
    END cal_allowance;
    
    -- Public procedure to generate payroll (unchanged except for error handling)
    PROCEDURE generate_payroll(p_emp_id NUMBER) IS
        v_basic_salary NUMBER;
        v_allowances NUMBER;
        v_deductions NUMBER;
        v_tax_amount NUMBER;
        v_net_salary NUMBER;
    BEGIN
        -- Get employee's salary
        SELECT salary INTO v_basic_salary
        FROM employee
        WHERE emp_id = p_emp_id;

        -- Calculate components
        v_tax_amount := cal_tax(v_basic_salary);
        v_deductions := cal_deduction(v_basic_salary);
        v_allowances := cal_allowance(v_basic_salary);
        
        -- Calculate net salary
        v_net_salary := v_basic_salary + v_allowances - v_deductions - v_tax_amount;

        -- Insert into payroll table
        INSERT INTO payroll (
            emp_id,
            pay_period_start_date,
            pay_period_end_date,
            basic_salary,
            allowances,
            deductions,
            tax_amount,
            net_salary,
            payment_date,
            payment_method
        ) VALUES (
            p_emp_id,
            TRUNC(SYSDATE, 'MONTH'),
            LAST_DAY(SYSDATE),
            v_basic_salary,
            v_allowances,
            v_deductions,
            v_tax_amount,
            v_net_salary,
            SYSDATE,
            'Bank Transfer'
        );
        
        -- Log the activity
        log_payroll_activity(p_emp_id);
        
        DBMS_OUTPUT.PUT_LINE('Payroll generated for employee ID: ' || p_emp_id);
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Error: Employee not found with ID ' || p_emp_id);
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error generating payroll: ' || SQLERRM);
    END generate_payroll;

    -- Public function to get latest net salary (unchanged)
    FUNCTION get_net_salary(p_emp_id NUMBER) RETURN NUMBER IS
        v_net_salary NUMBER;
    BEGIN
        SELECT net_salary
        INTO v_net_salary
        FROM (
            SELECT net_salary
            FROM payroll
            WHERE emp_id = p_emp_id
            ORDER BY payment_date DESC
        )
        WHERE ROWNUM = 1;

        RETURN v_net_salary;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN NULL;
    END get_net_salary;

END payroll_pkg;
