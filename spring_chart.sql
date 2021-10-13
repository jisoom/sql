-------------------------------------------------------------
/*
집계 함수(SUM, AVG, MAX, MIN, COUNT)
*/

--상품코드, 상품명, 상품 판매가, 판매 수량, 금액(판매가 * 수량)
--집계 함수 검증법 : 집계함수 이외의 컬럼들은 GROUP BY 절에 기술함
--집계 결과에 조건을 달아야 하는 경우 HAVING을 사용함
SELECT A.PROD_ID,
       A.PROD_NAME,
       SUM(A.PROD_SALE * B.CART_QTY) MONEY
FROM PROD A, CART B
WHERE 1=1
AND A.PROD_ID = B.CART_PROD  --조인 조건
GROUP BY A.PROD_ID, A.PROD_NAME
HAVING SUM(A.PROD_SALE * B.CART_QTY) >= 10000000 --금액 합계가 천만원이 넘는 정보만
;