USE cmpe172;
-- Q00: Retrieve the birth date and address of the employee(s) whose name is 'John B. Smith'
SELECT Bdate,
    Address
FROM employee
WHERE Fname = 'John'
    AND Minit = 'B'
    AND Lname = 'Smith';
-- Q01: Retrieve the name and address of all employees who work for the 'Research department.
SELECT Fname,
    Lname,
    Address
FROM employee,
    department
WHERE Dname = 'Research'
    AND Dnumber = Dno;
-- Q02: For every project located in 'Stafford', list the project number, the controlling department number, and the department manager's last name, address, and birth date.
SELECT Pnumber,
    Dnum,
    Lname,
    Address,
    Bdate
FROM PROJECT,
    department,
    employee
WHERE Dnum = Dnumber
    AND Mgr_ssn = Ssn
    AND Plocation = 'Stafford';
-- Q01A: Ambiguous Attribute Names
SELECT Fname,
    EMPLOYEE.Fname,
    address
FROM employee,
    department
WHERE DEPARTMENT.Dname = 'Research'
    AND DEPARTMENT.Dnumber = Employee.Dno;
-- Q08: For each employee, retrieve the employee’s first and last name
SELECT E.Fname,
    E.Lname,
    S.Fname,
    S.Lname
FROM EMPLOYEE AS E,
    EMPLOYEE AS S
WHERE E.Super_ssn = S.Ssn;
-- Q09: Select all SSNs for Employees
SELECT SSN
FROM employee;
-- Q10: Select all combos of employee SSN and dept names in the database
SELECT SSN,
    Dname
FROM employee,
    department;
-- Q01C: Select all values from employee who belong to deptID 5
SELECT *
FROM employee
WHERE Dno = 5;
-- Q01D: Select all employees who belong to the research dept
SELECT *
FROM employee,
    department
WHERE Dname = 'Research'
    AND Dno = Dnumber;
-- Q10A: Select all employees from all depts
SELECT *
FROM employee,
    department;
-- Q11: retrieve the salary of every employee
SELECT ALL Salary
FROM employee;
-- Q11A: Retrive all distinct salary values
SELECT DISTINCT Salary
FROM employee;
-- Q04: make a list of all project numbers for projects that involve an employee whoese last name is 'Smith' either as a worker or as a manager of the department that controls the project
(
    SELECT DISTINCT Pnumber
    FROM project,
        department,
        employee
    WHERE Dnum = Dnumber
        AND Mgr_ssn = Ssn
        AND Lname = 'Smith'
)
UNION
(
    SELECT DISTINCT Pnumber
    FROM project,
        works_on,
        employee
    WHERE Pnumber = Pno
        AND Essn = Ssn
        AND Lname = 'Smith'
);
-- Q13: Show the resulting salaries if every employee working on the ‘ProductX’ project is given a 10 percent raise.
SELECT E.Fname,
    E.Lname,
    1.1 * E.Salary AS Increased_sal
FROM EMPLOYEE AS E,
    WORKS_ON AS W,
    PROJECT AS P
WHERE E.Ssn = W.Essn
    AND W.Pno = P.Pnumber
    AND P.Pname = 'ProjectX';
-- There was no 'ProductX' in the example slides, so 'ProjectX' was used instead
-- U01: Specify the relation name and a list of values for the tuple. All values including nulls are supplied
INSERT INTO employee
VALUES (
        'Richard',
        'K',
        'Marini',
        '653298653',
        '1962-12-30',
        '98 Oak Forest, Katy, TX',
        'M',
        37000,
        '653298653',
        4
    );
-- U03B: Insert multiple tuples where a new table is loaded values from the result of a query
-- Uses assumption that WORKS_ON_INFO was already created
CREATE TABLE WORKS_ON_INFO (
    Emp_name VARCHAR(15),
    Proj_name VARCHAR(15),
    Hours_per_week DECIMAL
);
INSERT INTO WORKS_ON_INFO (Emp_name, Proj_name, Hours_per_week)
SELECT E.Lname,
    P.Pname,
    W.Hours
FROM project P,
    works_on W,
    employee E
WHERE P.Pnumber = W.Pno
    AND W.Essn = E.Ssn;
-- DROP TABLE WORKS_ON_INFO; -- For testing purposes
-- U04: The following line removes foreign key checks, else it complains to preserve ref integrity
SET FOREIGN_KEY_CHECKS = 0;
-- U04A: Deletes all employees with last name 'Brown'
DELETE FROM EMPLOYEE
WHERE Lname = 'Brown';
-- U04B: Deletes all employees with SSN '123456789'
DELETE FROM EMPLOYEE
WHERE Ssn = '123456789';
-- U04C: Deletes all employees that belong to deptID 5
DELETE FROM EMPLOYEE
WHERE Dno = 5;
-- U04D: Delete all employee entries, they got laid off in the recent tech bubble burst
DELETE FROM EMPLOYEE;
-- Re-enables all foreign key checks to preserve ref integrity
SET FOREIGN_KEY_CHECKS = 1;
-- U05: Change the location and controlling dept number of project number 10 to 'Bellaire' and 5, respectively
UPDATE project
SET Plocation = 'Bellaire',
    Dnum = 5
WHERE Pnumber = 10;
-- U06: Give all employees in the 'Research' dept a 10% raise in salary
UPDATE EMPLOYEE
SET SALARY = SALARY * 1.1
WHERE DNO IN (
        SELECT DNUMBER
        FROM DEPARTMENT
        WHERE DNAME = 'Research'
    )