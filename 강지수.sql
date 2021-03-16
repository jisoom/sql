where13
emp 테이블에서 job이 SALESMAN 이거나 사원번호가 78로 시작하는 직원의 정보를 다음과 같이 조회하세요
(LIKE 연산자 사용하지 마세요)

SELECT *
FROM emp
WHERE job ='SALESMAN' 
OR empno ='7839' OR empno ='7844' OR empno ='7876' ; //하드 코딩 ==> 코드가 바뀌면 새로 작성해줘야함 (좋지 않음)


----------------정답--------------------------
SELECT *
FROM emp
WHERE job = 'SALESMAN' 
OR empno BETWEEN 7800 AND 7899
OR empno BETWEEN 780 AND 789
OR empno BETWEEN 78 AND 78;