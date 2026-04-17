USE bank_staging;
GO
/*
CREATE TABLE lkp_transaction_type (
    type_raw     VARCHAR(20),
    type_english VARCHAR(30)
);
GO

INSERT INTO lkp_transaction_type VALUES
('PRIJEM',  'Credit'),
('VYDAJ',   'Debit');
GO

CREATE TABLE lkp_operation (
    operation_raw     VARCHAR(50),
    operation_english VARCHAR(50)
);
GO

INSERT INTO lkp_operation VALUES
('VYBER KARTOU',       'Card Withdrawal'),
('VKLAD',              'Cash Credit'),
('PREVOD Z UCTU',      'Collection from Another Bank'),
('VYBER',              'Cash Withdrawal'),
('PREVOD NA UCET',     'Remittance to Another Bank');
GO

CREATE TABLE lkp_k_symbol (
    k_symbol_raw     VARCHAR(20),
    k_symbol_english VARCHAR(50)
);
GO

INSERT INTO lkp_k_symbol VALUES
('POJISTNE',       'Insurance Payment'),
('SLUZBY',         'Payment for Statement'),
('UROK',           'Interest Credited'),
('SANKC. UROK',    'Sanction Interest'),
('SIPO',           'Household Payment'),
('DUCHOD',         'Old Age Pension'),
('UVER',           'Loan Payment');
GO

CREATE TABLE lkp_frequency (
    frequency_raw     VARCHAR(50),
    frequency_english VARCHAR(50)
);
GO

INSERT INTO lkp_frequency VALUES
('POPLATEK MESICNE',    'Monthly'),
('POPLATEK TYDNE',      'Weekly'),
('POPLATEK PO OBRATU',  'After Transaction');
GO
*/
/*
SELECT * FROM lkp_transaction_type;
SELECT * FROM lkp_operation;
SELECT * FROM lkp_k_symbol;
SELECT * FROM lkp_frequency;
*/
