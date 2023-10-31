/* Q18: Retrieve the names of all emploees who do not have supervisors*/
SELECT Fname,
    Lname
FROM EMPLOYEE
WHERE Super_ssn IS NULL;
/* Q04a: Select the projects that Smith is either an employee or a manager*/
SELECT DISTINCT Pnumber
FROM PROJECT
WHERE Pnumber IN (
        SELECT Pnumber
        FROM PROJECT,
            department,
            employee
        where Dnum = Dnumber
            AND Mgr_ssn = Ssn
            AND Lname = 'Smith'
    )
    OR Pnumber IN (
        SELECT Pno
        FROM works_on,
            employee
        WHERE Essn = Ssn
            AND Lname = 'Smith'
    );
/* Tuples in comparisons within parenthesis */
SELECT DISTINCT Essn
FROM WORKS_ON
WHERE (Pno, WORKS_ON.Hours) IN (
        SELECT Pno,
            WORKS_ON.Hours
        FROM WORKS_ON
        WHERE Essn = '123456789'
    );
/* Q16: Retrieve the name of ech employee who has a dependent with the same first name and is the same sex as the employee */
SELECT E.Fname,
    E.Lname
FROM employee AS E
WHERE E.Ssn IN (
        SELECT Essn
        FROM dependent as D
        Where E.Fname = D.Dependent_name
            AND E.Sex = D.Sex
    );
/* Q16A: Alternate approach to Q16 */
SELECT E.Fname,
    E.Lname
FROM employee AS E,
    dependent as D
Where E.Ssn = D.Essn
    AND E.Sex = D.Sex
    AND E.Fname = D.Dependent_name;
/* Q16B: Another Alternate approach to Q16 */
SELECT E.Fname,
    E.Lname
FROM EMPLOYEE AS E
WHERE EXISTS (
        SELECT *
        FROM DEPENDENT AS D
        WHERE E.Ssn = D.Essn
            AND E.Sex = D.Sex
            AND E.Fname = D.Dependent_name
    );
/* Q06: Retrieve the names of employees who have no dependents */
SELECT Fname,
    Lname
FROM EMPLOYEE
WHERE NOT EXISTS (
        SELECT *
        FROM DEPENDENT
        WHERE Ssn = Essn
    );
/* Q07: List the names of managers that have at least one dependent */
SELECT Fname,
    Lname
FROM Employee
WHERE EXISTS (
        SELECT *
        FROM DEPENDENT
        WHERE Ssn = Essn
    )
    AND EXISTS (
        SELECT *
        FROM department
        WHERE Ssn = Mgr_ssn
    );
/* Q3A: List names of each employee who works on all projects controlled by dept no 5 */
SELECT Fname,
    Lname
FROM EMPLOYEE
WHERE NOT EXISTS (
        (
            SELECT Pnumber
            FROM PROJECT
            WHERE Dnum = 5
        )
        EXCEPT (
                SELECT Pno
                FROM WORKS_ON
                WHERE Ssn = Essn
            )
    );
/* Q03B: List names of each employee who works on all projects controlled by dept no 5 */
SELECT Lname,
    Fname
FROM EMPLOYEE
WHERE NOT EXISTS (
        SELECT *
        FROM WORKS_ON B
        WHERE (
                B.Pno IN (
                    SELECT Pnumber
                    FROM PROJECT
                    WHERE Dnum = 5
                        AND NOT EXISTS (
                            SELECT *
                            FROM WORKS_ON C
                            WHERE C.Essn = Ssn
                                AND C.Pno = B.Pno
                        )
                )
            )
    );
/* Q17: Select each employee that works on either projects 1/2/3 */
SELECT DISTINCT Essn
FROM works_on
WHERE Pno IN (1, 2, 3);
/* Q08A: Retrieve the last name of each employee as well as the name of their immediate supervisor */
SELECT E.Lname AS Employee_name,
    S.Lname AS Supervisor_name
FROM EMPLOYEE AS E,
    EMPLOYEE AS S
WHERE E.Super_ssn = S.Ssn;
/* Q01A: Retrieve the name and address of each employee from the research department */
SELECT Fname,
    Lname,
    Address
FROM (
        EMPLOYEE
        JOIN DEPARTMENT ON Dno = Dnumber
    )
WHERE Dname = 'Research';
/* Q01B: Retrieve the name and address of each employee from the research department */
SELECT Fname,
    Lname,
    Address
FROM (
        EMPLOYEE
        NATURAL JOIN (DEPARTMENT AS DEPT (Dname, Dno, Mssn, Msdate))
    )
WHERE Dname = 'Research';
/* Q08B: Perform an outer join */
SELECT E.Lname AS Employee_name,
    S.Lname AS Supervisor_name
FROM (
        EMPLOYEE AS E
        LEFT OUTER JOIN EMPLOYEE AS S ON E.Super_ssn = S.Ssn
    );
/* Q02A: retrieve the name, address, and birthday of all employees who work on all manner of different projects at the Stafford location */
SELECT Pnumber,
    Dnum,
    Lname,
    Address,
    Bdate
FROM (
        (
            PROJECT
            JOIN DEPARTMENT ON Dnum = Dnumber
        )
        JOIN EMPLOYEE ON Mgr_ssn = Ssn
    )
WHERE Plocation = 'Stafford';
/* Q19: Retrieve the total salary paid, the maximum/minimum salaries paid, as well as the average salary of an employee */
SELECT SUM(Salary),
    MAX(Salary),
    MIN(Salary),
    AVG(Salary)
FROM EMPLOYEE;
/* Q08C: Perform join based on comparison operators */
SELECT E.Lname,
    S.Lname
FROM EMPLOYEE E,
    EMPLOYEE S
WHERE E.Super_ssn = S.Ssn;
/* Q19: Find the sum of the salaries of all employees, the maximum salary, the minimum salary, and the average salary */
SELECT SUM (Salary),
    MAX (Salary),
    MIN (Salary),
    AVG (Salary)
FROM EMPLOYEE;
/* Q19A: Retrieve the total salary paid, the maximum/minimum salaries paid, as well as the average salary of an employee while giving an alias to each */
SELECT SUM (Salary) AS Total_Sal,
    MAX (Salary) AS Highest_Sal,
    MIN (Salary) AS Lowest_Sal,
    AVG (Salary) AS Average_Sal
FROM EMPLOYEE;
/* Q20: Find the sum of the salaries of all employees of the 'Research' department, as well as the maximum salary, the minimum salary, and the average salary in this department */
SELECT SUM(Salary),
    MAX(Salary),
    MIN(Salary),
    AVG(Salary)
FROM (
        EMPLOYEE
        JOIN DEPARTMENT ON Dno = Dnumber
    )
WHERE Dname = 'Research';
/* Q21: Retrive the total number of employees in the company */
SELECT COUNT(*)
FROM EMPLOYEE;
/* Q22: Retrive the number of employees in the 'Research' Department */
SELECT COUNT(*)
FROM EMPLOYEE,
    DEPARTMENT
WHERE Dno = Dnumber
    AND Dname = 'Research';
/* Q23: Count the number of distinct salary values in the database */
SELECT COUNT (DISTINCT Salary)
FROM EMPLOYEE;
/* Q05: Retrieve the name of all employees who have two or more dependents */
SELECT Lname,
    Fname
FROM EMPLOYEE
WHERE (
        SELECT COUNT (*)
        FROM DEPENDENT
        WHERE Ssn = Essn
    ) >= 2;
/* Q24: Retrieve number of employees and the average salary of each department */
SELECT Dno,
    COUNT(*),
    AVG(Salary)
FROM EMPLOYEE
GROUP BY Dno;
/* Q25: Retrieve the name, project number and number of employees allotted to each project */
SELECT Pnumber,
    Pname,
    COUNT(*)
FROM PROJECT,
    works_on
WHERE Pnumber = Pno
GROUP BY Pnumber,
    Pname;
/* Q26: For each project on which more than two employees work, retrieve the project number, the project name, and the number of employees who work on the project. */
SELECT Pnumber,
    Pname,
    COUNT(*)
FROM PROJECT,
    WORKS_ON
WHERE Pnumber = Pno
GROUP BY Pnumber,
    Pname
HAVING COUNT(*) > 2;
/* Q27: For each proejct, retrieve the project number, the project name, and te number of employees from department 5 who work on the project */
SELECT Pnumber,
    Pname,
    COUNT (*)
FROM PROJECT,
    WORKS_ON,
    EMPLOYEE
WHERE Pnumber = Pno
    AND Ssn = Essn
    AND Dno = 5
GROUP BY Pnumber,
    Pname;
/* Q28: For each department that has more than five employees, retrieve the department number and the number of its employees who are making more than USD 40,000 */
SELECT Dno,
    COUNT(*)
FROM EMPLOYEE
WHERE Salary > 40000
    AND Dno IN (
        SELECT Dno
        FROM EMPLOYEE
        GROUP BY Dno
        HAVING Count(*) > 5
    )
GROUP BY Dno;
/* Q28': Alternate version of Q28 */
WITH BIGDEPTS (Dno) AS (
    SELECT Dno
    FROM EMPLOYEE
    GROUP BY Dno
    HAVING COUNT (*) > 5
)
SELECT Dno,
    COUNT (*)
FROM EMPLOYEE
WHERE Salary > 40000
    AND Dno
GROUP BY Dno;
/* U06': Update employees with raises, depending on the department they are in */
UPDATE EMPLOYEE
SET Salary = CASE
        WHEN Dno = 5 THEN Salary + 2000
        WHEN Dno = 4 THEN Salary + 1500
        WHEN Dno = 1 THEN Salary + 3000
        ELSE Salary + 0 -- This line is necessary to handle all other cases
    END;
/* Q29: Retrieve the social security number from each employee and their immediate supervisor */
WITH RECURSIVE SUP_EMP (SupSsn, EmpSsn) AS (
    SELECT Super_ssn,
        Ssn
    FROM EMPLOYEE
    UNION
    SELECT E.Ssn,
        S.SupSsn
    FROM EMPLOYEE AS E,
        SUP_EMP AS S
    WHERE E.Super_ssn = S.EmpSsn
)
SELECT *
FROM SUP_EMP;
/* QV01: Retrieve the name of all employees who work on ProjectX */
SELECT Fname,
    Lname
FROM WORKS_ON1
WHERE Pname = 'ProjectX';
/* UV01: Use the WORKS_ON1 View to change John Smith to ProjectY */
UPDATE WORKS_ON1
SET Pname = 'ProductY'
WHERE Lname = 'Smith'
    AND Fname = 'John'
    AND Pname = 'ProductX';
/* UV02: Update is not permitted on aggregate views */
UPDATE dept_info
SET Total_Sal = 100000
WHERE Dname = 'Research';