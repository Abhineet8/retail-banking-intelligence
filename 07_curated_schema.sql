USE bank_curated;
GO
/*
CREATE TABLE DIM_DATE (
    date_key        INT PRIMARY KEY,
    full_date       DATE,
    year            INT,
    month           INT,
    month_name      VARCHAR(10),
    quarter         INT,
    day_of_month    INT,
    day_of_week     INT,
    day_name        VARCHAR(10),
    is_weekend      BIT
);
GO

CREATE TABLE DIM_DISTRICT (
    district_key        INT PRIMARY KEY IDENTITY(1,1),
    district_id         INT,
    district_name       VARCHAR(50),
    region              VARCHAR(50),
    population          INT,
    avg_salary          INT,
    unemployment_rate   DECIMAL(5,2),
    num_entrepreneurs   INT,
    num_crimes          INT
);
GO

CREATE TABLE DIM_CLIENT (
    client_key      INT PRIMARY KEY IDENTITY(1,1),
    client_id       INT,
    gender          VARCHAR(10),
    birth_date      DATE,
    age             INT,
    district_id     INT
);
GO

CREATE TABLE DIM_ACCOUNT (
    account_key     INT PRIMARY KEY IDENTITY(1,1),
    account_id      INT,
    district_id     INT,
    frequency       VARCHAR(50),
    open_date       DATE
);
GO

CREATE TABLE FACT_TRANSACTIONS (
    trans_key       INT PRIMARY KEY IDENTITY(1,1),
    trans_id        INT,
    account_id      INT,
    date_key        INT,
    trans_date      DATE,
    type            VARCHAR(30),
    operation       VARCHAR(50),
    amount          DECIMAL(10,2),
    balance         DECIMAL(10,2),
    k_symbol        VARCHAR(50),
    bank            VARCHAR(10)
);
GO

CREATE TABLE FACT_LOANS (
    loan_key        INT PRIMARY KEY IDENTITY(1,1),
    loan_id         INT,
    account_id      INT,
    date_key        INT,
    loan_date       DATE,
    amount          DECIMAL(10,2),
    duration        INT,
    payments        DECIMAL(10,2),
    status          VARCHAR(5),
    status_desc     VARCHAR(30)
);
GO

CREATE TABLE FACT_CARDS (
    card_key        INT PRIMARY KEY IDENTITY(1,1),
    card_id         INT,
    account_id      INT,
    date_key        INT,
    issued_date     DATE,
    card_type       VARCHAR(20)
);
GO
*/

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;