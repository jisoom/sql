SELECT TEST_SCORE, LEC_OPEN_ID, TEST_RANK, TEST_ID, TEST_TITLE, STU_ID, TO_CHAR(TEST_DATE, 'YYYY-MM-DD') TEST_DATE, TEST_TOTAL_SCORE
FROM STU_SCORE
WHERE LEC_OPEN_ID = 1
AND TEST_ID = 'T1'
AND STU_ID = 'stu01'

SELECT ROUND(AVG(TEST_SCORE),1)
FROM STU_SCORE
WHERE LEC_OPEN_ID = 1
AND TEST_ID = 'T1'

SELECT MEM_ID, MEM_PW, MEM_BIR, MEM_NAME, MEM_PHN, MEM_EMAIL, POST, ADDR, ADDR_DETAIL, PROTEC_NAME, PROTEC_PHN, ATFILE_ID, SCH_NAME
FROM MEMBER
WHERE MEM_ID = 'stu01';

SELECT TEST_SCORE,  COUNT(STU_ID) SAME_SCORE_CNT 
FROM STU_SCORE
WHERE LEC_OPEN_ID = 1
AND TEST_ID = 'T1'
GROUP BY(TEST_SCORE)
ORDER BY TEST_SCORE

SELECT TEST_ID, TEST_SCORE
FROM STU_SCORE
WHERE LEC_OPEN_ID = 1
AND STU_ID = 'stu01'
ORDER BY TEST_ID