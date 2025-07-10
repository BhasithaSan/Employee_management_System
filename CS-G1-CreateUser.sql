-- Create a new user (replace password)
ALTER SESSION SET CONTAINER = XEPDB1;
CREATE USER emp_mgmt_sys IDENTIFIED BY employee_mgmt123;

-- Grant basic permissions
GRANT CONNECT, RESOURCE TO emp_mgmt_sys;
ALTER USER emp_mgmt_sys QUOTA UNLIMITED ON USERS;

