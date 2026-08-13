-- ==========================================================
-- BANKING ANALYSIS DATABASE SCHEMA
-- ==========================================================

DROP TABLE IF EXISTS transactions CASCADE;
DROP TABLE IF EXISTS loan CASCADE;
DROP TABLE IF EXISTS account CASCADE;
DROP TABLE IF EXISTS branch CASCADE;
DROP TABLE IF EXISTS customer CASCADE;
DROP TABLE IF EXISTS transaction_type CASCADE;
DROP TABLE IF EXISTS account_type CASCADE;
DROP TABLE IF EXISTS account_status CASCADE;
DROP TABLE IF EXISTS loan_status CASCADE;
DROP TABLE IF EXISTS customer_type CASCADE;
DROP TABLE IF EXISTS address CASCADE;

CREATE TABLE customer_type (

    customer_type_id INT PRIMARY KEY,

    type_name VARCHAR(30) NOT NULL

);


CREATE TABLE account_type (

    account_type_id INT PRIMARY KEY,

    type_name VARCHAR(20) NOT NULL

);

CREATE TABLE account_status (

    account_status_id INT PRIMARY KEY,

    status_name VARCHAR(15) NOT NULL

);


CREATE TABLE transaction_type (

    transaction_type_id INT PRIMARY KEY,

    type_name VARCHAR(30) NOT NULL

);


CREATE TABLE loan_status (

    loan_status_id INT PRIMARY KEY,

    status_name VARCHAR(15) NOT NULL

);

CREATE TABLE address (

    address_id INT PRIMARY KEY,

    street VARCHAR(150),

    city VARCHAR(100),

    country VARCHAR(100)

);


CREATE TABLE customer (

    customer_id INT PRIMARY KEY,

    first_name VARCHAR(100),

    last_name VARCHAR(100),

    date_of_birth DATE,

    address_id INT NOT NULL,

    customer_type_id INT NOT NULL,

    CONSTRAINT FK_CUSTOMER_ADDRESS
        FOREIGN KEY (address_id)
        REFERENCES address(address_id),

    CONSTRAINT FK_CUSTOMER_TYPE
        FOREIGN KEY (customer_type_id)
        REFERENCES customer_type(customer_type_id)

);

CREATE TABLE branch (

    branch_id INT PRIMARY KEY,

    branch_name VARCHAR(150) NOT NULL,

    address_id INT NOT NULL,

    CONSTRAINT FK_BRANCH_ADDRESS
        FOREIGN KEY (address_id)
        REFERENCES address(address_id)

);

CREATE TABLE account (

    account_id INT PRIMARY KEY,

    customer_id INT NOT NULL,

    account_type_id INT NOT NULL,

    account_status_id INT NOT NULL,

    balance NUMERIC(15,2),

    opening_date DATE,

    CONSTRAINT FK_ACCOUNT_CUSTOMER
        FOREIGN KEY (customer_id)
        REFERENCES customer(customer_id),

    CONSTRAINT FK_ACCOUNT_TYPE
        FOREIGN KEY (account_type_id)
        REFERENCES account_type(account_type_id),

    CONSTRAINT FK_ACCOUNT_STATUS
        FOREIGN KEY (account_status_id)
        REFERENCES account_status(account_status_id)

);

CREATE TABLE loan (

    loan_id INT PRIMARY KEY,

    account_id INT NOT NULL,

    loan_status_id INT NOT NULL,

    principal_amount NUMERIC(15,2)
        CHECK (principal_amount > 0),

    interest_rate NUMERIC(6,4)
        CHECK (interest_rate >= 0),

    start_date DATE,

    estimated_end_date DATE,

    CONSTRAINT FK_LOAN_ACCOUNT
        FOREIGN KEY (account_id)
        REFERENCES account(account_id),

    CONSTRAINT FK_LOAN_STATUS
        FOREIGN KEY (loan_status_id)
        REFERENCES loan_status(loan_status_id)

);

CREATE TABLE transactions (

    transaction_id INT PRIMARY KEY,

    account_origin_id INT NOT NULL,

    account_destination_id INT NOT NULL,

    transaction_type_id INT NOT NULL,

    amount NUMERIC(15,2)
        CHECK (amount > 0),

    transaction_date TIMESTAMP,

    branch_id INT NOT NULL,

    description VARCHAR(255),

    CONSTRAINT FK_TRANSACTION_ORIGIN
        FOREIGN KEY (account_origin_id)
        REFERENCES account(account_id),

    CONSTRAINT FK_TRANSACTION_DESTINATION
        FOREIGN KEY (account_destination_id)
        REFERENCES account(account_id),

    CONSTRAINT FK_TRANSACTION_TYPE
        FOREIGN KEY (transaction_type_id)
        REFERENCES transaction_type(transaction_type_id),

    CONSTRAINT FK_TRANSACTION_BRANCH
        FOREIGN KEY (branch_id)
        REFERENCES branch(branch_id)

);

