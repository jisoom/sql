select *
from TB_JDBC_BOARD

insert into TB_JDBC_BOARD(BOARD_NO, TITLE, CONTENT, WRITER)
values(1, '바보', '지수','안녕');

insert into TB_JDBC_BOARD(BOARD_NO, TITLE, CONTENT, WRITER)
values(2, '바보', '지수','안녕');


SELECT COUNT(BOARD_NO)+1
FROM TB_JDBC_BOARD

--insert into TB_JDBC_BOARD
--values(SELECT COUNT(BOARD_NO)+1 FROM TB_JDBC_BOARD,'바보', '지수','안녕')

ALTER TABLE TB_JDBC_BOARD
    RENAME COLUMN WRITER TO USER_ID;
    
UPDATE TB_JDBC_BOARD
SET TITLE = '멍청이',CONTENT = '짖우'
WHERE BOARD_NO = 2;

DELETE TB_JDBC_BOARD
WHERE BOARD_NO = 4




COMMIT;
