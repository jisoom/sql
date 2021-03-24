월별 실적

                반도체     핸드폰     냉장고
2021년 1월 :      500       300      400
2021년 2월 :       0         0        0
2021년 3월 :      500       300      400
.
.
.
2021년 12월 :      500       300      400

outerjoin1
SELECT buy_date, buy_prod, prod_id, prod_name, NVL(buy_qty,0)
FROM buyprod, prod
WHERE buyprod.buy_prod (+) = prod.prod_id
    AND buy_date(+) = TO_DATE('2005/01/25', 'YYYY/MM/DD');

outerjoin2~3
outerjoin1에서 작업을 시작하세요. buy_date 컬럼이 null인 항목이 
안나오도록 다음처럼 데이터를 채워지도록 쿼리를 작성하세요

SELECT TO_DATE(:yyyymmdd, 'YYYY/MM/DD'), buy_prod, prod_id, prod_name, NVL(buy_qty,0)
FROM buyprod, prod
WHERE buyprod.buy_prod (+) = prod.prod_id
    AND buy_date(+) = TO_DATE(:yyyymmdd, 'YYYY/MM/DD');
    
outerjoin4
cycle, product 테이블을 이용하여 고객이 애음하는 제품명칭을 표현하고, 애음하지 않는 제품도
다음과 같이 조회되도록 쿼리를 작성하세요
(고객은 cid =1인 고객만 나오도록 제한, null처리)

SELECT product.*, :cid, NVL(cycle.day, 0), NVL(cycle.cnt, 0) cnt --cid = >1 이므로 변수화시킴
FROM product LEFT OUTER JOIN cycle ON (product.pid = cycle.pid AND cid =:cid);

SELECT product.*, :cid, NVL(cycle.day, 0), NVL(cycle.cnt, 0) cnt
FROM product, cycle 
WHERE product.pid = cycle.pid (+)
    AND cid(+) =:cid;


select *
from product, cycle, customer

outerjoin5
outerjoin4를 바탕으로 고객 이름 컬럼 추가하기

SELECT product.*, :cid, NVL(cycle.day, 0), NVL(cycle.cnt, 0) cnt, customer.cnm
FROM product, cycle, customer
WHERE product.pid = cycle.pid (+)
    AND cycle.cid(+) =:cid
    AND :cid = customer.cid;

WHERE, GROUP BY(그룹핑), JOIN

JOIN
문법
:ANSI / ORACLE
논리적 형태
:SELF JOIN, NON-EQUI-JOIN <==> EQUI-JOIN
연결 조건 성공 실패에 따라 조회 여부 결정
:OUTERJOIN <==> INNER JOIN : 연결이 성공적으로  이루어진 행에 대해서만 조회가 되는 조인

SELECT *
FROM dept INNER JOIN emp ON (dept.deptno = emp.deptno);

CROSS JOIN
.별도의 연결 조건이 없는 조인
.묻지마 조인
.두 테이블의 행간 연결 가능한 모든 경우의 수로 연결
==> CROSS JOIN의 결과는 두 테이블의 행의 수를 곱한 값과 같은 행이 반환된다
[.데이터 복제를 위해 사용]

↓예시)
SELECT *
FROM emp, dept;
--연결 조건이 없기 때문에 오라클로 쓰면 연결만 시키면 됨
SELECT *
FROM emp CROSS JOIN dept;

데이터 결합 (cross join 실습 crossjoin1)
customer, product 테이블을 이용하여 고객이 애음 가능한 모든 제품의 정보를
결합하여 다음과 같이 조회되도록 쿼리를 작성하세요

SELECT customer.cid, customer.cnm, product. *
FROM customer, product;

select *
from burgerstore

SELECT STORECATEGORY
FROM BURGERSTORE
WHERE SIDO = '대전'
GROUP BY STORECATEGORY;

도시발전 지수 : (KFC + 맥도날드 + 버거킹) /롯데리아
                1       3       2       3   ==>(1+3+2)/3 =2;
대전 중구 : 2
SELECT *
FROM BURGERSTORE
WHERE SIDO = '대전'
    AND SIGUNGU = '중구'
    
--행을 컬럼으로 변경 (PIVOT)
--SELECT sido, sigungu, storecategory,
--        storecategory가 BURGER KING이면 1, 아니면 0
--        storecategory가 KFC이면 1, 아니면 0
--        storecategory가 MACDONALD이면 1, 아니면 0
--        storecategory가 LOTTERIA이면 1, 아니면 0
--FROM burgerstore

--CASE문으로
SELECT sido, sigungu, storecategory,
        CASE
            WHEN storecategory = 'BURGER KING' THEN 1
            ELSE 0
        END bk
FROM burgerstore;

--DECODE문으로
SELECT sido, sigungu,
        ROUND((SUM(DECODE (storecategory ,'BURGER KING',1,0))+
        SUM(DECODE (storecategory ,'KFC',1,0))+
        SUM(DECODE (storecategory ,'MACDONALD',1,0)))/
        DECODE(SUM(DECODE (storecategory ,'LOTTERIA',1,0)),0,1,
        SUM(DECODE (storecategory ,'LOTTERIA',1,0))),2) idx
FROM burgerstore
GROUP BY sido, sigungu
ORDER BY idx DESC;


    
