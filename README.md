# FNB Student Connect — Database Solution
### MDB622 Database Manipulation | Formative Assessment 1
**Student:** Nicolette Mashaba | **Student Number:** 20232990
**Campus:** Polokwane (Online) | **NQF Level:** 6 | **Credits:** 16

---

## Project Overview

This repository contains the complete SQL Server database solution for the
FNB Student Connect banking system, developed as part of the MDB622 Database
Manipulation module at CTU Training Solutions.

The FNB Student Connect system is designed to manage student banking accounts,
track transactions, and enforce regulatory compliance with FICA and POPIA
legislation through database-level constraints.

---

## Repository Structure
```
FNB-StudentConnect-DB/
├── README.md
├── Solution.sql
└── docs/
    └── MDB622_FA01_Nicolette_Mashaba.pdf
```

---

## Database Structure

The database **FNB_StudentDB** consists of four entities normalized to
Third Normal Form (3NF):

| Table | Description |
|---|---|
| `dbo.Customers` | Stores customer personal information with age and ID number validation |
| `dbo.Accounts` | Stores bank accounts linked to customers with balance constraints |
| `dbo.Transactions` | Records all Credit and Debit transactions per account |

---

## Key Features

- Database created with **SQL Server 2022 Compatibility Level 160**
- **3NF Normalization** applied to eliminate data anomalies
- **CHECK constraints** enforce business rules at database level
- **FOREIGN KEY constraints** maintain referential integrity
- **ACID-compliant transaction** with ROLLBACK on insufficient funds
- Full **FICA and POPIA** compliance through ID number uniqueness and age validation

---

## Assessment Sections Covered

| Section | Topic |
|---|---|
| Section A | Database Design — Anomalies, Normalization, ERD, Database Creation |
| Section B | Implementation — Table Creation, Constraint Testing |
| Section C | Data Manipulation — Sample Data Insertion, Transaction Management |
| Section D | Querying — Filtering, Joins, Aggregation, Scalar Functions |

---

## How to Run

1. Open **SQL Server Management Studio (SSMS)**
2. Connect to your SQL Server instance
3. Open `Solution.sql`
4. Select all code → press **F5** to execute
5. The database and all objects will be created automatically

---

## Technologies Used

- Microsoft SQL Server 2022
- SQL Server Management Studio (SSMS)
- T-SQL (Transact-SQL)
- draw.io (ERD Design)
- Git & GitHub (Version Control)

---

## References

- Codd, E.F. (1970). *A Relational Model of Data for Large Shared Data Banks*
- Connolly, T. & Begg, C. (2015). *Database Systems: A Practical Approach*
- Microsoft (2023). *T-SQL Reference Documentation*
- Republic of South Africa (2013). *Protection of Personal Information Act (POPIA)*
- Republic of South Africa (2001). *Financial Intelligence Centre Act (FICA)*

---

*Submitted in partial fulfillment of the MDB622 module requirements.*
*CTU Training Solutions — 2026*
```

---

## How to Update it in VS Code

1. Open **VS Code**
2. Click on **README.md** in the left file panel
3. Press **Ctrl + A** to select everything
4. Press **Delete** to clear it
5. Paste the content above → **Ctrl + V**
6. Press **Ctrl + S** to save
7. Go to Source Control → stage → commit with message:
```
Update README with professional project documentation
