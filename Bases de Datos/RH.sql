TEMA 3: Manipulating Data
 
;
COMMIT;
;

Data Manipulation Language

? A DML statement is executed when you:
  ? Add new rows to a table
  ? Modify existing rows in a table
  ? Remove existing rows from a table
? A transaction consists of a collection of DML statements that form a logical unit of work.

INSERT Statement Syntax

? Add new rows to a table by using the INSERT statement

 INSERT INTO table [(column [, column...])]
 VALUES (value [, value...]);

With this syntax, only one row is inserted at a time.

Inserting New Rows
 ? Insert a new row containing values for each column.
 ? List values in the default order of the columns in the table.
 ? Optionally, list the columns in the INSERT clause.
;
 DROP TABLE DEPT;

 CREATE TABLE DEPT(
  ID_DEPARTAMENTO NUMBER(4,0) CONSTRAINT DEPT PRIMARY KEY,
  NOMBRE_DEPARTAMENTO VARCHAR2(30) CONSTRAINT DEPT_NOMDEP_NN NOT NULL,
  ID_GERENTE NUMBER(6,0),
  ID_LOCALIDAD NUMBER(4,0)
 );
 SELECT * FROM DEPT;
 DESC DEPT;
 INSERT INTO DEPT VALUES (10, 'Sales', 120, 2000);

 INSERT INTO DEPT(ID_DEPARTAMENTO, NOMBRE_DEPARTAMENTO, ID_GERENTE, ID_LOCALIDAD)
      VALUES (20, 'Public Relations', 100, 1700);

SELECT * FROM DEPT;

Enclose character and date values within single quotation marks.

Inserting Rows with Null Values

? Implicit method: Omit the column from the column list.

  INSERT INTO DEPT (ID_DEPARTAMENTO, NOMBRE_DEPARTAMENTO) VALUES (30, 'Purchasing');

?Explicit method: Specify the NULL keyword in the VALUES clause.

  INSERT INTO DEPT  VALUES (40, 'Finance', NULL, NULL);

SELECT * FROM DEPT;

INSERT INTO DEPT VALUES (40, 'Finance', NULL);
--NOTA:
INSERT INTO DEPT VALUES (40, NULL, NULL,NULL);
--NOTA:

Inserting Special Values
The SYSDATE function records the current date and time..
DESC DEPT;
ALTER TABLE DEPT ADD FECHA_CREACION DATE;
SELECT * FROM DEPT;

INSERT INTO DEPT(ID_DEPARTAMENTO, NOMBRE_DEPARTAMENTO, ID_GERENTE, ID_LOCALIDAD, FECHA_CREACION)
      VALUES (50, 'Public Relations 2', 100, 1700, SYSDATE);


Inserting Specific Date and Time Values

INSERT INTO DEPT(ID_DEPARTAMENTO, NOMBRE_DEPARTAMENTO, ID_GERENTE, ID_LOCALIDAD, FECHA_CREACION)
      VALUES (60, 'Public Relations 3', 100, 1700, TO_DATE('FEB 3, 1999', 'MON DD, YYYY'));


Verify your addition.

SELECT * FROM DEPT;
INSERT INTO DEPT(ID_DEPARTAMENTO, NOMBRE_DEPARTAMENTO, ID_GERENTE, ID_LOCALIDAD, FECHA_CREACION)
      VALUES (70, 'Public Relations 4', 100, 1700, TO_DATE('FEB 3, 1899', 'MON DD, YYYY'));


Creating a Script
? Use the & substitution in a SQL statement to prompt for values.
? & is a placeholder for the variable value.


INSERT INTO DEPT (ID_DEPARTAMENTO, NOMBRE_DEPARTAMENTO, ID_LOCALIDAD)
VALUES (&department_id, '&department_name',&location);

SELECT * FROM DEPT;

INSERT INTO DEPT (ID_DEPARTAMENTO, NOMBRE_DEPARTAMENTO, ID_LOCALIDAD, FECHA_CREACION)
VALUES (&department_id, '&department_name',&location,SYSDATE);

Copying Rows from Another Table
? Write your INSERT statement with a subquery:

? Do not use the VALUES clause.
? Match the number of columns in the INSERT clause to those in the subquery.
? Inserts all the rows returned by the subquery in the table, sales_reps.

DROP TABLE SALES_REPS;

CREATE TABLE SALES_REPS (
  ID NUMBER(6),    
  NAME VARCHAR2(25), 
  SALARY NUMBER(8,2),
  COMMISSION_PCT NUMBER(2,2)
);

DESC SALES_REPS;


SELECT * FROM SALES_REPS;
  
  INSERT INTO sales_reps(id, name, salary, commission_pct)
  SELECT employee_id, last_name, salary, commission_pct
  FROM HR.employees
  WHERE job_id LIKE '%REP%';
DESC sales_reps
--
GRANT SELECT ANY TABLE TO "RH";


SELECT * FROM SALES_REPS;
DELETE FROM SALES_REPS;
  
  INSERT INTO sales_reps
  SELECT employee_id, last_name, salary, commission_pct
  FROM HR.employees
  WHERE job_id LIKE '%REP%';

SELECT * FROM SALES_REPS;
  
--INSERT INTO REGION_GZV SELECT * FROM HR.REGIONS;
--SELECT * FROM R_GZV;
--------------------------------------------------------------------------------
Changing Data in a Table
UPDATE Statement Syntax
? Modify existing values in a table with the UPDATE statement:

UPDATE table
SET column = value [, column = value, ...]
[WHERE condition];

? Update more than one row at a time (if required).

Updating Rows in a Table

? Values for a specific row or rows are modified if you specify the WHERE clause:
DROP TABLE COPY_EMP;
CREATE TABLE COPY_EMP
AS SELECT * FROM HR.EMPLOYEES;

SELECT * FROM COPY_EMP;

SELECT * FROM COPY_EMP WHERE department_id= 120;
SELECT * FROM COPY_EMP WHERE department_id= 70;
--204 EST? EN EL DEP 70
UPDATE COPY_EMP
SET department_id = 120
WHERE department_id = 70;


? Values for all the rows in the table are modified if you omit the WHERE clause:
DROP TABLE COPY_EMP2;
CREATE TABLE COPY_EMP2
AS SELECT * FROM COPY_EMP;

SELECT * FROM COPY_EMP2;

UPDATE COPY_EMP2
SET department_id = 110;

SELECT * FROM COPY_EMP2;

? Specify SET column_name= NULL to update a column value to NULL.

SELECT * FROM COPY_EMP2;

UPDATE COPY_EMP2
SET PHONE_NUMBER = NULL;

SELECT * FROM COPY_EMP2;

Updating Two Columns with a Subquery

Update employee 113?s job and salary to match those of employee 205.
;
SELECT * FROM COPY_EMP2 WHERE employee_id = 205;
SELECT * FROM COPY_EMP2 WHERE employee_id = 113;

UPDATE COPY_EMP2
  SET job_id = (SELECT job_id
                FROM COPY_EMP2
                WHERE employee_id = 205),
      salary = (SELECT salary
                FROM COPY_EMP2
                WHERE employee_id = 205)
WHERE employee_id = 113;

SELECT * FROM COPY_EMP2 WHERE employee_id = 205;
SELECT * FROM COPY_EMP2 WHERE employee_id = 113;

Updating Rows Based on Another Table

Use the subqueries in the UPDATE statements to update row values in a table based on values from another table:

SELECT * FROM COPY_EMP2;
UPDATE COPY_EMP2
SET department_id = (SELECT department_id
                       FROM COPY_EMP
                       WHERE EMPLOYEE_ID = 120);
               
UPDATE COPY_EMP2 CE
SET CE.DEPARTMENT_ID = (
  SELECT E.DEPARTMENT_ID
  FROM HR.EMPLOYEES E
  WHERE E.EMPLOYEE_ID = CE.EMPLOYEE_ID
);
--WHERE ce.department_id IS NULL;

------------------------------------------------------

Removing a Row from a Table

DELETE Statement

You can remove existing rows from a table by using the DELETE statement:


DELETE [FROM] table
[WHERE condition];

Deleting Rows from a Table

Specific rows are deleted if you specify the WHERE clause:

SELECT * FROM COPY_EMP2;

DELETE FROM COPY_EMP2
WHERE JOB_ID = 'IT_PROG';


All rows in the table are deleted if you omit the WHERE clause:
SELECT * FROM COPY_EMP2;

DELETE FROM COPY_EMP2;


Deleting Rows Based on Another Table
Use the subqueries in the DELETE statements to remove rows from a table based on values from another table:
SELECT * FROM COPY_EMP;
SELECT * FROM DEPT;
DELETE FROM DEPT WHERE ID_DEPARTAMENTO = 110;
INSERT INTO DEPT(ID_DEPARTAMENTO, NOMBRE_DEPARTAMENTO, ID_GERENTE, ID_LOCALIDAD, FECHA_CREACION)
      VALUES (110, 'Public Relations 5', 100, 1700, SYSDATE);

SELECT * FROM DEPT;

DELETE FROM COPY_EMP
        WHERE DEPARTMENT_ID =
            (SELECT ID_DEPARTAMENTO
               FROM DEPT
              WHERE NOMBRE_DEPARTAMENTO = 'Public Relations 5');
     
----------------------------------------

TRUNCATE Statement

Removes all rows from a table, leaving the table empty and the table structure intact
? Is a data definition language (DDL) statement rather than a DML statement; cannot easily be undone
? Syntax:
   TRUNCATE TABLE table_name;
? Example:
   TRUNCATE TABLE copy_emp;

SELECT * FROM COPY_EMP;

--------------------------------------------------------------------------------
---------------------CONTROL DE TRANSACCIONES-----------------------------------
--------------------------------------------------------------------------------

Database transactions control using COMMIT, ROLLBACK, and SAVEPOINT

Database Transactions

? A transaction consists of a collection of DML statements that form a logical unit of work.

A database transaction consists of one of the following:
? DML statements that constitute one consistent change to the data
? One DDL statement
? One data control language (DCL) statement

Database Transactions: Start and End

? Begin when the first DML SQL statement is executed.
? End with one of the following events:
  ? A COMMIT or ROLLBACK statement is issued.
  ? A DDL or DCL statement executes (automatic commit).
  ? The user exits SQL Developer or SQL*Plus.
  ? The system crashes.

Advantages of COMMIT and ROLLBACK Statements

With COMMIT and ROLLBACK statements, you can:
 ? Ensure data consistency
 ? Preview data changes before making changes permanent
 ? Group logically-related operations
;
SELECT * FROM COPY_EMP2;
TRUNCATE TABLE COPY_EMP2;
INSERT INTO COPY_EMP2 SELECT * FROM EMPLEADO_GZV;
INSERT INTO COPY_EMP2 SELECT * FROM HR.EMPLOYEES;

COMMIT;

--delete from empleado_gzv;
--
DROP TABLE COPY_EMP2;
CREATE TABLE COPY_EMP2 AS SELECT * FROM HR.EMPLOYEES;

SELECT * FROM COPY_EMP2;

ROLLBACK;


Explicit Transaction Control Statements
COMMIT;

Time COMMIT

   Transaction
      DELETE
      SAVEPOINT A
      INSERT
      UPDATE
      SAVEPOINT B
      INSERT
       
   ROLLBACK to SAVEPOINT B
   ROLLBACK to SAVEPOINT A
   ROLLBACK

Rolling Back Changes to a Marker

? Create a marker in the current transaction by using the SAVEPOINT statement.
? Roll back to that marker by using the ROLLBACK TO SAVEPOINT statement.

UPDATE...
SAVEPOINT update_done;

INSERT...
ROLLBACK TO update_done;

COMMIT;

SELECT * FROM DEPT;
DELETE FROM DEPT;
COMMIT;
INSERT INTO DEPT VALUES (1, 'A', 100, 1000, SYSDATE);
ROLLBACK;

INSERT INTO DEPT VALUES (1, 'A', 100, 1000, SYSDATE);
INSERT INTO DEPT VALUES (2, 'B', 100, 1000, SYSDATE);
SAVEPOINT A;
INSERT INTO DEPT VALUES (3, 'C', 100, 1000, SYSDATE);
ROLLBACK TO SAVEPOINT A;
INSERT INTO DEPT VALUES (4, 'D', 100, 1000, SYSDATE);
COMMIT;

Implicit Transaction Processing
? An automatic commit occurs in the following circumstances:
  ? A DDL statement issued
  ? A DCL statement issued
  ? Normal exit from SQL Developer or SQL*Plus, without explicitly issuing COMMIT or ROLLBACK statements
? An automatic rollback occurs when there is an abnormal termination of SQL Developer or SQL*Plus or a system failure.


1: State of the Data Before COMMIT or ROLLBACK
 ? The previous state of the data can be recovered.
 ? The current user can review the results of the DML operations by using the SELECT statement.
 ? Other users cannot view the results of the DML statements issued by the current user.
 ? The affected rows are locked; other users cannot change the data in the affected rows.

2: State of the Data After COMMIT
 ? Data changes are saved in the database.
 ? The previous state of the data is overwritten.
 ? All users can view the results.
 ? Locks on the affected rows are released; those rows are available for other users to manipulate.
 ? All savepoints are erased.

3: State of the Data After ROLLBACK
 ? Discard all pending changes by using the ROLLBACK statement:
 ? Data changes are undone.
 ? Previous state of the data is restored.
 ? Locks on the affected rows are released.

Statement-Level Rollback
? If a single DML statement fails during execution, only that statement is rolled back.
? The Oracle server implements an implicit savepoint.
? All other changes are retained.
? The user should terminate transactions explicitly by executing a COMMIT or ROLLBACK statement.

Read Consistency
? Read consistency guarantees a consistent view of the data at all times.
? Changes made by one user do not conflict with the changes made by another user.
? Read consistency ensures that, on the same data:
  ? Readers do not wait for writers
  ? Writers do not wait for readers
  ? Writers wait for writers


COMMIT;
SELECT * FROM DEPT;
INSERT INTO DEPT VALUES(5,'E',100,1000,SYSDATE);

UPDATE DEPT SET NOMBRE_DEPARTAMENTO ='EEEEE' 
WHERE ID_DEPARTAMENTO= 5;
DELETE FROM DEPT WHERE ID_DEPARTAMENTO = 5;


SELECT * FROM COPY_EMP;
DROP TABLE COPY_EMP;
CREATE TABLE COPY_EMP AS SELECT * FROM HR.EMPLOYEES;
ROLLBACK;


FOR UPDATE Clause in a SELECT Statement
? Locks the rows in the EMPLOYEES table where job_id is SA_REP.
SELECT employee_id, salary, commission_pct, job_id
FROM COPY_EMP
WHERE job_id = 'SA_REP'
FOR UPDATE
ORDER BY employee_id;
SELECT * FROM COPY_EMP WHERE JOB_ID ='SA_REP';
COMMIT;
--UPDATE COPY_EMP SET COMMISSION_PCT = NULL  WHERE JOB_ID ='SA_REP';
--UPDATE COPY_EMP SET SALARY = 0  WHERE JOB_ID ='SA_REP';

? Lock is released only when you issue a ROLLBACK or a COMMIT.
? If the SELECT statement attempts to lock a row that is
locked by another user, the database waits until the row is
available, and then returns the results of the SELECT statement.

FOR UPDATE Clause: Examples

? You can use the FOR UPDATE clause in a SELECT statement against multiple tables.
COMMIT;
/*
SELECT e.employee_id, e.salary, e.commission_pct
FROM employees e JOIN departments d
USING (department_id)
WHERE job_id = 'ST_CLERK'
AND location_id = 1500
FOR UPDATE
ORDER BY e.employee_id;
*/

? Rows from both the EMPLOYEES and DEPARTMENTS tables are locked.
