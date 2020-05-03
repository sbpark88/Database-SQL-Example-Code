-- 1. Domain Constraint, ������ ���Ἲ ����

CREATE TABLE KOPO_PRODUCT_COLUMN_TEST 
(
    CHARCOL VARCHAR2 (100),
    NUMCOL NUMBER NOT NULL
);

-- �ڷ����� ����Ǵ� �����ʹ� �����ʹ� �� �� ����.
INSERT INTO KOPO_PRODUCT_COLUMN_TEST
VALUES('TEST1','TEST2')

-- NULL�� ������� �ʴ´� �Ͽ� NULL�� �� �� ����.
INSERT INTO KOPO_PRODUCT_COLUMN_TEST
VALUES('TEST1',NULL)

-- ������ ���Ἲ ������ �������� �ʴ� �����ʹ� ���������� ����.
INSERT INTO KOPO_PRODUCT_COLUMN_TEST
VALUES('TEST1',10)

SELECT * FROM KOPO_PRODUCT_COLUMN_TEST

-- �߰��� �־ �� ����.
INSERT INTO KOPO_PRODUCT_COLUMN_TEST
VALUES('TEST1',10)

DROP TABLE KOPO_PRODUCT_COLUMN_TEST


-- 2. PK(Primary Key Constraint, ��ü ���Ἲ ����), FK(Foreign Key Constrain, ���� ���Ἲ ����)

-- ��� ���̺� ��ȸ
SELECT * FROM TABS

-- �θ� ���̺� ���� �� ��ȸ (��� ���� ���̺�)
CREATE TABLE KOPO_EVENT_INFO_FOREIGN
(
    EVENTID VARCHAR2(20),
    EVENTPERIOD VARCHAR2(20),
    PROMOTION_RATIO NUMBER,
    CONSTRAINT PK_KOPO_EVENT_INFO_FOREIGN PRIMARY KEY (EVENTID) -- �������� ���� / ���Ļ� ���ִ°� / PK (������ �÷�)
);
 
SELECT * FROM KOPO_EVENT_INFO_FOREIGN

DESC KOPO_EVENT_INFO_FOREIGN
 
 
-- �ڽ� ���̺� ���� �� ��ȸ (���� ���� ���̺�)
CREATE TABLE KOPO_PRODUCT_VOLUME_FOREIGN
(
    REGIONID VARCHAR2(20),
    PRODUCTGROUP VARCHAR2(20),
    YEARWEEK VARCHAR2(8),
    VOLUME NUMBER NOT NULL,
    EVENTID VARCHAR2(20),
    CONSTRAINT PK_KOPO_PRODUCT_VOLUME_FOREIGN PRIMARY KEY (REGIONID, PRODUCTGROUP, YEARWEEK),
    CONSTRAINT FK_KOPO_PRODUCT_VOLUME_FOREIGN FOREIGN KEY (EVENTID) REFERENCES KOPO_EVENT_INFO_FOREIGN (EVENTID) -- �������� ���� / ���Ļ� ���ִ°� / FK (������ �÷�) ref '�θ����̺�'(�� �÷���)
);
 
SELECT * FROM KOPO_PRODUCT_VOLUME_FOREIGN

DESC KOPO_PRODUCT_VOLUME_FOREIGN

-- �ڽ� ���̺��� ����Ű �����ϱ� (���̺� ���� �� FK �����ϱ�)(�θ� ���̺��� ���� �����ϱ� ���� CASCADE �ɼ��� �ָ� �ڽ� ���̺��� FK�� �����ȴ�.)
ALTER TABLE KOPO_PRODUCT_VOLUME_FOREIGN
ADD CONSTRAINTS FK_KOPO_PRODUCT_VOLUME_FOREIGN FOREIGN KEY (EVENTID)
REFERENCES KOPO_EVENT_INFO_FOREIGN (EVENTID)
--ON DELETE CASCADE -- �θ� ���̺��� ���� ���� ������ ����������. (�ڽ� ���̺��� �ش� row�� ���� ����)
--ON DELETE SET NULL -- �θ� ���̺��� ���� ���� ������ ����������. (�ڽ� ���̺��� �ش� FK�� NULLó���ϰ� row ��ü�� �������� �ʴ´�.)
 
-- �ڽ� ���̺��� ����Ű ����ϱ�
ALTER TABLE KOPO_PRODUCT_VOLUME_FOREIGN
DROP CONSTRAINT FK_KOPO_PRODUCT_VOLUME_FOREIGN;

-- �θ� ���̺� ������ �Է�
INSERT INTO KOPO_EVENT_INFO_FOREIGN
VALUES ('A01','20',0.1)
 
-- �ڽ� ���̺� ������ �Է� (�θ� ���̺� 'A01'�� �̹� ������� ����)
INSERT INTO KOPO_PRODUCT_VOLUME_FOREIGN
VALUES ('SEOUL','REF','202010',20,'A01')
 
-- �ڽ� ���̺� ������ �Է� (�θ� ���̺� 'A02'�� ���� ����)
INSERT INTO KOPO_PRODUCT_VOLUME_FOREIGN
VALUES ('SEOUL','REF','202010',20,'A02')

-- �θ� ���̺��� ������ ���� (�ڽ� ���̺��� �θ� ���̺��� 'A01'�� FK�� ������)
DELETE FROM KOPO_EVENT_INFO_FOREIGN
WHERE EVENTID = 'A01'

-- �θ� ���̺��� ���� (�ڽ� ���̺��� �θ� ���̺��� 'A01'�� FK�� ������)
DROP TABLE KOPO_EVENT_INFO_FOREIGN

-- �θ� ���̺��� ���� ���� (�ڽ� ���̺��� �θ� ���̺��� 'A01'�� FK�� ������)
DROP TABLE KOPO_EVENT_INFO_FOREIGN CASCADE CONSTRAINT -- ���̺� ������ ���� CONSTRAINT ���� ����(PK, FK)�� ������Ű�� �ɼ��� �ش�.

DROP TABLE KOPO_EVENT_INFO_FOREIGN DELETE SET NULL CONSTRAINT

-- ON DELETE SET NULL �ǽ� �� �ش� row ������ ����
DELETE FROM KOPO_PRODUCT_VOLUME_FOREIGN
WHERE REGIONID = 'SEOUL'












-- 1. Relation Algebra(���� ���)
-- ��� ���̺� ��ȸ�ϱ�
SELECT * FROM TABS

-- �ش� ���̺������� ��� ������ ��ȸ�ϱ�
SELECT * FROM KOPO_PRODUCT_VOLUME

SELECT
    REGIONID,       -- ��������
    PRODUCTGROUP,   -- ��ǰ����
    YEARWEEK,       -- ��������
    VOLUME          -- �Ǹŷ�
FROM KOPO_PRODUCT_VOLUME

-- Ư�� �÷��� ��ȸ�ϱ�.
SELECT
    PRODUCTGROUP,   -- ��ǰ����
    YEARWEEK,       -- ��������
    VOLUME          -- �Ǹŷ�
FROM KOPO_PRODUCT_VOLUME

SELECT YEARWEEK
FROM KOPO_PRODUCT_VOLUME

-- �÷��� �����ϱ� (VOLUME -> VOLUME2)
ALTER TABLE KOPO_PRODUCT_VOLUME
RENAME COLUMN VOLUME TO VOLUME2

-- �÷��� �ٽ� �ǵ����� (VOLUME2 -> VOLUME)
ALTER TABLE KOPO_PRODUCT_VOLUME
RENAME COLUMN VOLUME2 TO VOLUME

-- 1.1 ������ ��ȸ (Selection) : Ư�� row ��ȸ�ϱ�
-- KOPO_PRODUCT_VOLUME ���̺��� ������ 800,000 �̻��� �����͸� ��ȸ�ϼ���.
SELECT
    REGIONID,       -- ��������
    PRODUCTGROUP,   -- ��ǰ����
    YEARWEEK,       -- ��������
    VOLUME          -- �Ǹŷ�
FROM KOPO_PRODUCT_VOLUME
WHERE VOLUME >= 800000
    
-- KOPO_PRODUCT_VOLUME ���̺��� 201601���� �̻��̸鼭, ST0001�� ��ǰ �����͸� ��ȸ�ϼ���.
SELECT
    REGIONID,       -- ��������
    PRODUCTGROUP,   -- ��ǰ����
    YEARWEEK,       -- ��������
    VOLUME          -- �Ǹŷ�
FROM KOPO_PRODUCT_VOLUME
WHERE YEARWEEK >= '201601' AND PRODUCTGROUP = 'ST0001'

-- 1.2 ������ ��ȸ (Projection) : Ư�� column ��ȸ�ϱ�
-- KOPO_PRODUCT_VOLUME ���̺��� ��� ��ǰ�� ��ȸ�ϼ���.
SELECT
    PRODUCTGROUP   -- ��ǰ����
FROM KOPO_PRODUCT_VOLUME

-- 1.3 ���� ������ (Union) : 2���� �����̼��� ��ġ��
-- A02 ���̺��� �ϳ� �����ϰ� �����͸� �ҷ��´�.
CREATE TABLE KOPO_PRODUCT_VOLUME_A02
(
    REGIONID VARCHAR2(20),       -- ��������
    PRODUCTGROUP VARCHAR2(20),   -- ��ǰ����
    YEARWEEK VARCHAR2(6),        -- ��������
    VOLUME NUMBER,               -- �Ǹŷ�   
    CONSTRAINT PK_KOPO_PRODUCT_VOLUME_A02 PRIMARY KEY(REGIONID, PRODUCTGROUP, YEARWEEK)
);

SELECT * FROM KOPO_PRODUCT_VOLUME_A02

DESC KOPO_PRODUCT_VOLUME_A02

-- A01 ������ A02 ������ ������ ��ġ��. (������ Union �ϱ�) (�Ӽ� ���� �÷� ������ ���ƾ��Ѵ�.)
SELECT
    REGIONID,       -- ��������
    PRODUCTGROUP,   -- ��ǰ����
    YEARWEEK,       -- ��������
    VOLUME          -- �Ǹŷ�
FROM KOPO_PRODUCT_VOLUME
UNION ALL           -- �ߺ� ���� �� ��
--UNION               -- �ߺ� ���� �� ����
SELECT
    REGIONID,       -- ��������
    PRODUCTGROUP,   -- ��ǰ����
    YEARWEEK,       -- ��������
    VOLUME          -- �Ǹŷ�
FROM KOPO_PRODUCT_VOLUME_A02




-- 1. Expression ���� ����ϱ� (���� AS �÷���)(��Ī �ޱ�)
-- '��������'��� ���ڿ� ������ 'MEASURE_NAME'�̶�� �÷��� ��´�.
SELECT '��������' AS MEASURE_NAME, A.*
FROM KOPO_PRODUCT_VOLUME A

-- ���� ����.
SELECT
    '��������' AS MEASUER_NAME,
    A.REGIONID,       -- ��������
    A.PRODUCTGROUP,   -- ��ǰ����
    A.YEARWEEK,       -- ��������
    A.VOLUME          -- �Ǹŷ�
FROM KOPO_PRODUCT_VOLUME A

-- '��� ���ڿ�'�� �ƴ� �÷� ������ �̿��� ���� �ִ�.
SELECT
    A.REGIONID || '_' || A.PRODUCTGROUP AS PLANID,    -- REGIONID + '_' + PRODUCTGROUP �� 'PLANID'��� �÷��� ��´�.
    A.REGIONID          -- �����ڵ�
FROM KOPO_PRODUCT_VOLUME A


-- 2. Expression ���� ����ϱ� (������ ���� ���)(���)
SELECT
    A.YEARWEEK + A.VOLUME AS TEST,    -- (YEARWEEK + VOLUME) �� 'TEST��� �÷��� ��´ٴ�.
    A.*
FROM KOPO_PRODUCT_VOLUME A

-- Expression �� ����� ��ȸ�� �����͸� ������� �ϰ� ���� ���
CREATE TABLE STABLE AS
SELECT
    YEARWEEK+VOLUME AS TEST,
    A.*
FROM KOPO_PRODUCT_VOLUME A

-- ������ ������ STABLE ��ȸ
SELECT * FROM STABLE

-- ���� ���̺��� ���Ἲ ���� ������ ���캻��.(PK)
DESC KOPO_PRODUCT_VOLUME

-- �̷��� ������ �����ʹ� ���� ��������� '����' �������� ���������� �� �Ѵ�.
DESC STABLE

-- ������ ������ STABLE ����
DROP TABLE STABLE

SELECT * FROM TABS

