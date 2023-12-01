-- Q01: Retrieve the name and address of all employees who work for the Research dept
SELECT Fname,
    Lname,
    Address
FROM employee
    JOIN department ON department.Dnumber = employee.Dno
WHERE Dname = 'Research';
-- Q02: For every project located in ‘Stafford’, list the project number, the controlling department number, and the department manager’s last name, address, and birth date
SELECT Pnumber,
    Dnum,
    Lname,
    Bdate,
    FROM employee,
    project
    NATURAL JOIN department
WHERE department.Mgr_Ssn = employee.Ssn
    AND Plocation = 'Stafford';
-- Q03: Find the names of employees who work on all the projects controlled by department number 5