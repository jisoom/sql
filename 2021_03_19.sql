Function (group function 실습 grp3)
emp 테이블을 이용하여 다음을 구하시오
grp2에서 작성한 쿼리를 활용하여 deptno 대신 부서명이 나올 수 있도록 수정하시오
SELECT CASE
        WHEN deptno = 10 THEN 'ACCOUNTING'
        WHEN deptno = 20 THEN 'RESEARCH'
        WHEN deptno = 30 THEN 'SALES'
        WHEN deptno = 40 THEN 'OPERATIONS'
        ELSE 'DDIT'
        END dname_case, 
        MAX(sal), MIN(sal),  ROUND(AVG(sal),2), SUM(sal), COUNT(sal),  COUNT(mgr), COUNT(*)
FROM emp
GROUP BY deptno;

grp4
emp테이블을 이용하여 다음을 구하시오
직원의 입사년월별로 몇명의 직원이 입사했는지 조회하는 쿼리를 작성하세요
SELECT TO_CHAR(hiredate,'YYYYMM')hire_yyyymm, COUNT(*) cnt
FROM emp
GROUP BY TO_CHAR(hiredate,'YYYYMM')
ORDER BY TO_CHAR(hiredate,'YYYYMM');

grp5
emp테이블을 이용하여 다음을 구하시오
직원의 입사년별로 몇명의 직원이 입사했는지 조회하는 쿼리를 작성하세요
SELECT TO_CHAR(hiredate,'YYYY')hire_yyyymm, COUNT(*) cnt
FROM emp
GROUP BY TO_CHAR(hiredate,'YYYY')
ORDER BY TO_CHAR(hiredate,'YYYY');

grp6
회사에 존재하는 부서의 개수는 몇개인지 조회하는 쿼리를 작성하시오 (dept 테이블 사용)
SELECT COUNT(*)
FROM dept;


grp7
직원이 속한 부서의 개수를 조회하는 쿼리를 작성하시오 (emp 테이블 사용)
SELECT COUNT(*)
FROM(SELECT deptno, COUNT(*) cnt
FROM emp
GROUP BY deptno);

---------------------------------------------------------------------------------------------------------------
데이터 결합(확장)
1. 컬럼에 대한 확장 : JOIN
2. 행에 대한 확장 : 집합연산자(UNION ALL, UNION, MINUS, INTERSECT) --UNION(합집합), MINUS(차집합), INTERSECT(교집합)
JOIN
-RDBMS는 중복을 최소화하는 형태의 데이터 베이스
-다른 테이블과 결합하여 데이터를 조회
-중복을 최소화하는 RDBMS 방식으로 설계한 경우
-emp 테이블에는 부서코드만 존재, 부서정보를 담은 dept테이블 별도로 생성
-emp 테이블과 dept 테이블의 연결고리(deptno)로 조인하여 실제 부서명을 조회한다

1. 표준 SQL => ANSI SQL
2. 비표준 SQL - DBMS를 만드는 회사에서 만든 고유의 SQL 문법

ANSI : SQL
ORACLE : SQL


ANSI - NATURAL JOIN
. 조인하고자 하는 테이블의 연결 컬럼 명과 타입이 동일한 경우 (emp.deptno, detp.deptno)
. 연결 컬럼의 값이 동일 할 때 (=) 컬럼이 확장된다

SELECT emp.ename , emp.ename,deptno --deptno는 연결 컬럼이기 때문에 한정자가 붙으면 조회가 안됨
FROM emp NATURAL JOIN dept;

-------------------------------------------------------------------------------------------------------

ORACLE join : 하나뿐
1. FROM절에 조인할 테이블을 (,)콤마로 구분하여 나열
2. WHERE : 조인할 테이블의 연결 조건을 기술

SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno; --어떤 테이블의 컬럼인지 한정자를 붙여서 나타내줌

7369 SMITH, 7902 FORD

SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno;

--------------------------------------------------------------------------------------------------------

ANSI SQL : JOIN WITH USING
조인하려고 하는 테이블의 컬럼명과 타입이 같은 컬럼이 두개 이상인 상황에서
두 컬럼을 모두 조인 조건으로 참여시키지 않고, 개발자가 원하는 특정 컬럼으로만 연결을 시키고 싶을 때 사용

SELECT * --한정자 써주면 조회 안됨
FROM emp JOIN dept USING(deptno);

SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;  --오라클 방식으로 바꿔줬을 때

---------------------------------------------------------------------------------------------------------

JOIN WITH ON : NATURAL JOIN, JOIN WITH USING을 대체할 수 있는 보편적인 문법
조인 컬럼 조건을 개발자가 임의로 지정

SELECT *
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

사원번호, 사원이름, 해당 사원의 상사 사번, 해당사원의 상사이름 : JOIN WITH ON을 이용하여 쿼리 작성
단 사원의 번호가 7369에서 7698인 사원들만 조회

SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e JOIN emp m ON(e.mgr = m.empno)
WHERE e.empno BETWEEN 7369 AND 7698;


SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m
WHERE e.empno BETWEEN 7369 AND 7698
    AND e.mgr = m.empno;

논리적인 조인 형태
1. SELF JOIN : 조인 테이블이 같은 경우
    -계층구조
2. NONEQUI-JOIN : 조인 조건이 =(equals)가 아닌 조인

(******************시험********************)
SELECT *
FROM emp, dept
WHERE emp.deptno != dept.deptno;
--emp deptno가 10일 때 dept.deptno 20, 30, 40 일때 같지 않으니까 3번 조인됨

SELECT *
FROM salgrade;

SELECT *
FROM emp;

--salgrade를 이용하여 직원의 급여 등급 구하기
--empno, ename, sal, 급여등급
SELECT e.empno, e.ename, e.sal, s.grade
FROM emp e, salgrade s
WHERE e.sal BETWEEN s.losal AND s.hisal;

SELECT e.empno, e.ename, e.sal, s.grade
FROM emp e JOIN salgrade s ON(e.sal BETWEEN s.losal AND s.hisal);

데이터 결합 (실습 join0)
emp, dept 테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성하세요

SELECT empno, ename, emp.deptno, dname
FROM emp, dept
WHERE emp. deptno = dept.deptno
ORDER BY deptno;

join0_1
emp, dept 테이블을 이용하여 다음과 같이 조회하도록 쿼리를 작성하세요 (부서번호가 10, 30인 데이터만 조회)

SELECT empno, ename, emp.deptno, dname
FROM emp, dept
WHERE emp. deptno = dept.deptno
    AND emp.deptno IN(10,30);
    
join0_2
emp, dept 테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성하세요 (급여가 2500 초과)

SELECT empno, ename, emp.deptno, dname
FROM emp, dept
WHERE emp. deptno = dept.deptno
    AND sal > 2500;

join0_3
emp, dept 테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성하세요
(급여 2500초과, 사번이 7600보다 큰 직원)

SELECT empno, ename, emp.deptno, dname
FROM emp, dept
WHERE emp. deptno = dept.deptno
    AND sal > 2500
    AND empno > 7600;
    
join0_4
emp, dept 테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성하세요
(급여 2500초과, 사번이 7600보다 크고, RESEARCH 부서에 속하는 직원)

SELECT empno, ename, emp.deptno, dname
FROM emp, dept
WHERE emp. deptno = dept.deptno
    AND sal > 2500
    AND empno > 7600
    AND dname = 'RESEARCH'; --emp.deptno = 20
    
-------------------------------------------------------------------------------------------------------------
가상화가 도입된 이유
물리적 컴퓨터는 동시에 하나의 OS만 실행 가능
성능이 좋은 컴퓨터(서버)라도 하드웨어 자원의 활용이 낮음 : 15~20%





































