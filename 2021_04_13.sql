패키지(Package)
-논리적 연관성 있는 PL/SQL타입, 변수, 상수, 함수,프로시저 등의 항목들을 묶어 놓은 것
-모듈화, 캡슐화 기능 제공
-관련성있는 서브프로그램의 집합으로 disk I/O 가 줄어 효율적


1. PACKAGE 구조

-선언부와 본문부로 구성

1) 선언부
.패키지에 포함될 변수, 프로시저, 함수 등을 선언

(사용형식)
CREATE [OR REPLACE] PACKAGE 패키지명
IS|AS
    TYPE 구문; --사용자 변수 
    상수[변수] 선언문;
    커서;
    함수|프로시저 프로토타입; --여러개 나올 수 있음
            .
            .
END 패키지명;            
--BIGIN은 없음 (구현 되는 부분)

2) 본문부
.선언부에서 정의한 서브프로그램의 구현 담당
(사용형식)
CREATE [OR REPLACE] PACKAGE BODY 패키지명
IS|AS
    상수, 커서, 변수 선언;
        FUNCTION 함수명(매개변수 list)
            RETURN 타입명
            BIGIN 
                PL/SQL 명령(들);
                RETURN expr;
            END 함수명;
                .
                .
END 패키지명;

사용예)상품테이블에 신규 상품을 등록하는 업무를 패키지로 구성하시오
분류코드확인 -> 상품코드생성 -> 상품테이블에 등록 -> 재고수불테이블 등록

(패키지 선언부 생성)
CREATE OR REPLACE PACKAGE PROD_NEWITEM_PKG
IS
  V_PROD_LGU LPROD.LPROD_GU%TYPE;
  
  --분류코드 생성
  FUNCTION FN_INSERT_LPROD(
    P_GU IN LPROD.LPROD_GU%TYPE,
    P_NM IN LPROD.LPROD_NM%TYPE)
    RETURN LPROD.LPROD_GU%TYPE;
    
  --상품코드 생성 및 상품 등록  
  PROCEDURE  PROC_CREATE_PROD_ID(
    P_GU IN LPROD.LPROD_GU%TYPE,
    P_NAME IN PROD.PROD_NAME%TYPE,
    P_BUYER IN PROD.PROD_BUYER%TYPE,
    P_COST IN NUMBER,
    P_PRICE IN NUMBER,
    P_SALE IN NUMBER,
    P_OUTLINE IN PROD.PROD_OUTLINE%TYPE,
    P_IMG IN PROD.PROD_IMG%TYPE,
    P_TOTALSTOCK IN PROD.PROD_TOTALSTOCK%TYPE,
    P_PROPERSTOCK IN PROD.PROD_PROPERSTOCK%TYPE,
    P_ID OUT PROD.PROD_ID%TYPE);
    
  --재고수불테이블 삽입 
  PROCEDURE PROC_INSERT_REMAIN(
    P_ID IN PROD.PROD_ID%TYPE,
    P_AMT NUMBER);

END PROD_NEWITEM_PKG;
  
(패키지 본문 생성)
CREATE OR REPLACE PACKAGE BODY PROD_NEWITEM_PKG
IS
  FUNCTION FN_INSERT_LPROD(
    P_GU IN LPROD.LPROD_GU%TYPE,  --P_GU, P_NM이런식으로 2개 있으면 실행부에서도 2개가 있어야함
    P_NM IN LPROD.LPROD_NM%TYPE)
    RETURN LPROD.LPROD_GU%TYPE
  IS 
    V_ID  NUMBER:=0;
  BEGIN
    SELECT MAX(LPROD_ID)+1 INTO V_ID
      FROM LPROD;
    INSERT INTO LPROD
      VALUES(V_ID,P_GU,P_NM);
    RETURN P_GU;  
  END;    
  
  --상품코드 생성 및 상품 등록  
  PROCEDURE PROC_CREATE_PROD_ID(
    P_GU IN LPROD.LPROD_GU%TYPE,
    P_NAME IN PROD.PROD_NAME%TYPE,
    P_BUYER IN PROD.PROD_BUYER%TYPE,
    P_COST IN NUMBER,
    P_PRICE IN NUMBER,
    P_SALE IN NUMBER,
    P_OUTLINE IN PROD.PROD_OUTLINE%TYPE,
    P_IMG IN PROD.PROD_IMG%TYPE,
    P_TOTALSTOCK IN PROD.PROD_TOTALSTOCK%TYPE,
    P_PROPERSTOCK IN PROD.PROD_PROPERSTOCK%TYPE,
    P_ID OUT PROD.PROD_ID%TYPE)
  IS
    V_PID PROD.PROD_ID%TYPE;
    V_CNT NUMBER:=0;
  BEGIN
    SELECT COUNT(*) INTO V_CNT
      FROM PROD
     WHERE PROD_ID LIKE  P_GU||'%';
    
    IF V_CNT=0 THEN
      V_PID:=P_GU||'000001';
    ELSE
      SELECT 'P'||TO_CHAR(SUBSTR(A.MNUM,2)+1) INTO V_PID
        FROM (SELECT MAX(PROD_ID) AS MNUM
                FROM PROD
               WHERE PROD_LGU=P_GU) A;
    END IF;           
    P_ID:=V_PID;         
    INSERT INTO PROD(PROD_ID,PROD_NAME,PROD_LGU,PROD_BUYER,PROD_COST,
                     PROD_PRICE,PROD_SALE,PROD_OUTLINE,PROD_IMG,
                     PROD_TOTALSTOCK,PROD_PROPERSTOCK)
      VALUES(V_PID,P_NAME,P_GU,P_BUYER,P_COST,P_PRICE,P_SALE,
             P_OUTLINE,P_IMG,P_TOTALSTOCK,P_PROPERSTOCK); 
  END;
  
  --재고수불테이블 삽입 
  PROCEDURE PROC_INSERT_REMAIN(
    P_ID IN PROD.PROD_ID%TYPE,
    P_AMT NUMBER)
  IS
  BEGIN
    INSERT INTO REMAIN(REMAIN_YEAR,PROD_ID,REMAIN_J_00,REMAIN_I,
                       REMAIN_J_99,REMAIN_DATE)
      VALUES('2005',P_ID,P_AMT,P_AMT,P_AMT,SYSDATE);                 
  END;
END PROD_NEWITEM_PKG;  

(실행)
(신규분류코드 사용하는 경우)
DECLARE
  V_LGU LPROD.LPROD_GU%TYPE;
  V_PID PROD.PROD_ID%TYPE;
BEGIN
  V_LGU:=PROD_NEWITEM_PKG.FN_INSERT_LPROD('P701','농축산물');
  PROD_NEWITEM_PKG.PROC_CREATE_PROD_ID(V_LGU,'소시지','P20101',10000,
     13000,11000,' ',' ',0,0,V_PID); 
  PROD_NEWITEM_PKG.PROC_INSERT_REMAIN(V_PID,10); 
END;  



    
(입고상품의 분류코드가 P202인 경우 상품코드)
SELECT 'P' || TO_CHAR(SUBSTR(A.MNUM,2)+1) 
--오라클은 숫자가 우선이라 숫자로 바꾸려하기때문에 앞에 TO_CHAR해서 SUBSTR(A.MNUM,2)+1를 문자열로 바꿔준 뒤 P와 합쳐짐
  FROM(SELECT MAX(PROD_ID) AS MNUM --MAX(PROD_ID)+1 :앞에 P가 붙어있어서 자동형변환이 안됨 ==>에러
         FROM PROD
        WHERE PROD_LGU = 'P202')A;
    
    
    
    
    

    