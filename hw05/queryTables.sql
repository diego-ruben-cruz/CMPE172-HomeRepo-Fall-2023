-- Problem 8.15
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
    Address,
    Bdate
FROM Project
    JOIN department ON Dnum = Dnumber,
    employee
WHERE Plocation = 'Stafford'
    AND Mgr_ssn = Ssn;
-- Q03: Find the names of employees who work on all the projects controlled by department number 5
SELECT DISTINCT Lname,
    Fname
FROM works_on
    JOIN project ON works_on.Pno = project.Pnumber
    JOIN employee ON employee.ssn = works_on.Essn
WHERE project.Dnum = 5;
-- Q04: Make a list of project numbers for projects that involve an employee whose last name is ‘Smith’, either as a worker or as a manager of the department that controls the project.
SELECT DISTINCT Pno
FROM works_on
    JOIN Project ON works_on.Pno = project.Pnumber
    JOIN employee ON works_on.Essn = employee.Ssn
WHERE employee.Lname = 'Smith';
-- Q05: List the names of all employees with two or more dependents
SELECT Lname,
    Fname
FROM employee
WHERE (
        SELECT COUNT (*)
        FROM DEPENDENT
        WHERE Ssn = Essn
    ) >= 2;
-- Q06: Retrieve the names of employees who have no dependents
SELECT Lname,
    Fname
FROM employee
WHERE (
        SELECT COUNT (*)
        FROM DEPENDENT
        WHERE Ssn = Essn
    ) = 0;
-- Q07:  List the names of managers who have at least one dependent
SELECT DISTINCT employee.Fname,
    employee.Lname
FROM Employee
    JOIN Dependent ON employee.Ssn = dependent.Essn
WHERE EXISTS (
        SELECT *
        FROM department
        WHERE Ssn = Mgr_ssn
    );
-- Problem 8.16
-- QA: Retrieve the names of all employees in department 5 who work more than 10 hours per week on the Product X project
SELECT Lname,
    Fname
FROM (
        SELECT LName,
            Fname,
            Pno
        FROM employee
            JOIN works_on ON works_on.Essn = employee.Ssn
        WHERE employee.Dno = 5
            AND works_on.Hours > 10
    ) AS dept5_10hour_subquery
    JOIN project ON dept5_10hour_subquery.Pno = project.Pnumber
WHERE project.Pname = 'ProductX';
-- QB: List the names of all employees who have a dependent with the same first name as themselves 
SELECT Lname,
    Fname
FROM employee,
    dependent
WHERE employee.fname = Dependent_name;
-- QC: Find the names of all employees who are directly supervised by Franklin Wong
SELECT Lname,
    Fname
FROM employee
WHERE Super_ssn = 333445555;
-- QD: For each project, list the project name and the total hours per week by all employees spent on that project
SELECT Pname,
    SUM(works_on.Hours) AS TotalHours
FROM works_on
    JOIN PROJECT ON PROJECT.Pnumber = works_on.Pno
GROUP BY Pname;
-- QE: Get the names of all employees who work on every project
SELECT Fname,
    Lname
FROM EMPLOYEE
WHERE NOT EXISTS (
        SELECT Pnumber
        FROM PROJECT
        WHERE NOT EXISTS (
                SELECT Essn
                FROM WORKS_ON
                WHERE WORKS_ON.Pno = PROJECT.Pnumber
                    AND Works_on.Essn = EMPLOYEE.Ssn
            )
    );
-- QF: Get the names of employees who don't work on any projects
SELECT Fname,
    Lname
FROM EMPLOYEE
WHERE NOT EXISTS (
        SELECT 1
        FROM WORKS_ON
        WHERE WORKS_ON.Essn = EMPLOYEE.Ssn
    );
-- QG: For each department, retrieve the department name and the average salary of all employees working in that department
SELECT department.Dname,
    AVG(employee.Salary) AS avg_salary
FROM department,
    employee
GROUP BY Department.Dname;
-- QH: Compute the average salary of female employees
SELECT AVG(employee.Salary) AS avg_salary
FROM employee
WHERE employee.Sex = 'F';
-- QI: Get names and addresses of employees who work on at least one project located in Houston and whose department has no location in Houston
SELECT DISTINCT E.Fname,
    E.Lname,
    E.Address
FROM EMPLOYEE E
    JOIN WORKS_ON W ON E.Ssn = W.Essn
    JOIN PROJECT P ON W.Pno = P.Pnumber
    JOIN DEPARTMENT D ON E.Dno = D.Dnumber
    LEFT JOIN DEPT_LOCATIONS DL1 ON D.Dnumber = DL1.Dnumber
    AND DL1.Dlocation = 'Houston'
    LEFT JOIN DEPT_LOCATIONS DL2 ON D.Dnumber = DL2.Dnumber
WHERE P.Plocation = 'Houston'
    AND DL1.Dnumber IS NULL
    AND DL2.Dlocation IS NULL;
-- QJ: List the last names of all department managers who have no dependents
SELECT Lname
FROM employee E JOIN department D ON E.Ssn = D.Mgr_ssn
    AND Mgr_ssn NOT IN(
        SELECT Essn
        FROM dependent
    );