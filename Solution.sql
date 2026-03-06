-- ================================================================
-- FNB Student Connect Database | Solution.sql
-- Nicolette Mashaba | 20232990 | Polokwane (Online)
-- MDB622 — Database Manipulation | March 2026
-- ================================================================

-- ----------------------------------------------------------------
-- SECTION A — Q2: Create FNB_StudentDB
-- ----------------------------------------------------------------

IF EXISTS (SELECT name FROM sys.databases WHERE name = N'FNB_StudentDB')
BEGIN
    ALTER DATABASE FNB_StudentDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE FNB_StudentDB;
    PRINT 'Existing FNB_StudentDB dropped successfully.';
END
GO

CREATE DATABASE FNB_StudentDB
    COLLATE Latin1_General_CI_AS;
GO

ALTER DATABASE FNB_StudentDB

    SET COMPATIBILITY_LEVEL = 160;
GO

PRINT 'FNB_StudentDB created successfully with compatibility level 160.';
GO

USE FNB_StudentDB;
GO


-- ----------------------------------------------------------------
-- SECTION B — Q3: Create Tables
-- ----------------------------------------------------------------

USE FNB_StudentDB;
GO

-- Drop table if it already exists (clean run)
IF OBJECT_ID('dbo.Customers', 'U') IS NOT NULL DROP TABLE dbo.Customers;
GO

CREATE TABLE dbo.Customers
(
    CustomerID   INT           NOT NULL IDENTITY(1,1),
    IDNumber     CHAR(13)      NOT NULL,
    FullName     VARCHAR(100)  NOT NULL,
    DateOfBirth  DATE          NOT NULL,

    -- Primary Key: uniquely identifies each customer
    CONSTRAINT PK_Customers PRIMARY KEY (CustomerID),

    -- IDNumber must be unique — no duplicate SA ID registrations
    CONSTRAINT UQ_Customers_IDNumber UNIQUE (IDNumber),

    -- Customer must be 18 years or older at time of registration
    CONSTRAINT CHK_Customers_Age
	        CHECK (
            DATEDIFF(YEAR, DateOfBirth, GETDATE())
            - CASE
                WHEN (MONTH(DateOfBirth) > MONTH(GETDATE()))
                  OR (MONTH(DateOfBirth) = MONTH(GETDATE())
                      AND DAY(DateOfBirth) > DAY(GETDATE()))
                THEN 1 ELSE 0
              END >= 18
        )
);
GO

IF OBJECT_ID('dbo.Accounts', 'U') IS NOT NULL DROP TABLE dbo.Accounts;
GO

CREATE TABLE dbo.Accounts
(
    AccountNumber  VARCHAR(20)    NOT NULL,
    CustomerID     INT            NOT NULL,
    Balance        DECIMAL(18,2)  NOT NULL DEFAULT 0.00,

    CONSTRAINT PK_Accounts PRIMARY KEY (AccountNumber),

    CONSTRAINT FK_Accounts_Customers
        FOREIGN KEY (CustomerID) REFERENCES dbo.Customers(CustomerID),

    CONSTRAINT CHK_Accounts_Balance CHECK (Balance >= 0.00)
);
GO

IF OBJECT_ID('dbo.Transactions', 'U') IS NOT NULL DROP TABLE dbo.Transactions;
GO

CREATE TABLE dbo.Transactions
(
    TransactionID  INT            NOT NULL IDENTITY(1,1),
    AccountNumber  VARCHAR(20)    NOT NULL,
    Amount         DECIMAL(18,2)  NOT NULL,
    TransDate      DATETIME       NOT NULL DEFAULT GETDATE(),
    Type           VARCHAR(10)    NOT NULL,

    CONSTRAINT PK_Transactions PRIMARY KEY (TransactionID),

    CONSTRAINT FK_Transactions_Accounts
        FOREIGN KEY (AccountNumber) REFERENCES dbo.Accounts(AccountNumber),

    CONSTRAINT CHK_Transactions_Type CHECK (Type IN ('Credit', 'Debit'))
);
GO

PRINT 'All tables created successfully.';
GO

SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_TYPE = 'BASE TABLE' 
AND TABLE_CATALOG = 'FNB_StudentDB';


-- ----------------------------------------------------------------
-- SECTION B — Q4: Constraint Tests
-- ----------------------------------------------------------------

-- Q4.1: This INSERT will FAIL — customer is only 15 years old
INSERT INTO dbo.Customers (IDNumber, FullName, DateOfBirth)
VALUES ('0101015800089', 'Young Testuser', '2010-01-01');
GO

-- Q4.2: First insert a valid customer to satisfy the foreign key
INSERT INTO dbo.Customers (IDNumber, FullName, DateOfBirth)
VALUES ('9001015800089', 'Test Customer', '1990-01-01');
GO

-- This INSERT will FAIL — balance is negative
INSERT INTO dbo.Accounts (AccountNumber, CustomerID, Balance)
VALUES ('ACC-TEST-001', 1, -500.00);
GO

-- Clean up test data
DELETE FROM dbo.Customers WHERE IDNumber = '9001015800089';
GO


-- ----------------------------------------------------------------
-- SECTION C — Q5: Insert Sample Data
-- ----------------------------------------------------------------

-- Q5.1: Insert 5 Customers
INSERT INTO dbo.Customers (IDNumber, FullName, DateOfBirth) VALUES
    ('0003155900082', 'Thabo Ndlovu',    '2000-03-15'),
    ('9812200800086', 'Annika Botha',    '1998-12-20'),
    ('0109287500083', 'Lungelo Dlamini', '2001-09-28'),
    ('9706140600081', 'Priya Naidoo',    '1997-06-14'),
    ('0205230300084', 'Roodt van Wyk',   '2002-05-23');
GO

-- Q5.2: Insert 10 Accounts
INSERT INTO dbo.Accounts (AccountNumber, CustomerID, Balance) VALUES
    ('FNB-10000001', 1, 15000.00),
    ('FNB-10000002', 1,  3500.50),
    ('FNB-10000003', 2, 22000.00),
    ('FNB-10000004', 2,   800.00),
    ('FNB-10000005', 3, 10500.75),
    ('FNB-10000006', 3,  5000.00),
    ('FNB-10000007', 4, 30000.00),
    ('FNB-10000008', 4,  1200.00),
    ('FNB-10000009', 5,  9800.00),
    ('FNB-10000010', 5,  4750.25);
GO

SELECT * FROM dbo.Customers;

DELETE FROM dbo.Customers;
GO
DBCC CHECKIDENT ('dbo.Customers', RESEED, 0);
GO

INSERT INTO dbo.Customers (IDNumber, FullName, DateOfBirth) VALUES
    ('0003155900082', 'Thabo Ndlovu',    '2000-03-15'),
    ('9812200800086', 'Annika Botha',    '1998-12-20'),
    ('0109287500083', 'Lungelo Dlamini', '2001-09-28'),
    ('9706140600081', 'Priya Naidoo',    '1997-06-14'),
    ('0205230300084', 'Roodt van Wyk',   '2002-05-23');
GO

SELECT * FROM dbo.Customers;

-- Q5.3: Insert 20 Transactions
INSERT INTO dbo.Transactions (AccountNumber, Amount, TransDate, Type) VALUES
    ('FNB-10000001',  2000.00, '2025-01-05 09:00:00', 'Credit'),
    ('FNB-10000001',   500.00, '2025-01-10 11:30:00', 'Debit'),
    ('FNB-10000002',  1000.00, '2025-01-12 08:45:00', 'Credit'),
    ('FNB-10000003',  5000.00, '2025-01-15 14:00:00', 'Credit'),
    ('FNB-10000003',  1500.00, '2025-01-18 10:00:00', 'Debit'),
    ('FNB-10000004',   200.00, '2025-01-20 16:30:00', 'Debit'),
    ('FNB-10000005',  3000.00, '2025-02-01 09:15:00', 'Credit'),
    ('FNB-10000005',   750.00, '2025-02-03 13:00:00', 'Debit'),
    ('FNB-10000006',  1200.00, '2025-02-05 10:30:00', 'Credit'),
    ('FNB-10000007', 10000.00, '2025-02-07 08:00:00', 'Credit'),
    ('FNB-10000007',  2000.00, '2025-02-10 12:00:00', 'Debit'),
    ('FNB-10000008',   600.00, '2025-02-12 15:00:00', 'Credit'),
    ('FNB-10000009',  4000.00, '2025-02-14 09:45:00', 'Credit'),
    ('FNB-10000009',  1000.00, '2025-02-16 11:00:00', 'Debit'),
    ('FNB-10000010',  2500.00, '2025-02-18 14:30:00', 'Credit'),
    ('FNB-10000001',   300.00, '2025-03-01 10:00:00', 'Debit'),
    ('FNB-10000003',   800.00, '2025-03-03 09:00:00', 'Credit'),
    ('FNB-10000005',   450.00, '2025-03-05 11:30:00', 'Debit'),
    ('FNB-10000007',  5000.00, '2025-03-07 08:30:00', 'Credit'),
    ('FNB-10000010',   900.00, '2025-03-09 16:00:00', 'Debit');
GO

PRINT '5 Customers, 10 Accounts, and 20 Transactions inserted successfully.';
GO

SELECT * FROM dbo.Customers;

-- ----------------------------------------------------------------
-- SECTION C — Q6: Transaction Management
-- ----------------------------------------------------------------

DECLARE @TransferAmount DECIMAL(18,2) = 1000.00;
DECLARE @AccountA       VARCHAR(20)   = 'FNB-10000001';
DECLARE @AccountB       VARCHAR(20)   = 'FNB-10000002';
DECLARE @BalanceA       DECIMAL(18,2);

BEGIN TRANSACTION;

    -- Step 1: Debit Account A
    UPDATE dbo.Accounts
       SET Balance = Balance - @TransferAmount
     WHERE AccountNumber = @AccountA;

    -- Step 2: Check resulting balance of Account A
    SELECT @BalanceA = Balance
      FROM dbo.Accounts
     WHERE AccountNumber = @AccountA;

    -- Step 3: If balance is negative, roll back everything
    IF @BalanceA < 0
    BEGIN
        ROLLBACK TRANSACTION;
        PRINT 'Transfer Failed: Insufficient funds. Transaction rolled back.';
    END
    ELSE
    BEGIN
        -- Step 4: Credit Account B
        UPDATE dbo.Accounts
           SET Balance = Balance + @TransferAmount
         WHERE AccountNumber = @AccountB;

        -- Step 5: Log the debit
        INSERT INTO dbo.Transactions (AccountNumber, Amount, TransDate, Type)
        VALUES (@AccountA, @TransferAmount, GETDATE(), 'Debit');

        -- Step 6: Log the credit
        INSERT INTO dbo.Transactions (AccountNumber, Amount, TransDate, Type)
        VALUES (@AccountB, @TransferAmount, GETDATE(), 'Credit');

        COMMIT TRANSACTION;
        PRINT 'Transfer Successful';
    END
GO


SELECT AccountNumber, Balance
  FROM dbo.Accounts
 WHERE AccountNumber IN ('FNB-10000001', 'FNB-10000002');


 -- ----------------------------------------------------------------
-- SECTION D — Q7: Filtering and Sorting
-- ----------------------------------------------------------------

SELECT CustomerID,
       FullName,
       IDNumber,
       DateOfBirth
  FROM dbo.Customers
 WHERE FullName LIKE '%oo%'
 ORDER BY DateOfBirth DESC;
GO


-- ----------------------------------------------------------------
-- SECTION D — Q8: Joins
-- ----------------------------------------------------------------

-- Q8.1: INNER JOIN - only customers who have an account
SELECT c.FullName,
       a.AccountNumber,
       a.Balance
  FROM dbo.Customers AS c
 INNER JOIN dbo.Accounts AS a
         ON c.CustomerID = a.CustomerID;
GO


-- Q8.2: LEFT JOIN - ALL customers including those with no account
SELECT c.CustomerID,
       c.FullName,
       a.AccountNumber,
       a.Balance
  FROM dbo.Customers AS c
  LEFT JOIN dbo.Accounts AS a
         ON c.CustomerID = a.CustomerID;
GO


-- ----------------------------------------------------------------
-- SECTION D — Q9: Aggregation and Functions
-- ----------------------------------------------------------------

-- Q9.1: Total Bank Liability formatted as ZAR currency
SELECT 'R ' + FORMAT(SUM(Balance), 'N2') AS TotalBankLiability
  FROM dbo.Accounts;
GO

-- Q9.2: Count transactions per Type, only show types with more than 5
SELECT   Type,
         COUNT(*) AS TransactionCount
  FROM   dbo.Transactions
 GROUP BY Type
HAVING   COUNT(*) > 5;
GO

-- Q9.3: Display FullName in UPPERCASE alongside original name
SELECT FullName,
       UPPER(FullName) AS FullNameUppercase
  FROM dbo.Customers;
GO