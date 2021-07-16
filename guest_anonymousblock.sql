select * from guestbook_message order by message_id

DECLARE
    CNT NUMBER := 3;
BEGIN
    FOR I IN 1..30 LOOP
    INSERT INTO GUESTBOOK_MESSAGE(MESSAGE_ID, GUEST_NAME, PASSWORD, MESSAGE)
    VALUES(
        (SELECT NVL(MAX(MESSAGE_ID),0) + 1 FROM GUESTBOOK_MESSAGE),
        '개똥이'||CNT,
        '1234',
        '메시지'||CNT
    );
    CNT := CNT + 1;
    END LOOP;
    COMMIT;
END;

--PL/SQL
--패키지
--사용자정의함수
--저장프로시저
--트리거
--익명블록