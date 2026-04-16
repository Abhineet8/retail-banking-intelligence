USE bank_staging;
GO
/*
BULK INSERT stg_account
FROM '/var/opt/mssql/data/bankdata/account.asc'
WITH(
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    TABLOCK
);
GO

BULK INSERT stg_client
FROM '/var/opt/mssql/data/bankdata/client.asc'
WITH (
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    TABLOCK
);
GO

BULK INSERT stg_disposition
FROM '/var/opt/mssql/data/bankdata/disp.asc'
WITH (
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    TABLOCK
);
GO

BULK INSERT stg_district
FROM '/var/opt/mssql/data/bankdata/district.asc'
WITH (
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    TABLOCK
);
GO

BULK INSERT stg_loan
FROM '/var/opt/mssql/data/bankdata/loan.asc'
WITH (
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    TABLOCK
);
GO

BULK INSERT stg_order
FROM '/var/opt/mssql/data/bankdata/order.asc'
WITH (
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    TABLOCK
);
GO

BULK INSERT stg_card
FROM '/var/opt/mssql/data/bankdata/card.asc'
WITH (
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    TABLOCK
);
GO

BULK INSERT stg_transaction
FROM '/var/opt/mssql/data/bankdata/trans.asc'
WITH (
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    TABLOCK
);
GO
*/

SELECT 'stg_account'     AS table_name, COUNT(*) AS row_count FROM stg_account
UNION ALL
SELECT 'stg_client',      COUNT(*) FROM stg_client
UNION ALL
SELECT 'stg_disposition', COUNT(*) FROM stg_disposition
UNION ALL
SELECT 'stg_district',    COUNT(*) FROM stg_district
UNION ALL
SELECT 'stg_loan',        COUNT(*) FROM stg_loan
UNION ALL
SELECT 'stg_order',       COUNT(*) FROM stg_order
UNION ALL
SELECT 'stg_card',        COUNT(*) FROM stg_card
UNION ALL
SELECT 'stg_transaction', COUNT(*) FROM stg_transaction;