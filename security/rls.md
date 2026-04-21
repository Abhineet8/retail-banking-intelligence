# Row Level Security — Design and Limitations

## Implementation

RLS is configured in Power BI Desktop under Modeling → Manage Roles.

**Role: District Manager**
- Table: DIM_DISTRICT
- Filter: [district_name] = "Hl.m. Praha"

In production each district manager would be assigned their own role with their district name as the filter value. Power BI Service handles user-to-role assignment after publishing.

## How it works

The filter on DIM_DISTRICT propagates through the data model via relationships:

DIM_DISTRICT → DIM_ACCOUNT → FACT_TRANSACTIONS
DIM_DISTRICT → DIM_ACCOUNT → FACT_LOANS  
DIM_DISTRICT → DIM_ACCOUNT → FACT_CARDS
DIM_DISTRICT → DIM_CLIENT

A district manager assigned to Praha sees only Praha accounts, transactions, loans, and cards across all three dashboard pages automatically.

## Known limitations

**RLS restricts rows, not objects.** A Viewer with RLS applied can still see all measure names, table names, and column names in the model. Only the data rows are filtered.

**District-level comparative visuals become less meaningful** when a role restricts to a single district. The scatter chart (bad loan rate vs unemployment by district) and the district volume bar chart show only one data point under a district role. In production these would be replaced with account-level drill-downs for district manager roles.

**Dynamic RLS** — a more production-ready approach would use USERPRINCIPALNAME() to map the logged-in user to their district dynamically, rather than creating one static role per district. This was not implemented here as it requires Power BI Service with Pro licence.

## Testing

Tested in Power BI Desktop using Modeling → View as → District Manager.
Result: all three dashboard pages correctly filtered to Hl.m. Praha data only.