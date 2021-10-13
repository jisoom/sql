CREATE TABLE BOOK(
    BOOK_ID NUMBER,
    TITLE VARCHAR2(600),
    CATEGORY VARCHAR2(600),
    PRICE NUMBER,
    CONSTRAINT PK_BOOK PRIMARY KEY(BOOK_ID)
);

--DISCRIBE 테이블 스키마 구조를 보기
DESC BOOK;
--NVL(널이 있나 봐라)
SELECT NVL(MAX(BOOK_ID),0)+1 FROM BOOK;

INSERT INTO BOOK(BOOK_ID, TITLE, CATEGORY, PRICE)
VALUES(
    (SELECT NVL(MAX(BOOK_ID),0)+1 FROM BOOK),
    '제목',
    '카테고리',
    10000
);

SELECT * FROM BOOK;

SELECT BOOK_ID, TITLE, CATEGORY, PRICE
FROM BOOK
WHERE BOOK_ID =1;

/*
LIKE와 함께 사용하는 %, _ : 와일드 카드
1) % : 여러 글자
2) _ : 한 글자
*/

SELECT ROW_NUMBER() OVER (ORDER BY BOOK_ID DESC) RNUM
,BOOK_ID AS bookId, TITLE, CATEGORY, PRICE
FROM BOOK
WHERE 1=1
AND TITLE LIKE '%여%' OR CATEGORY LIKE '%여%'
;
--데이터 있는지 먼저 검증 후 업데이트 실행
SELECT * FROM BOOK WHERE BOOK_ID = 2;
UPDATE BOOK
SET TITLE = '제리소여모험', CATEGORY = '전설', PRICE = '10000'
WHERE BOOK_ID = 2

--등푸른생선주세여
DELETE FROM BOOK
WHERE BOOK_ID= 7