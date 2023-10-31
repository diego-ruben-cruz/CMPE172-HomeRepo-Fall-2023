CREATE DATABASE IF NOT EXISTS cmpe172;
USE cmpe172;
CREATE TABLE EMPLOYEE (
    Fname VARCHAR(15) NOT NULL,
    Minit CHAR,
    Lname VARCHAR(15) NOT NULL,
    Ssn CHAR(9) NOT NULL,
    Bdate DATE,
    Address VARCHAR(30),
    Sex CHAR,
    Salary DECIMAL(10, 2),
    Super_ssn CHAR(9),
    Dno INT NOT NULL,
    PRIMARY KEY (Ssn)
);
CREATE TABLE DEPARTMENT (
    Dname VARCHAR(15) NOT NULL,
    Dnumber INT NOT NULL,
    Mgr_ssn CHAR(9) NOT NULL,
    Mgr_start_date DATE,
    PRIMARY KEY (Dnumber),
    UNIQUE (Dname),
    FOREIGN KEY (Mgr_ssn) REFERENCES EMPLOYEE(Ssn)
);
CREATE TABLE DEPT_LOCATIONS (
    Dnumber INT NOT NULL,
    Dlocation VARCHAR(15) NOT NULL,
    PRIMARY KEY (Dnumber, Dlocation),
    FOREIGN KEY (Dnumber) REFERENCES DEPARTMENT(Dnumber)
);
CREATE TABLE PROJECT (
    Pname VARCHAR(15) NOT NULL,
    Pnumber INT NOT NULL,
    Plocation VARCHAR(15),
    Dnum INT NOT NULL,
    PRIMARY KEY (Pnumber),
    UNIQUE (Pname),
    FOREIGN KEY (Dnum) REFERENCES DEPARTMENT(Dnumber)
);
CREATE TABLE WORKS_ON (
    Essn CHAR(9) NOT NULL,
    Pno INT NOT NULL,
    Hours DECIMAL(3, 1) NOT NULL,
    PRIMARY KEY (Essn, Pno),
    FOREIGN KEY (Essn) REFERENCES EMPLOYEE(Ssn),
    FOREIGN KEY (Pno) REFERENCES PROJECT(Pnumber)
);
CREATE TABLE DEPENDENT (
    Essn CHAR(9) NOT NULL,
    Dependent_name VARCHAR(15) NOT NULL,
    Sex CHAR,
    Bdate DATE,
    Relationship VARCHAR(8),
    PRIMARY KEY (Essn, Dependent_name),
    FOREIGN KEY (Essn) REFERENCES EMPLOYEE(Ssn)
);
/* R05:  Create trigger to ensure that the  */
DELIMITER / / CREATE TEMPORARY TABLE INFORM_SUPERVISOR(Super_ssn int, ssn int);
CREATE TRIGGER SALARY_VIOLATION BEFORE
UPDATE ON EMPLOYEE FOR EACH ROW BEGIN IF (
        NEW.Salary > (
            SELECT Salary
            FROM employee
            WHERE Ssn = NEW.Super_ssn
        )
    ) THEN
SELECT NEW.Super_ssn,
    NEW.Ssn INTO INFORM_SUPERVISOR;
END IF;
END / / DELIMITER;
/* V1: View one */
CREATE VIEW WORKS_ON1 AS
SELECT Fname,
    Lname,
    Pname,
    works_on.Hours
FROM EMPLOYEE,
    PROJECT,
    WORKS_ON
WHERE Ssn = Essn
    AND Pno = Pnumber;
/* V2: View two */
CREATE VIEW DEPT_INFO(Dept_name, No_of_emps, Total_Sal) AS
SELECT Dname,
    COUNT(*),
    SUM(Salary)
FROM DEPARTMENT,
    EMPLOYEE
WHERE Dnumber = Dno
GROUP BY Dname;