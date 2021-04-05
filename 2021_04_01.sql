view
. Table과 유사한 객체이다
. View는 기존의 테이블이나 다른 View 객체를 통하여 새로운 SELECT문의 결과를 테이블처럼 사용한다 (가상 테이블)
 . View는 SELECT문에 귀속되는 것이 아니고, 독립적으로 테이블처럼 존재
 
View를 이용하는 경우
. 필요한 정보가 한 개의 테이블에 있지 않고, 여러개의 테이블에 분산되어 있는 경우
. 테이블에 들어 있는 자료의 일부분만 필요하고 자료의 전체 row 나 column 이 필요하지 않은 경우 [복잡한 서브쿼리와 조인을 사용하지 않아도됨]
. 특정 자료에 대한 접근을 제한하고자 할 경우(보안) 

오라클 객체
객체 생성 create 삭제 drop

인덱스객체 [찾기의 효율성을 증가 시키려고]
자료구조 -> 핵심기법 ()
**이진트리 


View 객체
- TABLE과 유사한 기능 제공
- 보안, QUERY 실행의 효율성, TABLE의 은닉성을 위하여 사용
(사용형식)
CREATE [OR REPLACE] [FORCE|NOFORCE] VIEW 뷰이름 [(컬럼LIST)]
AS
    SELECT 문;
    [WITH CHECK OPTION;]
    [WITH READ ONLY;]
    
. OR REPLACE : 뷰가 존재하면 대체되고 없으면 신규로 생성 (생성을 하되 이미 하드디스크에 생성되어 있으면 덮어쓰고(대체) 없으면 새로 생성)
. FORCE : 원본 테이블이 존재하지 않아도 뷰를 생성
. NOFORCE : 원본 테이블이 존재하지 않으면 뷰를 생성 불가
. 컬럼LIST : 생성된 뷰의 컬럼명 (SELECT 절에 나와있는 만큼 적어줌)
WITH CHECK OPTION : SELECT 문의 조건절(WHERE절)에 위배되는 DML 명령(INSERT, UPDATE, DELETE) 실행 거부
WITH READ ONLY : 읽기 전용 뷰 생성 (UPDATE, DELETE, INSERT 할 수 없음)
--WITH CHECK OPTION, WITH READ ONLY 두개를 동시에 쓸 수 없음

--사용 예 ) 사원테이블에서 부모부서코드가 90번 부서에 속한 사원정보를 조회하시오.
--         조회할 데이터 : 사원번호, 사원명, 부서명, 급여

사용 예 ) 회원 테이블에서 마일리지가 3000이상인 회원의 회원번호, 회원명, 직업, 마일리지를 조회하시오.
SELECT mem_id 회원번호, mem_name 회원명, mem_job 직업, mem_mileage 마일리지
FROM member
WHERE mem_mileage >= 3000;

--자바 특성 : 재사용 (reuse) ==> 재사용하려면 저장해서 불러야됨

=>뷰 생성
CREATE OR REPLACE VIEW V_MEMBER01
AS 
    SELECT mem_id 회원번호,
           mem_name 회원명,
           mem_job 직업,
           mem_mileage 마일리지
    FROM member
    WHERE mem_mileage >= 3000;
    
SELECT * FROM V_MEMBER01;    

(신용환 회원의 자료 검색)
SELECT mem_name, mem_job, mem_mileage
FROM member
WHERE UPPER(mem_id) = 'C001'; --대문자, 소문자인지 고민 안하려고 mem_id에 UPPER를붙여서 대문자로 바꿔준 채로 검색함

(MEMBER 테이블에서 신용환의 마일리지를 10000으로 변경)
UPDATE member 
SET mem_mileage = 10000
WHERE mem_name = '신용환'; 
--뷰는 업데이트 해주지 않았지만 원본테이블에서 업데이트 되어서 뷰에 즉각 반영됨
--테이블에서의 조작이 뷰에 반영됨

(VIEW V_MEMBER01에서 신용환의 마일리지를 500으로 변경) --뷰에 있기 때문에 뷰의 컬럼명을 맞춰사용해줘야함
UPDATE V_MEMBER01
SET 마일리지 = 500
WHERE 회원명 = '신용환';
--테이블은 업데이트 해주지 않았지만 뷰에서 업데이트 되어서 테이블에 즉각 반영됨
--뷰에서의 조작이 테이블에 반영됨
--뷰 조건이 마일리지가 3000이상인데 마일리지를 500으로 바꿔주니까 뷰에서 사라짐

(뷰 검색)
SELECT * FROM V_MEMBER01;  
(신용환 테이블 검색)
SELECT mem_name, mem_job, mem_mileage
FROM member
WHERE UPPER(mem_id) = 'C001';

--ROLLBACK; 
--밖으로 빠져나갔다오면 자동으로 커밋됨 ==> 신용환의 마일리지가 2000으로 저장됨
--롤백해도 2000이 나옴

--WITH CHECK OPTION 사용 VIEW 생성
CREATE OR REPLACE VIEW V_MEMBER01(MID, MNAME, MJOB, MILE)
AS 
    SELECT mem_id 회원번호,
           mem_name 회원명,
           mem_job 직업,
           mem_mileage 마일리지
    FROM member
    WHERE mem_mileage >= 3000
    WITH CHECK OPTION;
--뷰는 같은 이름이어도 OR REPLACE 때문에 덮어쓰게 됨

뷰의 컬럼명 부여 방식
1. 사용자가 뷰의 컬럼LIST에 지정
2. 컬럼LIST 생략 -> 원본 SELECT문의 별칭
3. 원본 SELECT문에 별칭 없을 때 -> 해당 컬럼명

(뷰 V_MEMBER01에서 신용환 회원의 마일리지를 2000으로 변경)
UPDATE V_MEMBER01
SET MILE = 2000
WHERE MNAME = '신용환';
--조건이 마일리지 3000이상인데 2000으로 변경해서 WITH CHECK OPTION 조건에 위배되서 오류남

(테이블에서 신용환 회원의 마일리지를 2000으로 변경)
UPDATE member
SET mem_mileage = 2000
WHERE UPPER(mem_id) = 'C001';
--뷰로 인해 원본테이블의 조작에 제한이 있으면 안된다 ==> 테이블 업데이트는 가능함
-- -> 원본테이블의 신용환 회원의 마일리지가 2000이 되어서 뷰 검색해보면 조건에 맞지 않는 신용환 회원 사라짐

--WITH READ ONLY 사용하여 VIEW 생성
CREATE OR REPLACE VIEW V_MEMBER01(MID, MNAME, MJOB, MILE)
AS 
    SELECT mem_id 회원번호,
           mem_name 회원명,
           mem_job 직업,
           mem_mileage 마일리지
    FROM member
    WHERE mem_mileage >= 3000
    WITH READ ONLY;

--ROLLBACK;

SELECT * FROM V_MEMBER01;

(뷰 V_MEMBER01 에서 오철희의 마일리지를 5700으로 변경)
UPDATE V_MEMBER01
SET MILE = 5700
WHERE MNAME ='오철희';
--WITH READ ONLY 옵션이 사용되어진 뷰는 조작어 (INSERT, DELETE, UPDATE 조작이 제한됨) // SELECT만 사용 가능(보기만 함)


CREATE OR REPLACE VIEW V_MEMBER01(MID, MNAME, MJOB, MILE)
AS 
    SELECT mem_id 회원번호,
           mem_name 회원명,
           mem_job 직업,
           mem_mileage 마일리지
    FROM member
    WHERE mem_mileage >= 3000
    WITH READ ONLY
    WITH CHECK OPTION;
--WITH REDA ONLY나 WITH CHECK OPTION 둘 중 하나만 써서 그거로 끝내야됨 (두개를 동시에 쓸 수 없어서 오류가 남)

SELECT HR.DEPARTMENTS.DEPARTMENT_ID,
        DEPARTMENT_NAME
    FROM HR.DEPARTMENTS;
    
문제) 사원테이블(employees)에서 50번 부서에 속한 사원 중 급여가
     5000이상인 사원번호, 사원명, 입사일, 급여를 읽기전용 뷰로 생성하시오.
     뷰 이름은 v_emp_sal01이고 컬럼명은 원본 테이블의 컬럼명을 상용
     뷰가 생성된 후 뷰와 테이블을 이용하여 해당 사원의 사원번호, 사원명, 직무명, 급여를 출력하는 sql 작성

--CREATE synonym DEPARTMENTS FOR HR.DEPARTMENTS; HR계정의 DEPARTMENTS를 DEPARTMENTS라는 이름으로 만듦 (어디서든 사용 가능)
     
CREATE OR REPLACE VIEW v_emp_sal01
AS
   SELECT employee_id, emp_name, hire_date, salary
   FROM EMPLOYEES
   WHERE department_id = 50
        AND salary >= 5000
     WITH READ ONLY;

SELECT * FROM v_emp_sal01

SELECT C.employee_id AS 사원번호,
       C.emp_name AS 사원명,
       B.job_title AS 직무명,
       C.salary AS 급여
FROM employees A, jobs B, v_emp_sal01 C
WHERE A.employee_id = C.employee_id
    AND A.job_id = B.job_id;

커서 : 실행에 의해 영향을 받은 행들 (결과로 나오는 행들)
묵시적 커서 : 익명 커서 : 열고 닫힘
SELECT문의 커서는 커서와 VIEW가 같음
이름 붙은 명시적 커서 : 오픈시켜서 하나씩 꺼내서 읽을 수 있음
읽어오는 것 : fetch












         