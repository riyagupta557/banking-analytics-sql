--===========================================================================================
-- BUISNESS ANALYSIS
--===========================================================================================

---------------------------------------CUSTOMER ANALYTICS------------------------------------

--Who are the top 10 most valuable customers based on total account balance?

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(a.balance) AS total_balance
FROM customer c
JOIN account a
    ON c.customer_id = a.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY total_balance DESC
LIMIT 10;

--Which customer segments have the highest total account balances?

SELECT
    ct.type_name AS customer_segment,
    SUM(a.balance) AS total_balance
FROM customer c
JOIN customer_type ct
    ON c.customer_type_id = ct.customer_type_id
JOIN account a
    ON c.customer_id = a.customer_id
GROUP BY ct.type_name
ORDER BY total_balance DESC;

--Which customers have an account but have never participated in a transaction?

SELECT
    c.customer_id,
    c.first_name,
    c.last_name
FROM customer c
JOIN account a
    ON c.customer_id = a.customer_id
LEFT JOIN transactions t
    ON a.account_id = t.account_origin_id
    OR a.account_id = t.account_destination_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
HAVING COUNT(t.transaction_id) = 0
ORDER BY c.customer_id;

--How long has each customer been with the bank?

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    MIN(a.opening_date) AS customer_start_date,
	AGE(CURRENT_DATE, MIN(a.opening_date)) AS tenure
FROM customer c
JOIN account a
    ON c.customer_id = a.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY tenure DESC NULLS LAST;

---------------------------------------ACCOUNT ANALYTICS------------------------------------

--What percentage of total bank balance is held by each account type?

SELECT
    at.type_name AS account_type,
    SUM(a.balance) AS total_balance,
    ROUND(
        SUM(a.balance) * 100.0 /
        SUM(SUM(a.balance)) OVER (),
        2
    ) AS balance_percentage
FROM account a
JOIN account_type at
    ON a.account_type_id = at.account_type_id
GROUP BY at.type_name
ORDER BY total_balance DESC;

--Which 10 accounts have the highest balances?

SELECT
    account_id,
    customer_id,
    balance
FROM account
ORDER BY balance DESC NULLS LAST
LIMIT 10;

--Which account statuses have the highest number of accounts?

SELECT
    ast.status_name AS account_status,
    COUNT(*) AS account_count
FROM account a
JOIN account_status ast
    ON a.account_status_id = ast.account_status_id
GROUP BY ast.status_name
ORDER BY account_count DESC;

------------------------------------TRANSACTIONS ANALYTICS------------------------------------

--How many transactions occur each month?

SELECT
    DATE_TRUNC('month', transaction_date)::DATE AS month,
    COUNT(*) AS transaction_count
FROM transactions
WHERE transaction_date IS NOT NULL
GROUP BY DATE_TRUNC('month', transaction_date)::DATE
ORDER BY month;

--What is the monthly transaction value and month-over-month change in transaction value?

WITH monthly_transactions AS (
    SELECT
        DATE_TRUNC('month', transaction_date)::DATE AS month,
        SUM(amount) AS total_transaction_value
    FROM transactions
    WHERE transaction_date IS NOT NULL
    GROUP BY DATE_TRUNC('month', transaction_date)
)

SELECT
    month,
    total_transaction_value,
    total_transaction_value
        - LAG(total_transaction_value) OVER (ORDER BY month)
        AS mom_change
FROM monthly_transactions
ORDER BY month;

--Which transaction types are most frequently used?

SELECT
    tt.type_name AS transaction_type,
    COUNT(*) AS transaction_count
FROM transactions t
JOIN transaction_type tt
    ON t.transaction_type_id = tt.transaction_type_id
GROUP BY tt.type_name
ORDER BY transaction_count DESC;

--Which branches process the highest transaction volume and transaction value?

SELECT
    b.branch_name,
    COUNT(t.transaction_id) AS transaction_count,
    SUM(t.amount) AS total_transaction_value
FROM transactions t
JOIN branch b
    ON t.branch_id = b.branch_id
GROUP BY b.branch_name
ORDER BY total_transaction_value DESC;

--What are the peak transaction hours?

SELECT
    EXTRACT(HOUR FROM transaction_date) AS transaction_hour,
    COUNT(*) AS transaction_count
FROM transactions
WHERE transaction_date IS NOT NULL
GROUP BY EXTRACT(HOUR FROM transaction_date)
ORDER BY transaction_count DESC;

--------------------------------------LOAN ANALYTICS------------------------------------

--Which loan statuses are most common, and what is the total principal amount associated
--with each status.

SELECT
    ls.status_name AS loan_status,
    COUNT(l.loan_id) AS loan_count,
    SUM(l.principal_amount) AS total_principal_amount
FROM loan l
JOIN loan_status ls
    ON l.loan_status_id = ls.loan_status_id
GROUP BY ls.status_name
ORDER BY loan_count DESC;

--What percentage of loans are overdue?

SELECT
    ROUND(
        SUM(
            CASE
                WHEN LOWER(ls.status_name) = 'overdue' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS overdue_rate
FROM loan l
JOIN loan_status ls
    ON l.loan_status_id = ls.loan_status_id;

--How are loans distributed across customer segments?

SELECT
    ct.type_name AS customer_segment,
    COUNT(l.loan_id) AS loan_count,
    SUM(l.principal_amount) AS total_principal_amount
FROM loan l
JOIN account a
    ON l.account_id = a.account_id
JOIN customer c
    ON a.customer_id = c.customer_id
JOIN customer_type ct
    ON c.customer_type_id = ct.customer_type_id
GROUP BY ct.type_name
ORDER BY loan_count DESC;

-----------------------------------BRANCH PERFORMANCE------------------------------------

--Which branches serve the most customers?

SELECT
    b.branch_name,
    COUNT(DISTINCT a.customer_id) AS customer_count
FROM branch b
JOIN transactions t
    ON b.branch_id = t.branch_id
JOIN account a
    ON a.account_id = t.account_origin_id
GROUP BY b.branch_name
ORDER BY customer_count DESC;

--Which branches process the highest transaction value?

SELECT
    b.branch_name,
    COUNT(t.transaction_id) AS transaction_count,
    SUM(t.amount) AS total_transaction_value
FROM branch b
JOIN transactions t
    ON b.branch_id = t.branch_id
GROUP BY b.branch_name
ORDER BY total_transaction_value DESC;

--Which branches manage the highest account balances?

SELECT
    b.branch_name,
    SUM(DISTINCT a.balance) AS total_account_balance
FROM branch b
JOIN transactions t
    ON b.branch_id = t.branch_id
JOIN account a
    ON a.account_id = t.account_origin_id
GROUP BY b.branch_name
ORDER BY total_account_balance DESC;

--Which branches issues the most loans?

SELECT
    b.branch_name,
    COUNT(DISTINCT l.loan_id) AS loan_count
FROM branch b
JOIN transactions t
    ON b.branch_id = t.branch_id
JOIN account a
    ON a.account_id = t.account_origin_id
JOIN loan l
    ON l.account_id = a.account_id
GROUP BY b.branch_name
ORDER BY loan_count DESC;

----------------------------------RISK AND MONITORING------------------------------------

--Rank customers with multiple loans based on their total loan exposure.

WITH customer_loans AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        COUNT(l.loan_id) AS loan_count,
        SUM(l.principal_amount) AS total_loan_exposure
    FROM customer c
    JOIN account a
        ON c.customer_id = a.customer_id
    JOIN loan l
        ON a.account_id = l.account_id
    GROUP BY
        c.customer_id,
        c.first_name,
        c.last_name
    HAVING COUNT(l.loan_id) > 1
)

SELECT
    customer_id,
    first_name,
    last_name,
    loan_count,
    total_loan_exposure,
    RANK() OVER (
        ORDER BY total_loan_exposure DESC
    ) AS loan_exposure_rank
FROM customer_loans
ORDER BY loan_exposure_rank;


