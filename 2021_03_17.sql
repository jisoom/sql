WHERE 조건1 :10건

WHERE 조건1
WHERE 조건2 : 10건 넘을 수 없음

WHERE dept = 10
    AND sal > 500
    
table 객체의 특징 : 입력, 조회할 때 순서가 없다
(오늘 조회했을 때와 내일 조회했을 때 순서가 달라질 수 있다)

Function
Single row function
단일 행을 기준으로 작업하고, 행당 하나의 결과를 반환
특정 컬럼의 문자열 길이 : length(ename)

Multi row function
여러 행을 기준으로 작업하고, 하나의 결과를 반환
그룹함수
count, sum, avg

함수명을 보고
1. 파라미터(인자)가 어떤게 들어갈까 ?
2. 몇개의 파라미터가 들어갈까 ?
3. 반환되는 값을 무엇일까?

Single row function

character 
대소문자
-LOWER 소문자로 만들어줌 (입력값 : 문자, 1개, 반환되는 값 : 소문자로 바뀐 문자)
-UPPER 대문자로 만들어줌
-INITCAP 첫글자를 대문자로 만들어줌

문자열 조작
-CONCAT 연쇄 : 문자열 묶어서 이음 (인자2개, 반환되는 값 : 결합된 문자열 1개)
-SUBSTR 부분 문자열 문자열의 일부분빼옴 SUBSTR(1, 3) SMITH -> SMI (1번째부터 3번째까지)
-LENGTH 문자열의 길이를 반환해줌
-INSTR 특정 문자열에 검색하고 싶은 문자 있는지 검색
-LPAD RPAD 왼쪽이나 오른쪽에 문자 추가하기 
-TRIM 공백 제거, 문자열의 시작과 종료만 제거함, 중간은 제거하지 않음
-REPLACE 대상문자열에서 특정 문자를 다른 문자로 바꾸고 싶을 때 사용 (인자 3개)

SELECT * | {컬럼 column | 표현식 expression}

SELECT ename, LOWER(ename), UPPER(ename), INITCAP(ename), LOWER('TEST'),
        SUBSTR(ename, 1, 3), SUBSTR(ename, 2), --2번째부터 끝까지
        REPLACE(ename,'S','T')
FROM emp;

DUAL table
-sys 계정에 있는 테이블
-누구나 사용가능
-DUMMY 컬럼하나만 존재하며 값은 'X'이며 데이터는 한 행만 존재
사용용도
-데이터와 관련없이
    =>함수실행
    =>시퀀스실행
-merge문에서 merge : INSERT + UPDATE
-데이터 복제시(connect by level)

SELECT *
FROM dual;

SELECT 1
FROM emp;

SELECT LENGTH('TEST')
FROM emp;

SELECT LENGTH('TEST')
FROM dual
CONNECT BY LEVEL <= 10;

SINGLE ROW FUNCTION : WHERE절에서도 사용 가능
--emp 테이블에 등록된 직원들 중에 직원의 이름이 5글자를 초과하는 직원만 조회
SELECT *
FROM emp
WHERE LENGTH(ename) > 5;

SELECT *
FROM emp
WHERE LOWER(ename) = 'smith'; --emp 테이블에 있는 ename을 전부 LOWER해보고 비교해봐야함 (권장하지 않음)

SELECT *
FROM emp
WHERE ename = UPPER('smith'); -- ename = 'SMITH'를 권장함

엔코아 ==> 엔코아_부사장 : b2en ==> b2en 대표컨설턴트 : dbian

ORACLE 문자열 함수
'HELLO'||','||WORLD

SELECT CONCAT('HELLO',CONCAT(',','WORLD')) CONCAT,--마지막 CONCAT은 ALIAS로 쓰임 //인자 2개만 가능 , 3개는 못함
       SUBSTR('HELLO, WORLD',1,5) SUBSTR,
       LENGTH('HELLO, WORLD') LENGTH, --공백도 문자열임
       INSTR('HELLO, WORLD', 'O') INSTR,
       INSTR('HELLO, WORLD', 'O', 6) INSTR2,
       LPAD('HELLO, WORLD', 15, '-') LPAD, --왼쪽에 부족한 글자 수 만큼 padding
       RPAD('HELLO, WORLD', 15, '-') RPAD,
       REPLACE ('HELLO, WORLD', 'O', 'X') REPLACE,
       TRIM ('  HELLO, WORLD  ') TRIM, --공백을 제거, 문자열의 앞과 뒷부분에 있는 공백만 제거하고 가운데 공백은 건들지 않음
       TRIM ('D' FROM 'HELLO, WORLD') --TRIM -HELLO, WORLD에서 D를 없애겠다
FROM dual;

--------------------------------------------------------------------------------------------------------------------------

number
숫자조작
-ROUND : 반올림 (인자 2개)
-TRUNC : 내림 (인자 2개)
-MOD : 나눗셈의 나머지 (인자 2개)


--java : 10 % 3 => 1;
--SELECT 10 % 3 --SQL에서는 오류
--FROM dual;

피제수 : 10, 제수 : 3
SELECT MOD(10,3)
FROM dual;

-- java : alt +shift + a : 세로 편집기(위, 아래 동시에 편집하기)

반올림
SELECT
ROUND(105.54, 1) round1, --반올림 결과가 소수점 첫번째 자리까지 나오도록 (소수점 둘째자리에서) : 105.5
ROUND(105.55, 1) round2, --반올림 결과가 소수점 첫번째 자리까지 나오도록 (소수점 둘째자리에서) : 105.6
ROUND(105.55, 0) round3, --반올림 결과가 첫번째 자리(일의 자리)까지 나오도록 (소수점 첫째자리에서) :106
ROUND(105.55, -1) round4, --반올림 결과가 두번째 자리(십의 자리)까지 나오도록 (정수 첫째자리에서) :110 
ROUND(105.55) round5 --두번째 인자를 생략하면 인자를 0으로 한 것과 결과가 같음 (소수점 첫째자리에서)
FROM dual;

절삭(버림)
SELECT
TRUNC(105.54, 1) trunc1, --반올림 결과가 소수점 첫번째 자리까지 나오도록 (소수점 둘째자리에서) : 105.5
TRUNC(105.55, 1) trunc2, --반올림 결과가 소수점 첫번째 자리까지 나오도록 (소수점 둘째자리에서) : 105.5
TRUNC(105.55, 0) trunc3, --반올림 결과가 첫번째 자리(일의 자리)까지 나오도록 (소수점 첫째자리에서) :105
TRUNC(105.55, -1) trunc4, --반올림 결과가 두번째 자리(십의 자리)까지 나오도록 (정수 첫째자리에서) :100
TRUNC(105.55) trunc5 --두번째 인자를 생략하면 인자를 0으로 한 것과 결과가 같음 (소수점 첫째자리에서)
FROM dual;

-ex : 7499, ALLEN,  1600, 1, 600
SELECT empno, ename, sal, sal을 1000으로 나눴을 때의 몫, sal을 1000으로 나눴을 때의 나머지
FROM emp;

SELECT empno, ename, sal, TRUNC(sal/1000,0), MOD(sal,1000)
FROM emp;

---------------------------------------------------------------------------------------------------------------------------

날짜 <==> 문자
서버의 현재 시간 : SYSDATE
LENGTH('TEST')
SYSDATE --오라클에서는 인자가 없는 함수는 ()안씀 // 자바는 인자가 없더라도 ()써줌

--서버 시간 포맷 변경
-- 도구 -> 환경설정 -> 데이터 베이스 -> NLS -> YYYY/MM/DD HH24:MI:SS로 변경

SELECT SYSDATE
FROM dual;

SELECT SYSDATE, SYSDATE + 1/24/60/60 -- +1 :1일 더해짐, +1/24 :1시간 더해짐 +1/24/60 : 1분 더해짐 +1/24/60/60 : 1초 더해짐
FROM dual;

Function (date 실습 fn1)
1. 2019년 12월 31일을 date형으로 표현
2. 2019년 12월 31일을 date형으로 표현하고 5일 이전 날짜
3. 현재날짜
4. 현재날짜에서 3일 전 값

위 4개 컬럼을 생성하여 다음과 같이 조회하는 쿼리를 작성하세요

SELECT TO_CHAR(TO_DATE('2019/12/31','YYYY/MM/DD'), 'YYYY') AS LASTDAY ,
       TO_DATE('2019/12/31','YYYY/MM/DD') - 5 AS LASTDAY_BEFORE5,
       SYSDATE AS NOW, 
       SYSDATE - 3 AS NOW_BEFORE3
FROM dual;

문자 ==> 날짜
TO_DATE : 인자: 문자, 문자의 형식

날짜 ==> 문자
TO_CHAR : 인자: 날짜, 문자의 형식

NLS : YYYY/MM/DD HH24:MI:SS
SELECT SYSDATE, TO_CHAR(SYSDATE, 'YYYY/MM/DD')
FROM dual;

총 52 ~ 53주
--무슨 요일인가? 포맷 : D //0 : 일요일 1: 월요일 2: 화요일 ... 6:토요일
SELECT SYSDATE, TO_CHAR(SYSDATE, 'IW'), TO_CHAR(SYSDATE, 'D') -- IW : 몇 주차인가?
FROM dual;

Function (date)

date
FORMAT
-YYYY :4자리 년도
-MM : 2자리 월
-DD : 2자리 일자
-D : 주간 일자 (1~7)
-IW : 주차(1~53)
-HH, HH12 : 2자리 시간 (12시간 표현)
-HH24 : 2자리 시간 (24시간 표현)
-MI : 2자리 분
-SS : 2자리 초

fn2

오늘 날짜를 다음과 같은 포맷으로 조회하는 쿼리를 작성하시오
1. 년-월-일
2. 년-월-일 시간(24)-분-초
3. 일-월-년

SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD')AS DT_DASH,
       TO_CHAR(SYSDATE,'YYYY-DD-MM HH24:MI:SS')AS DT_DASH_WITH_TIME,
       TO_CHAR(SYSDATE, 'DD-MM-YYYY') AS DT_DD_MM_YYYY
FROM dual;

SELECT TO_DATE(TO_CHAR(SYSDATE,'YYYY-MM-DD'),'YYYY-MM-DD')AS DT_DASH
FROM dual;  --시,분,초 정보를 날려버리고 싶을 때 사용

'2021-03-17'=> '2021-03-17 12:41:00'

SELECT TO_CHAR(SYSDATE,'YYYY/MM/DD HH24:MI:SS')
FROM dual;

SELECT TO_CHAR(TO_DATE('2021-03-17','YYYY-MM-DD'),'YYYY-MM-DD HH24:MI:SS')
FROM dual;




과제) 유투브 - grit, 노마드코더 동영상 보고 느낀점