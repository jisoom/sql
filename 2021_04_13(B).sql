조인
-다수개의 테이블로부터 필요한 자료 추출
-RDBMS에서 가장 중요한 연산
1. 내부 조인
 . 조인 조건을 만족하지 않는 행은 무시
예) 상품테이블에서 상품의 분류별 상품의 수를 조회하시오
    Alias는 분류코드, 분류명, 상품의 수
    
**상품테이블에서 사용한 분류코드의 종류
SELECT DISTINCT PROD_LGU
    FROM PROD; --7가지의 분류코드가 사용됨
--LPROD 분류코드는 11개

--외부 조인인 경우 자료가 많은 쪽꺼를 기준으로 넣어야함 // 내부조인은 상관없음


--내부조인
SELECT A.LPROD_GU AS 분류코드, 
       A.LPROD_NM AS 분류명, 
       COUNT(*) AS "상품의 수" --공백은 쌍따옴표로 묶어줌
  FROM LPROD A, PROD B
 WHERE LPROD_GU = PROD_LGU
 GROUP BY A.LPROD_GU, A.LPROD_NM
 ORDER BY 1;
 
예) 2005년 5월 매출자료와 거래처 테이블을 이용하여 거래처별 상품매출정보를 조회하시오
    Alias는 거래처코드, 거래처명, 매출액
SELECT B.PROD_BUYER AS 거래처코드,
       C.BUYER_NAME AS 거래처명,
       SUM(A.CART_QTY * B.PROD_PRICE) AS 매출액
FROM CART A, PROD B, BUYER C
WHERE A.CART_PROD = B.PROD_ID --단가 얻으려고 조인
  AND B.PROD_BUYER = C.BUYER_ID --거래처명 얻으려고 조인
  AND A.CART_NO LIKE '200505%'
GROUP BY B.PROD_BUYER, C.BUYER_NAME
ORDER BY 1;
--조건에 맞는 것만 뽑아서 출력하기 때문에 어떨때는 효율이 좋을 수 있음 ==> 조인한다해서 무조건 속도가 늦어지는건 아님

(ANSI 내부조인)
SELECT 컬럼list
  FROM 테이블명1
INNER JOIN 테이블명2 ON (조인 조건 --테이블 1은 테이블 2와 조인됨
  [AND 일반조건] )
INNER JOIN 테이블명3 ON (조인 조건 --테이블 3은 위에서 조인한 결과와 조인됨
  [AND 일반조건] )--WHERE로 해도 상관없음
        .
        .
WHERE 조건;

    Alias는 거래처코드, 거래처명, 매출액
    
    
SELECT B.PROD_BUYER AS 거래처코드,
       C.BUYER_NAME AS 거래처명,
       SUM(A.CART_QTY * B.PROD_PRICE) AS 매출액
FROM CART A
INNER JOIN PROD B ON (A.CART_PROD = B.PROD_ID
    AND A.CART_NO LIKE '200505%')
INNER JOIN BUYER C ON(B.PROD_BUYER = C.BUYER_ID)
GROUP BY B.PROD_BUYER, C.BUYER_NAME
ORDER BY 1;

문제1] 2005년 1월~3월 거래처별 매입정보(buyprod)를 조회하시오
      Alias는 거래처코드, 거래처명, 매입금액합계이고
      매입금액 합계가 500만원 이상인 거래처만 검색하시오.

--집계함수는 일반 조건을 사용할 수 없음

SELECT A.BUYER_ID AS 거래처코드, 
       A.BUYER_NAME AS 거래처명, 
       SUM(BUY_COST * BUY_QTY) AS 매입금액합계
  FROM BUYER A, BUYPROD B, PROD C
 WHERE B.BUY_PROD = C.PROD_ID
   AND C.PROD_BUYER = A.BUYER_ID
   AND B.BUY_DATE BETWEEN '20050101' AND '20050331'
 GROUP BY A.BUYER_ID, A.BUYER_NAME
HAVING SUM(BUY_COST * BUY_QTY) >= 5000000;
 
 
문제2]사원테이블(EMPLOYEES)에서 부서별 평균급여보다 급여를 많이 받는 직원들의 수를 부서별로 조회하시오
      Alias는 부서코드, 부서명, 부서평균급여, 인원수
      --부서별 평균급여를 계산해서 한사람의 급여를 그사람이 속한 부서의 평균 급여와 비교

메인쿼리 : 사원테이블에서 부서코드, 부서명, 부서평균급여, 인원수 출력
SELECT 부서코드, 부서명, 부서평균급여, 인원수
  FROM DEPARTMENTS TBLA
서브쿼리 : 부서별 평균 급여
서브쿼리2 : 평균 급여보다 급여를 많이 받고있는 사람 수
SELECT DEPARTMENT_ID,
       ROUND(AVG(SALARY),0) AS ASAL
  FROM EMPLOYEES
 GROUP BY DEPARTMENT_ID;
 

SELECT A.DEPARTMENT_ID,
       COUNT(*) AS CNT
  FROM (SELECT DEPARTMENT_ID,
               ROUND(AVG(SALARY),0) AS ASAL
          FROM EMPLOYEES
          GROUP BY DEPARTMENT_ID) A, EMPLOYEES B
 WHERE A.DEPARTMENT_ID = B.DEPARTMENT_ID
   AND B.SALARY >= A.ASAL
GROUP BY A.DEPARTMENT_ID
ORDER BY 1;

--최종 정답   
SELECT TBLA.DEPARTMENT_ID AS 부서코드, 
       TBLA.DEPARTMENT_NAME AS 부서명, 
       (SELECT ROUND(AVG(SALARY),0)
          FROM EMPLOYEES TBLC
         WHERE TBLC.DEPARTMENT_ID = TBLB.DID) AS 부서평균급여, 
       TBLB.CNT AS 인원수
  FROM DEPARTMENTS TBLA,
        (SELECT A.DEPARTMENT_ID AS DID,
                COUNT(*) AS CNT
           FROM (SELECT DEPARTMENT_ID,
                        ROUND(AVG(SALARY),0) AS ASAL
                   FROM EMPLOYEES
                  GROUP BY DEPARTMENT_ID) A, EMPLOYEES B
          WHERE A.DEPARTMENT_ID = B.DEPARTMENT_ID
            AND B.SALARY >= A.ASAL
          GROUP BY A.DEPARTMENT_ID
          ORDER BY 1) TBLB
  WHERE TBLA.DEPARTMENT_ID = TBLB.DID;




