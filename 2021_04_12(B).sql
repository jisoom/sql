2021-04-12 보강
1. ROLLUP
- GROUP BY 절과 같이 사용하여 추가적인 집계정보를 제공함
-명시한 표현식의 수와 순서(오른쪽에서 왼쪽 순)에 따라 레벨 별로 집계한 결과를 반환함
-표현식이 n개 사용된 경우 n+1 가지의 집계 반환

(사용형식)
SELECT 컬럼list
FROM 테이블명
WHERE 조건
GROUP BY [컬럼명] ROLLUP [컬럼명1, 컬럼명2, ... 컬럼명 n]
.ROLLUP안에 기술된 컬럼명 1, 컬럼명2, ...컬럼명 n을 오른쪽 부터 왼쪽 순으로 레벨화시키고 그것을 기준으로한 집계결과 반환
period : (연도 4자리 + 월2자리)월별
region : 17개 광역시도
gubun : 주택담보대출
loan jan amt : 대출잔액 합계

kor_loan_status
사용예) 우리나라 광역시도의 대출현황테이블에서 기간별(년), 지역별 구분별
       잔액합계를 조회하시오
       
SELECT SUBSTR(PERIOD,1,4) AS "기간별(년)", 
       REGION AS 지역,
       GUBUN AS 구분,
       SUM(LOAN_JAN_AMT) AS 잔액합계
  FROM KOR_LOAN_STATUS
 GROUP BY SUBSTR(PERIOD,1,4), REGION, GUBUN
 ORDER BY 1;
        
(ROLLUP 사용)
SELECT SUBSTR(PERIOD,1,4) AS "기간별(년)", 
       REGION AS 지역,
       GUBUN AS 구분,
       SUM(LOAN_JAN_AMT) AS 잔액합계
  FROM KOR_LOAN_STATUS
 GROUP BY ROLLUP(SUBSTR(PERIOD,1,4), REGION, GUBUN)
 ORDER BY 1;
 --구분을 기준으로 잔액합계(기타대출, 주택담보대출) 나오고 기간, 지역을 기준으로 잔액합계 2개가 합쳐진 값 1개 나옴, 기간을 기준으로 잔액합계 3개 모두 합쳐진 값 1개 나옴
 --마지막에 전체 기준 다 NULL로 한 총 합계(전체 집계) 나옴
 
(부분 ROLLUP) 
SELECT SUBSTR(PERIOD,1,4) AS "기간별(년)", 
       REGION AS 지역,
       GUBUN AS 구분,
       SUM(LOAN_JAN_AMT) AS 잔액합계
 FROM KOR_LOAN_STATUS
 GROUP BY SUBSTR(PERIOD,1,4),ROLLUP(REGION, GUBUN)
 ORDER BY 1;
--SUBSTR(PERIOD,1,4)이 ROLLUP 밖이라 전체집계 안나옴(3가지 집계 나옴)
 
 
 2.CUBE
 -GROUP BY 절과 같이 사용하여 추가적인 집계정보를 제공함
 -CUBE절 안에 사용된 컬럼의 조합가능한 가지 수 만큼의 종류별 집계 반환(2의 n승)
 (CUBE 사용)
 SELECT SUBSTR(PERIOD,1,4) AS "기간별(년)", 
       REGION AS 지역,
       GUBUN AS 구분,
       SUM(LOAN_JAN_AMT) AS 잔액합계
  FROM KOR_LOAN_STATUS
 GROUP BY CUBE(SUBSTR(PERIOD,1,4), REGION, GUBUN)
 ORDER BY 1;
 

 

         
       