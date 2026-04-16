USE bank_staging;
GO


CREATE TABLE stg_account (
    account_id INT,
    district_id INT,
    frequency VARCHAR(50),
    date_raw VARCHAR(10)
);
GO


CREATE TABLE stg_card (
    card_id INT,
    disp_id INT,
    type VARCHAR(20),
    issued_raw VARCHAR(20)
);
GO

CREATE TABLE stg_client(
    client_id INT,
    birth_number VARCHAR(20),
    district_id INT
);
GO

CREATE TABLE stg_disposition(
    disp_id INT,
    client_id INT,
    account_id INT,
    type VARCHAR(20)
);
GO

CREATE TABLE stg_district (
    district_id        INT,
    district_name      VARCHAR(50),
    region             VARCHAR(50),
    population         INT,
    num_munic_under499 INT,
    num_munic_500_1999 INT,
    num_munic_2000_9999 INT,
    num_munic_over10000 INT,
    num_cities         INT,
    urban_ratio        DECIMAL(5,2),
    avg_salary         INT,
    unemploy_95    DECIMAL(5,2),
    unemploy_96    DECIMAL(5,2),
    num_entrep  INT,
    num_crimes_95      INT,
    num_crimes_96      INT
);
GO

CREATE TABLE stg_loan(
    loan_id INT,
    account_id INT,
    date_raw varchar (10),
    amount DECIMAL (10,2),
    duration INT,
    payments DECIMAL (10,2),
    status VARCHAR (5)
);
GO

CREATE TABLE stg_order (
    order_id    INT,
    account_id  INT,
    bank_to     VARCHAR(10),
    account_to  VARCHAR(20),
    amount      DECIMAL(10,2),
    k_symbol    VARCHAR(20)
);
GO

CREATE TABLE stg_transaction (
    trans_id    INT,
    account_id  INT,
    date_raw    VARCHAR(10),
    type        VARCHAR(20),
    operation   VARCHAR(50),
    amount      DECIMAL(10,2),
    balance     DECIMAL(10,2),
    k_symbol    VARCHAR(20),
    bank        VARCHAR(10),
    account_to  VARCHAR(20)
);
GO

/*
SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;
*/