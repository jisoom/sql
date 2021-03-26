INSERT 단건, 여러건
INSERT INTO 테이블명
SELECT ...

UPDATE 테이블명 SET 컬럼명 1 = (스칼라 서브쿼리),
                   컬럼명 2 = (스칼라 서브쿼리),
                   컬럼명 3 = 'TEST';
                   
9999사번(empno)을 갖는 brown 직원(ename)을 입력                   
INSERT INTO emp (empno, ename) VALUES (9999, 'brown');
INSERT INTO emp (ename, empno) VALUES (9999, 'brown');

DESC emp;

SELECT *
FROM emp;

9999번 직원의 deptno와 job 정보를 SMITH 사원의 deptno, job 정보로 업데이트
SELECT deptno, job
FROM emp
WHERE ename = 'SMITH';

UPDATE emp SET deptno = (SELECT deptno
                         FROM emp
                         WHERE ename = 'SMITH'),
                job = (SELECT job
                        FROM emp
                        WHERE ename = 'SMITH')
WHERE empno = 9999;        

SELECT *
FROM emp
WHERE empno = 9999;

MERGE --추후에

DELETE : 기존에 존재하는 데이터를 삭제
DELETE 테이블 명
WHERE 조건;

DELETE 테이블 명; ==> 테이블의 모든 행이 삭제됨

삭제 테스트를 위한 데이터 입력
INSERT INTO emp (empno, ename) VALUES (9999, 'brown');

DELETE emp
WHERE empno = 9999;

mgr가 7698사번 (BLAKE)인 직원들 모두 삭제
SELECT *
FROM emp
WHERE mgr = 7698;

ROLLBACK;

DBMS는 DML문장을 실행하게 되면 LOG를 남긴다
    UNDO(REDO) LOG
    
로그를 남기지 않고 더 빠르게 데이터를 삭제하는 방법 : TRUNCATE
.DML이 아님 (DDL)
.ROLLBACK이 불가(복구 불가)
.주로 테스트 환경에서 사용

CREATE TABLE emp_test AS
SELECT *
FROM emp;
    
SELECT *
FROM emp_test;

TRUNCATE TABLE emp_test;

ROLLBACK;



트랜잭션 : 논리적인 일의 단위
.첫번째 DML문을 실행함과 동시에 트랜잭션 시작
.이후 다른 DML문 실행
commit : 트랜잭션을 종료, 데이터를 확정
rollback : 트랜잭션에서 실행한 DML문을 취소하고 트랜잭션 종료

읽기 일관성 레벨 : 0 ~ 3 까지
트랜잭션에서 실행한 결과가 다른 트랜잭션에 어떻게 영향을 미치는지 정의한 레벨 (단계)

LEVEL 0 : READ UNCOMMITED
    .dirty(변경이 가해졌다) read
    .커밋을 하지 않은 변경 사항도 다른 트랜잭션에서 확인 가능
    .oracle에서는 지원하지 않음
    
LEVEL 1 : READ COMMITED
    .대부분의 DBMS 읽기 일관성 설정 레벨
    .커밋한 데이터만 다른 트랜잭션에서 읽을 수 있다
    .커밋하지 않은 데이터는 다른 트랜잭션에서 볼 수 없다

LEVEL 2 : Reapeatable Read
    .선행 트랜잭션에서 읽은 데이터를 후행 트랜잭션에서 수정하지 못하도록 방지
    .선행 트랜잭션에서 읽었던 데이터를 트랜잭션의 마지막에서 다시 조회를 해도 동일한 결과가 나오게끔 유지
    .신규 입력 데이터에 대해서는 막을 수 없음
    ==> Phantom Read (유령 읽기) 없던 데이터가 조회되는 현상
    .기존 데이터에 대해서는 동일한 데이터가 조회되도록 유지
    .Oracle 에서는 LEVEL2 에 대해 공식적으로 지원하지 않으나 FOR UPDATE 구문을 이용하여 효과를 만들어 낼 수 있다

LEVEL 3 : Serializable Read 직렬화 읽기
    .후행 트랜잭션에서 수정, 입력, 삭제한 데이터가 선행 트랜잭션에 영향을 주지 않음
    .선 : 데이터 조회(14)
     후 : 신규에 입력(15)
     선 : 데이터 조회(14)

인덱스
.눈에 안보여
.테이블의 일부 컬럼을 사용하여 데이터를 정렬한 객체
 ==>원하는 데이터를 빠르게 찾을 수 있다
    .일부 컬럼과 함께 그 컬럼의 행을 찾을 수 있는 ROWID가 같이 저장됨
.ROWID : 테이블에 저장된 행의 물리적 위치, 집 주소 같은 개념
         주소를 통해서 해당 행의 위치로 빠르게 접근하는 것이 가능하다
         데이터가 입력이 될 때 생성
SELECT emp.*
FROM emp
WHERE empno = 7782;
 
 --데이터가 정렬이 되어있으면 데이터를 찾는 것이 빠르다
SELECT empno, ROWID
FROM emp
WHERE empno = 7782;
 
SELECT *
FROM emp
WHERE ROWID = 'AAAE5gAAFAAAACPAAG';

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY); --DBMS_XPLAN : 패키지 DISPLAY : 반환해줌


오라클 객체 생성
CREATE 객체 타입(INDEX, TABLE....) 객체명
            int 변수명
            
인덱스 생성
CREATE [UNIQUE] INDEX 인덱스 이름 ON 테이블명(컬럼1, 컬럼2....);

UNIQUE : 중복값이 올 수 없음

CREATE UNIQUE INDEX PK_emp 
ON emp(empno);

--실행계획 설명
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;
--실행계획 보여줌
SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

filter : 전체를 찾아서 걸러냄
access : 바로 접근함 (인덱스 사용 장점)

DDL (unique Index가 있다면 : PK = unique + not null)

EXPLAIN PLAN FOR
SELECT empno   --사용자가 원하는 것은 empno컬럼인데 empno컬럼은 인덱스가 있기 때문에 인덱스만 확인하고, 테이블은 접근 안함
FROM emp
WHERE empno = 7782; 

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);


DROP INDEX PK_EMP;

CREATE INDEX IDX_emp_01 ON emp(empno);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);
UNIQUE : 딱 하나만 읽음 (중복이 없어서)
RANGE : 범위를 읽음 (중복이 가능해서)

--job컬럼에 인덱스 생성
CREATE INDEX IDX_job_02 ON emp(job);

SELECT job, ROWID
FROM emp
ORDER BY job;

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER';

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);


EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'  --access job이 MANAGER인 거에 접근
    AND ename LIKE 'C%';  --filter job이 MANAGER인 거를 전부 읽고 버림

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

CREATE INDEX IDX_EMP_03 ON emp (job, ename);

SELECT job, ename, ROWID
FROM emp
ORDER BY job, ename;

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'  --access
    AND ename LIKE 'C%'; --access job이 MANAGER이고, ename이 C로 시작하는 거부터 접근, filter로 C로 시작하는거만 걸러냄

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

SELECT *
FROM emp
WHERE job = 'MANAGER'
        AND ename = '%C';

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER' 
    AND ename LIKE '%C';  --C로 끝나면 되는거라 앞에 어떤 글자가 와도 상관이 없어서 결국 정렬의 의미가 없음
    --job이 MANAGER고 이름 끝글자가 C인 게 없음 ==> 결국 테이블에 접근 안함
    
SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);    





