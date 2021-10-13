
--FUNCTION => User Defined Function 사용자 정의 함수
 --PL/SQL(절차적 언어로써의 질의어)
/*
    1. CREATE OR REPLACE FUNCTION 사용자 정의 함수명(바인드 변수...)
    2. 반환값이 있음. 일반 오라클 내장 함수처럼 사용할 수 있음
        ex) LENGTH, SUBSTR, INSTR, TO_CHAR...
    3. 반환할 데이터 타입을 RETURN으로 선언해야함
    4. 실행영역에서도 RETURN문이 있어야 함
*/ 

SET SERVEROUTPUT ON;

-- CREATE OR REPLACE FUNCTION FN_MEMNAME
-- 조건을 던져주면 회원의 이름을 리턴해주는 함수를 만들어보자
SELECT NM
FROM   EMP
WHERE  EMP_NUM = '202108001';

/
SET SERVEROUTPUT ON;
/
--P_EMP_NUM : 바인드 변수(IN/OUT) => 파라미터를 받거나 보내거나...
CREATE OR REPLACE FUNCTION FN_MEMNAME(P_EMP_NUM IN VARCHAR2)
    RETURN VARCHAR2
IS
    --SCALAR변수
    R_NM VARCHAR2(100);
BEGIN
    --PL/SQL에서의 SELECT에는 꼭 INTO 문이 있어야 한다
    SELECT NM INTO R_NM
    FROM   EMP
    WHERE  EMP_NUM = P_EMP_NUM; 
    
    DBMS_OUTPUT.PUT_LINE('생성 완료!');
    
    RETURN R_NM;
END;

--자동차번호를 통해 고객의 명을 알고자 할 때..
--101나1104
--EQUI JOIN
SELECT B.CUS_NM
FROM   CAR A, CUS B
WHERE  A.CUS_NUM = B.CUS_NUM
AND    A.CAR_NUM = '101나1104';
--INNER JOIN(ANSI표준)
SELECT B.CUS_NM
FROM   CAR A INNER JOIN CUS B ON(A.CUS_NUM = B.CUS_NUM)
WHERE  A.CAR_NUM = '101나1104';

CREATE OR REPLACE FUNCTION FN_GET_CUS_NM(P_CAR_NUM IN VARCHAR2)
 RETURN VARCHAR2
IS
    --R_CUS_NM VARCHAR2(60)
    R_CUS_NM CUS.CUS_NM%TYPE; -- REFERENCE 변수(참조변수)
BEGIN
    SELECT B.CUS_NM INTO R_CUS_NM
    FROM   CAR A INNER JOIN CUS B ON(A.CUS_NUM = B.CUS_NUM)
    WHERE  A.CAR_NUM = P_CAR_NUM;
    
    RETURN R_CUS_NM;
END;


SELECT CAR_NUM, MK, PY, DRI_DIST, FN_GET_CUS_NM(CAR_NUM) FROM CAR;


-----------------------------------------------------------------------------------------------------------------------------

/*
Package
1. 꾸러미, 포장한 상품이라는 의미
2. 업무상 관련 있는 것을 하나로 묶어서 사용
3. 여러 변수, Cursor, Function, Procedure, Exception을 묶어서 캡슐화함
4. 선언부와 본문 이렇게 두 부분으로 나뉨
5. 선언부는 패키지에 포함될 변수, Procedure, function 등을 선언함
*/

/
-- 선언부
CREATE OR REPLACE PACKAGE PKG_GET_NM
IS
    FUNCTION FN_MEMNAME(P_EMP_NUM IN VARCHAR2) RETURN VARCHAR2;
    FUNCTION FN_GET_CUS_NM(P_CAR_NUM IN VARCHAR2) RETURN VARCHAR2;
END;
/
/
-- 본문
CREATE OR REPLACE PACKAGE BODY PKG_GET_NM
IS
    -- 첫번째 함수 BODY
    FUNCTION FN_MEMNAME(P_EMP_NUM IN VARCHAR2) RETURN VARCHAR2
    IS
        --SCALAR변수
        R_NM VARCHAR2(100);
    BEGIN
        --PL/SQL에서의 SELECT에는 꼭 INTO 문이 있어야 한다
        SELECT NM INTO R_NM
        FROM   EMP
        WHERE  EMP_NUM = P_EMP_NUM; 
        
        DBMS_OUTPUT.PUT_LINE('생성 완료!');
        
        RETURN R_NM;
    END FN_MEMNAME;
    
    -- 두번째 함수 BODY
     FUNCTION FN_GET_CUS_NM(P_CAR_NUM IN VARCHAR2) RETURN VARCHAR2
     IS
        --R_CUS_NM VARCHAR2(60)
        R_CUS_NM CUS.CUS_NM%TYPE; -- REFERENCE 변수(참조변수)
     BEGIN
            SELECT B.CUS_NM INTO R_CUS_NM
            FROM   CAR A INNER JOIN CUS B ON(A.CUS_NUM = B.CUS_NUM)
            WHERE  A.CAR_NUM = P_CAR_NUM;
            
            RETURN R_CUS_NM;
     END FN_GET_CUS_NM;
END;
/

SELECT CAR_NUM, MK, PY, DRI_DIST,
       PKG_GET_NM.FN_GET_CUS_NM(CAR_NUM) 
FROM   CAR;

--------------------------------------------------------------------------------------------------------
-- 오라클 자료형(데이터 타입)
/*
    *RAW
    - 2000Byte까지 저장
    - 이진(Binary : 0 1)데이터 저장
    - 문자형 -> 이진데이터로 저장 : STRING_TO_RAW
    - 이진데이터 -> 문자형으로 읽을 때 : RAW_TO_CHAR
    
    * DBMS_CRYPTO
    - 암호화/복호화 패키지
    - 오라클 10g 이상에서 지원
    - 해시 알고리즘 제공 : 임의의 길이의 데이터를 고정길이의 해시값으로 변환
    - 데이터의 암호화 및 복호화를 위해 DES, AES등의 다양한 알고리즘 지원
    
    * DBMS_OBFUSCATION_TOOLKIT
    - 데이터를 암호화하고 복호화 하는 패키지.
    - 암호화 : 1234 -> SDJFLSKDFJALKDJ
    - 복호화 : SDJFLSKDFJALKDJ -> 1234
    
    * 대칭키 = 비밀키 = 관용키
    - DES, IDEA, SKIPJACK 등
    - 암호화와 복호화를 동일한 키를 사용 
        <-> 암호화와 복호화 시 서로 다른키를 사용하는 것은 공개키(비대칭키)
    - 보안이 뚫리면 끝    
*/

--1. 선언부
CREATE OR REPLACE PACKAGE PKG_CRYPTO
IS
    --암호화 함수 정의
    FUNCTION ENCRYPT(INPUT_STRING IN VARCHAR2) RETURN RAW;
    --복호화 함수 정의
    FUNCTION DECRYPT(INPUT_STRING IN VARCHAR2) RETURN VARCHAR2;
END PKG_CRYPTO;    

--2. 구현부
CREATE OR REPLACE PACKAGE BODY PKG_CRYPTO
IS
    -- 에러 발생시에 error code 와 message를 받기 위한 변수 지정.
    SQLERRMSG VARCHAR2(255);
    SQLERRCDE NUMBER; 
    
    --암호화 함수 구현
    FUNCTION ENCRYPT(INPUT_STRING IN VARCHAR2) RETURN RAW
    IS
        CONVERTED_RAW RAW(64);
        KEY_DATA_RAW RAW(64);
        ENCRYPTED_RAW RAW(64);
    BEGIN
        -- 대상 데이터 암호화
        -- 들어온 data와 암호 키를 각각 RAW로 변환한다.
        CONVERTED_RAW := UTL_I18N.STRING_TO_RAW(INPUT_STRING, 'AL32UTF8'); --데이터
        -- 비공개키 암호화
        KEY_DATA_RAW := UTL_I18N.STRING_TO_RAW('12345678', 'AL32UTF8'); --키
        
        -- DBMS_CRYPTO.ENCRYPT 로 암호화 하여 encrypted_raw 에 저장.
        ENCRYPTED_RAW := DBMS_CRYPTO.ENCRYPT(SRC => CONVERTED_RAW
            ,TYP => DBMS_CRYPTO.DES_CBC_PKCS5 -- typ 부분만 변경하면 원하는 알고리즘을 사용할 수 있다. key value byte 가 다 다르니 확인해야 한다.
            ,KEY => KEY_DATA_RAW
            ,IV => NULL
            );
        RETURN ENCRYPTED_RAW;    
    END ENCRYPT;
    
    --복호화 함수 구현
    FUNCTION DECRYPT(INPUT_STRING IN VARCHAR2) RETURN VARCHAR2
    IS
        KEY_DATA_RAW RAW(64);
        DECRYPTED_RAW VARCHAR2(64); --RAW 형의 VARCHAR2
        CONVERTED_STRING VARCHAR2(64);
    BEGIN
        -- INPUT_STRING (IN) 바인드 변수는 이미 이진데이터형이므로 STRING_TO_RAW를 할 필요가 없음
        -- 비공개키 암호화(대칭키이므로 동일함)
        KEY_DATA_RAW := UTL_I18N.STRING_TO_RAW('12345678', 'AL32UTF8');
        -- DECRYPT : RAW(이진데이터) -> STRING(문자데이터)
        DECRYPTED_RAW := DBMS_CRYPTO.DECRYPT(SRC => INPUT_STRING
            ,TYP => DBMS_CRYPTO.DES_CBC_PKCS5
            ,KEY => KEY_DATA_RAW
            ,IV => NULL
            );
            -- DBMS_CRYPTO.DECRYPT 결과(복호화)의 RAW 데이터를 VARCHAR2로 변환
        CONVERTED_STRING := UTL_I18N.RAW_TO_CHAR(DECRYPTED_RAW, 'AL32UTF8');    
        RETURN CONVERTED_STRING;
    END DECRYPT;
END PKG_CRYPTO;
/

SELECT PKG_CRYPTO.ENCRYPT('test') FROM DUAL;
SELECT PKG_CRYPTO.DECRYPT('CC55CDA07F1C8F7A') FROM DUAL;

COMMIT;

SELECT *
FROM EMP

--기존 비밀번호를 암호화 처리
UPDATE EMP
SET PWD = PKG_CRYPTO.ENCRYPT(PWD);

--로그인
SELECT *
FROM EMP
WHERE EMP_NUM = '202108001' AND PWD =PKG_CRYPTO.ENCRYPT('1234');

--CUS 테이블에 비밀번호 암호화해서 넣기
INSERT INTO CUS(CUS_NUM, CUS_NM, ADDR1, PNE, PWD, ZIPCODE)
VALUES(
    (SELECT NVL(MAX(CUS_NUM),0)+1 FROM CUS),
    '김은대',
    '대전 송촌동 선화마을',
    '01011112222',
    PKG_CRYPTO.ENCRYPT('java'),
    '11233'
);

SELECT *
FROM CUS

--CUS테이블 비밀번호 암호화시켜서 업데이트하기
UPDATE CUS
SET PWD = PKG_CRYPTO.ENCRYPT(PWD)
WHERE CUS_NUM < 4;

COMMIT;


SELECT T.*
		FROM
		(
		SELECT ROW_NUMBER() OVER (ORDER BY CUS_NUM DESC) RNUM,
		CUS_NUM, CUS_NM, ADDR1, PNE, PWD, CUS_DETAIL, CUS_IMAGE, ADDR2, ZIPCODE
		FROM CUS
		)T
		WHERE T.RNUM BETWEEN 2 * 15 - 14 AND 2 * 15
        
        