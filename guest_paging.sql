select *
from
(
    select ROWNUM RNUM, t.message_id, t.guest_name, t.password, t.message
    from
    (
        select message_id, guest_name, password, message
        from guestbook_message
        order by message_id desc
    ) t
)
where RNUM BETWEEN 7 AND 9;

SELECT ROW_NUMBER () OVER (ORDER BY MESSAGE_ID DESC)
    ,MESSAGE_ID, GUEST_NAME, PASSWORD, MESSAGE
    FROM GUESTBOOK_MESSAGE;
    
SELECT *
FROM
(
    SELECT ROW_NUMBER () OVER (ORDER BY MESSAGE_ID DESC) RNUM
            ,MESSAGE_ID, GUEST_NAME, PASSWORD, MESSAGE
    FROM GUESTBOOK_MESSAGE
) T
WHERE T.RNUM BETWEEN 7 AND 9;  