sub6
cycle 테이블을 이용하여 cid =1 인 고객이 애음하는 제품중 cid = 2인 고객도 애음하는 제품의 애음정보를 조회하는 쿼리를 작성하세요

SELECT *
FROM cycle
WHERE cid = 1 
    AND pid IN(100, 200); 
↓   
SELECT *
FROM cycle
WHERE cid = 1 
    AND pid IN(SELECT pid
            FROM cycle
            WHERE cid = 2);

sub7
customer, cycle, product 테이블을 이용하여 cid = 1인 고객이 애음하는 제품중 cid =2인 고객도 애음하는 제품의
애음정보를 조회하고 고객명과 제품명까지 포함하는 쿼리를 작성하세요

SELECT customer.cnm, product.pid, product.pnm, cycle.day, cycle.cnt
FROM customer, cycle, product
WHERE cycle.cid = 1
    AND cycle.cid = customer.cid
    AND cycle.pid = product.pid
    AND cycle.pid IN (SELECT pid
                FROM cycle
                WHERE cid = 2);

연산자 : 몇항인지 생각하기
++, -- //1항
1 + 5 //2항
//3항

EXISTS 서브쿼리 연산자 : 단항
IN : WHERE컬럼 | EXPRESSION IN (값1, 값2, 값3....)
EXISTS : WHERE EXISTS (서브쿼리)
        ==> 서브쿼리의 실행결과로 조회되는 행이 있으면 TRUE, 없으면 FALSE
        EXISTS 연산자와 사용되는 서브쿼리는 상호연관, 비상호연관 둘다 사용 가능하지만
        행을 제한하기 위해서 상호연관 서브쿼리와 사용되는 경우가 일반적이다
        
        서브쿼리에서 EXISTS 연산자를 만족하는 행을 하나라도 발견을 하면 더이상 진행하지 않고 효율적으로 일을 끊어 버린다
        서브쿼리가 1000건이라 하더라도 10번째 행에서 EXISTS 연산을 만족하는 행을 발견하면 9999만 건 정도의 데이터는 확인 안한다
[NOT] EXISTS

--매니저가 존재하는 직원
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

sub8
SELECT *
FROM emp e
WHERE EXISTS (SELECT 'X'  --값은 중요하지 않고 행이 있는지 없는지만 확인
              FROM emp m
              WHERE e.mgr = m.empno);
        
SELECT COUNT(*) cnt
FROM emp
WHERE deptno = 10;

if(cnt > 0){}

SELECT *
FROM dual
WHERE EXISTS (SELECT 'X' FROM emp WHERE deptno = 10);


sub9
cycle, product테이블을 이용하여 cid =1 인 고객이 애음하는 제품을 조회하는 쿼리를 EXISTS 연산자를 이용하여 작성하세요
SELECT *
FROM product
WHERE EXISTS (SELECT 'X'
              FROM cycle
              WHERE cid = 1
              AND product.pid = cycle.pid);

SELECT *
FROM product
WHERE NOT EXISTS (SELECT 'X'
              FROM cycle
              WHERE cid = 1
              AND product.pid = cycle.pid);           


집합연산              
UNION : 합집합 : 중복 제거
/UNION ALL 합집합 : 중복제거하지 않음 -> UNION 연산자에 비해 속도가 빠름
INTERSECT 교집합 : 두 집합의 공통된 부분
MINUS 차집합 : 한 집합에만 속하는 데이터

UNION : {a, b} U {a, c} ==> {a, a, b, c} ==> {a, b, c}
수학에서 이야기하는 일반적인 합집합

UNION ALL : {a, b} U {a, c}  ==> {a, a, b, c}
중복을 허용하는 합집합

집합 연산 : 행(row)을 확장 -> 위아래
            .위 아래 집합의 col 개수와 타입이 일치해야 한다
join : 열(col)을 확장 -> 양 옆

UNION : 합집합, 두개의 SELECT 결과를 하나로 합친다, 단 중복되는 데이터는 중복을 제거한다
        ==> 수학적 집합 개념과 동일

SELECT empno, ename, NULL --가짜 컬럼 하나를 만들어줘서 아래와 컬럼 갯수 동일하게 만듬
FROM emp
WHERE empno IN(7369,7499)
UNION   
SELECT empno, ename, deptno  --위, 아래 컬럼의 갯수가 동일 해야 함
FROM emp
WHERE empno IN(7369,7521);

UNION ALL : 중복을 허용하는 합집합, 중복 제거 로직이 없기 때문에 속도가 빠르다
            합집합 하려는 집합간 중복이 없다는 것을 알고 있을 경우 UNION 연산자보다 UNION ALL 연산자가 유리하다
            
SELECT empno, ename
FROM emp
WHERE empno IN(7369,7499)
UNION ALL
SELECT empno, ename
FROM emp
WHERE empno IN(7369,7521);

INTERSECT : 두개의 집합중 중복되는 부분만 조회

SELECT empno, ename
FROM emp
WHERE empno IN(7369,7499)
INTERSECT
SELECT empno, ename
FROM emp
WHERE empno IN(7369,7521);      

MINUS : 한쪽 집합에서 다른 한쪽 집합을 제외한 나머지 요소들을 반환

--위쪽 - 아래쪽
SELECT empno, ename
FROM emp
WHERE empno IN(7369,7499)
MINUS
SELECT empno, ename
FROM emp
WHERE empno IN(7369,7521); 

--위쪽 -아래쪽 (바꿔줬을 때)
SELECT empno, ename
FROM emp
WHERE empno IN(7369,7521)
MINUS
SELECT empno, ename
FROM emp
WHERE empno IN(7369,7499);

교환 법칙
A U B == B U A (UNION, UNION ALL)
A ^ B == B ^ A (INTERSECT)
A - B != B - A (MINUS) : 집합의순서에 따라 결과가 달라질 수 있다 [주의]

집합연산 특징
1. 집합연산의 결과로 조회되는 데이터의 컬럼 이름은 첫번째 집합의 컬럼을 따른다

SELECT empno e, ename enm
FROM emp
WHERE empno IN(7369,7521)
UNION
SELECT empno, ename
FROM emp
WHERE empno IN(7369,7499);

2. 집합연산의 결과를 정렬하고 싶으면 가장 마지막 집합 뒤에 ORDER BY를 기술한다
    .개별 집합에 ORDER BY를 사용한 경우 에러
    단 ORDER BY를 적용한 인라인 뷰를 사용하는 것은 가능
    
SELECT empno e, ename enm
FROM emp
WHERE empno IN(7369,7521)
UNION
SELECT empno, ename
FROM emp
WHERE empno IN(7369,7499)
ORDER BY e;  --마지막에만 ORDER BY 기술

--인라인 뷰로 ORDER BY 사용
SELECT e, enm
FROM(SELECT empno e, ename enm
FROM emp
WHERE empno IN(7369,7521)
ORDER BY e)
UNION
SELECT empno, ename
FROM emp
WHERE empno IN(7369,7499)
ORDER BY e;

3.중복된 것은 제거된다 (예외 UNION ALL)

[4. 9i 이전 버전 그룹연산을 하게되면 기본적으로 오름차순으로 정렬되어 나온다
       이후 버전 ==> 정렬을 보장하지 않음]
       
8i - Internet
------------------
9i - Internet
10g - Grid
11g - Grid
12c - Cloud
        
              
DML
    .SELECT
    .데이터 신규 입력 : INSERT
    .기존 데이터 수정 : UPDATE
    .기존 데이터  삭제 : DELETE
    
INSERT 문법
INSERT INTO 테이블명 [({column, })] VALUES ({value, })  --컬럼명 나열안함
INSERT INTO 테이블명 (컬럼명1, 컬럼명2, 컬럼명3...)  --컬럼명 나열함
            VALUES (값1, 값2, 값3...)
            
만약 테이블에 존재하는 모든 컬럼에 데이터를 입력하는 경우 컬럼명은 생략 가능하고
값을 기술하는 순서를 테이블에 정의된 컬럼 순서와 일치시킨다

INSERT INTO 테이블명 VALUES (값1, 값2, 값3);

INSERT INTO dept VALUES (99, 'ddit', 'daejeon');

INSERT INTO dept(deptno, dname, loc)
            VALUES (99, 'ddit', 'daejeon');

DESC dept;

SELECT *
FROM dept;

DESC emp; --조회해보면 empno컬럼에는 NOT NULL이어서 값을 무조건 넣어줘야함

INSERT INTO emp (empno, ename, job) 
            VALUES (9999, 'brown', 'RANGER');
            
SELECT *
FROM emp;

INSERT INTO emp (empno, ename, job, hiredate, sal, comm) 
            VALUES (9998, 'sally', 'RANGER', TO_DATE('2021-03-24','YYYY-MM-DD'), 1000, NULL);

여러건을 한번에 입력하기
INSERT INTO 테이블명
SELECT 쿼리

INSERT INTO dept
SELECT 90, 'DDIT', '대전' FROM dual UNION ALL
SELECT 80, 'DDIT8', '대전' FROM dual;


-----------------------------------------------
ROLLBACK;  --COMMIT 하기 전으로 되돌림

SELECT *
FROM dept;

SELECT *
FROM emp; 
-----------------------------------------------

UPDATE : 테이블에 존재하는 기존 데이터의 값을 변경

UPDATE 테이블명 SET 컬럼명1 = 값1, 컬럼명2 = 값2, 컬럼명3 = 값3...
WHERE ;

SELECT *
FROM dept;


.WHERE절이 누락되었는지 확인
.WHERE절이 누락된 경우 테이블의 모든 행에 대해 업데이트를 진행

부서 번호 99번 부서정보를 부서명= 대덕IT로, loc = 영민빌딩으로 변경
UPDATE dept SET dname = '대덕IT' , loc = '영민빌딩'
WHERE deptno =99;


