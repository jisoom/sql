--프로시저(before)
CREATE OR REPLACE PROCEDURE PRO_TEST_JOB

AS
SYS_DATE VARCHAR2(100); --현재 날짜 데이터
START_DATE VARCHAR2(100); --시험에 등록된 시험 시작일 데이터
END_DATE VARCHAR2(100); --시험에 등록된 시험 종료일 데이터
OPEN_CODE_MSG VARCHAR2(100);  --시험 상태 변경해줄 값

--여러개 조회해서 한번에 바꾸는것도 되는지
--날짜 값 비교하려면 TO_NUMBER로 해야되는지

BEGIN
    SYS_DATE := TO_CHAR(SYSDATE, 'YYYYMMDD'); 
    SELECT TO_CHAR(TEST_ST_DATE,'YYYYMMDD') INTO START_DATE FROM TEST WHERE NOT OPEN_CODE IN ('E101'); --시험 준비 제외한 모든것(시험 출제완료, 진행중, 시험완료)
    SELECT TO_CHAR(TEST_END_DATE,'YYYYMMDD') INTO END_DATE FROM TEST WHERE NOT OPEN_CODE IN ('E101');
    OPEN_CODE_MSG := 'E102';
    IF SYS_DATE >= START_DATE AND SYS_DATE <= END_DATE THEN 
        UPDATE TEST SET OPEN_CODE = OPEN_CODE_MSG WHERE NOT OPEN_CODE IN ('E101'); -- 시험시작일자가 현재일자랑 같거나 초과되면서 종료일자가 현재일자랑 같거나 작으면 -> 시험 진행중으로 변경
        COMMIT;
        
    OPEN_CODE_MSG := 'E103';        
    ELSIF SYS_DATE < END_DATE THEN
        UPDATE TEST SET OPEN_CODE = OPEN_CODE_MSG WHERE NOT OPEN_CODE IN ('E101'); --시험종료일자가 현재일자보다 크면 -> 시험 종료로 변경
        COMMIT;
    END IF;    
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        BEGIN
            OPEN_CODE_MSG := '[NO_DATA_FOUND]';
            UPDATE TEST SET OPEN_CODE = OPEN_CODE_MSG WHERE NOT OPEN_CODE IN ('E101'); --잘 모르겠음...
            COMMIT;
        END;        
END PRO_TEST_JOB;
/

--최종 프로시저(after)!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
CREATE OR REPLACE PROCEDURE PRO_TEST_JOB

AS
SYS_DATE VARCHAR2(100); --현재 날짜 데이터
START_DATE VARCHAR2(100); --시험에 등록된 시험 시작일 데이터
END_DATE VARCHAR2(100); --시험에 등록된 시험 종료일 데이터
OPEN_CODE_MSG VARCHAR2(100);  --시험 상태 변경해줄 값
USER_EXCEPTION EXCEPTION;
CNT NUMBER;

--하나의 행마다 각각 실행해주기 위해 cursor 사용함
    CURSOR CUR IS
        SELECT TO_CHAR(TEST_ST_DATE,'YYYYMMDD') AS TEST_ST_DATE, TO_CHAR(TEST_END_DATE,'YYYYMMDD')  AS TEST_END_DATE
             , TEST_ID
        FROM TEST 
        WHERE NOT OPEN_CODE IN ('E101');


BEGIN
    SYS_DATE := TO_CHAR(SYSDATE, 'YYYYMMDD'); 
    
    SELECT COUNT(*) INTO CNT 
    FROM TEST WHERE OPEN_CODE != 'E103';
    
    IF CNT<1 THEN
        RAISE USER_EXCEPTION;
    END IF;
    
    SELECT COUNT(*) INTO CNT 
    FROM TEST WHERE OPEN_CODE != 'E101';
    
    IF CNT<1 THEN
        RAISE USER_EXCEPTION;
    END IF;

    FOR REC IN CUR LOOP
         START_DATE := TO_CHAR(REC.TEST_ST_DATE);
         END_DATE   := TO_CHAR(REC.TEST_END_DATE);
         
        IF SYS_DATE BETWEEN START_DATE AND END_DATE THEN 
             -- 시험시작일자가 현재일자랑 같거나 초과되면서 종료일자가 현재일자랑 같거나 작으면 -> 시험 진행중으로 변경
            UPDATE TEST SET OPEN_CODE = 'E102' WHERE TEST_ID = REC.TEST_ID; 
            COMMIT;
    
        ELSIF SYS_DATE > END_DATE THEN
            UPDATE TEST SET OPEN_CODE = 'E103' WHERE TEST_ID = REC.TEST_ID; --시험종료일자가 현재일자보다 크면 -> 시험 종료로 변경
            COMMIT;
        END IF;
    END LOOP;
EXCEPTION
    WHEN USER_EXCEPTION THEN
        DBMS_OUTPUT.PUT_LINE('종료되었습니다');
END PRO_TEST_JOB;
/

--프로시저 실행
EXEC PRO_TEST_JOB;
/


SELECT TEST_ID
     , TEST_ST_DATE
     , TEST_END_DATE
     , OPEN_CODE
     , SYSDATE
     , CASE WHEN SYSDATE BETWEEN TEST_ST_DATE AND TEST_END_DATE THEN 'E102'
            WHEN SYSDATE > TEST_END_DATE THEN 'E103'
            ELSE 'E104'
       END RSLT
FROM   TEST
WHERE  OPEN_CODE != 'E101';
/

--JOB
--DECLARE
--    X NUMBER;
--BEGIN
--    SYS.DBMS_JOB.SUBMIT
--    (
--        job => X
--        ,what => 'PRO_TEST_JOB;'
--        ,next_date => TO_DATE('09/25/2021 23:00:00', 'mm/dd/yyyy hh24:mi:ss')
--        ,interval => 'SYSDATE+1'
--        ,no_parse => FALSE
--    );
--    :JobNumber := to_char(X);
--    exception
--        when others then
--            dbms_output.put_line('오류 발생 : ' || sqlerrm);
--END;     
/

/*
DECLARE
-- v_job 변수는 임의의 숫자로 job 아이디가 됩니다.
v_job NUMBER(5);
BEGIN
DBMS_JOB.submit(
v_job, -- job 아이디
'ex2;', -- 실행할 작업
sysdate, -- 처음 작업을 실행할 시간
'sysdate+(1/1440)', -- 1분마다
FALSE); -- 파싱여부
-- 출력메시지
sys.DBMS_OUTPUT.put_line('DBMS_JOB job number is' || TO_CHAR(v_job));
COMMIT;
END;
*/
/
--출력 ON
SET SERVEROUTPUT ON;
/
--최종 JOB!!!!!!!!!!!!!!!!!!!!!!!!(한시간 간격으로 프로시저 호출)
DECLARE
    V_JOB NUMBER(5);
BEGIN
    DBMS_JOB.SUBMIT(
        V_JOB,
        'PRO_TEST_JOB;',
        SYSDATE,
        'SYSDATE + (60/1440)',
        FALSE
    );
    sys.DBMS_OUTPUT.put_line('DBMS_JOB job number is : ' || TO_CHAR(v_job));
END;
/
--테스트
DECLARE
BEGIN
DBMS_OUTPUT.PUT_LINE('A');
END;
/

--JOB 조회
SELECT * FROM USER_JOBS;
/
BEGIN
  --JOB 재실행
  --DBMS_JOB.BROKEN(305, FALSE);
  
  --JOB 삭제
  DBMS_JOB.REMOVE(326);
  COMMIT;
END;
/

--TEST 테이블 조회
SELECT * 
FROM TEST
WHERE TEST_EXAMINER = 'teach03';
    