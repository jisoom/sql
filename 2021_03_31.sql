ana2
window function을 이용하여 모든 사원에 대해 사원번호, 사원이름, 본인 급여, 부서번호와 해당사원이 속한 부서의 급여평균을 
조회하는 쿼리를 작성하세요(급여평균은 소수점 둘째 자리까지 구한다)

SELECT empno, ename, sal, deptno, ROUND(AVG(sal) OVER (PARTITION BY deptno),2) avg_sal
FROM emp;
--해당부서의 가장 낮은 급여
--해당부서의 가장 높은 급여
SELECT empno, ename, sal, deptno, 
         ROUND(AVG(sal) OVER (PARTITION BY deptno),2) avg_sal,
         MIN(sal) OVER (PARTITION BY deptno) min_sal,
         MAX(sal) OVER (PARTITION BY deptno) max_sal,
         SUM(sal) OVER (PARTITION BY deptno) sum_sal,
         COUNT(*) OVER (PARTITION BY deptno) cnt
FROM emp;

LAG (col) : 파티션별 윈도우에서 이전 행의 컬럼 값
LEAD (col) : 파티션별 윈도우에서 이후 행의 컬럼 값

자신보다 급여 순위가 한단계 낮은 사람의 급여를 5번째 컬럼으로 생성
SELECT empno, ename, hiredate, sal, LEAD(sal) OVER (ORDER BY sal DESC, hiredate) lead_sal
FROM emp;
가져오려는 것은 이후행 ==> LEAD 사용

ana5
window function을 이용하여 모든 사원에 대해 사원번호, 사원이름, 입사일자, 급여, 전체사원중 급여 순위가 1단계 높은 사람의 급여를 조회하는
쿼리를 작성하세요(급여가 같을 경우 입사일이 빠른 사람이 높은 순위)
SELECT empno, ename, hiredate, sal, LAG(sal) OVER (ORDER BY sal DESC, hiredate) lag_sal
FROM emp;

ana5_1
ana5 문제 분석함수 사용하지 않고 해보기
SELECT a.empno, a.ename, a.hiredate, a.sal, b.sal
FROM(SELECT a.*, ROWNUM rn
FROM(SELECT empno, ename, hiredate, sal
FROM emp
ORDER BY sal DESC, hiredate) a) a,
(SELECT a.*, ROWNUM rn
FROM(SELECT empno, ename, hiredate, sal
FROM emp
ORDER BY sal DESC, hiredate) a) b
WHERE a.rn - 1 = b.rn(+)
ORDER BY a.sal DESC, a.hiredate;

ana6
window function을 이용하여 모든 사원에 대해 사원번호, 사원이름, 입사일자, 직군(job),급여정보와 담당업무(job)별 급여 순위가
1단계 높은 사람의 급여를 조회하는 쿼리를 작성하세요(급여가 같을 경우 입사일이 빠른 사람이 높은 순위)
SELECT empno, ename, hiredate,job, sal, LAG(sal) OVER (PARTITION BY job ORDER BY sal DESC, hiredate) lag_sal
FROM emp;

분석함수 OVER ([PARTITION BY] [ORDER BY] [WINDOWING])

LAG, LEAD 함수의 두번째 인자 : 이전, 이후 몇번째 행을 가져올지 표기 ==>LAG(sal,2), LEAD(sal,2)
SELECT empno, ename, hiredate, sal, LAG(sal,2) OVER (ORDER BY sal DESC, hiredate) lag_sal
FROM emp;

SELECT empno, ename, hiredate, sal, LEAD(sal,2) OVER (ORDER BY sal DESC, hiredate) lag_sal
FROM emp;

no_ana3
모든 사원에 대해 사원번호, 사원이름, 입사일자, 급여를 급여가 낮은 순으로 조회해보자. 급여가 동일할 경우 사원번호가 빠른 사람이 우선순위가 높다
우선순위가 가장 낮은 사람부터 본인 까지의 급여 합을 새로운 컬럼으로 생성
1. ROWNUM
2. INLINE VIEW
3. NON-EQUI JOIN (범위 조인): 동등조건이 아니다
4. GROUP BY

SELECT a.empno, a.ename, a.sal, SUM(b.sal)
FROM(SELECT a.*, ROWNUM rn
FROM(SELECT empno, ename, sal
FROM emp
ORDER BY sal, empno) a) a,
(SELECT a.*, ROWNUM rn
FROM(SELECT empno, ename, sal
FROM emp
ORDER BY sal, empno) a) b
WHERE a.rn >= b.rn
GROUP BY a.empno, a.ename, a.sal
ORDER BY a.sal, a.empno;


SELECT empno, ename, sal, SUM(sal) OVER ()c_sum
FROM emp
ORDER BY sal, empno;

분석함수 () OVER ( [PARTITION] [ORDER] [WINDOWING] )
WINDOWNING : 윈도우 함수의 대상이 되는 행을 지정

UNBOUNDED PRECEDING : 특정 행을 기준으로 모든 이전행(LAG)
    n PRECEDING : 특정 행을 기준으로 n행 이전행(LAG)
CURRENT ROW : 현재 행
UNBOUNDED FOLLOWING : 특정 행을 기준으로 모든 이후행(LEAD)
    n FOLLOWING : 특정 행을 기준으로 n행 이후행(LEAD)

분석함수 () OVER ( [] [ORDER] [WINDOWING] )
SELECT empno, ename, sal, 
        SUM(sal) OVER (ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)c_sum,  --길더라도 명확하니까 이걸 추천
        SUM(sal) OVER (ORDER BY sal, empno ROWS UNBOUNDED PRECEDING)c_sum  --생략해도 위랑 같은 결과 (현재행이 기준이 되있어서 자동으로 현재행까지 계산함)
FROM emp;
--ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW : 이전행과 현재행 사이의 행들

SELECT empno, ename, sal, 
        SUM(sal) OVER (ORDER BY sal, empno ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING)c_sum  --길더라도 명확하니까 이걸 추천
FROM emp;
--ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING : 선행하는 행, 현재 내 행, 이후 행

ana7
사원번호, 사원이름, 부서번호, 급여 정보를 부서별로 급여, 사원번호 오름차순으로 정렬 했을 때, 자신의 급여와 선행하는 사원들의
급여합을 조회하는 쿼리를 작성하세요(window 함수 사용)
SELECT empno, ename, deptno, sal,
        SUM(sal) OVER (PARTITION BY deptno ORDER BY sal, ename ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)c_sum
FROM emp;

ROWS : 물리적인 row
RANGE : 논리적인 값의 범위
        같은 값을 하나로 본다
      
ROWS와 RANGE의 차이        
SELECT empno, ename, sal,
        SUM(sal) OVER (ORDER BY sal ROWS UNBOUNDED PRECEDING)romws_c_sum,
        SUM(sal) OVER (ORDER BY sal RANGE UNBOUNDED PRECEDING)range_c_sum,
        SUM(sal) OVER (ORDER BY sal)no_win_c_sum, --ORDER BY 이후 윈도윙 없을 경우 기본 설정 : RANGE UNBOUNDED PRECEDING
        SUM(sal) OVER ()no_ord_c_sum --전체 합
FROM emp;   
--RANGE : 행의 값이 같은 애까지 내려가서 계산하겠다
--ex) 1250동일한 값의 행 두개 있으면 두번째꺼까지 계산




