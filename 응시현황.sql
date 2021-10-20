 
--시험별 학생 점수 조회
SELECT A.*, NVL(B.SUM_POINT, 0) SUM_POINT, C.MEM_NAME, D.TEST_TITLE
FROM (SELECT TEST_ID, STU_ID
        FROM STU_ANSWER
        WHERE TEST_ID = '44'
        GROUP BY TEST_ID, STU_ID) A,
     (SELECT STU_ID, SUM(QUEST_POINT) SUM_POINT
        FROM STU_ANSWER
        WHERE TEST_ID = '44'
        AND QUEST_MATCH ='Y'
        GROUP BY STU_ID) B, MEMBER C,
        TEST D
WHERE A.STU_ID = B.STU_ID(+)
AND A.STU_ID = C.MEM_ID(+)
AND A.TEST_ID = D.TEST_ID
;

--정답률
SELECT A.*, NVL(B.ANSWER_CNT, 0) ANSWER_CNT, ROUND(NVL(B.ANSWER_CNT, 0)/QUEST_STU_TOTAL*100, 2) ANSWER_PER
FROM (SELECT QUEST_ID, TEST_ID, COUNT(*) QUEST_STU_TOTAL
        FROM STU_ANSWER
        WHERE TEST_ID ='44'
        GROUP BY QUEST_ID, TEST_ID) A,
    (SELECT QUEST_ID, TEST_ID, COUNT(QUEST_MATCH) ANSWER_CNT
        FROM STU_ANSWER
        WHERE TEST_ID ='44'
        AND QUEST_MATCH ='Y'
        GROUP BY QUEST_ID, TEST_ID) B
WHERE A.QUEST_ID = B.QUEST_ID(+)
ORDER BY TO_NUMBER(A.QUEST_ID)
;


SELECT QUEST_CONTENT, QUEST_ANSWER, QUEST_POINT, QUEST_TYPE, QUEST_LEVEL, QUEST_COMMENT, EX1, EX2, EX3, EX4, EX5, TEST_ID, QUEST_ATFILE_ID
FROM TEST_QUEST
WHERE TEST_ID IN (SELECT TEST_ID FROM TEST WHERE TEST_EXAMINER = 'teach01');








