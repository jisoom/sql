---------------------------트리거 시작----------------------------

--직원 테이블 생성
CREATE TABLE EMP01(
    EMPNO NUMBER(4) PRIMARY KEY,
    EMPNAME VARCHAR2(45),
    EMPJOB VARCHAR2(60)
);

--급여 테이블 생성
CREATE TABLE SAL01(
    SALNO NUMBER(4) PRIMARY KEY,
    SAL NUMBER(7,2),
    EMPNO NUMBER(4) REFERENCES EMP01(EMPNO)
);


--시퀀스 생성(1부터 시작해서 1씩 증가시킴)
CREATE SEQUENCE SAL01_SALNO_SEQ
START WITH 1
INCREMENT BY 1;



--직원(EMP01)이 등록(INSERT 이벤트)되고 난 후(AFTER 타이밍) -> 직원번호 1
--급여(SAL01)테이블에 200을 INSERT함 -> 직원번호 1(자동)
-- 삽입 트리거 생성
CREATE OR REPLACE TRIGGER TRG_01
    AFTER INSERT
    ON EMP01
FOR EACH ROW    
BEGIN
    INSERT INTO SAL01(SALNO, SAL, EMPNO)
    VALUES(SAL01_SALNO_SEQ.NEXTVAL, 200, :NEW.EMPNO);
END;
/

--트리거로 인해 EMP01에 데이터 넣으면 SAL01에도 자동 등록됨
INSERT INTO EMP01(EMPNO, EMPNAME, EMPJOB)
VALUES(1, '개똥이', '개발자');
INSERT INTO EMP01(EMPNO, EMPNAME, EMPJOB)
VALUES(2, '김은대', '개발자');
INSERT INTO EMP01(EMPNO, EMPNAME, EMPJOB)
VALUES(3, '이쁜이', '개발자');
INSERT INTO EMP01(EMPNO, EMPNAME, EMPJOB)
VALUES(4, '신용환', '개발자');
INSERT INTO EMP01(EMPNO, EMPNAME, EMPJOB)
VALUES(5, '이순신', '개발자');

--조인해서 데이터 한번에 조회
SELECT * 
FROM EMP01 A, SAL01 B
WHERE A.EMPNO = B.EMPNO;

--삭제하면 child record found 오류 발생
DELETE FROM EMP01
WHERE EMPNO = 5;

--어떤 제약사항인지 알 수 있음
SELECT * FROM USER_CONSTRAINTS WHERE CONSTRAINT_NAME = 'SYS_C007580';

--삭제 트리거 생성
CREATE OR REPLACE TRIGGER TRG_02
    AFTER DELETE
    ON EMP01
FOR EACH ROW
BEGIN
    DELETE FROM SAL01 WHERE EMPNO = :OLD.EMPNO;
END;
/
--삭제 트리거 생성후 다시 삭제
DELETE FROM EMP01
WHERE EMPNO = 5;

--트리거 삭제
DROP TRIGGER TRG_02;

--둘 중 하나만 해야 함(부모테이블 데이터 삭제 시 자식 테이블 데이터도 함께 삭제하기)
--1. 테이블 편집에서 제약 조건 - 외래키 - 삭제시 - 종속삭제
--2. 트리거 생성

---------------------------트리거 끝----------------------------
--특정고객이 소유하고 있는 자동차 댓수 조회
SELECT COUNT(*) CNT
		FROM CAR
		WHERE CUS_NUM = 2;
        
--고객명, 주소, 연락처로 검색하기        
SELECT ROW_NUMBER() OVER (ORDER BY CUS_NUM DESC) RNUM,
		CUS_NUM, CUS_NM, ADDR1, PNE, PWD, CUS_DETAIL, CUS_IMAGE, ADDR2, ZIPCODE
FROM CUS
WHERE 1=1
AND CUS_NM LIKE '%이%'
AND ADDR1 || ADDR2 LIKE '%대전%'
AND PNE LIKE '%010%';