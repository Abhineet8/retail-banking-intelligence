# Retail Banking Intelligence Platform

## Problem Statement
Real Czech bank data (1M+ transactions, 1993-1998) transformed into a retail 
banking analytics system covering transaction monitoring, loan portfolio risk, 
and credit card cross-sell analytics.

## Dataset
Czech Financial Dataset (PKDD'99 Discovery Challenge) — anonymised real bank 
data from a Czech financial institution. 8 tables, 1,079,688 total rows.

## Architecture
Raw .asc files → SQL Server Staging → Translation Layer → Star Schema (Curated) 
→ Power BI Semantic Model → 3 Dashboards + Power Platform Loan Exception Workflow

## Data Model
- FACT_TRANSACTIONS — 1,056,320 transaction records
- FACT_LOANS — 682 loan records  
- FACT_CARDS — 892 card records
- DIM_DATE, DIM_ACCOUNT, DIM_CLIENT, DIM_DISTRICT

## Technologies
SQL Server 2022, T-SQL, Docker, Power BI, DAX, Power Query, 
Power Apps, Power Automate, Dataverse, Git, GitHub, VS Code

## Status
- [x] Staging layer — 8 tables loaded
- [x] Translation layer — Czech codes decoded
- [x] DQ checks — all 7 passing
- [ ] Star schema (curated layer)
- [ ] Power BI dashboards
- [ ] Power Platform workflow