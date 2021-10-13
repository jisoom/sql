CREATE TABLE MEMBER(
    MEMBERID VARCHAR2(50),
    NAME VARCHAR2(150),
    PASSWORD VARCHAR2(100),
    REGDATE DATE,
    CONSTRAINT PK_MEMBER PRIMARY KEY(MEMBERID)
);

COMMENT ON TABLE MEMBER IS '회원';

COMMENT ON COLUMN MEMBER.MEMBERID IS '회원 아이디';
COMMENT ON COLUMN MEMBER.NAME IS '회원 이름';
COMMENT ON COLUMN MEMBER.PASSWORD IS '비밀번호';
COMMENT ON COLUMN MEMBER.REGDATE IS '등록일';

COMMIT;
SELECT NVL(MAX(ARTICLE_NO),0) + 1 FROM ARTICLE;
SELECT MAX(ARTICLE_NO) FROM ARTICLE;

SELECT * FROM ARTICLE A, ARTICLE_CONTENT B
WHERE A.ARTICLE_NO = B.ARTICLE_NO;

SELECT ROW_NUMBER() OVER (ORDER BY ARTICLE_NO DESC) RNUM
        ,ARTICLE_NO, WRITER_ID, WRITER_NAME
        ,TITLE, REGDATE, MODDATE, READ_CNT FROM ARTICLE