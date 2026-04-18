USE bank_staging;
GO
/*
-- 1. Transactions with no matching account
SELECT COUNT(*) AS orphan_transactions
FROM stg_transaction t
LEFT JOIN stg_account a ON t.account_id = a.account_id
WHERE a.account_id IS NULL;
GO

-- 2. Loans with no matching account
SELECT COUNT(*) AS orphan_loans
FROM stg_loan l
LEFT JOIN stg_account a ON l.account_id = a.account_id
WHERE a.account_id IS NULL;
GO

-- 3. Negative transaction amounts
SELECT COUNT(*) AS negative_amounts
FROM stg_transaction
WHERE amount < 0;
GO

-- 4. NULL account_ids in transactions
SELECT COUNT(*) AS null_account_ids
FROM stg_transaction
WHERE account_id IS NULL;
GO

-- 5. Loans with invalid status (only A B C D are valid)
SELECT COUNT(*) AS invalid_loan_status
FROM stg_loan
WHERE REPLACE(REPLACE(TRIM(status), '"', ''), CHAR(13), '') 
      NOT IN ('A', 'B', 'C', 'D');

-- 6. Cards with no matching disposition
SELECT COUNT(*) AS orphan_cards
FROM stg_card c
LEFT JOIN stg_disposition d ON c.disp_id = d.disp_id
WHERE d.disp_id IS NULL;
GO

-- 7. Duplicate transaction ids
SELECT COUNT(*) AS duplicate_trans_ids
FROM (
    SELECT trans_id, COUNT(*) AS cnt
    FROM stg_transaction
    GROUP BY trans_id
    HAVING COUNT(*) > 1
) duplicates;
GO
*/

--SELECT DISTINCT status FROM stg_loan;