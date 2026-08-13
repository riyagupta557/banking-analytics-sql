--===================================================
-- DATA PROFILING,CLEANING AND VALIDATION
--===================================================

--RECORD COUNT VERIFICATION

SELECT COUNT(*) FROM customer;
SELECT COUNT(*) FROM address;
SELECT COUNT(*) FROM account;
SELECT COUNT(*) FROM branch;
SELECT COUNT(*) FROM transactions;
SELECT COUNT(*) FROM loan;


--MISSING VALUE ANALYSIS

SELECT
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(first_name) AS missing_first_name,
    COUNT(*) - COUNT(last_name) AS missing_last_name,
    COUNT(*) - COUNT(date_of_birth) AS missing_date_of_birth
FROM customer;

SELECT
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(street) AS missing_street,
    COUNT(*) - COUNT(city) AS missing_city,
    COUNT(*) - COUNT(country) AS missing_country
FROM address;

SELECT
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(balance) AS missing_balance,
    COUNT(*) - COUNT(opening_date) AS missing_opening_date
FROM account;

SELECT
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(branch_name) AS missing_branch_name,
    COUNT(*) - COUNT(address_id) AS missing_address_id
FROM branch;

SELECT
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(principal_amount) AS missing_principal_amount,
    COUNT(*) - COUNT(interest_rate) AS missing_interest_rate,
    COUNT(*) - COUNT(start_date) AS missing_start_date,
    COUNT(*) - COUNT(estimated_end_date) AS missing_estimated_end_date
FROM loan;

SELECT
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(amount) AS missing_amount,
    COUNT(*) - COUNT(transaction_date) AS missing_transaction_date,
    COUNT(*) - COUNT(description) AS missing_description
FROM transactions;


--CHECKING FOR TEXT INCONSISTENCIES AND TYPOS

SELECT 
    city,
    COUNT(*) AS frequency
FROM address
GROUP BY city
ORDER BY frequency DESC;

SELECT 
    country,
    COUNT(*) AS frequency
FROM address
GROUP BY country
ORDER BY frequency DESC;

SELECT 
    branch_name,
    COUNT(*) AS frequency
FROM branch
GROUP BY branch_name
ORDER BY frequency DESC;


--CHECKING FOR NUMERIC ANOMALIES

SELECT
    MIN(balance) AS min_balance,
    MAX(balance) AS max_balance,
    AVG(balance) AS avg_balance
FROM account;

SELECT
    MIN(principal_amount) AS min_principal,
    MAX(principal_amount) AS max_principal,
    AVG(principal_amount) AS avg_principal
FROM loan;

SELECT
    MIN(interest_rate) AS min_interest_rate,
    MAX(interest_rate) AS max_interest_rate,
    AVG(interest_rate) AS avg_interest_rate
FROM loan;

SELECT
    MIN(amount) AS min_amount,
    MAX(amount) AS max_amount,
    AVG(amount) AS avg_amount
FROM transactions;

--HANDLING MISSING VALUES

UPDATE customer
SET first_name = 'Unknown'
WHERE first_name IS NULL;

UPDATE customer
SET last_name = 'Unknown'
WHERE last_name IS NULL;

UPDATE address
SET street = 'Unknown'
WHERE street IS NULL;

UPDATE address
SET city = 'Unknown'
WHERE city IS NULL;

UPDATE address
SET country = 'Unknown'
WHERE country IS NULL;

--HANDLING TEXT INCONSISTENCIES AND TYPOS 

SELECT DISTINCT country
FROM address
ORDER BY country;

UPDATE address
SET country = 'United States'
WHERE country IN (
    'Pnited States',
    'Unitd States',
    'United Slates',
    'United Staes',
    'United State',
    'United StateR',
    'United StXtes',
    'United vtates',
    'United0States',
    'UnitedcStates'
);

--VALIDATING THE UPDATES

SELECT
    COUNT(*) - COUNT(first_name) AS remaining_missing_first_name,
    COUNT(*) - COUNT(last_name) AS remaining_missing_last_name
FROM customer;

SELECT
    COUNT(*) - COUNT(street) AS remaining_missing_street,
    COUNT(*) - COUNT(city) AS remaining_missing_city,
    COUNT(*) - COUNT(country) AS remaining_missing_country
FROM address;

SELECT
    country,
    COUNT(*) AS frequency
FROM address
GROUP BY country
ORDER BY country;


