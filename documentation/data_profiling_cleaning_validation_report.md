# Data Profiling, Cleaning & Validation Report

## Overview

Before performing SQL analysis, the dataset was profiled, cleaned, and validated to ensure data quality, consistency, and referential integrity.
These preprocessing steps helped identify potential data issues, apply appropriate cleaning techniques, and verify that the dataset was reliable for 
banking analysis.

---

# 1. Data Profiling

Data profiling was performed to assess the quality of the dataset and identify inconsistencies before analysis.

### Profiling Findings

- Duplicate records were removed in Excel before importing the dataset to prevent **Primary Key constraint violations** during database import.
- Reviewed all tables for **missing (NULL) values** and identified columns requiring attention.
- Verified **date consistency** across all date columns and confirmed standardized date formats.
- Examined **categorical/text columns** and identified inconsistent country name variations (e.g., *United State*, *United StateR*, *United Sltate*).
- Analyzed **numeric columns** for abnormal values and outliers:
  - **10 negative account balances** were identified and investigated.
  - Loan principal amounts, interest rates, and transaction amounts were within expected business ranges and required no correction.

---

# 2. Data Cleaning

Based on the profiling results, the following cleaning actions were performed to improve data consistency while preserving business accuracy.

### Cleaning Actions

- Replaced missing **text values** with **'Unknown'** where appropriate to improve data completeness.
- Retained **NULL date values** because the actual dates were unavailable and could not be reliably inferred.
- Standardized inconsistent country names to **'United States'** to ensure consistent reporting and analysis.
- Preserved negative account balances after validation, as they may legitimately represent customer overdrafts.
- Retained all numeric values since no significant inconsistencies were identified.

---

# 3. Data Validation

After cleaning, validation checks were performed to ensure the dataset was accurate, consistent, and ready for analysis.

---

# Final Outcome

The dataset was successfully profiled, cleaned, and validated before analysis. Data quality issues were addressed where appropriate, duplicate 
records were removed prior to import, legitimate business values were preserved, and the dataset was confirmed to be reliable for banking analytics.
