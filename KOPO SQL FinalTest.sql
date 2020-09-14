-- Step 1. 6개의 예측 결과값을 병합한다.
-- 주의 : 최근 주차를 기준으로 과거 데이터를 붙인다.
--CREATE TABLE MAPE_STEP1 AS    --CREATE 한 후 주석처리
SELECT A.PRD_SEG1 AS SEG1,
       A.PRD_SEG2 AS SEG2,
       11||A.PRD_SEG3 AS SEG3,
       A.YEAR||A.WEEK AS TARGETWEEK,
       A.YEAR,
       A.WEEK,
       A.QTY,
       F.OUTFCST AS FCST_W6,
       E.OUTFCST AS FCST_W5,
       D.OUTFCST AS FCST_W4,
       C.OUTFCST AS FCST_W3,
       B.OUTFCST AS FCST_W2,
       A.OUTFCST AS FCST_W1
FROM PRO_FCST_RESULT_1WEEK A
LEFT JOIN PRO_FCST_RESULT_2WEEK B
    ON 1=1
    AND (A.PRD_SEG1 = B.PRD_SEG1)
    AND (A.PRD_SEG2 = B.PRD_SEG2)
    AND (A.PRD_SEG3 = B.PRD_SEG3)
    AND (A.YEAR = B.YEAR)
    AND (A.WEEK = B.WEEK AND A.WEEK = 18)
LEFT JOIN PRO_FCST_RESULT_3WEEK C
    ON 1=1
    AND (A.PRD_SEG1 = C.PRD_SEG1)
    AND (A.PRD_SEG2 = C.PRD_SEG2)
    AND (A.PRD_SEG3 = C.PRD_SEG3)
    AND (A.YEAR = C.YEAR)
    AND (A.WEEK = C.WEEK AND A.WEEK = 18)
LEFT JOIN PRO_FCST_RESULT_4WEEK D
    ON 1=1
    AND (A.PRD_SEG1 = D.PRD_SEG1)
    AND (A.PRD_SEG2 = D.PRD_SEG2)
    AND (A.PRD_SEG3 = D.PRD_SEG3)
    AND (A.YEAR = D.YEAR)
    AND (A.WEEK = D.WEEK AND A.WEEK = 18)
LEFT JOIN PRO_FCST_RESULT_5WEEK E
    ON 1=1
    AND (A.PRD_SEG1 = E.PRD_SEG1)
    AND (A.PRD_SEG2 = E.PRD_SEG2)
    AND (A.PRD_SEG3 = E.PRD_SEG3)
    AND (A.YEAR = E.YEAR)
    AND (A.WEEK = E.WEEK AND A.WEEK = 18)
LEFT JOIN PRO_FCST_RESULT_6WEEK F
    ON 1=1
    AND (A.PRD_SEG1 = F.PRD_SEG1)
    AND (A.PRD_SEG2 = F.PRD_SEG2)
    AND (A.PRD_SEG3 = F.PRD_SEG3)
    AND (A.YEAR = F.YEAR)
    AND (A.WEEK = F.WEEK AND A.WEEK = 18)
ORDER BY SEG1 ASC, SEG2 ASC, SEG3 ASC;


-- STEP 1. 검증
SELECT * FROM MAPE_STEP1;   -- 스텝 1단계 저장본.. 문제푼거

SELECT * FROM PRO_FCST_EXCEL_KEY   -- 엑셀파일.. 답지
ORDER BY SEG1 ASC, SEG2 ASC, SEG3 ASC;

-- 검증 1. 컬럼수 비교
SELECT COUNT(*)
FROM MAPE_STEP1;

SELECT COUNT(*)
FROM PRO_FCST_EXCEL_KEY;

-- 검증 2. 합의 차 비교
SELECT SUM(A.FCST_W6 - B.FCST_W6) AS DIFF_FCST_W6,
       SUM(A.FCST_W5 - B.FCST_W5) AS DIFF_FCST_W5,
       SUM(A.FCST_W4 - B.FCST_W4) AS DIFF_FCST_W4,
       SUM(A.FCST_W3 - B.FCST_W3) AS DIFF_FCST_W3,
       SUM(A.FCST_W2 - B.FCST_W2) AS DIFF_FCST_W2,
       SUM(A.FCST_W1 - B.FCST_W1) AS DIFF_FCST_W1
FROM MAPE_STEP1 A
FULL OUTER JOIN PRO_FCST_EXCEL_KEY B
    ON 1=1
    AND (A.SEG1 = B.SEG1)
    AND (A.SEG2 = B.SEG2)
    AND (A.SEG3 = B.SEG3)
    AND (A.YEAR = B.YEAR)
    AND (A.WEEK = B.WEEK AND A.WEEK = 18)

-- 검증 3. 각 컬럼 차 비교
SELECT (A.FCST_W6 - B.FCST_W6) AS DIFF_FCST_W6,
       (A.FCST_W5 - B.FCST_W5) AS DIFF_FCST_W5,
       (A.FCST_W4 - B.FCST_W4) AS DIFF_FCST_W4,
       (A.FCST_W3 - B.FCST_W3) AS DIFF_FCST_W3,
       (A.FCST_W2 - B.FCST_W2) AS DIFF_FCST_W2,
       (A.FCST_W1 - B.FCST_W1) AS DIFF_FCST_W1
FROM MAPE_STEP1 A
FULL OUTER JOIN PRO_FCST_EXCEL_KEY B
    ON 1=1
    AND (A.SEG1 = B.SEG1)
    AND (A.SEG2 = B.SEG2)
    AND (A.SEG3 = B.SEG3)
    AND (A.YEAR = B.YEAR)
    AND (A.WEEK = B.WEEK AND A.WEEK = 18)

-- 검증 3.1 (Advanced)각 컬럼 차 비교 중 0이 아닌 것의 수를 조회
-- 주의 : 각 컬럼별로 조회되어야 하는데 AND나 OR 조건을 여러 컬럼에 동시에 넣을 수 없으니 하나씩 주석 해제 해가며 조회한다.
SELECT COUNT(DIFF_FCST_W6),
       COUNT(DIFF_FCST_W5),
       COUNT(DIFF_FCST_W4),
       COUNT(DIFF_FCST_W3),
       COUNT(DIFF_FCST_W2),
       COUNT(DIFF_FCST_W1)
FROM(
    SELECT (A.FCST_W6 - B.FCST_W6) AS DIFF_FCST_W6,
           (A.FCST_W5 - B.FCST_W5) AS DIFF_FCST_W5,
           (A.FCST_W4 - B.FCST_W4) AS DIFF_FCST_W4,
           (A.FCST_W3 - B.FCST_W3) AS DIFF_FCST_W3,
           (A.FCST_W2 - B.FCST_W2) AS DIFF_FCST_W2,
           (A.FCST_W1 - B.FCST_W1) AS DIFF_FCST_W1
    FROM MAPE_STEP1 A
    FULL OUTER JOIN PRO_FCST_EXCEL_KEY B
        ON 1=1
        AND (A.SEG1 = B.SEG1)
        AND (A.SEG2 = B.SEG2)
        AND (A.SEG3 = B.SEG3)
        AND (A.YEAR = B.YEAR)
        AND (A.WEEK = B.WEEK AND A.WEEK = 18)
)
WHERE 1=1
--AND DIFF_FCST_W6 != 0;
AND DIFF_FCST_W5 != 0;
--AND DIFF_FCST_W4 != 0;
--AND DIFF_FCST_W3 != 0;
--AND DIFF_FCST_W2 != 0;
--AND DIFF_FCST_W1 != 0;

-- 검증 3.2 (Advanced)각 컬럼 차 비교 중 0이 아닌 것의 수가 조회될 경우 어떤 row인지 찾는다.
-- 주의 : 각 컬럼별로 조회되어야 하는데 AND나 OR 조건을 여러 컬럼에 동시에 넣을 수 없으니 하나씩 주석 해제 해가며 조회한다.
SELECT B.*
FROM(
    SELECT A.*,
          (A.FCST_W6 - B.FCST_W6) AS DIFF_FCST_W6,
          (A.FCST_W5 - B.FCST_W5) AS DIFF_FCST_W5,
          (A.FCST_W4 - B.FCST_W4) AS DIFF_FCST_W4,
          (A.FCST_W3 - B.FCST_W3) AS DIFF_FCST_W3,
          (A.FCST_W2 - B.FCST_W2) AS DIFF_FCST_W2,
          (A.FCST_W1 - B.FCST_W1) AS DIFF_FCST_W1
          FROM MAPE_STEP1 A
          FULL OUTER JOIN PRO_FCST_EXCEL_KEY B
              ON 1=1
              AND (A.SEG1 = B.SEG1)
              AND (A.SEG2 = B.SEG2)
              AND (A.SEG3 = B.SEG3)
              AND (A.YEAR = B.YEAR)
              AND (A.WEEK = B.WEEK AND A.WEEK = 18)
) B
WHERE 1=1
--AND DIFF_FCST_W6 != 0;
--AND DIFF_FCST_W5 != 0;
AND DIFF_FCST_W4 != 0;
--AND DIFF_FCST_W3 != 0;
--AND DIFF_FCST_W2 != 0;
--AND DIFF_FCST_W1 != 0;

--------------------------------------------------------------------------------

-- Step 2. 예측한 값과 실제 값을 뺀 절대값을 구한다.
-- 주의 : FROM 절에 MAPE_STEP1를 지우고 (괄호)를 만들고, 그 괄호 안에 STEP1의 쿼리를 전부 서브쿼리로 복붙한다.
--CREATE TABLE MAPE_STEP2 AS    -- CREATE 한 후 주석처리
SELECT A.*,
   CASE WHEN A.FCST_W6 IS NOT NULL
       THEN ABS(A.QTY - A.FCST_W6)
       ELSE A.QTY END
   AS ABS8W_W6,
   CASE WHEN A.FCST_W5 IS NOT NULL
       THEN ABS(A.QTY - A.FCST_W5)
       ELSE A.QTY END
   AS ABS8W_W5,
   CASE WHEN A.FCST_W4 IS NOT NULL
       THEN ABS(A.QTY - A.FCST_W4)
       ELSE A.QTY END
   AS ABS8W_W4,
   CASE WHEN A.FCST_W3 IS NOT NULL
       THEN ABS(A.QTY - A.FCST_W3)
       ELSE A.QTY END
   AS ABS8W_W3,
   CASE WHEN A.FCST_W2 IS NOT NULL
       THEN ABS(A.QTY - A.FCST_W2)
       ELSE A.QTY END
   AS ABS8W_W2,
   CASE WHEN A.FCST_W1 IS NOT NULL
       THEN ABS(A.QTY - A.FCST_W1)
       ELSE A.QTY END
   AS ABS8W_W1
FROM MAPE_STEP1 A
ORDER BY SEG1 ASC, SEG2 ASC, SEG3 ASC;


-- STEP 2. 검증
SELECT * FROM MAPE_STEP2;   -- 스텝 2단계 저장본.. 문제푼거

SELECT * FROM PRO_FCST_EXCEL_KEY   -- 엑셀파일.. 답지
ORDER BY SEG1 ASC, SEG2 ASC, SEG3 ASC;

-- 검증 1. 컬럼수 비교
SELECT COUNT(*)
FROM MAPE_STEP2;

SELECT COUNT(*)
FROM PRO_FCST_EXCEL_KEY;

-- 검증 2. 합의 차 비교
SELECT SUM(A.ABS8W_W6 - B.ABS8W_W6) AS DIFF_ABS8W_W6,
       SUM(A.ABS8W_W5 - B.ABS8W_W5) AS DIFF_ABS8W_W5,
       SUM(A.ABS8W_W4 - B.ABS8W_W4) AS DIFF_ABS8W_W4,
       SUM(A.ABS8W_W3 - B.ABS8W_W3) AS DIFF_ABS8W_W3,
       SUM(A.ABS8W_W2 - B.ABS8W_W2) AS DIFF_ABS8W_W2,
       SUM(A.ABS8W_W1 - B.ABS8W_W1) AS DIFF_ABS8W_W1
FROM MAPE_STEP2 A
FULL OUTER JOIN PRO_FCST_EXCEL_KEY B
    ON 1=1
    AND (A.SEG1 = B.SEG1)
    AND (A.SEG2 = B.SEG2)
    AND (A.SEG3 = B.SEG3)
    AND (A.YEAR = B.YEAR)
    AND (A.WEEK = B.WEEK AND A.WEEK = 18)

-- 검증 3. 각 컬럼 차 비교
SELECT (A.ABS8W_W6 - B.ABS8W_W6) AS DIFF_ABS8W_W6,
       (A.ABS8W_W5 - B.ABS8W_W5) AS DIFF_ABS8W_W5,
       (A.ABS8W_W4 - B.ABS8W_W4) AS DIFF_ABS8W_W4,
       (A.ABS8W_W3 - B.ABS8W_W3) AS DIFF_ABS8W_W3,
       (A.ABS8W_W2 - B.ABS8W_W2) AS DIFF_ABS8W_W2,
       (A.ABS8W_W1 - B.ABS8W_W1) AS DIFF_ABS8W_W1
FROM MAPE_STEP2 A
FULL OUTER JOIN PRO_FCST_EXCEL_KEY B
    ON 1=1
    AND (A.SEG1 = B.SEG1)
    AND (A.SEG2 = B.SEG2)
    AND (A.SEG3 = B.SEG3)
    AND (A.YEAR = B.YEAR)
    AND (A.WEEK = B.WEEK AND A.WEEK = 18)

-- 검증 3.1 (Advanced)각 컬럼 차 비교 중 0이 아닌 것의 수를 조회
-- 주의 : 각 컬럼별로 조회되어야 하는데 AND나 OR 조건을 여러 컬럼에 동시에 넣을 수 없으니 하나씩 주석 해제 해가며 조회한다.
SELECT COUNT(DIFF_ABS8W_W6),
       COUNT(DIFF_ABS8W_W5),
       COUNT(DIFF_ABS8W_W4),
       COUNT(DIFF_ABS8W_W3),
       COUNT(DIFF_ABS8W_W2),
       COUNT(DIFF_ABS8W_W1)
FROM(
    SELECT (A.ABS8W_W6 - B.ABS8W_W6) AS DIFF_ABS8W_W6,
           (A.ABS8W_W5 - B.ABS8W_W5) AS DIFF_ABS8W_W5,
           (A.ABS8W_W4 - B.ABS8W_W4) AS DIFF_ABS8W_W4,
           (A.ABS8W_W3 - B.ABS8W_W3) AS DIFF_ABS8W_W3,
           (A.ABS8W_W2 - B.ABS8W_W2) AS DIFF_ABS8W_W2,
           (A.ABS8W_W1 - B.ABS8W_W1) AS DIFF_ABS8W_W1
    FROM MAPE_STEP2 A
    FULL OUTER JOIN PRO_FCST_EXCEL_KEY B
        ON 1=1
        AND (A.SEG1 = B.SEG1)
        AND (A.SEG2 = B.SEG2)
        AND (A.SEG3 = B.SEG3)
        AND (A.YEAR = B.YEAR)
        AND (A.WEEK = B.WEEK AND A.WEEK = 18)
)
WHERE 1=1
--AND DIFF_ABS8W_W6 != 0;
AND DIFF_ABS8W_W5 != 0;
--AND DIFF_ABS8W_W4 != 0;
--AND DIFF_ABS8W_W3 != 0;
--AND DIFF_ABS8W_W2 != 0;
--AND DIFF_ABS8W_W1 != 0;

-- 검증 3.2 (Advanced)각 컬럼 차 비교 중 0이 아닌 것의 수가 조회될 경우 어떤 row인지 찾는다.
-- 주의 : 각 컬럼별로 조회되어야 하는데 AND나 OR 조건을 여러 컬럼에 동시에 넣을 수 없으니 하나씩 주석 해제 해가며 조회한다.
SELECT B.*
FROM(
    SELECT A.*,
          (A.ABS8W_W6 - B.ABS8W_W6) AS DIFF_ABS8W_W6,
          (A.ABS8W_W5 - B.ABS8W_W5) AS DIFF_ABS8W_W5,
          (A.ABS8W_W4 - B.ABS8W_W4) AS DIFF_ABS8W_W4,
          (A.ABS8W_W3 - B.ABS8W_W3) AS DIFF_ABS8W_W3,
          (A.ABS8W_W2 - B.ABS8W_W2) AS DIFF_ABS8W_W2,
          (A.ABS8W_W1 - B.ABS8W_W1) AS DIFF_ABS8W_W1
          FROM MAPE_STEP2 A
          FULL OUTER JOIN PRO_FCST_EXCEL_KEY B
              ON 1=1
              AND (A.SEG1 = B.SEG1)
              AND (A.SEG2 = B.SEG2)
              AND (A.SEG3 = B.SEG3)
              AND (A.YEAR = B.YEAR)
              AND (A.WEEK = B.WEEK AND A.WEEK = 18)
) B
WHERE 1=1
--AND DIFF_ABS8W_W6 != 0;
--AND DIFF_ABS8W_W5 != 0;
AND DIFF_ABS8W_W4 != 0;
--AND DIFF_ABS8W_W3 != 0;
--AND DIFF_ABS8W_W2 != 0;
--AND DIFF_ABS8W_W1 != 0;

--------------------------------------------------------------------------------

-- Step 3. 값이 0인 경우 0처리, 이상치 정제 처리
-- 주의 1 : CASE WHEN, WHEN... 으로 다중 IF ESLEIF ESLEIF... 로직 처리 후 마지막 ELSE가 끝나면 반드시 END로 전체 CASE WHEN 조건문을 닫아준다.
--         DECODE는 특정 컬럼에 대해 값을 동등한지 비교해 새로운 값으로 처리해주는 것으로 조건을 비교할 컬럼이 바뀌는 경우 혹은 '='이 아닌 부등호 '>', '<'는 처리할 수 없다.
--CREATE TABLE MAPE_STEP3 AS    -- CREATE 한 후 주석처리
SELECT A.*,
    CASE WHEN ((A.FCST_W6 = 0 OR A.FCST_W6 IS NULL) OR (A.QTY = 0)) THEN 0
        WHEN (A.QTY / A.FCST_W6) > 2 THEN 0
        ELSE (1 - (A.ABS8W_W6 / A.FCST_W6)) END
   AS ACC8W_W6,
   CASE WHEN ((A.FCST_W5 = 0 OR A.FCST_W5 IS NULL) OR (A.QTY = 0)) THEN 0
        WHEN (A.QTY / A.FCST_W5) > 2 THEN 0
        ELSE (1 - (A.ABS8W_W5 / A.FCST_W5)) END
   AS ACC8W_W5,
   CASE WHEN ((A.FCST_W4 = 0 OR A.FCST_W4 IS NULL) OR (A.QTY = 0)) THEN 0
        WHEN (A.QTY / A.FCST_W4) > 2 THEN 0
        ELSE (1 - (A.ABS8W_W4 / A.FCST_W4)) END
   AS ACC8W_W4,
   CASE WHEN ((A.FCST_W3 = 0 OR A.FCST_W3 IS NULL) OR (A.QTY = 0)) THEN 0
        WHEN (A.QTY / A.FCST_W3) > 2 THEN 0
        ELSE (1 - (A.ABS8W_W3 / A.FCST_W3)) END
   AS ACC8W_W3,
   CASE WHEN ((A.FCST_W2 = 0 OR A.FCST_W2 IS NULL) OR (A.QTY = 0)) THEN 0
        WHEN (A.QTY / A.FCST_W2) > 2 THEN 0
        ELSE (1 - (A.ABS8W_W2 / A.FCST_W2)) END
   AS ACC8W_W2,
   CASE WHEN ((A.FCST_W1 = 0 OR A.FCST_W1 IS NULL) OR (A.QTY = 0)) THEN 0
        WHEN (A.QTY / A.FCST_W1) > 2 THEN 0
        ELSE (1 - (A.ABS8W_W1 / A.FCST_W1)) END
   AS ACC8W_W1
FROM MAPE_STEP2 A
ORDER BY SEG1 ASC, SEG2 ASC, SEG3 ASC;


-- STEP 3. 검증
SELECT * FROM MAPE_STEP3;   -- 스텝 3단계 저장본.. 문제푼거

SELECT * FROM PRO_FCST_EXCEL_KEY   -- 엑셀파일.. 답지
ORDER BY SEG1 ASC, SEG2 ASC, SEG3 ASC;

-- 검증 1. 컬럼수 비교
SELECT COUNT(*)
FROM MAPE_STEP3;

SELECT COUNT(*)
FROM PRO_FCST_EXCEL_KEY;

-- 검증 2. 합의 차 비교
-- 주의 : 그냥 'SUM(A.ACC8W_W6 - B.ACC8W_W6) AS DIFF_ACC8W_W6'을 할 경우 엑셀 답지와 오라클이 직접 계산한 결과가 약간씩 오차가 발생한다.
--       따라서 오차가 일정 크기보다 작으면 0으로 처리한다. 여기서는 10^(-8)보다 작을 경우로 했다.
SELECT CASE WHEN(ABS(SUM(A.ACC8W_W6 - B.ACC8W_W6)) < POWER(10,-8)) THEN 0
            ELSE SUM(A.ACC8W_W6 - B.ACC8W_W6) END
       AS DIFF_ACC8W_W6,
       CASE WHEN(ABS(SUM(A.ACC8W_W5 - B.ACC8W_W5)) < POWER(10,-8)) THEN 0
            ELSE SUM(A.ACC8W_W5 - B.ACC8W_W5) END
       AS DIFF_ACC8W_W5,
       CASE WHEN(ABS(SUM(A.ACC8W_W4 - B.ACC8W_W4)) < POWER(10,-8)) THEN 0
            ELSE SUM(A.ACC8W_W4 - B.ACC8W_W4) END
       AS DIFF_ACC8W_W4,
       CASE WHEN(ABS(SUM(A.ACC8W_W3 - B.ACC8W_W3)) < POWER(10,-8)) THEN 0
            ELSE SUM(A.ACC8W_W3 - B.ACC8W_W3) END
       AS DIFF_ACC8W_W3,
       CASE WHEN(ABS(SUM(A.ACC8W_W2 - B.ACC8W_W2)) < POWER(10,-8)) THEN 0
            ELSE SUM(A.ACC8W_W2 - B.ACC8W_W2) END
       AS DIFF_ACC8W_W2,
       CASE WHEN(ABS(SUM(A.ACC8W_W1 - B.ACC8W_W1)) < POWER(10,-8)) THEN 0
            ELSE SUM(A.ACC8W_W1 - B.ACC8W_W1) END
       AS DIFF_ACC8W_W1
FROM MAPE_STEP3 A
FULL OUTER JOIN PRO_FCST_EXCEL_KEY B
    ON 1=1
    AND (A.SEG1 = B.SEG1)
    AND (A.SEG2 = B.SEG2)
    AND (A.SEG3 = B.SEG3)
    AND (A.YEAR = B.YEAR)
    AND (A.WEEK = B.WEEK AND A.WEEK = 18)

-- 검증 3. 각 컬럼 차 비교
-- 주의 : 마찬가지로 오차가 일정 크기보다 작으면 0으로 처리한다.
--       여기서는 각 행렬 단일 비교이므로 조금 더 엄격한 기준으로10^(-14)보다 작을 경우로 했다.
SELECT CASE WHEN(ABS(A.ACC8W_W6 - B.ACC8W_W6) < POWER(10,-14)) THEN 0
            ELSE A.ACC8W_W6 - B.ACC8W_W6 END
       AS DIFF_ACC8W_W6,
       CASE WHEN(ABS(A.ACC8W_W5 - B.ACC8W_W5) < POWER(10,-14)) THEN 0
            ELSE A.ACC8W_W5 - B.ACC8W_W5 END
       AS DIFF_ACC8W_W5,
       CASE WHEN(ABS(A.ACC8W_W4 - B.ACC8W_W4) < POWER(10,-14)) THEN 0
            ELSE A.ACC8W_W4 - B.ACC8W_W4 END
       AS DIFF_ACC8W_W4,
       CASE WHEN(ABS(A.ACC8W_W3 - B.ACC8W_W3) < POWER(10,-14)) THEN 0
            ELSE A.ACC8W_W3 - B.ACC8W_W3 END
       AS DIFF_ACC8W_W3,
       CASE WHEN(ABS(A.ACC8W_W2 - B.ACC8W_W2) < POWER(10,-14)) THEN 0
            ELSE A.ACC8W_W2 - B.ACC8W_W2 END
       AS DIFF_ACC8W_W2,
       CASE WHEN(ABS(A.ACC8W_W1 - B.ACC8W_W1) < POWER(10,-14)) THEN 0
            ELSE A.ACC8W_W1 - B.ACC8W_W1 END
       AS DIFF_ACC8W_W1
FROM MAPE_STEP3 A
FULL OUTER JOIN PRO_FCST_EXCEL_KEY B
    ON 1=1
    AND (A.SEG1 = B.SEG1)
    AND (A.SEG2 = B.SEG2)
    AND (A.SEG3 = B.SEG3)
    AND (A.YEAR = B.YEAR)
    AND (A.WEEK = B.WEEK AND A.WEEK = 18)

-- 검증 3.1 (Advanced)각 컬럼 차 비교 중 0이 아닌 것의 수를 조회
-- 주의 : 각 컬럼별로 조회되어야 하는데 AND나 OR 조건을 여러 컬럼에 동시에 넣을 수 없으니 하나씩 주석 해제 해가며 조회한다.
SELECT COUNT(DIFF_ACC8W_W6),
       COUNT(DIFF_ACC8W_W5),
       COUNT(DIFF_ACC8W_W4),
       COUNT(DIFF_ACC8W_W3),
       COUNT(DIFF_ACC8W_W2),
       COUNT(DIFF_ACC8W_W1)
FROM(
    SELECT CASE WHEN(ABS(A.ACC8W_W6 - B.ACC8W_W6) < POWER(10,-14)) THEN 0
                ELSE A.ACC8W_W6 - B.ACC8W_W6 END
           AS DIFF_ACC8W_W6,
           CASE WHEN(ABS(A.ACC8W_W5 - B.ACC8W_W5) < POWER(10,-14)) THEN 0
                ELSE A.ACC8W_W5 - B.ACC8W_W5 END
           AS DIFF_ACC8W_W5,
           CASE WHEN(ABS(A.ACC8W_W4 - B.ACC8W_W4) < POWER(10,-14)) THEN 0
                ELSE A.ACC8W_W4 - B.ACC8W_W4 END
           AS DIFF_ACC8W_W4,
           CASE WHEN(ABS(A.ACC8W_W3 - B.ACC8W_W3) < POWER(10,-14)) THEN 0
                ELSE A.ACC8W_W3 - B.ACC8W_W3 END
           AS DIFF_ACC8W_W3,
           CASE WHEN(ABS(A.ACC8W_W2 - B.ACC8W_W2) < POWER(10,-14)) THEN 0
                ELSE A.ACC8W_W2 - B.ACC8W_W2 END
           AS DIFF_ACC8W_W2,
           CASE WHEN(ABS(A.ACC8W_W1 - B.ACC8W_W1) < POWER(10,-14)) THEN 0
                ELSE A.ACC8W_W1 - B.ACC8W_W1 END
           AS DIFF_ACC8W_W1
    FROM MAPE_STEP3 A
    FULL OUTER JOIN PRO_FCST_EXCEL_KEY B
        ON 1=1
        AND (A.SEG1 = B.SEG1)
        AND (A.SEG2 = B.SEG2)
        AND (A.SEG3 = B.SEG3)
        AND (A.YEAR = B.YEAR)
        AND (A.WEEK = B.WEEK AND A.WEEK = 18)
)
WHERE 1=1
--AND DIFF_ACC8W_W6 != 0;
AND DIFF_ACC8W_W5 != 0;
--AND DIFF_ACC8W_W4 != 0;
--AND DIFF_ACC8W_W3 != 0;
--AND DIFF_ACC8W_W2 != 0;
--AND DIFF_ACC8W_W1 != 0;

-- 검증 3.2 (Advanced)각 컬럼 차 비교 중 0이 아닌 것의 수가 조회될 경우 어떤 row인지 찾는다.
-- 주의 : 각 컬럼별로 조회되어야 하는데 AND나 OR 조건을 여러 컬럼에 동시에 넣을 수 없으니 하나씩 주석 해제 해가며 조회한다.
SELECT B.*
FROM(
    SELECT A.*,
           CASE WHEN(ABS(A.ACC8W_W6 - B.ACC8W_W6) < POWER(10,-14)) THEN 0
                ELSE A.ACC8W_W6 - B.ACC8W_W6 END
           AS DIFF_ACC8W_W6,
           CASE WHEN(ABS(A.ACC8W_W5 - B.ACC8W_W5) < POWER(10,-14)) THEN 0
                ELSE A.ACC8W_W5 - B.ACC8W_W5 END
           AS DIFF_ACC8W_W5,
           CASE WHEN(ABS(A.ACC8W_W4 - B.ACC8W_W4) < POWER(10,-14)) THEN 0
                ELSE A.ACC8W_W4 - B.ACC8W_W4 END
           AS DIFF_ACC8W_W4,
           CASE WHEN(ABS(A.ACC8W_W3 - B.ACC8W_W3) < POWER(10,-14)) THEN 0
                ELSE A.ACC8W_W3 - B.ACC8W_W3 END
           AS DIFF_ACC8W_W3,
           CASE WHEN(ABS(A.ACC8W_W2 - B.ACC8W_W2) < POWER(10,-14)) THEN 0
                ELSE A.ACC8W_W2 - B.ACC8W_W2 END
           AS DIFF_ACC8W_W2,
           CASE WHEN(ABS(A.ACC8W_W1 - B.ACC8W_W1) < POWER(10,-14)) THEN 0
                ELSE A.ACC8W_W1 - B.ACC8W_W1 END
           AS DIFF_ACC8W_W1
          FROM MAPE_STEP3 A
          FULL OUTER JOIN PRO_FCST_EXCEL_KEY B
              ON 1=1
              AND (A.SEG1 = B.SEG1)
              AND (A.SEG2 = B.SEG2)
              AND (A.SEG3 = B.SEG3)
              AND (A.YEAR = B.YEAR)
              AND (A.WEEK = B.WEEK AND A.WEEK = 18)
) B
WHERE 1=1
--AND DIFF_ACC8W_W6 != 0;
--AND DIFF_ACC8W_W5 != 0;
AND DIFF_ACC8W_W4 != 0;
--AND DIFF_ACC8W_W3 != 0;
--AND DIFF_ACC8W_W2 != 0;
--AND DIFF_ACC8W_W1 != 0;


--------------------------------------------------------------------------------

-- Step 4. aaaa
-- 주의 : aaaa
--CREATE TABLE MAPE_STEP4 AS    -- CREATE 한 후 주석처리
