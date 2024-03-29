SELECT *
FROM DEPARTMENTS;

SELECT * 
FROM EMPLOYEES;

-----------계층형으로 만들기---------------
SELECT LEVEL
      ,EMPLOYEE_ID
      ,MANAGER_ID
      ,LPAD(' ', 2*(LEVEL -1)) || FIRST_NAME AS FIRST_NAME
FROM EMPLOYEES
START WITH MANAGER_ID IS NULL
CONNECT BY PRIOR EMPLOYEE_ID = MANAGER_ID;