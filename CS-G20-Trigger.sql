-- Trigger: Validate Payroll Entry
CREATE OR REPLACE TRIGGER trg_validate_payroll_entry
BEFORE INSERT OR UPDATE ON Payroll
FOR EACH ROW
BEGIN
    -- Check for valid date range
    IF :NEW.pay_period_end_date < :NEW.pay_period_start_date THEN
        RAISE_APPLICATION_ERROR(-20002, 'Pay period end date cannot be earlier than start date.');
    END IF;

    -- Check for non-negative net salary
    IF :NEW.net_salary < 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Net salary cannot be negative.');
    END IF;
END;
/
