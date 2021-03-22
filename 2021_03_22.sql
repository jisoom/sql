--데이터 결합 (base_tables.sql, 실습 join1)
erd 다이어그램을 참고하여 prod 테이블과 lprod 테이블을 조인하여 다음과 같은 결과가 나오는 쿼리를 작성해보세요

SELECT lprod.lprod_gu, lprod.lprod_nm,
        prod.prod_id, prod.prod_name
FROM lprod, prod
WHERE lprod.lprod_gu = prod.prod_lgu;

SELECT *
FROM prod;

join2
erd 다이어그램을 참고하여 buyer, prod 테이블을 조인하여 buyer별 담당하는 제품정보를 다음과 같은 결과가 나오도록
쿼리를 작성해보세요

SELECT buyer.buyer_id, buyer.buyer_name, prod.prod_id, prod.prod_name
FROM buyer, prod
WHERE buyer.buyer_id = prod.prod_buyer;

join3
erd 다이어그램을 참고하여 member, cart, prod 테이블을 조인하여 회원별 장바구니에 담은
제품정보를 다음과 같은 결과가 나오는 쿼리를 작성해보세요

SELECT member.mem_id, member.mem_name, prod.prod_id, prod.prod_name, cart.cart_qty
FROM member, prod, cart
WHERE prod.prod_id = cart.cart_prod
    AND member.mem_id = cart.cart_member ;

SELECT member.mem_id, member.mem_name, prod.prod_id, prod.prod_name, cart.cart_qty
FROM member JOIN cart ON(member.mem_id = cart.cart_member) 
    JOIN prod ON (prod.prod_id = cart.cart_prod);
    
SELECT *
FROM customer;

SELECT *
FROM product;

SELECT *
FROM cycle;

join4
 erd 다이어그램을 참고하여 customer, cycle 테이블을 조인하여
고객별 애음 제품, 애음요일, 개수를 다음과 같은 결과가 나오도록 쿼리를
작성해보세요(고객명이 brown, sally인 고객만 조회)
(*정렬과 관계없이 값이 맞으면 정답)

SELECT customer.cid, customer.cnm, cycle.pid, cycle.day, cycle.cnt
FROM customer, cycle
WHERE customer.cid = cycle.cid
    AND customer.cnm IN('brown', 'sally');
    
join5
erd 다이어그램을 참고하여 customer, cycle, product 테이블을 조인하여
고객별 애음 제품, 애음요일, 개수, 제품명을 다음과 같은 결과가 나오도록
쿼리를 작성해보세요(고객명이 brown, sally인 고객만 조회)
(*정렬과 관계없이 값이 맞으면 정답)

SELECT customer.cid, customer.cnm, cycle.pid, product.pnm, cycle.day, cycle.cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid
    AND cycle.pid = product.pid
    AND customer.cnm IN('brown', 'sally');

join6
erd 다이어그램을 참고하여 customer, cycle, product 테이블을 조인하여
애음요일과 관계없이 고객별 애음 제품별, 개수의 합과, 제품명을 다음과 같은
결과가 나오도록 쿼리를 작성해보세요
(*정렬과 관계없이 값이 맞으면 정답)

SELECT customer.cid, customer.cnm, product.pid, product.pnm, SUM(cycle.cnt) cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid
    AND cycle.pid = product.pid
GROUP BY  customer.cid, customer.cnm, product.pid, product.pnm;

join7
erd 다이어그램을 참고하여 cycle, product 테이블을 이용하여
제품별, 개수의 합과, 제품명을 다음과 같은 결과가 나오도록 쿼리를
작성해보세요
(*정렬과 관계없이 값이 맞으면 정답)

SELECT product.pid, product.pnm, SUM(cycle.cnt) cnt
FROM cycle, product
WHERE cycle.pid = product.pid
GROUP BY product.pid, product.pnm;

OUTER JOIN : 컬럼 연결이 실패해도 [기준]이 되는 테이블 쪽의 컬럼정보는 나오도록 하는 조인
LEFT OUTER JOIN : 기준이 왼쪽에 기술한 테이블이 되는 OUTER JOIN
RIGHT OUTER JOIN : 기준이 오른쪽에 기술한 테이블이 되는 OUTER JOIN
FULL OUTER JOIN :LEFT OUTER + RIGHT OUTER - 중복 데이터 제거
    테이블 1 JOIN 테이블 2
    테이블 1 LEFT OUTER JOIN 테이블 2
    ==
    테이블 2 RIGHT OUTER JOIN 테이블 1
    
직원의 이름, 직원의 상사 이름 두개의 컬럼이 나오도록 join query 작성
SELECT e.ename, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno;

SELECT e.ename, m.ename
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno);

--ORACLE SQL OUTER JOIN 표기 : (+)
--OUTER 조인으로 인해 데이터가 안나오는 쪽 컬럼에 (+)를 붙여준다
SELECT e.ename, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno(+);

---------------------------------------------------------------------
--ON절과 WHERE절의 결과 비교

--조건 ON절 기술
SELECT e.ename, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno AND m.deptno = 10);

--ON절 기술과 결과 동일
SELECT e.ename, m.ename, m.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+)
    AND  m.deptno(+) = 10;

--조건 WHERE절 기술
SELECT e.ename, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno)
WHERE m.deptno = 10;

--WHERE절 기술과 결과 동일
SELECT e.ename, m.ename, m.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+)
    AND  m.deptno = 10;

--LEFT 와 RIGHT 동일하게 만들기 
SELECT e.ename, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno);

SELECT e.ename, m.ename, m.deptno
FROM emp m RIGHT OUTER JOIN emp e ON(e.mgr = m.empno);

--데이터는 몇건이 나올까 ? 그려볼 것
SELECT e.ename, m.ename, m.deptno
FROM emp e RIGHT OUTER JOIN emp m ON(e.mgr = m.empno);

--FULL OUTER JOIN :LEFT OUTER(14) + RIGHT OUTER(21) - 중복 데이터 1개만 남기고 제거(13)=>(22)
--FULL OUTER
SELECT e.ename, m.ename
FROM emp e FULL OUTER JOIN emp m ON (e.mgr = m.empno);

SELECT e.ename, m.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno);

FULL OUTER 조인은 오라클 SQL 문법으로 제공하지 않는다
--오류 뜸 (+) => 오라클에서는 한쪽에만 사용할 수 있음
SELECT e.ename, m.ename
FROM emp e, emp m
WHERE e.mgr(+) = m.empno(+)

데이터 결합 (outer join 실습 outerjoin1)
buyprod 테이블에 구매일자가 2005년 1월 25일인 데이터는 3품목 밖에 없다.
모든 품목이 나올 수 있도록 쿼리를 작성해보세요
==
모든 제품을 다 보여주고, 실제 구매가 있을 때는 구매 수량을 조회, 없을 경우는 null로 표현
제품코드 : 수량

SELECT buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM buyprod RIGHT OUTER JOIN prod ON(buyprod.buy_prod = prod.prod_id 
    AND buy_date = TO_DATE('2005/01/25', 'YYYY/MM/DD'));
    
SELECT buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM buyprod ,prod
WHERE buyprod.buy_prod (+) = prod.prod_id 
    AND buy_date(+) = TO_DATE('2005/01/25', 'YYYY/MM/DD');

