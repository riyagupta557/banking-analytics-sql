# Dataset

## Overview

This dataset represents a banking system with information on customers, accounts, transactions, loans, branches, and related reference data.
It provides a relational view of banking operations and supports analysis of customer behavior, account activity, transaction trends, loan performance,
and branch operations.

## Tables Included

### Core Tables

- **customers** → Customer details and customer segment information.
- **accounts** → Account details including customer, account type, status, and balance.
- **transactions** → Transaction records including transaction date, amount, account, branch, and transaction type.
- **loans** → Loan details including customer, loan type, principal amount, interest rate, and loan status.

### Reference Tables

- **customer_types** → Customer segment classifications such as Individual, Small Business, and Large Enterprise.
- **account_types** → Account categories such as Savings, Checking, Business, Payroll, and Youth.
- **account_statuses** → Account lifecycle statuses such as Active, Inactive, and Closed.
- **loan_types** → Categories of loans offered by the bank.
- **loan_statuses** → Loan statuses such as Active, Paid Off, and Overdue.
- **transaction_types** → Transaction categories such as Deposit, Transfer, Withdrawal, and Payment.
- **branches** → Branch information used for branch-level analysis.
- **addresses** → Address information associated with customers and branches.

## Data Source

[Kaggle – Finance, Fraud and Loans Dataset](https://www.kaggle.com/datasets/testdatabox/finance-fraud-and-loans-dataset-testdatabox)
