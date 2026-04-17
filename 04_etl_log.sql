
USE bank_staging;
GO
/*
CREATE TABLE etl_run_log (
    log_id        INT IDENTITY(1,1) PRIMARY KEY,
    table_name    VARCHAR(50),
    rows_loaded   INT,
    loaded_at     DATETIME DEFAULT GETDATE(),
    status        VARCHAR(10),
    notes         VARCHAR(200)
);
GO

INSERT INTO etl_run_log (table_name, rows_loaded, status, notes)
VALUES
('stg_account',     4500,    'SUCCESS', 'Initial load from account.asc'),
('stg_client',      5369,    'SUCCESS', 'Initial load from client.asc'),
('stg_disposition', 5369,    'SUCCESS', 'Initial load from disp.asc'),
('stg_district',    77,      'SUCCESS', 'Initial load - unemploy_95/96 and crimes_95/96 loaded as VARCHAR due to missing values in source'),
('stg_loan',        682,     'SUCCESS', 'Initial load from loan.asc'),
('stg_order',       6471,    'SUCCESS', 'Initial load from order.asc'),
('stg_card',        892,     'SUCCESS', 'Initial load from card.asc'),
('stg_transaction', 1056320, 'SUCCESS', 'Initial load from trans.asc');
GO
*/
/*
SELECT * FROM etl_run_log; 
*/
