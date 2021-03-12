--zisoom 계정에 있는 prod 테이블의 모든 컬럼을 조회하는 SELECT 쿼리(SQL) 작성
SELECT *
FROM prod;
--zisoom 계정에 있는 prod 테이블의 prod_id, prod_name 두개의 컬럼만 조회하는 SELECT 쿼리(SQL) 작성
SELECT prod_id, prod_name
FROM prod;

select1

--lprod 테이블에서 모든 데이터를 조회하는 쿼리를 작성하세요
SELECT *
FROM lprod;

--buyer 테이블에서 buyer_id, buyer_name 컬럼만 조회하는 쿼리를 작성하세요
SELECT buyer_id, buyer_name
FROM buyer;

--cart 테이블에서 모든 데이터를 조회하는 쿼리를 작성하세요
SELECT *
FROM cart;

--member 테이블에서 mem_id, mem_pass, mem_name 컬럼만 조회하는 쿼리를 작성하세요 
SELECT mem_id, mem_pass, mem_name
FROM member;

컬럼 정보 보는 방법
1. SELECT * => 컬럼의 이름을 알 수 있다
2.  SQL DEVELOPER의 테이블 객체를 클릭하여 정보 확인
3. DESC 테이블명; //DESCRIBE :설명하다

DESC emp;

empno : number;
empno +10 ==>expression, 10=>expression --컬럼정보가 아닌것은 expression임
SELECT empno empnumber, empno+10 emp_plus, 10,
        hiredate, hiredate + 10
FROM emp;
--empno값은 변경되지 않고 그대로임
--컬럼이나 expression 뒤에 붙을 수 있는 alias는 컬럼명을 바꾸는 옵션임
alias : 컬럼의 이름을 변경
        컬럼 | expression [AS] [별칭명]
SELECT empno "emp no", empno +10 AS empno_plus
FROM emp;
--첫번째 empno : 컬럼명, 두번째 empno : 별칭명
--별칭명 alias에 ""를 붙여주면 소문자로 나옴

NULL :아직 모르는 값
      0과 공백은 NULL과 다르다
      **** NULL을 포함한 연산은 결과가 항상 NULL ****
      ==>NULL 값을 다른 값으로 치환해주는 함수
      
SELECT ename, sal, sal +comm, comm, comm +100
FROM emp;

select2

--prod 테이블에서 prod_id, prod_name 두 컬럼을 조회하는 쿼리를 작성하시오
--(단 prod_id->id, prod_name->name으로 컬럼 별칭을 지정)
SELECT prod_id AS "id", prod_name AS "name"
FROM prod;
--lprod 테이블에서 lprod_gu, lprod_nm 두 컬럼을 조회하는 쿼리를 작성하시오
--(단 lprod_gu->gu, lprod_nm->nm으로 컬럼 별칭을 지정)
SELECT lprod_gu AS "gu", lprod_nm AS "nm"
FROM lprod;
--buyer 테이블에서 buyer_id, buyer_name 두 컬럼을 조회하는 쿼리를 작성하시오
--(단 buyer_id->바이어아이디, buyer_name->이름으로 컬럼 별칭을 지정)
SELECT buyer_id AS 바이어아이디, buyer_name AS 이름
FROM buyer;

literal : 값 자체
literal 표기법 : 값을 표현하는 방법

java 정수 값을 어떻게 표현할까 (10)?
int a =10;
float f =10f;
long l =10L;
String s = "Hello World";

* | {컬럼 | 표현식 [AS] [ALIAS], ... }

--sql에서는 java와는 다르게 문자열을 ''로 표현함
SELECT empno, 10, 'Hello World'
FROM emp;

문자열 연산
java : String msg = "Hello" + ", World";

SELECT empno + 10, ename || 'Hello' || ',World',  -- +대신 || (3개 가능)
        CONCAT(ename, ',World')
FROM emp;
--CONCAT : 결합할 2개의 문자열을 입력받아 결합하고 결합된 문자열을 반환해줌 (3개 불가능)
DESC emp;


아이디 : brown
아이디 : apeach
.
.
SELECT userid
FROM users;

SELECT CONCAT('아이디:',userid ), '아이디:' || userid
FROM users;

SELECT table_name
FROM user_tables;
--user_tables; 은 현재 접속한 사용자가 소유한 테이블의 목록을 볼 수 있음 (오라클 자체에서 제공)


CONCAT (문자열1, 문자열2, 문자열3)
==> CONCAT(문자열1과 문자열2가 결합된 문자열, 문자열 3)
==>CONCAT(CONCAT(문자열1, 문자열2), 문자열3)

SELECT 'SELECT * FROM ' || table_name || ';' AS QUERY,
        CONCAT(CONCAT('SELECT * FROM ', table_name),';') AS QUERY,
        CONCAT('SELECT * FROM ', table_name ||';') AS QUERY
FROM user_tables;

--조건에 맞는 데이터 조회하기
WHERE절 조건연산자
같은값 =
다른값 !=, <>
클때 >
크거나 같을 때 >=
작을때 <
작거나 같을 때<=

--부서번호가 10인 직원들만 조회
--부서번호 : deptno
SELECT *
FROM emp
WHERE deptno = 10;

--users 테이블에서 userid 컬럼의 값이 brown인 사용자만 조회
SELECT *
FROM users
WHERE userid = 'brown';
--BROWN이라고 대문자로 쓰면 안나옴 데이터가 소문자기때문

--emp 테이블에서 부서번호가 20번보다 큰 부서에 속한 직원 조회
SELECT *
FROM emp
WHERE deptno > 20;

--emp 테이블에서 부서번호가 20번 부서에 속하지 않은 모든 직원 조회
SELECT *
FROM emp
WHERE deptno != 20;

WHERE절 : 기술한 조건을 참(true)으로 만족하는 행들만 조회한다(FILTER)

SELECT *
FROM emp
WHERE 1=1;
--모든 행에 대해서 1=1은 참이기 때문에 모든 행 다 나옴 (항상 true)

SELECT *
FROM emp
WHERE 1=2;
--모든 행에 대해서 1=2는 거짓이기 때문에 모든 행 나오지 않음 (항상 false)

SELECT empno, ename, hiredate
FROM emp
WHERE hiredate >= '81/03/01';  --81년 3월 1일 날짜 값을 표기하는 방법
--미국과 우리나라 연도작성법이 다르기때문에 이렇게 작성하면 위험함

문자열을 날짜 타입으로 변환하는 방법
TO_DATE(날짜 문자열, 날짜 문자열의 포맷팅)
ex) TO_DATE('1981/03/01', 'YYYY/MM/DD') 문자열 인자 2개를 입력받고 1개의 날짜값 반환함

SELECT empno, ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('1981/03/01','YYYY/MM/DD');
--이런식으로 작성해줘야 안전함  RRRR/YYYY 연도 4자리 사용 권장
