- # RetailOps 360

An end-to-end retail analytics project analysing 100,000+ real 
e-commerce orders using SQL, Python, and Power BI.

## Dataset
Brazilian E-Commerce Public Dataset by Olist (Kaggle)
~100,000 orders | January 2017 – September 2018 | 7 relational tables

> Data filtered to Jan 2017 – Sep 2018 to exclude partial months 
> at dataset boundaries, ensuring clean trend analysis.

## Project Structure

### SQL Analysis (MS SQL Server)
| File | Description |
|---|---|
| 01_data_exploration.sql | Monthly revenue and order volume trends |
| 02_sales_analysis.sql | Category revenue, peak days, weekday patterns |
| 03_basket_analysis.sql | Basket size, multi-item rate, co-purchase analysis |
| 04_kpi_summary.sql | Business KPIs, delivery performance, revenue growth rate |

### Python Analysis (Jupyter Notebook)
| Notebook | Description |
|---|---|
| demand_forecasting.ipynb | Monthly revenue trends, category performance, delivery analysis |
| customer_segmentation.ipynb | RFM customer segmentation — Champions, Loyal, At Risk, Lost |

### Dashboard (Power BI)
- Executive KPI dashboard — in progress

## Key Insights
- Revenue grew ~7x from January to November 2017 before stabilising
- November 2017 peak aligns with Black Friday — highest order volume in dataset
- Health & Beauty and Watches are top revenue-generating categories
- RFM segmentation reveals distinct customer behaviour groups across 
  recency, frequency, and monetary dimensions

## Tools
- MS SQL Server — data storage and querying
- Python / Pandas / Matplotlib / Jupyter — analysis and visualisation
- Power BI — dashboard and reporting

## Status
✅ Complete

## Dashboard Preview
### Page 1 — Executive Overview
![Executive Overview](dashboard/page1_executive_overview.png)

### Page 2 — Category Performance
![Category Performance](dashboard/page2_category_performance.png)

### Page 3 — Customer Segmentation
![Customer Segmentation](dashboard/page3_customer_segmentation.png)

### Page 4 — Delivery Performance
![Delivery Performance](dashboard/page4_delivery_performance.png)

## Author
Mohammad Ali Rafique
[LinkedIn](https://linkedin.com/in/mohammad-ali-rafique) | 
[GitHub](https://github.com/alirafique026)
