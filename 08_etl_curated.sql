USE bank_curated;
GO
/*
-- DIM_DATE: generate one row per date from 1993-01-01 to 1999-12-31
DECLARE @date DATE = '1993-01-01';
DECLARE @end  DATE = '1999-12-31';

WHILE @date <= @end
BEGIN
    INSERT INTO DIM_DATE (
        date_key, full_date, year, month, month_name,
        quarter, day_of_month, day_of_week, day_name, is_weekend
    )
    VALUES (
        CAST(FORMAT(@date, 'yyyyMMdd') AS INT),
        @date,
        YEAR(@date),
        MONTH(@date),
        DATENAME(MONTH, @date),
        DATEPART(QUARTER, @date),
        DAY(@date),
        DATEPART(WEEKDAY, @date),
        DATENAME(WEEKDAY, @date),
        CASE WHEN DATEPART(WEEKDAY, @date) IN (1, 7) THEN 1 ELSE 0 END
    );
    SET @date = DATEADD(DAY, 1, @date);
END
GO

TRUNCATE TABLE DIM_DISTRICT;
GO

INSERT INTO DIM_DISTRICT (
    district_id, district_name, region, population,
    avg_salary, unemployment_rate, num_entrepreneurs, num_crimes
)
SELECT
    district_id,
    REPLACE(REPLACE(TRIM(district_name), '"', ''), CHAR(13), ''),
    REPLACE(REPLACE(TRIM(region), '"', ''), CHAR(13), ''),
    population,
    avg_salary,
    CASE 
        WHEN ISNUMERIC(REPLACE(unemploy_96, CHAR(13), '')) = 1 
        THEN CAST(REPLACE(unemploy_96, CHAR(13), '') AS DECIMAL(5,2))
        ELSE NULL
    END,
    num_entrep,
    CASE
        WHEN ISNUMERIC(REPLACE(num_crimes_96, CHAR(13), '')) = 1 
        THEN CAST(REPLACE(num_crimes_96, CHAR(13), '') AS INT)
        ELSE NULL
    END
FROM bank_staging.dbo.stg_district;
GO

TRUNCATE TABLE DIM_CLIENT;
GO
INSERT INTO DIM_CLIENT (
    client_id, gender, birth_date, age, district_id
)
SELECT
    client_id,
    CASE 
        WHEN CAST(SUBSTRING(REPLACE(REPLACE(birth_number, '"', ''), CHAR(13), ''), 3, 2) AS INT) > 50 
        THEN 'Female' 
        ELSE 'Male' 
    END,
    CASE
        WHEN CAST(SUBSTRING(REPLACE(REPLACE(birth_number, '"', ''), CHAR(13), ''), 3, 2) AS INT) > 50
        THEN TRY_CAST(
            CONCAT(
                '19', SUBSTRING(REPLACE(REPLACE(birth_number, '"', ''), CHAR(13), ''), 1, 2), '-',
                CAST(CAST(SUBSTRING(REPLACE(REPLACE(birth_number, '"', ''), CHAR(13), ''), 3, 2) AS INT) - 50 AS VARCHAR), '-',
                SUBSTRING(REPLACE(REPLACE(birth_number, '"', ''), CHAR(13), ''), 5, 2)
            ) AS DATE)
        ELSE TRY_CAST(
            CONCAT(
                '19', SUBSTRING(REPLACE(REPLACE(birth_number, '"', ''), CHAR(13), ''), 1, 2), '-',
                SUBSTRING(REPLACE(REPLACE(birth_number, '"', ''), CHAR(13), ''), 3, 2), '-',
                SUBSTRING(REPLACE(REPLACE(birth_number, '"', ''), CHAR(13), ''), 5, 2)
            ) AS DATE)
    END,
    YEAR(GETDATE()) - CAST(CONCAT('19', SUBSTRING(REPLACE(REPLACE(birth_number, '"', ''), CHAR(13), ''), 1, 2)) AS INT),
    district_id
FROM bank_staging.dbo.stg_client;
GO


INSERT INTO DIM_ACCOUNT (
    account_id, district_id, frequency, open_date
)
SELECT
    a.account_id,
    a.district_id,
    ISNULL(f.frequency_english, 'Unknown'),
    TRY_CAST(
        CONCAT(
            '19', SUBSTRING(CAST(a.date_raw AS VARCHAR), 1, 2), '-',
            SUBSTRING(CAST(a.date_raw AS VARCHAR), 3, 2), '-',
            SUBSTRING(CAST(a.date_raw AS VARCHAR), 5, 2)
        ) AS DATE
    )
FROM bank_staging.dbo.stg_account a
LEFT JOIN bank_staging.dbo.lkp_frequency f 
    ON REPLACE(REPLACE(TRIM(a.frequency), '"', ''), CHAR(13), '') = f.frequency_raw;
GO


INSERT INTO FACT_LOANS (
    loan_id, account_id, date_key, loan_date,
    amount, duration, payments, status, status_desc
)
SELECT
    l.loan_id,
    l.account_id,
    CAST(CONCAT(
        '19', SUBSTRING(CAST(l.date_raw AS VARCHAR), 1, 2),
        SUBSTRING(CAST(l.date_raw AS VARCHAR), 3, 2),
        SUBSTRING(CAST(l.date_raw AS VARCHAR), 5, 2)
    ) AS INT),
    TRY_CAST(CONCAT(
        '19', SUBSTRING(CAST(l.date_raw AS VARCHAR), 1, 2), '-',
        SUBSTRING(CAST(l.date_raw AS VARCHAR), 3, 2), '-',
        SUBSTRING(CAST(l.date_raw AS VARCHAR), 5, 2)
    ) AS DATE),
    l.amount,
    l.duration,
    l.payments,
    REPLACE(REPLACE(TRIM(l.status), '"', ''), CHAR(13), ''),
    CASE REPLACE(REPLACE(TRIM(l.status), '"', ''), CHAR(13), '')
        WHEN 'A' THEN 'Good - Finished'
        WHEN 'B' THEN 'Good - Running'
        WHEN 'C' THEN 'Bad - Running'
        WHEN 'D' THEN 'Bad - Finished'
    END
FROM bank_staging.dbo.stg_loan l;
GO


INSERT INTO FACT_CARDS (
    card_id, account_id, date_key, issued_date, card_type
)
SELECT
    c.card_id,
    d.account_id,
    CAST(CONCAT(
        '19', SUBSTRING(REPLACE(REPLACE(TRIM(c.issued_raw), '"', ''), CHAR(13), ''), 1, 2),
        SUBSTRING(REPLACE(REPLACE(TRIM(c.issued_raw), '"', ''), CHAR(13), ''), 3, 2),
        SUBSTRING(REPLACE(REPLACE(TRIM(c.issued_raw), '"', ''), CHAR(13), ''), 5, 2)
    ) AS INT),
    TRY_CAST(CONCAT(
        '19', SUBSTRING(REPLACE(REPLACE(TRIM(c.issued_raw), '"', ''), CHAR(13), ''), 1, 2), '-',
        SUBSTRING(REPLACE(REPLACE(TRIM(c.issued_raw), '"', ''), CHAR(13), ''), 3, 2), '-',
        SUBSTRING(REPLACE(REPLACE(TRIM(c.issued_raw), '"', ''), CHAR(13), ''), 5, 2)
    ) AS DATE),
    REPLACE(REPLACE(TRIM(c.type), '"', ''), CHAR(13), '')
FROM bank_staging.dbo.stg_card c
LEFT JOIN bank_staging.dbo.stg_disposition d ON c.disp_id = d.disp_id;
GO

INSERT INTO FACT_TRANSACTIONS (
    trans_id, account_id, date_key, trans_date,
    type, operation, amount, balance, k_symbol, bank
)
SELECT
    t.trans_id,
    t.account_id,
    CAST(CONCAT(
        '19', SUBSTRING(CAST(t.date_raw AS VARCHAR), 1, 2),
        SUBSTRING(CAST(t.date_raw AS VARCHAR), 3, 2),
        SUBSTRING(CAST(t.date_raw AS VARCHAR), 5, 2)
    ) AS INT),
    TRY_CAST(CONCAT(
        '19', SUBSTRING(CAST(t.date_raw AS VARCHAR), 1, 2), '-',
        SUBSTRING(CAST(t.date_raw AS VARCHAR), 3, 2), '-',
        SUBSTRING(CAST(t.date_raw AS VARCHAR), 5, 2)
    ) AS DATE),
    ISNULL(ty.type_english, 'Unknown'),
    ISNULL(op.operation_english, 'Unknown'),
    t.amount,
    t.balance,
    ISNULL(ks.k_symbol_english, 'Other'),
    REPLACE(REPLACE(TRIM(t.bank), '"', ''), CHAR(13), '')
FROM bank_staging.dbo.stg_transaction t
LEFT JOIN bank_staging.dbo.lkp_transaction_type ty 
    ON REPLACE(REPLACE(TRIM(t.type), '"', ''), CHAR(13), '') = ty.type_raw
LEFT JOIN bank_staging.dbo.lkp_operation op 
    ON REPLACE(REPLACE(TRIM(t.operation), '"', ''), CHAR(13), '') = op.operation_raw
LEFT JOIN bank_staging.dbo.lkp_k_symbol ks 
    ON REPLACE(REPLACE(TRIM(t.k_symbol), '"', ''), CHAR(13), '') = ks.k_symbol_raw;
GO
*/
USE bank_curated;
GO

SELECT 'DIM_DATE'          AS table_name, COUNT(*) AS row_count FROM DIM_DATE
UNION ALL
SELECT 'DIM_DISTRICT',      COUNT(*) FROM DIM_DISTRICT
UNION ALL
SELECT 'DIM_CLIENT',        COUNT(*) FROM DIM_CLIENT
UNION ALL
SELECT 'DIM_ACCOUNT',       COUNT(*) FROM DIM_ACCOUNT
UNION ALL
SELECT 'FACT_LOANS',        COUNT(*) FROM FACT_LOANS
UNION ALL
SELECT 'FACT_CARDS',        COUNT(*) FROM FACT_CARDS
UNION ALL
SELECT 'FACT_TRANSACTIONS', COUNT(*) FROM FACT_TRANSACTIONS;