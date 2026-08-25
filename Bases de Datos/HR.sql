TEMA 1: Using DDL Statements to Create and Manage Tables

Database Objects

Object    Description
Table:    Basic unit of storage; composed of rows
*View:     Logically represents subsets of data from one or more tables
Sequence: Generates numeric values
Index:    Improves the performance of some queries
Synonym:  Gives alternative name to an object

Naming Rules

Table names and column names must:
  * Begin with a letter
  * Be 1-30 characters long
  * Contain only A-Z, a-z, 0-9, _, $, and #
  * Not duplicate the name of another object owned by the same user
  * Not be an Oracle server-reserved Word

CREATE TABLE Statement
* You must have:
  - The CREATE TABLE privilege
  - A storage ?rea

CREATE TABLE [schema.]table
  (column datatype [DEFAULT expr][, ...]);

* You specify:
  - The table name
  - The column name, column data type, and column size

Referencing Another User's Tables

  * Tables belonging to other users are not in the user's schema.
  * You should use the owner's name as a prefix to those tables.

USERA 
SELECT *
FROM userB.employees;

USERB
SELECT *
FROM userA.employees;

DEFAULT Option
  * Specify a default value for a column during an insert.

      ... hire_date DATE DEFAULT SYSDATE, ...

  * Literal values, expressions, or SQL functions are legal values.
  * Another column's name or a pseudocolumn are illegal values.
  * The default data type must match the column data type.
'

Creating Tables
 
DROP TABLE DEPT;

CREATE TABLE dept
 (deptno NUMBER(2),
  dname VARCHAR2(14),
  loc VARCHAR2(13),
  create_date DATE DEFAULT SYSDATE);

Confirm table creation:
 DESCRIBE dept;

SELECT * FROM dept;
INSERT INTO dept (deptno,dname,loc) VALUES (1,'VENTAS','ZAC');
INSERT INTO dept (deptno,dname,loc,create_date) VALUES (2,'COMPRAS','ZAC','19/08/25');
SELECT SYSDATE FROM DUAL;


Data Types
    Data Type              Description
 VARCHAR2(size):   Variable-length character data
 CHAR(size):       Fixed-length character data
 NUMBER(p,s):      Variable-length numeric data
 DATE:             Date and time values
 LONG:             Variable-length character data (up to 2 GB)
 CLOB:             Character data (up to 4 GB)
 RAW and LONG RAW: Raw binary data
 BLOB:             Binary data (up to 4 GB)
 BFILE:            Binary data stored in an external file (up to 4 GB)
 ROWID:            A base-64 number system representing the unique address of a row in its table

Datetime Data Types
You can use several datetime data types:
 TIMESTAMP: Date with fractional seconds
 INTERVAL YEAR TO MONTH: Stored as an interval of years and months
 INTERVAL DAY TO SECOND: Stored as an interval of days, hours, minutes, and seconds

DROP TABLE ejemplo_timestamp;

CREATE TABLE ejemplo_timestamp (
    evento_id NUMBER,
    fecha_hora TIMESTAMP
);

INSERT INTO ejemplo_timestamp (evento_id, fecha_hora)
VALUES (1, TIMESTAMP '2025-08-25 12:34:56.789');

SELECT * FROM ejemplo_timestamp;


Including Constraints
 * Constraints enforce rules at the table level.
 * Constraints prevent the deletion of a table if there are dependencies.
 * The following constraint types are valid:
    - NOT NULL
    - UNIQUE
    - PRIMARY KEY
    - FOREIGN KEY
    - CHECK


Constraint Guidelines
 * You can name a constraint, or the Oracle server generates a name by using the SYS_Cn format.
 * Create a constraint at either of the following times:
    - At the same time as the creation of the table (CREATE TABLE)
    - After the creation of the table (ALTER TABLE)
 * Define a constraint at the column or table level.
 * View a constraint in the data dictionary.

Defining Constraints

* Syntax:
CREATE TABLE [schema.]table
   (column datatype [DEFAULT expr]
   [column_constraint],
   ...
   [table_constraint][,...]);

* Column-level constraint syntax:
 column [CONSTRAINT constraint_name] constraint_type,

* Table-level constraint syntax:
 column,...
   [CONSTRAINT constraint_name] constraint_type
   (column, ...),


NOT NULL Constraint
Ensures that null values are not permitted for the column
SELECT * FROM EMPLOYEES;

UNIQUE Constraint
Ensures unique values in non-primary key columns

PRIMARY KEY Constraint
SELECT * FROM DEPARTMENTS;

FOREIGN KEY Constraint
SELECT * FROM EMPLOYEES;

FOREIGN KEY Constraint: Keywords
 * FOREIGN KEY: Defines the column in the child table at the table-constraint level
 * REFERENCES: Identifies the table and column in the parent table
 * ON DELETE CASCADE: Deletes the dependent rows in the child table when a row in the parent table is deleted
 * ON DELETE SET NULL: Converts dependent foreign key values to null

CHECK Constraint
* Defines a condition that each row must satisfy
* The following expressions are not allowed:
  - References to CURRVAL, NEXTVAL, LEVEL, and ROWNUM pseudocolumns
  - Calls to SYSDATE, UID, USER, and USERENV functions
  - Queries that refer to other values in other rows

Defined at either the table level or the column level:


Example: 


CREATE TABLE departamento
(
    departamento_id  NUMBER(4) CONSTRAINT departamento_pk PRIMARY KEY,
    nombre VARCHAR2(50) CONSTRAINT dep_nombre_nn NOT NULL CONSTRAINT dep_nombre_uk UNIQUE,
    ubicacion         VARCHAR2(50),
    fecha_registro    DATE DEFAULT SYSDATE
);

CREATE TABLE empleado
(
    empleado_id NUMBER(6) CONSTRAINT emp_id_pk PRIMARY KEY,
    nombre VARCHAR2(50) CONSTRAINT emp_nombre_nn NOT NULL,
    email VARCHAR2(80) CONSTRAINT emp_e_mail_uk UNIQUE,
    salario NUMBER(8,2) CONSTRAINT emp_sal_ck CHECK (salario > 0),
    comision_pct      NUMBER(3,2) CONSTRAINT emp_com_ck CHECK (comision_pct BETWEEN 0 AND 1),
    fecha_contratacion DATE DEFAULT SYSDATE CONSTRAINT emp_fecha_con_nn NOT NULL,
    manager_id        NUMBER(6),
    departamento_id   NUMBER(4) CONSTRAINT emp_dep_fk REFERENCES departamento (departamento_id),
    CONSTRAINT emp_man_fk FOREIGN KEY (manager_id) REFERENCES empleado (empleado_id)
);

DESC departamento;
DESC empleado;

INSERT INTO departamento (departamento_id, nombre, ubicacion) VALUES (10, 'VENTAS', 'ZACATECAS');
INSERT INTO departamento (departamento_id, nombre, ubicacion) VALUES (20, 'SISTEMAS', 'ZACATECAS');

INSERT INTO empleado (empleado_id, nombre, email, salario, comision_pct, departamento_id) VALUES (1001, 'ANA LOPEZ', 'ana@empresa.com', 15000, 0.10, 10);
INSERT INTO empleado (empleado_id, nombre, email, salario, comision_pct, manager_id, departamento_id) VALUES (1002, 'LUIS PEREZ', 'luis@empresa.com', 18000, 0.15, 1001, 20);

COMMIT;

SELECT * FROM departamento;
SELECT * FROM empleado;


PRIMARY KEY: valor duplicado
INSERT INTO empleado (empleado_id, nombre, email, salario, departamento_id) VALUES (1001, 'PEDRO', 'pedro@empresa.com', 12000, 10);

NOT NULL: nombre no puede ser NULL
INSERT INTO empleado (empleado_id, nombre, email, salario, departamento_id) VALUES (1003, NULL, 'maria@empresa.com', 12000, 10);

UNIQUE: correo repetido
INSERT INTO empleado (empleado_id, nombre, email, salario, departamento_id) VALUES (1003, 'MARIA', 'ana@empresa.com', 12000, 10);

CHECK: salario debe ser mayor que cero
INSERT INTO empleado (empleado_id, nombre, email, salario, departamento_id) VALUES (1003, 'MARIA', 'maria@empresa.com', -5000, 10);

FOREIGN KEY: departamento 99 no existe
INSERT INTO empleado (empleado_id, nombre, email, salario, departamento_id) VALUES (1003, 'MARIA', 'maria@empresa.com', 12000, 99);

DELETE FROM departamento WHERE departamento_id = 10;



Creating a Table Using a Subquery
* Create a table and insert rows by combining the CREATE TABLE statement and the AS subquery option.

CREATE TABLE table
[(column, column...)]
AS subquery;

Match the number of specified columns to the number of subquery columns.
* Define columns with column names and default values.
DROP TABLE dept80;
CREATE TABLE dept80
 AS
   SELECT employee_id, last_name,
      salary*12 ANNSAL,
      hire_date
   FROM employees
   WHERE department_id = 80;

DESCRIBE dept80;
SELECT * FROM dept80;

CREATE TABLE COPY_EMPLOYEES
AS
SELECT * FROM EMPLOYEES;

DESC COPY_EMPLOYEES;
SELECT * FROM COPY_EMPLOYEES;
DROP TABLE COPY_EMPLOYEES;


ALTER TABLE Statement
 Use the ALTER TABLE statement to:
  * Add a new column
  * Modify an existing column definition
  * Define a default value for the new column
  * Drop a column
  * Rename a column
  * Change table to read-only status
;

DROP TABLE EMPLOYEES_3;
CREATE TABLE employees_3(
  employee_id NUMBER(6),
  last_name VARCHAR2(25) CONSTRAINT emp_3_ln_nn NOT NULL,
  email VARCHAR2(25),
  salary NUMBER(8,2),
  commission_pct NUMBER(2,2),
  hire_date DATE CONSTRAINT emp_3_hd_nn NOT NULL,
  CONSTRAINT emp_3_email_uk UNIQUE(email));

SELECT * FROM employees_3;
DESC employees_3;

ALTER TABLE employees_3 ADD phone_number VARCHAR2(15);
ALTER TABLE employees_3 MODIFY last_name VARCHAR2(50);
ALTER TABLE employees_3 MODIFY phone_number VARCHAR2(15) NOT NULL;
ALTER TABLE employees_3 MODIFY phone_number VARCHAR2(15) NULL;
ALTER TABLE employees_3 DROP COLUMN commission_pct;
ALTER TABLE employees_3 RENAME COLUMN email TO contact_email;
ALTER TABLE employees_3 ADD CONSTRAINT emp_salary_ck CHECK (salary > 1000);
ALTER TABLE employees_3 DROP CONSTRAINT emp_3_email_uk;
ALTER TABLE employees_3 DISABLE CONSTRAINT emp_salary_ck;
ALTER TABLE employees_3 ENABLE CONSTRAINT emp_salary_ck;
ALTER TABLE employees_3 RENAME TO staff;
SELECT * FROM STAFF;

UPDATE employees_3 SET PHONE_NUMBER = '123';
DROP TABLE STAFF;


Read-Only Tables
 You can use the ALTER TABLE syntax to:
  * Put a table into read-only mode, which prevents DDL or DML changes during table maintenance
  * Put the table back into read/write mode
;
ALTER TABLE employees READ ONLY;
-- perform table maintenance and then
-- return table back to read/write mode

ALTER TABLE employees READ WRITE;


Dropping a Table
 * Moves a table to the recycle bin
 * Removes the table and all its data entirely if the PURGE clause is specified
 * Invalidates dependent objects and removes object privileges on the table
;
DROP TABLE dept80;

DROP TABLE nombre_de_la_tabla PURGE;
DROP TABLE dept80 PURGE;



-------------------------------------------------------
Nomenclatura para asignar un nombre a las restricciones

Primary Key: Nombre de la tabla, un guion bajo y PK
	Ejemplo: 
	Tabla Alumno: alumno_pk
?
Not Null: Identificador de la tabla, un guion bajo, identificador del campo, guion bajo y NN
	Ejemplo:
	Tabla alumno y Campo apaterno: al_ap_nn

Unique: Identificador de la tabla, un guion bajo, identificador del campo, guion bajo y UK
	Ejemplo:
	Tabla alumno y Campo email: al_email_uk

Check: Identificador de la tabla, un guion bajo, identificador del campo, guion bajo y CK
	Ejemplo:
	Tabla alumno y Campo edad: al_edad_ck

Foreign Key: Identificador de la tabla origen, guion bajo, identificador de la tabla destino, guion bajo y FK
	Ejemplo:
	Relaci?n entre la tabla alumno y asignatura: 	alumno_asignatura_fk