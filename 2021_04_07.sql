반복문
-개발언어의 반복문과 같은 기능 제공
-loop, while, for문
1)LOOP 문
.반복문의 기본 구조
.JAVA의 DO문과 유사한 구조임
.기본적으로 무한 루프 구조
(사용형식)
LOOP
    반복처리문(들);
    [EXIT WHEN 조건;]
END LOOP;
    -'EXIT WHEN 조건' : '조건'이 참인 경우 반복문의 범위를 벗어남
운영체제는 기본적으로 무한루프임(사용자 명령 받기 전까지 대기상태)
--WHILE문은 조건이 거짓일 때 반복을 멈추고, LOOP는 조건이 참일 때 반복을 멈춤

사용예) 구구단의 7단을 출력
DECLARE
 V_CNT NUMBER :=1;  --초기화 시킬때 NUMBER로 초기화
 V_RES NUMBER :=0;
BEGIN
    LOOP
        V_RES := 7 * V_CNT;
        DBMS_OUTPUT.PUT_LINE(7|| '*' || V_CNT || '=' || V_RES);
        V_CNT := V_CNT+1;
        EXIT WHEN V_CNT > 9;
    END LOOP;
END; 

사용예) 1-50사이의 피보나치수를 구하여 출력하시오
FIBONACCI NUMBER : 첫번째와 두번째 수가 1, 1로 주어지고 세번째 수부터 전 두 수의 합이 현재수가 되는 수열 -> 검색알고리즘에 사용
DECLARE
    V_PNUM NUMBER := 1; --전수
    V_PPNUM NUMBER := 1; --전전수
    V_CURRNUM NUMBER := 0; --현재수
    V_RES VARCHAR(100);
BEGIN
    V_RES := V_PPNUM || ',' ||V_PNUM;
    
    LOOP
        V_CURRNUM := V_PPNUM + V_PNUM;
        EXIT WHEN V_CURRNUM >= 50;
        V_RES := V_RES||','||V_CURRNUM;
        V_PPNUM := V_PNUM;
        V_PNUM := V_CURRNUM;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('1~50사이의 피보나치 수 :' || V_RES);
END;

2)WHILE 문
.개발언어의 WHILE문과 같은 기능
.조건을 미리 체크하여 조건이 참인 경우에만 반복처리
(사용형식)
WHILE 조건 
    LOOP
        반복처리문(들);
    END LOOP;

사용예) 첫날에 100원 둘째날부터 전날의 2배씩 저축할 경우 최초로 100만원을 넘는 날과 저축한 금액을 구하시오
    
DECLARE
    V_DAYS NUMBER := 1; --날짜
    V_AMT NUMBER := 100; --날짜별 저축할 금액
    V_SUM NUMBER := 0; --저축한 금액 합계
BEGIN
    WHILE V_SUM <1000000 LOOP
    V_SUM := V_SUM + V_AMT;
    V_DAYS := V_DAYS + 1;
    V_AMT := V_AMT *2;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('날수 :' ||(V_DAYS-1));
    DBMS_OUTPUT.PUT_LINE('저축액수 :' ||V_SUM);
END;

사용예) 회원테이블(MEMBER)에서 마일리지가 3000이상인 회원들을 찾아 그들이 2005년 5월 구매한 횟수와 구매금액합계를 구하시오
        (커서 사용) 출력은 회원번호, 회원명, 구매횟수, 구매금액
        커서로 구현해야 될 것 : 멤버테이블에서 마일리지가 3000이상인 회원들의 회원번호, 회원명 뽑아내는 것
        
(LOOP를 사용한 커서 실행)        
DECLARE
V_MID MEMBER.MEM_ID%TYPE; --회원번호
V_MNAME MEMBER.MEM_NAME%TYPE; --회원명
V_CNT NUMBER := 0; --구매횟수
V_AMT NUMBER := 0; --구매금액 합계
    CURSOR CUR_CART_AMT
    IS
        SELECT MEM_ID, MEM_NAME
        FROM MEMBER
        WHERE MEM_MILEAGE >= 3000;
BEGIN
    OPEN CUR_CART_AMT;
    
    LOOP
        FETCH CUR_CART_AMT INTO V_MID, V_MNAME; --커서내의 컬럼값을 INTO 다음 기술된 변수에 할당
        EXIT WHEN CUR_CART_AMT%NOTFOUND;
        SELECT SUM(A.CART_QTY * B.PROD_PRICE),
               COUNT(A.CART_PROD) INTO V_AMT, V_CNT
        FROM CART A, PROD B
        WHERE A.CART_PROD = B.PROD_ID
            AND A.CART_MEMBER = V_MID
            AND SUBSTR(A.CART_NO,1,6) = '200505';
            
        DBMS_OUTPUT.PUT_LINE(V_MID||', '||V_MNAME||' =>' ||V_AMT||'('||V_CNT|| ')');
    END LOOP;
    CLOSE CUR_CART_AMT;
END;

(WHILE 문 사용)
DECLARE
V_MID MEMBER.MEM_ID%TYPE; --회원번호
V_MNAME MEMBER.MEM_NAME%TYPE; --회원명
V_CNT NUMBER := 0; --구매횟수
V_AMT NUMBER := 0; --구매금액 합계
    CURSOR CUR_CART_AMT
    IS
        SELECT MEM_ID, MEM_NAME
        FROM MEMBER
        WHERE MEM_MILEAGE >= 3000;
BEGIN
    OPEN CUR_CART_AMT;
    FETCH CUR_CART_AMT INTO V_MID, V_MNAME; --커서내의 컬럼값을 INTO 다음 기술된 변수에 할당
    
    WHILE CUR_CART_AMT%FOUND LOOP  
    --CUR_CART_AMT%FOUND은 조건에 맞지 않아서 FALSE가 됨 ==> FETCH문을 OPEN 다음으로 이동해주고, FETCH문을 LOOP끝나기 전에 한번 더해줌
        SELECT SUM(A.CART_QTY * B.PROD_PRICE),
               COUNT(A.CART_PROD) INTO V_AMT, V_CNT
        FROM CART A, PROD B
        WHERE A.CART_PROD = B.PROD_ID
            AND A.CART_MEMBER = V_MID
            AND SUBSTR(A.CART_NO,1,6) = '200505';
            
        DBMS_OUTPUT.PUT_LINE(V_MID||', '||V_MNAME||' =>' ||V_AMT||'('||V_CNT|| ')');
         FETCH CUR_CART_AMT INTO V_MID, V_MNAME;
    END LOOP;
    CLOSE CUR_CART_AMT;
END;

3) FOR 문
.반복횟수를 알고 있거나 횟수가 중요한 경우 사용
(사용 형식 -1 : 일반적 FOR)
--증감값을 조정할 수 없음 무조건 1증가, 1감소
FOR 인덱스 IN[REVERSE] 최소값..최대값  --REVERSE : 1~10을 출력할 때 역으로 10~1로 출력되게 함
LOOP
    반복처리문(들);
END LOOP;

사용예) 구구단의 7단을 FOR 문을 이용하여 구성
DECLARE
--    V_CNT NUMBER := 1; --승수(1~9) 1~9까지 FOR문을 통해 자동으로 되서 얘는 필요 없음
--    V_RES NUMBER := 0; --결과값 직접 기술해 주면되서 얘도 필요 없음
BEGIN
    FOR I IN 1..9 LOOP
--    V_RES := 7 * I;
    DBMS_OUTPUT.PUT_LINE(7|| '*' ||I|| '=' ||7 * I);  --7 * I 값 : V_RES
    END LOOP;
END;

(사용 형식 -2 : CURSOR에 사용하는 FOR)
FOR 레코드명 IN 커서명|(커서 선언문)
LOOP
    반복처리문(들);
END LOOP;
.'레코드명' 은 시스템에서 자동으로 설정
.커서 컬럼 참조형식 : 레코드명.커서컬럼명 =>변수선언이 필요없음
.커서명 대신 커서 선언문(선언부에 존재했던)을 INLINE 형식으로 기술할 수 있음
.FOR문을 사용하는 경우 커서의 OPEN, FETCH, CLOSE 문은 생략함

(FOR 문 사용)
DECLARE
V_CNT NUMBER := 0; --구매횟수
V_AMT NUMBER := 0; --구매금액 합계
    CURSOR CUR_CART_AMT
    IS
        SELECT MEM_ID, MEM_NAME
        FROM MEMBER
        WHERE MEM_MILEAGE >= 3000;
BEGIN
    FOR REC_CART IN CUR_CART_AMT 
    LOOP
        SELECT SUM(A.CART_QTY * B.PROD_PRICE),
               COUNT(A.CART_PROD) INTO V_AMT, V_CNT
        FROM CART A, PROD B
        WHERE A.CART_PROD = B.PROD_ID
            AND A.CART_MEMBER = REC_CART.MEM_ID --CURSOR는 6명의 MEM_ID, MEM_NAME을 전부 가지고 있음
            AND SUBSTR(A.CART_NO,1,6) = '200505';
            
        DBMS_OUTPUT.PUT_LINE(REC_CART.MEM_ID||', '||REC_CART.MEM_NAME||' =>' ||V_AMT||'('||V_CNT|| ')');
    END LOOP;
END;

(FOR 문에서 INLINE 커서 사용)

DECLARE
V_CNT NUMBER := 0; --구매횟수
V_AMT NUMBER := 0; --구매금액 합계

BEGIN
    FOR REC_CART IN (SELECT MEM_ID, MEM_NAME --INLINE으로 커서 만듦
                     FROM MEMBER
                     WHERE MEM_MILEAGE >= 3000) 
    LOOP
        SELECT SUM(A.CART_QTY * B.PROD_PRICE),
               COUNT(A.CART_PROD) INTO V_AMT, V_CNT
        FROM CART A, PROD B
        WHERE A.CART_PROD = B.PROD_ID
            AND A.CART_MEMBER = REC_CART.MEM_ID --CURSOR는 6명의 MEM_ID, MEM_NAME을 전부 가지고 있음
            AND SUBSTR(A.CART_NO,1,6) = '200505';
            
        DBMS_OUTPUT.PUT_LINE(REC_CART.MEM_ID||', '||REC_CART.MEM_NAME||' =>' ||V_AMT||'('||V_CNT|| ')');
    END LOOP;
END;

---------------------------------------------------------------------------------------------------------------------

저장 프로시저(Stored Procedure : Procedure) 
-특정 결과를 산출하기 위한 코드의 집합(모듈)
-반환값이 없음 따라서 독립적으로 실행되는 곳에 사용함 (<==> FUNCTION : 값 반환, SELECT문의 WHERE절에서 호출 가능)
-컴파일되어 서버에 보관(실행 속도를 증가, 은닉성, 보안성)

(사용형식)
CREATE [OR REPLACE] PROCEDURE 프로시저명[(
    매개변수명 [IN | OUT | INOUT] 데이터타입 [[:= | DEFAULT] expr],
    매개변수명 [IN | OUT | INOUT] 데이터타입 [[:= | DEFAULT] expr],
                            .
                            .
    매개변수명 [IN | OUT | INOUT] 데이터타입 [[:= | DEFAULT] expr])]
AS | IS
    선언영역;
BEGIN
    실행영역;
END;

----------------------------------------------------------------------------------------------------

**다음 조건에 맞는 재고수불 테이블을 생성하시오
1. 테이블 명 : REMAIN;
2. 컬럼
---------------------------------------------------------------------------------------------------
컬럼명                     데이터 타입                          제약사항
REMAIN_YEAR                CHAR(4)                             PK
PROD_ID                    VARCHAR2(10)                        PK & FK
REMAIN_J_OO                NUMBER(5)                           DEFAULT 0 --기초재고
REMAIN_I                   NUMBER(5)                           DEFAULT 0 --입고수량
REMAIN_O                   NUMBER(5)                           DEFAULT 0 --출고수량
REMAIN_J_99                NUMBER(5)                           DEFAULT 0 --기말재고
REMAIN_DATE                DATE                                DEFAULT SYSDATE --처리일자

**테이블 생성명령
CREATE TABLE 테이블명(
컬럼명1 데이터타입[(크기)] [NOT NULL] [DEFAULT 값 | 수식] [,]
컬럼명2 데이터타입[(크기)] [NOT NULL] [DEFAULT 값 | 수식] [,]
                        .
                        .
컬럼명n 데이터타입[(크기)] [NOT NULL] [DEFAULT 값 | 수식] [,]

CONSTRAINT 기본키설정명 PRIMARY KEY (컬럼명1 [, 컬럼명2, ... ]) [,]
CONSTRAINT 외래키설정명1 FOREIGN KEY (컬럼명1 [, 컬럼명2, ... ])
    REFERENCES 테이블명1 (컬럼명1 [, 컬럼명2, ... ])[,]
                        .
                        .
CONSTRAINT 외래키설정명n FOREIGN KEY (컬럼명1 [, 컬럼명2, ... ])
    REFERENCES 테이블명n (컬럼명1 [, 컬럼명2, ... ])[,]  

**테이블 생성하기
CREATE TABLE REMAIN(
    REMAIN_YEAR  CHAR(4),
    PROD_ID      VARCHAR2(10),
    REMAIN_J_OO  NUMBER(5) DEFAULT 0,
    REMAIN_I     NUMBER(5) DEFAULT 0,
    REMAIN_O     NUMBER(5) DEFAULT 0,
    REMAIN_J_99  NUMBER(5) DEFAULT 0, 
    REMAIN_DATE  DATE,
    
    CONSTRAINT pk_remain PRIMARY KEY(REMAIN_YEAR, PROD_ID),
    CONSTRAINT fk_remain_prod FOREIGN KEY(PROD_ID)
        REFERENCES PROD(PROD_ID));

--테이블 이름 잘못써서 변경함
ALTER TABLE REMAIN
    RENAME COLUMN REMAIN_J_OO TO REMAIN_J_00;


PROD테이블
LGU 분류 코드
BUYER 납품업자 코드
TOTALSTOCK 전체 재고량
PROPERSTOCK 적정 재고량 
적정 재고량 - 전체 재고량 = 자동 발주량
        
**REMAIN 테이블에 기초자료 삽입
년도 : 2005
상품코드 : 상품테이블의 상품코드
기초재고 : 상품테이블의 적정재고(PROD_PROPERSTOCK)
--기말재고= 기초재고 - 출고수량 + 입고수량
입고수량/출고수량 : 없음
처리일자 : 2004/12/31
INSERT 문 쓸 때 서브쿼리 사용하면 VALUES 안쓰고, 괄호도 안씀

INSERT INTO remain(remain_year, prod_id, remain_j_00, remain_j_99, remain_date)
    SELECT '2005', prod_id, prod_properstock, prod_properstock,TO_DATE('20041231')
        FROM prod;
        
SELECT * FROM remain;    


바꾸고 나서 INSERT문 실행시키기

--1. 테이블 컬럼명 변경
ALTER TABLE 테이블명
    RENAME COLUMN 변경시킬 컬럼명 TO 변경컬럼명;

ex) TEMP 테이블의 ABC를 QAZ라는 컬럼명으로 변경
ALTER TABLE TEMP
    RENAME COLUMN ABC TO QAZ;
     
--2. 컬럼 데이터타입(크기) 변경
ALTER TABLE 테이블명
    MODIFY 컬럼명 데이터타입(크기);
ex) TEMP 테이블의 ABC컬럼을 NUMBER(10)으로 변경하는 경우
ALTER TABLE TEMP
    MODIFY ABC NUMBER(10);
    --해당 컬럼의 내용을 모두 지워야 가능
    
    








