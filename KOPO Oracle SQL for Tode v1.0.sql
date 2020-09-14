-- 1. Domain Constraint, 도메인 무결성 제약

CREATE TABLE KOPO_PRODUCT_COLUMN_TEST
(
    CHARCOL VARCHAR2 (100),
    NUMCOL NUMBER NOT NULL
);

-- 자료형에 위배되는 데이터는 데이터는 들어갈 수 없다.
INSERT INTO KOPO_PRODUCT_COLUMN_TEST
VALUES('TEST1','TEST2')

-- NULL을 허용하지 않는다 하여 NULL이 들어갈 수 없다.
INSERT INTO KOPO_PRODUCT_COLUMN_TEST
VALUES('TEST1',NULL)

-- 도메인 무결성 제약을 위배하지 않는 데이터는 정상적으로 들어간다.
INSERT INTO KOPO_PRODUCT_COLUMN_TEST
VALUES('TEST1',10)

SELECT * FROM KOPO_PRODUCT_COLUMN_TEST

-- 추가로 넣어도 또 들어간다.
INSERT INTO KOPO_PRODUCT_COLUMN_TEST
VALUES('TEST1',10)

DROP TABLE KOPO_PRODUCT_COLUMN_TEST


-- 2. PK(Primary Key Constraint, 개체 무결성 제약), FK(Foreign Key Constrain, 참조 무결성 제약)

-- 모든 테이블 조회
SELECT * FROM TABS

-- 부모 테이블 생성 및 조회 (행사 정보 테이블)
CREATE TABLE KOPO_EVENT_INFO_FOREIGN
(
    EVENTID VARCHAR2(20),
    EVENTPERIOD VARCHAR2(20),
    PROMOTION_RATIO NUMBER,
    CONSTRAINT PK_KOPO_EVENT_INFO_FOREIGN PRIMARY KEY (EVENTID) -- 제약조건 설정 / 형식상 써주는거 / PK (지정할 컬럼)
);

SELECT * FROM KOPO_EVENT_INFO_FOREIGN

DESC KOPO_EVENT_INFO_FOREIGN


-- 자식 테이블 생성 및 조회 (실적 정보 테이블)
CREATE TABLE KOPO_PRODUCT_VOLUME_FOREIGN
(
    REGIONID VARCHAR2(20),
    PRODUCTGROUP VARCHAR2(20),
    YEARWEEK VARCHAR2(8),
    VOLUME NUMBER NOT NULL,
    EVENTID VARCHAR2(20),
    CONSTRAINT PK_KOPO_PRODUCT_VOLUME_FOREIGN PRIMARY KEY (REGIONID, PRODUCTGROUP, YEARWEEK),
    CONSTRAINT FK_KOPO_PRODUCT_VOLUME_FOREIGN FOREIGN KEY (EVENTID) REFERENCES KOPO_EVENT_INFO_FOREIGN (EVENTID) -- 제약조건 설정 / 형식상 써주는거 / FK (지정할 컬럼) ref '부모테이블'(의 컬럼명)
);

SELECT * FROM KOPO_PRODUCT_VOLUME_FOREIGN

DESC KOPO_PRODUCT_VOLUME_FOREIGN

-- 자식 테이블에서 참조키 설정하기 (테이블 생성 후 FK 설정하기)(부모 테이블을 강제 삭제하기 위해 CASCADE 옵션을 주면 자식 테이블의 FK가 삭제된다.)
ALTER TABLE KOPO_PRODUCT_VOLUME_FOREIGN
ADD CONSTRAINTS FK_KOPO_PRODUCT_VOLUME_FOREIGN FOREIGN KEY (EVENTID)
REFERENCES KOPO_EVENT_INFO_FOREIGN (EVENTID)
--ON DELETE CASCADE -- 부모 테이블에서 에러 없이 삭제가 가능해진다. (자식 테이블의 해당 row를 전부 삭제)
--ON DELETE SET NULL -- 부모 테이블에서 에러 없이 삭제가 가능해진다. (자식 테이블의 해당 FK를 NULL처리하고 row 자체를 삭제하진 않는다.)

-- 자식 테이블에서 참조키 드랍하기
ALTER TABLE KOPO_PRODUCT_VOLUME_FOREIGN
DROP CONSTRAINT FK_KOPO_PRODUCT_VOLUME_FOREIGN;

-- 부모 테이블에 데이터 입력
INSERT INTO KOPO_EVENT_INFO_FOREIGN
VALUES ('A01','20',0.1)

-- 자식 테이블에 데이터 입력 (부모 테이블에 'A01'이 이미 만들어져 있음)
INSERT INTO KOPO_PRODUCT_VOLUME_FOREIGN
VALUES ('SEOUL','REF','202010',20,'A01')

-- 자식 테이블에 데이터 입력 (부모 테이블에 'A02'가 아직 없음)
INSERT INTO KOPO_PRODUCT_VOLUME_FOREIGN
VALUES ('SEOUL','REF','202010',20,'A02')

-- 부모 테이블에서 데이터 삭제 (자식 테이블이 부모 테이블의 'A01'을 FK로 참조중)
DELETE FROM KOPO_EVENT_INFO_FOREIGN
WHERE EVENTID = 'A01'

-- 부모 테이블을 삭제 (자식 테이블이 부모 테이블의 'A01'을 FK로 참조중)
DROP TABLE KOPO_EVENT_INFO_FOREIGN

-- 부모 테이블을 강제 삭제 (자식 테이블이 부모 테이블의 'A01'을 FK로 참조중)
DROP TABLE KOPO_EVENT_INFO_FOREIGN CASCADE CONSTRAINT -- 테이블 삭제를 위해 CONSTRAINT 제약 조건(PK, FK)을 삭제시키는 옵션을 준다.

DROP TABLE KOPO_EVENT_INFO_FOREIGN DELETE SET NULL CONSTRAINT

-- ON DELETE SET NULL 실습 후 해당 row 데이터 삭제
DELETE FROM KOPO_PRODUCT_VOLUME_FOREIGN
WHERE REGIONID = 'SEOUL'












-- 1. Relation Algebra(관계 대수)
-- 모든 테이블 조회하기
SELECT * FROM TABS

-- 해당 테이블데이터의 모든 데이터 조회하기
SELECT * FROM KOPO_PRODUCT_VOLUME

SELECT
    REGIONID,       -- 지역정보
    PRODUCTGROUP,   -- 상품정보
    YEARWEEK,       -- 주차정보
    VOLUME          -- 판매량
FROM KOPO_PRODUCT_VOLUME

-- 특정 컬럼만 조회하기.
SELECT
    PRODUCTGROUP,   -- 상품정보
    YEARWEEK,       -- 주차정보
    VOLUME          -- 판매량
FROM KOPO_PRODUCT_VOLUME

SELECT YEARWEEK
FROM KOPO_PRODUCT_VOLUME

-- 컬럼명 변경하기 (VOLUME -> VOLUME2)
ALTER TABLE KOPO_PRODUCT_VOLUME
RENAME COLUMN VOLUME TO VOLUME2

-- 컬럼명 다시 되돌리기 (VOLUME2 -> VOLUME)
ALTER TABLE KOPO_PRODUCT_VOLUME
RENAME COLUMN VOLUME2 TO VOLUME

-- 1.1 데이터 조회 (Selection) : 특정 row 조회하기
-- KOPO_PRODUCT_VOLUME 테이블에서 물량이 800,000 이상인 데이터만 조회하세요.
SELECT
    REGIONID,       -- 지역정보
    PRODUCTGROUP,   -- 상품정보
    YEARWEEK,       -- 주차정보
    VOLUME          -- 판매량
FROM KOPO_PRODUCT_VOLUME
WHERE VOLUME >= 800000

-- KOPO_PRODUCT_VOLUME 테이블에서 201601주차 이상이면서, ST0001인 상품 데이터를 조회하세요.
SELECT
    REGIONID,       -- 지역정보
    PRODUCTGROUP,   -- 상품정보
    YEARWEEK,       -- 주차정보
    VOLUME          -- 판매량
FROM KOPO_PRODUCT_VOLUME
WHERE YEARWEEK >= '201601' AND PRODUCTGROUP = 'ST0001'

-- 1.2 데이터 조회 (Projection) : 특정 column 조회하기
-- KOPO_PRODUCT_VOLUME 테이블에서 모든 상품을 조회하세요.
SELECT
    PRODUCTGROUP   -- 상품정보
FROM KOPO_PRODUCT_VOLUME

-- 1.3 집합 연산자 (Union) : 2개의 릴레이션을 합치기
-- A02 테이블을 하나 생성하고 데이터를 불러온다.
CREATE TABLE KOPO_PRODUCT_VOLUME_A02
(
    REGIONID VARCHAR2(20),       -- 지역정보
    PRODUCTGROUP VARCHAR2(20),   -- 상품정보
    YEARWEEK VARCHAR2(6),        -- 주차정보
    VOLUME NUMBER,               -- 판매량
    CONSTRAINT PK_KOPO_PRODUCT_VOLUME_A02 PRIMARY KEY(REGIONID, PRODUCTGROUP, YEARWEEK)
);

SELECT * FROM KOPO_PRODUCT_VOLUME_A02

DESC KOPO_PRODUCT_VOLUME_A02

-- A01 지점과 A02 지점의 실적을 합치기. (데이터 Union 하기) (속성 수와 컬럼 정보가 같아야한다.)
SELECT
    REGIONID,       -- 지역정보
    PRODUCTGROUP,   -- 상품정보
    YEARWEEK,       -- 주차정보
    VOLUME          -- 판매량
FROM KOPO_PRODUCT_VOLUME
UNION ALL           -- 중복 제거 안 함
--UNION               -- 중복 제거 및 정렬
SELECT
    REGIONID,       -- 지역정보
    PRODUCTGROUP,   -- 상품정보
    YEARWEEK,       -- 주차정보
    VOLUME          -- 판매량
FROM KOPO_PRODUCT_VOLUME_A02




-- 1. Expression 수식 사용하기 (수식 AS 컬럼명)(별칭 달기)
-- '실적정보'라는 문자열 수식을 'MEASURE_NAME'이라는 컬럼에 담는다.
SELECT '실적정보' AS MEASURE_NAME, A.*
FROM KOPO_PRODUCT_VOLUME A

-- 위와 동일.
SELECT
    '실적정보' AS MEASUER_NAME,
    A.REGIONID,       -- 지역정보
    A.PRODUCTGROUP,   -- 상품정보
    A.YEARWEEK,       -- 주차정보
    A.VOLUME          -- 판매량
FROM KOPO_PRODUCT_VOLUME A

-- '상수 문자열'이 아닌 컬럼 정보를 이용할 수도 있다.
SELECT
    A.REGIONID || '_' || A.PRODUCTGROUP AS PLANID,    -- REGIONID + '_' + PRODUCTGROUP 을 'PLANID'라는 컬럼에 담는다.
    A.REGIONID          -- 지역코드
FROM KOPO_PRODUCT_VOLUME A


-- 2. Expression 수식 사용하기 (수식을 통해 계산)(계산)
SELECT
    A.YEARWEEK + A.VOLUME AS TEST,    -- (YEARWEEK + VOLUME) 을 'TEST라는 컬럼에 담는다다.
    A.*
FROM KOPO_PRODUCT_VOLUME A

-- Expression 을 사용해 조회한 데이터를 저장까지 하고 싶은 경우
CREATE TABLE STABLE AS
SELECT
    YEARWEEK+VOLUME AS TEST,
    A.*
FROM KOPO_PRODUCT_VOLUME A

-- 위에서 생성한 STABLE 조회
SELECT * FROM STABLE

-- 원본 테이블의 무결성 제약 조건을 살펴본다.(PK)
DESC KOPO_PRODUCT_VOLUME

-- 이렇게 저장한 데이터는 값은 저장되지만 '권한' 설정까지 복제하지는 못 한다.
DESC STABLE

-- 위에서 생성한 STABLE 삭제
DROP TABLE STABLE

SELECT * FROM TABS
