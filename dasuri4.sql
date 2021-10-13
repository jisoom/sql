-----------------다중 INSERT-------------------
INSERT ALL
    INTO CAR VALUES(1,2,3,4,4)
    INTO CAR VALUES(5,6,7,8,4)
    INTO CAR VALUES(9,10,11,12,4)
SELECT * FROM DUAL;    

SELECT * FROM CAR;

rollback;

----------------계층형 쿼리---------------------
SELECT  LEVEL
        ,NUM
        ,LPAD(' ', 2 * (LEVEL-1)) || TITLE AS TITLE--레벨만큼 공백채움
        ,WRITER
        ,P_NUM
FROM FREEBOARD
START WITH P_NUM IS NULL --최상위 댓글
CONNECT BY PRIOR NUM = P_NUM;

SELECT LPAD('* ',5) FROM DUAL;

-----------------ROWNUM 처리하기-------------------------------
SELECT  ROWNUM RNUM
        ,T.LVL, T.NUM, T.TITLE, T.P_NUM
FROM
(
    SELECT  LEVEL LVL
            ,NUM
            ,LPAD(' ', 2 * (LEVEL-1)) || TITLE AS TITLE--레벨만큼 공백채움
            ,WRITER
            ,P_NUM
    FROM FREEBOARD
    START WITH P_NUM IS NULL --최상위 댓글
    CONNECT BY PRIOR NUM = P_NUM
) T;
--WHERE T.TITLE LIKE '%여름%';


-----------------------------------------------------------------
UNION 합집합 중복1회
UNION ALL 합집합 중복ALL
INTERSECT 교집합
MINUS 차집합
-------------직원, 고객 로그인--------------------------------------
WITH T AS(
SELECT EMP_NUM, NM, ADDR, PNE, SAL, PWD, ADMIN_YN
		FROM EMP
UNION        
SELECT CUS_NUM, CUS_NM, ZIPCODE || ' ' || ADDR1 ||' ' || ADDR2, PNE, 0, PWD, ''
FROM CUS)
SELECT T.EMP_NUM, T.NM, T.ADDR, T.PNE, T.SAL, T.PWD, T.ADMIN_YN FROM T
WHERE T.EMP_NUM = '2' AND T.PWD= PKG_CRYPTO.ENCRYPT('5678');

SELECT PKG_CRYPTO.DECRYPT('CC55CDA07F1C8F7A') FROM DUAL;

COMMIT


SELECT A.NUM, B.CUS_NM AS WRITER, A.P_NUM, A.CONTENT
FROM FREEBOARD A, CUS B
WHERE A.WRITER = B.CUS_NUM;


