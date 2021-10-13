CREATE TABLE TEST_SYC_JOB(
    T_IDX VARCHAR2(5BYTE) NOT NULL,
    T_NAME VARCHAR2(50BYTE) NOT NULL,
    T_DES VARCHAR2(50BYTE) NOT NULL,
    T_DATE VARCHAR2(50BYTE) NOT NULL
);

SELECT *
FROM TEST_SYC_JOB;

CREATE OR REPLACE PROCEDURE TEST_PRO_SYC_JOB

AS
M_DATE VARCHAR2(100);
M_STEP VARCHAR2(100);
O_MSG VARCHAR2(100);

BEGIN
    M_STEP := '1'; 
    M_DATE := TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS');
    O_MSG := 'Y : SUCCESS';  
    INSERT INTO TEST_SYC_JOB VALUES (M_STEP, 'TEST_PRO_SYC_JOB', O_MSG || ' ['|| M_STEP ||']', M_DATE);
    COMMIT;     

    M_STEP := '2'; 
    M_DATE := TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS');
    INSERT INTO TEST_SYC_JOB VALUES (M_STEP, 'TEST_PRO_SYC_JOB', O_MSG || ' ['|| M_STEP ||']', M_DATE);
    COMMIT;
    
EXCEPTION
   WHEN NO_DATA_FOUND 
   THEN
      BEGIN
         O_MSG := 'N : ' || 'EXCEPTION' || ' [NO_DATA_FOUND]';
         INSERT INTO TEST_SYC_JOB VALUES (M_STEP, 'TEST_PRO_SYC_JOB', O_MSG || ' ['|| M_STEP ||']', M_DATE);   
         COMMIT;      
      END;

   WHEN OTHERS 
   THEN
      BEGIN
         O_MSG := 'N : ' || 'EXCEPTION' || ' [M_STEP := '|| M_STEP ||']';  
         INSERT INTO TEST_SYC_JOB VALUES (M_STEP, 'TEST_PRO_SYC_JOB', O_MSG || ' ['|| M_STEP ||']', M_DATE);   
         COMMIT;                      
      END;   
END TEST_PRO_SYC_JOB;  

DECLARE
  X NUMBER;
BEGIN
  begin
    SYS.DBMS_JOB.SUBMIT
      (
        job        => X 
       ,what       => 'TEST_PRO_SYC_JOB;'
       ,next_date  => to_date('09/24/2021 10:12:00','mm/dd/yyyy hh24:mi:ss')
       ,interval   => 'SYSDATE+1/24/60'
       ,no_parse   => FALSE
    );
  :JobNumber := to_char(X);
  exception
    when others then
    begin
      raise;
    end;
  end;
END;

SELECT * FROM USER_JOBS;
EXEC TEST_PRO_SYC_JOB;

CALL DBMS_JOB.REMOVE(303);
DROP PROCEDURE TEST_PRO_SYC_JOB;
SELECT * 
FROM TEST_SYC_JOB;

DECLARE 
BEGIN
  DBMS_JOB.BROKEN(304, FALSE);
  COMMIT;
END;
