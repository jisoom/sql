date
날짜 조작
ROUND
TRUNC

날짜 관련 함수
-MONTHS_BETWEEN : 인자 - start date, end date, 반환값 : 두 일자 사이의 개월 수
-ADD_MONTHS (***): 인자 - date, number 더할 개월 수 : date로 부터 x개월 뒤의 날짜

date + 90
1/15 3개월 뒤의 날짜 ==> ADD_MONTHS 사용

-NEXT_DAY (***):인자 - date, number (weekday, 주간 일자)
date 이후의 가장 첫번째 주간 일자에 해당하는 date를 반환

-LAST_DAY(***) : 인자 : date : date가 속한 월의 마지막 일자를 date로 반환

MONTHS_BETWEEN
SELECT ename, TO_CHAR(hiredate, 'yyyy/mm/dd HH24:mi:ss') hiredate,
        MONTHS_BETWEEN(SYSDATE, hiredate) month_between,
        ADD_MONTHS(SYSDATE, 5 ) add_months,
        ADD_MONTHS(TO_DATE('2021-02-15','YYYY-MM-DD'),-5) ADD_MONTHS2,
        NEXT_DAY(SYSDATE, 6) NEXT_DAY, --현재 시간 18일 이후에 등장하는 첫번째 금요일 언제냐 > 19일
        LAST_DAY(SYSDATE) LAST_DAY,
--        SYSDATE를 이용하여 SYSDATE가 속한 월의 첫번째 날짜 구하기
--        SYSDATE 이용해서 년, 월까지 문자로 구하기 + ||'01'
--        '202103' || '01' ==> '20210301'
--        TO_DATE('20210301', 'YYYYMMDD')
        TO_DATE(TO_CHAR(SYSDATE,'YYYYMM')||'01', 'YYYYMMDD')  FIRST_DAY
FROM emp;
--일요일 : 1, 월요일 : 2, 화요일 : 3, 수요일 : 4, 목요일 : 5, 금요일 : 6, 토요일 : 7

SELECT TO_DATE('2021', 'YYYY')
FROM dual; ==> 서버의 현재 시간의 월이 나옴

SELECT TO_DATE('2021' || '0101', 'YYYYMMDD')  => 고정된 문자열로 초기화가 가능하다
FROM dual;

fn3 (********다시 해보기**********)
파라미터로 yyyymm형식의 문자열을 사용하여 (ex: yyyymm = 201912) 해당 년월에 해당하는 일자 수를 구해보세요
(201602 -> 윤년 일수 29일 나옴)
SELECT :YYYYMM, TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'DD')DT
FROM dual;

형변환
-명시적 형변환
TO_DATE, TO_CHAR, TO_NUMBER
-묵시적 형변환

SELECT *
FROM emp
WHERE TO_CHAR(empno) = '7369';

1.위에서 아래로
2. 단, 들여쓰기 되어있을 경우 (자식노드) 자식노드부터 읽는다

NUMBER
FORMAT
9 : 숫자
0 : 강제로 0 표시
, : 1000자리 표시
. : 소수점
L : 화폐단위 (사용자 지역)
$ : 달러 화폐 표시

NULL 처리 함수 : 4가지
NVL(expr1, expr2) --expression, 컬럼 올 수 있음
expr1이 NULL 값이 아니면 expr1을 사용하고 ,expr1이 NULL값이면 expr2로 대체해서 사용한다
--java
--if(expr1 == null)
    --System.out.println(expr2)
-- else
    --System.out.println(expr1)
        
emp 테이블에서 comm컬럼의 값이 NULL일 경우 0으로 대체해서 조회하기
SELECT empno, sal, comm, sal + NVL(comm, 0) nvl_sal_comm,
        NVL(sal+comm,0) --null처리를 하지 않았기 때문에 sal + comm 둘중에 null값이 있으면==> null이 되고 0으로 바뀜
FROM emp;

NVL2(expr1, expr2, expr3)
--java
--if(expr1 != null)
   --System.out.println(expr2);
--else
   --System.out.println(expr3);

comm이 null이 아니면 sal + comm을 반환
comm이 null이면 sal을 반환

SELECT empno, sal, comm, NVL2(comm, sal+comm, sal)nvl2,
        sal + NVL(comm,0)
FROM emp;

NULLIF(expr1, expr2)
--java
--if(expr1 == expr2)
   --System.out.println(null);
--else
   --System.out.println(expr1);

SELECT empno, sal, NULLIF(sal, 1250) --sal == 1250이면 null이 나옴
FROM emp;

COALESCE(expr1, expr2, expr3,...) --인자 갯수 무한대
--인자들 중에 가장 먼저 등장하는 null이 아닌 인자를 반환
--java
--if(expr1 != null)
   --System.out.println(expr1);
--else
   --COALESCE(expr2, expr3....);

--if(expr2 != null)
   --System.out.println(expr2);
--else
   --COALESCE(expr3....);   
   
SELECT empno, sal, comm, COALESCE
FROM emp;


Function (null 실습 fn4)
emp 테이블의 정보를 다음과 같이 조회되도록 쿼리를 작성하세요
(nvl, nvl2, coalesce)

SELECT empno, ename, mgr, NVL(mgr,9999) mgr_n, NVL2(mgr,mgr,9999) mgr_n_1, COALESCE(mgr,9999) mgr_n_2
FROM emp;

fn5
users 테이블의 정보를 다음과 같이 조회되도록 쿼리를 작성하세요
reg_dt가 null일 경우 sysdate를 적용

SELECT userid, usernm, reg_dt , NVL(reg_dt, SYSDATE) n_reg_dt
FROM users
WHERE userid IN('cony', 'sally', 'james', 'moon');

조건분기
1. CASE 절
    CASE expr1 비교식(참거짓을 판단할 수 있는 수식) THEN 사용할 값        => if
    CASE expr1 비교식(참거짓을 판단할 수 있는 수식) THEN 사용할 값2       => else if
    CASE expr1 비교식(참거짓을 판단할 수 있는 수식) THEN 사용할 값3       => else if
    ELSE 사용할 값4                                                 => else
    END
    
직원들의 급여를 인상하려고 한다
job이 SALESMAN이면 현재 급여에서 5%를 인상
job이 MANAGER이면 현재 급여에서 10%를 인상
job이 PRESIDENT이면 현재 급여에서 20%를 인상
그 이외의 직군은 현재 급여를 유지

SELECT ename, job, sal, 인상된 급여
FROM emp;
↓
SELECT ename, job, sal, 
        CASE 
            WHEN job = 'SALESMAN' THEN sal * 1.05
            WHEN job = 'MANAGER' THEN sal * 1.10
            WHEN job = 'PRESIDENT' THEN sal * 1.20
            ELSE sal * 1.0
        END sal_bonus
FROM emp;


2. DECODE 함수 => COALESCE 함수처럼 가변인자 사용 (동등비교만 사용 가능 // 대소비교 불가능)
DECODE (expr1, search1, return1, search2, return2, search3, return3, ...[, default])
DECODE (expr1, 
            search1, return1, 
            search2, return2,
            search3, return3,
            ...[, default])
if (expr1 == search1)
   System.out.println(return1)
else if (expr1 == search2)
   System.out.println(return2)
else if (expr1 == search3)
   System.out.println(return3)
else
   System.out.println(default)
   
SELECT ename, job, sal, 
        DECODE(job,
                'SALESMAN' , sal * 1.05,
                'MANAGER' , sal * 1.10,
                'PRESIDENT' , sal * 1.20,
                sal * 1.0) sal_bonus_decode --default값을 해주지 않으면 null이 나옴
FROM emp;
--원래는 한줄로 쓰는데 이해하기 쉬우라고 여러줄로 띄워서 사용했음

condition 실습 cond1
emp 테이블을 이용하여 deptno에 따라 부서명으로 변경해서 다음과 같이 조회되는 쿼리를 작성하세요
10 -> 'ACCOUNTING'
20 -> 'RESEARCH'
30 -> 'SALES'
40 -> 'OPERATIONS'
기타 다른 값 -> 'DDIT'

SELECT empno, ename, deptno,
        DECODE(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES', 40, 'OPERATIONS','DDIT') dname_decode,
                
        CASE
        WHEN deptno = 10 THEN 'ACCOUNTING'
        WHEN deptno = 20 THEN 'RESEARCH'
        WHEN deptno = 30 THEN 'SALES'
        WHEN deptno = 40 THEN 'OPERATIONS'
        ELSE 'DDIT'
        END dname_case
FROM emp;

cond2
emp테이블을 이용하여 hiredate에 따라 올해 건강보험 검진 대상자인지 조회하는 쿼리를 작성하세요
(생년을 기준으로 하나, 여기서는 입사년도를 기준으로 한다)
홀수년도 입사 - 대상자, 짝수년도 입사 -비대상자

2=>0,1
SELECT MOD(1981,2)
FROM dual;


SELECT empno, ename, hiredate,
        MOD(TO_CHAR(hiredate,'yyyy'),2),
        MOD(TO_CHAR(SYSDATE,'yyyy'),2),
        CASE
        WHEN MOD(TO_CHAR(hiredate,'yyyy'),2) = MOD(TO_CHAR(SYSDATE,'yyyy'),2) THEN '건강검진 대상자'
        ELSE '건강검진 비대상자'
        END CONTACT_TO_DOCTOR_CASE
FROM emp;

SELECT empno, ename, hiredate,
        MOD(TO_CHAR(hiredate,'yyyy'),2),
        MOD(TO_CHAR(SYSDATE,'yyyy'),2),
        DECODE (MOD(TO_CHAR(hiredate,'yyyy'),2),
        MOD(TO_CHAR(SYSDATE,'yyyy'),2),'건강검진 대상자',
        '건강검진 비대상자')
         CONTACT_TO_DOCTOR_DECODE
FROM emp;

cond3
users 테이블을 이용하여 reg_dt에 따라 올해 건강보험 검진 대상자인지 조회하는 쿼리를 작성하세요
(생년을 기준으로 하나 여기서는 reg_dt를 기준으로 한다)

SELECT userid, usernm, reg_dt,
        MOD(TO_CHAR(reg_dt,'yyyy'),2),
        MOD(TO_CHAR(SYSDATE,'yyyy'),2),
        CASE
        WHEN MOD(TO_CHAR(reg_dt,'yyyy'),2) = MOD(TO_CHAR(SYSDATE,'yyyy'),2) THEN '건강검진 대상자'
        ELSE '건강검진 비대상자'
        END CONTACT_TO_DOCTOR_CASE
FROM users
WHERE userid IN('brown', 'cony', 'james', 'moon', 'sally');

SELECT userid, usernm, reg_dt,
        MOD(TO_CHAR(reg_dt,'yyyy'),2),
        MOD(TO_CHAR(SYSDATE,'yyyy'),2),
        DECODE (MOD(TO_CHAR(reg_dt,'yyyy'),2),
        MOD(TO_CHAR(SYSDATE,'yyyy'),2),'건강검진 대상자',
        '건강검진 비대상자')
         CONTACT_TO_DOCTOR_DECODE
FROM users
WHERE userid IN('brown', 'cony', 'james', 'moon', 'sally');

GROUP FUNCTION : 여러행을 그룹으로 하여 하나의 행으로 결과값을 반환하는 함수

SELECT *
FROM emp;

무슨 값이 같은 행들을기준으로 묶을지 :그룹핑을 무엇을 기준으로 할지가 중요함

Group function
-AVG : 평균
-COUNT : 건수
-MAX : 최대값
-MIN : 최소값
-SUM : 합

SELECT
FROM
WHERE
GROUP BY
HAVING
ORDER BY


SELECT deptno, MAX(sal),--deptno가 같은 사람들중 sal이 가장 큰 사람의 sal
        MIN(sal), ROUND(AVG(sal),2),
        SUM(sal), COUNT(sal), --그룹핑된 행중에 sal 컬럼의 값이 NULL이 아닌 행의 건수
        COUNT(mgr), --그룹핑된 행중에 mgr 컬럼의 값에 있는 null값 때문에 제대로 안나옴
        COUNT(*) -- 그룹핑된 행 건수
FROM emp
GROUP BY deptno; --deptno가 같은사람들끼리 하나의 행으로 묶겠다

--GROUP BY를 사용하지 않을 경우 테이블의 모든 행을 하나의 행으로 그룹핑한다.
SELECT COUNT(*), MAX(sal), MIN(sal), ROUND(AVG(sal),2), SUM(sal)
FROM emp; --SELECT절에 deptno쓰면 에러
--에러 해결 ==> GROUP BY절에 넣어 그룹함수 만들어줌 // 하지만 원하는 결과에 따라 다름 무조건 적용되는건 아님
SELECT COUNT(*), MAX(sal), MIN(sal), ROUND(AVG(sal),2), SUM(sal)
FROM emp
GROUP BY deptno;


--GROUP BY 절에 나온 컬럼이 SELECT절에 그룹함수가 적용되지 않은채로 기술되면 에러가 뜸
SELECT deptno, empno,
        MAX(sal),
        MIN(sal), ROUND(AVG(sal),2),
        SUM(sal), COUNT(sal),
        COUNT(mgr), 
        COUNT(*)
FROM emp
GROUP BY deptno;
--에러 해결 ==> GROUP BY절에 같이 넣어줘서 그룹함수를 만들어줌
SELECT deptno, empno,
        MAX(sal),
        MIN(sal), ROUND(AVG(sal),2),
        SUM(sal), COUNT(sal), 
        COUNT(mgr), 
        COUNT(*) 
FROM emp
GROUP BY deptno, empno; --empno를 그룹핑하면 같은 값이 없기때문에 14건이 전부 다나옴

SELECT deptno, 'Test', 100, --상수는 같이 써도 가능 // 항상 똑같은 값이기 때문에 
        MAX(sal),
        MIN(sal), ROUND(AVG(sal),2),
        SUM(sal), COUNT(sal), 
        COUNT(mgr), 
        COUNT(*),
        SUM(comm), --30에 있는 null값이 무시가 됨->null처리 안해도됨 // 10,20은 원래 값이 없어서 null이나옴
        SUM(NVL(comm,0)), --null값을 다 0으로 바꿔줘야하기 때문에
        NVL(SUM(comm),0) --위에보다 이게 효율적임
FROM emp
GROUP BY deptno
HAVING COUNT(*) >= 4; 

그룹함수에서 NULL컬럼은 계산에서 제외된다
GROUP BY절에 작성된 컬럼이외의 컬럼이 SELECT절에 올 수 없다
WHERE절에 그룹함수를 조건으로 사용할 수 없다
HAVIG절 사용 
WHERE SUM(sal) > 3000 (X)
HAVIG SUM(sal) > 3000 (O)

Function (group function 실습 grp1)
emp 테이블을 이용하여 다음을 구하시오
직원중 가장 높은 급여
직원중 가장 낮은 급여
직원의 급여 평균(소수점 두자리까지 나오도록 반올림)
직원의 급여 합
직원중 급여가 있는 직원의 수 (null제외)
직원중 상급자가 있는 직원의 수 (null제외)
전체 직원의 수

SELECT MAX(sal), MIN(sal),  ROUND(AVG(sal),2), SUM(sal), COUNT(sal),  COUNT(mgr), COUNT(*)
FROM emp;

SELECT  MAX(sal), MIN(sal),  ROUND(AVG(sal),2), SUM(sal), COUNT(sal),  COUNT(mgr), COUNT(*)
FROM emp
GROUP BY deptno;

