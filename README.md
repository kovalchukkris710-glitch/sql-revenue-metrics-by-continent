# Revenue Metrics by Continent

## Project overview

Google BigQuery project that calculates revenue, account, verification, and session metrics by continent.

## Metrics

- total revenue;
- revenue from mobile;
- revenue from desktop;
- percentage of total revenue;
- unique account count;
- verified account count;
- unique session count.

## SQL techniques used

- Common Table Expressions
- `JOIN`
- conditional aggregation with `CASE`
- `COUNT(DISTINCT)`
- `SAFE_DIVIDE`
- grouping and sorting

## Files

- [SQL query](sql/revenue_metrics_by_continent.sql)
- [Query result](results/revenue_metrics_by_continent.csv)

## Result

The query creates an aggregated report that compares revenue and user activity across continents.
