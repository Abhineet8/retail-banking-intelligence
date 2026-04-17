# Retail Banking Intelligence Platform

![SQL Server](https://img.shields.io/badge/SQL_Server_2022-CC2927?style=flat-square&logo=microsoftsqlserver&logoColor=white)
![Power BI](https://img.shields.io/badge/Power_BI-F2C811?style=flat-square&logo=powerbi&logoColor=black)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat-square&logo=docker&logoColor=white)
![Git](https://img.shields.io/badge/Git-F05032?style=flat-square&logo=git&logoColor=white)
![Power Platform](https://img.shields.io/badge/Power_Platform-742774?style=flat-square&logo=microsoftpowerplatform&logoColor=white)
![Status](https://img.shields.io/badge/Status-In_Progress-f0b860?style=flat-square)

> End-to-end retail banking analytics system built on real anonymised Czech bank data — transaction monitoring, loan portfolio risk, and credit card cross-sell analytics, with a loan exception workflow in Power Platform.

---

## Problem Statement

A Czech bank recorded 6 years of real transaction, loan, and credit card data across 5,369 clients. The data lived in flat files with Czech-encoded values, non-standard date formats, and no analytics layer on top of it.

This project transforms that raw data into a production-style analytics system: a SQL Server data warehouse, three Power BI dashboards covering the core business questions a retail bank cares about, and a loan exception management workflow in Power Platform.

---

## Dataset

**Source:** Czech Financial Dataset — PKDD'99 Discovery Challenge  
**Origin:** Real anonymised data from a Czech financial institution, 1993–1998  
**Scale:** 1,079,688 total rows across 8 tables

| File | Rows | Description |
|------|------|-------------|
| trans.asc | 1,056,320 | All account transactions |
| client.asc | 5,369 | Client demographics |
| disp.asc | 5,369 | Client-account relationships |
| account.asc | 4,500 | Account static data |
| order.asc | 6,471 | Standing payment orders |
| loan.asc | 682 | Loans with repayment status |
| card.asc | 892 | Credit cards issued |
| district.asc | 77 | District demographics + economic data |

**Known source data issues documented:**
- Transaction type codes encoded in Czech (`PRIJEM`, `VYDAJ`, `VYBER KARTOU` etc) — decoded via translation layer
- Loan status values wrapped in quotes with carriage returns (`"A"` → `A`) — cleaned in curated ETL
- Gender not a column — derived from `birth_number` encoding (month > 50 = female)
- Unemployment and crime rate columns in district file contain missing values — loaded as `VARCHAR` in staging, handled in curated layer
- Dates in `YYMMDD` format — converted to proper `DATE` in curated layer

---

## Architecture

```
Raw .asc files (8 tables)
        │
        ▼
┌─────────────────────┐
│   bank_staging      │  Raw data loaded as-is. No transforms.
│   (SQL Server)      │  Czech codes, raw dates, quoted values.
└─────────────────────┘
        │
        ▼
┌─────────────────────┐
│  Translation Layer  │  Czech → English lookup tables.
│  (SQL Server)       │  lkp_transaction_type, lkp_operation,
│                     │  lkp_k_symbol, lkp_frequency
└─────────────────────┘
        │
        ▼
┌─────────────────────┐
│   bank_curated      │  Star schema. Clean dates, decoded gender,
│   (SQL Server)      │  translated codes, proper types.
│                     │  FACT_TRANSACTIONS, FACT_LOANS, FACT_CARDS
│                     │  DIM_DATE, DIM_ACCOUNT, DIM_CLIENT, DIM_DISTRICT
└─────────────────────┘
        │
        ▼
┌─────────────────────┐
│   Power BI          │  Semantic model connected to bank_curated.
│   Desktop           │  DAX measure library. Incremental refresh.
│                     │  RLS by district.
└─────────────────────┘
        │
        ▼
┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│  Transaction │  │    Loan      │  │    Card      │
│  Monitoring  │  │  Portfolio   │  │  Analytics   │
│  Dashboard   │  │  Dashboard   │  │  + Cross-sell│
└──────────────┘  └──────────────┘  └──────────────┘
        
┌─────────────────────────────────────────┐
│   Power Platform — Loan Exception Workflow
│   Dataverse → Canvas App → Power Automate
│   Analyst flags bad loan → Supervisor review
│   → Audit trail → ALM packaged solution
└─────────────────────────────────────────┘
```

---

## Star Schema

```
                    DIM_DATE
                       │
DIM_DISTRICT ──── FACT_TRANSACTIONS ──── DIM_ACCOUNT ──── DIM_CLIENT
                       
DIM_DISTRICT ──── FACT_LOANS ──── DIM_ACCOUNT ──── DIM_CLIENT

                  FACT_CARDS ──── DIM_ACCOUNT ──── DIM_CLIENT
```

**Fact grains:**
- `FACT_TRANSACTIONS` — one row per transaction (1,056,320 rows)
- `FACT_LOANS` — one row per loan (682 rows)
- `FACT_CARDS` — one row per card issued (892 rows)

---

## Dashboards

### 1 — Transaction Monitoring
- Daily and monthly transaction volumes and average balances
- Card (CCW) vs cash withdrawal vs credit breakdown
- District-level transaction volumes overlaid with average salary data
- Running balance anomaly detection — accounts flagged where balance goes negative

### 2 — Loan Portfolio Risk
- Loan status breakdown: A (good/finished) · B (good/running) · C (bad/running) · D (bad/finished)
- Bad loan rate % by district correlated with unemployment rate
- Outstanding balance vs repayment progress by duration bucket (12/24/36/48/60 months)
- Client risk segmentation by age group and district economic indicators

### 3 — Card Analytics + Cross-sell
- Card issuance trend by type (classic / gold / junior)
- Card vs non-card transaction pattern analysis per account segment
- Cross-sell signal: accounts with 12+ months clean history and no card issued
- RLS by district — each regional manager sees only their data

---

## Data Quality Checks

7 checks run against staging before any data moves to curated:

| Check | Expected | Result |
|-------|----------|--------|
| Orphan transactions (no matching account) | 0 | ✅ 0 |
| Orphan loans (no matching account) | 0 | ✅ 0 |
| Negative transaction amounts | 0 | ✅ 0 |
| NULL account_ids in transactions | 0 | ✅ 0 |
| Invalid loan status values | 0 | ✅ 0 |
| Orphan cards (no matching disposition) | 0 | ✅ 0 |
| Duplicate transaction IDs | 0 | ✅ 0 |

**Note on loan status:** Raw values were `"A"`, `"B"`, `"C"`, `"D"` (quoted with carriage returns). DQ check uses `REPLACE/TRIM` to normalise before validation. Clean values written to curated layer.

---

## Repo Structure

```
retail-banking-intelligence/
│
├── sql/
│   ├── 01_create_database.sql        # bank_staging + bank_curated
│   ├── 02_staging_tables.sql         # 8 staging table definitions
│   ├── 03_load_staging.sql           # BULK INSERT from .asc files
│   ├── 04_etl_log.sql                # ETL run log table + initial entries
│   ├── 05_translation_layer.sql      # Czech → English lookup tables
│   ├── 06_dq_checks.sql              # 7 data quality checks
│   ├── 07_curated_schema.sql         # Star schema DDL (coming)
│   ├── 08_etl_curated.sql            # Staging → curated ETL (coming)
│   └── 09_incremental_load.sql       # Watermark + incremental logic (coming)
│
├── powerbi/                          # Power BI project files (coming)
│   ├── retail_banking.pbip
│   └── release/
│       └── retail_banking.pbix
│
├── security/
│   └── rls.md                        # RLS design + limitations (coming)
│
├── powerplatform/                    # Power Platform components (coming)
│   ├── solution_exports/
│   ├── alm.md
│   └── solution-checker/
│
├── docs/
│   └── kpi-glossary.md              # KPI definitions + grain (coming)
│
├── videos/                           # Demo links (coming)
│
└── README.md
```

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Database | SQL Server 2022 (Docker) |
| ETL | T-SQL, BULK INSERT |
| BI | Power BI Desktop, DAX, Power Query |
| Automation | Power Automate |
| App | Power Apps (Canvas) |
| Data platform | Microsoft Dataverse |
| Version control | Git, GitHub |
| Dev environment | Docker, VS Code |

---

## Local Setup

**Prerequisites:** Docker Desktop, VS Code, SQL Server (mssql) VS Code extension

```bash
# Pull and start SQL Server
docker pull mcr.microsoft.com/mssql/server:2022-latest
docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=YourPassword!" \
  -p 1433:1433 --name sqlserver -d \
  mcr.microsoft.com/mssql/server:2022-latest

# After restart
docker start sqlserver
```

Connect VS Code to `localhost` with username `sa`.

Run SQL scripts in order: `01` → `02` → `03` → `04` → `05` → `06`

---

## Build Status

- [x] Dev environment — Docker + SQL Server + VS Code
- [x] Staging layer — 8 tables, 1,079,688 rows loaded
- [x] Translation layer — Czech codes decoded to English
- [x] ETL run log — all loads documented
- [x] Data quality checks — 7 checks, all passing
- [ ] Star schema — curated layer
- [ ] ETL scripts — staging to curated
- [ ] Incremental load — watermark pattern on trans_date
- [ ] Power BI — semantic model + 3 dashboards
- [ ] RLS — by district
- [ ] Incremental refresh — RangeStart/RangeEnd on FACT_TRANSACTIONS
- [ ] Power Platform — loan exception workflow
- [ ] ALM — solution packaging + Solution Checker
- [ ] Portfolio — demo video + case study finalised

---
