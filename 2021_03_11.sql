--데이터 조회 방법
--FROM : 데이터를 조회할 테이블 명시
--SELECT : 조회 하고자하는 컬럼명(테이블에 있는 컬럼명)
--         테이블의 모든 컬럼을 조회할 경우 *를 기술
--         컬럼을 구분짓는 구분자 : ,(콤마)

SELECT * 
FROM emp;

SELECT empno, ename 
FROM emp;

--외우기
--EMPNO: 직원번호, ENAME : 직원명, JOB: 담당업무
--MGR : 상위 담당자, HIREDATE : 입사일자, SAL : 급여
--COMM : (커미션)상여금, DEPTNO : 부서번호 