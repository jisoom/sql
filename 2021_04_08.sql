사용 예 )오늘이 2005년 1월 31일이라고 가정하고 오늘까지 발생된 상품입고 정보를 이용하여
재고 수불테이블을 update하는 프로시저를 생성하시오
1. 프로시저명 : PROC_REMAIN_IN
2. 매개변수 : 상품코드, 매입수량
3. 처리 내용 : 해당 상품코드에 대한 입고 수량, 현 재고 수량, 날짜 UPDATE

** 1. 2005년 상품별 매입수량 집계 --프로시저 밖에서 처리
   2. 1의 결과 각 행을 PROCEDURE에 전달
   3. PROCEDURE에서 재고 수불 테이블 UPDATE
   SELECT *
   FROM REMAIN
(PROCEDURE 생성) 
CREATE OR REPLACE PROCEDURE PROC_REMAIN_IN(
    P_CODE IN PROD.PROD_ID%TYPE,
    P_CNT IN NUMBER) --매개변수는 데이터 타입만 씀 NUMBER(10)이런식으로 쓰면 안됨
    --매개변수에서도 참조형 데이터타입 쓸 수 있음
IS

BEGIN
    UPDATE REMAIN
    SET (REMAIN_I, REMAIN_J_99, REMAIN_DATE) = (SELECT REMAIN_I + P_CNT,
                                                       REMAIN_J_99 + P_CNT,
                                                       TO_DATE('20050131')
                                                FROM REMAIN
                                                WHERE  REMAIN_YEAR = '2005'
                                                     AND PROD_ID = P_CODE)
    WHERE REMAIN_YEAR = '2005'
        AND PROD_ID = P_CODE;

END;

2.프로시저 실행명령
EXEC | EXECUTE 프로시저명[(매개변수 list)];
-단, 익명블록 등 또다른 프로시저나 함수에서 프로시저 호출시 'EXEC | EXECUTE'는 생략해야 한다
SELECT *
FROM BUYPROD
(2005년 1월 상품별 매입 집계)
SELECT BUY_PROD AS BCODE,
        SUM(BUY_QTY) AS BAMT
FROM BUYPROD
WHERE BUY_DATE BETWEEN '20050101' AND '20050131'
GROUP BY BUY_PROD;

(익명블록 작성)
DECLARE
    CURSOR CUR_BUY_AMT
    IS
    SELECT BUY_PROD AS BCODE,
        SUM(BUY_QTY) AS BAMT
      FROM BUYPROD
     WHERE BUY_DATE BETWEEN '20050101' AND '20050131'
     GROUP BY BUY_PROD;
BEGIN
    FOR REC01 IN CUR_BUY_AMT LOOP
        PROC_REMAIN_IN(REC01.BCODE, REC01.BAMT);
    END LOOP;
END;

**REMAIN 테이블의 내용을 VIEW로 구성
CREATE OR REPLACE VIEW V_REMAIN01
AS
    SELECT * FROM REMAIN;


CREATE OR REPLACE VIEW V_REMAIN02
AS
    SELECT * FROM REMAIN;
    
SELECT * FROM V_REMAIN01;
SELECT * FROM V_REMAIN02;


사용예) 회원아이디를 입력받아 그 회원의 이름, 주소와 직업을 반환하는 프로시저를 작성하시오
1. 프로시저명 : PROC_MEM_INFO
2. 매개변수 : 입력용 : 회원아이디 
             출력용: 이름, 주소, 직업
             
(프로시저 생성)
CREATE OR REPLACE PROCEDURE PROC_MEM_INFO(
    P_ID IN MEMBER.MEM_ID%TYPE,
    P_NAME OUT MEMBER.MEM_NAME%TYPE,
    P_ADDR OUT VARCHAR2,
    P_JOB OUT MEMBER.MEM_JOB%TYPE)
AS
BEGIN
    SELECT MEM_NAME, MEM_ADD1 || ' ' ||MEM_ADD2, MEM_JOB
        INTO P_NAME, P_ADDR, P_JOB
    FROM MEMBER
    WHERE MEM_ID = P_ID;
END;

(실행)
ACCEPT PID PROMPT '회원 아이디 : '
DECLARE
    V_NAME MEMBER.MEM_NAME%TYPE;
    V_ADDR VARCHAR2(200);
    V_JOB MEMBER.MEM_JOB%TYPE;
BEGIN
    PROC_MEM_INFO('&PID', V_NAME, V_ADDR, V_JOB);
    DBMS_OUTPUT.PUT_LINE('회원아이디 : ' || '&PID');
    DBMS_OUTPUT.PUT_LINE('회원이름 : ' || V_NAME);
    DBMS_OUTPUT.PUT_LINE('주소 : ' || V_ADDR);
    DBMS_OUTPUT.PUT_LINE('직업 : ' || V_JOB);
END;


문제] 년도를 입력 받아 해당 년도에 구매를 가장 많이한 회원이름과 구매액을 반환하는 프로시저를 작성하시오.
1. 프로시저명 : PROC_MEM_PTOP
2. 매개변수 : 입력용 : 년도
             출력용 : 회원이름, 구매액

**2005년도 회원별 구매금액
--ORDER BY 2 : SUM(C.CART_QTY * P.PROD_PRICE)로 정렬하라

SELECT M.MEM_NAME, A.AMT
FROM(SELECT C.CART_MEMBER AS MID, 
           SUM(C.CART_QTY * P.PROD_PRICE) AS AMT
     FROM CART C, PROD P
     WHERE C.CART_PROD = P.PROD_ID
       AND SUBSTR(C.CART_NO,1,4)='2005'
     GROUP BY C.CART_MEMBER
     ORDER BY 2 DESC) A, MEMBER M
WHERE M.MEM_ID = A.MID
    AND ROWNUM =1;

(프로시저 생성)
CREATE OR REPLACE PROCEDURE PROC_MEM_PTOP(
    P_YEAR IN CHAR,
    P_NAME OUT MEMBER.MEM_NAME%TYPE , --테이블명과 테이블을 알고있을 때 참조형으로 써줌
    P_AMT OUT NUMBER)
IS
BEGIN 
        SELECT M.MEM_NAME, A.AMT INTO P_NAME, P_AMT
        FROM(SELECT C.CART_MEMBER AS MID, 
                   SUM(C.CART_QTY * P.PROD_PRICE) AS AMT
             FROM CART C, PROD P
             WHERE C.CART_PROD = P.PROD_ID
             AND SUBSTR(C.CART_NO,1,4)=P_YEAR
             GROUP BY C.CART_MEMBER
             ORDER BY 2 DESC) A, MEMBER M
        WHERE M.MEM_ID = A.MID
            AND ROWNUM =1;
END;

(실행)
(OUT매개 변수가 있어서 익명 프로시저로 실행)
DECLARE
    V_NAME MEMBER.MEM_NAME%TYPE;
    V_AMT NUMBER := 0;
BEGIN --EXEC쓰면 안됨 하나의 블럭에서 호출할 때는 생략해야됨
    PROC_MEM_PTOP('2005',V_NAME, V_AMT);
    
    DBMS_OUTPUT.PUT_LINE('회원명 :' || V_NAME);
    DBMS_OUTPUT.PUT_LINE('구매금액 :' || TO_CHAR(V_AMT, '99,999,999'));
END;


문제] 2005년도 구매금액이 없는 회원을 찾아 회원테이블(MEMBER)의 삭제여부 컬럼(MEM_DELETE)의 값을 'Y'로 변경하는 프로시저를 작성하시오
(프로시저 생성 : 입력받은 회원번호로 해당 회원의 삭제 여부 컬럼값을 변경)

CREATE OR REPLACE PROCEDURE PROC_MEM_UPDATE (
    P_MID IN MEMBER.MEM_ID%TYPE)
IS
BEGIN
    UPDATE MEMBER
       SET MEM_DELETE = 'Y'
     WHERE MEM_ID = P_MID;
     COMMIT;
END;


(구매금액이 없는 회원)
DECLARE
    CURSOR CUR_MID 
IS
    SELECT MEM_ID
      FROM MEMBER
     WHERE MEM_ID NOT IN (SELECT CART_MEMBER
                            FROM CART
                           WHERE CART_NO LIKE '2005%');
BEGIN
    FOR REC_MID IN CUR_MID LOOP
        PROC_MEM_UPDATE(REC_MID.MEM_ID);
    END LOOP;
END;






