
--jspexam계정..
CREATE TABLE ITEM(
    ITEM_ID NUMBER,
    ITEM_NAME VARCHAR2(300),
    PRICE NUMBER,
    DESCRIPTION VARCHAR2(1000),
    PICTURE_URL VARCHAR2(600),
    CONSTRAINT PK_ITEM PRIMARY KEY(ITEM_ID)
);

DESC ITEM;

--insert 확인용
INSERT INTO ITEM(ITEM_ID, ITEM_NAME, PRICE, DESCRIPTION, PICTURE_URL)
VALUES(
    (SELECT NVL(MAX(ITEM_ID),0)+1 FROM ITEM),
    '자전거', 20000, '자전거 개요글', 'bicycle.jpg'
);

rollback;

SELECT * FROM ITEM;

SELECT NVL(MAX(SEQ),0) + 1 FROM ITEM_ATCH
