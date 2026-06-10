# Supply Chain Analysis

## Overview
Analyzed **180,519 supply chain orders** to identify delivery patterns, regional 
performance, shipping trends, and profit impact. The goal was to understand 
where delays are happening, which markets and segments drive the most sales, 
and how delivery performance affects overall profitability.

---

## Objectives
- Identify the most common delivery issues across all orders
- Analyze which markets, regions, and customer segments drive the most sales
- Understand which shipping modes are most frequently used and most delayed
- Measure the impact of late deliveries on profit
- Identify high-value orders using advanced SQL techniques

---

## Tools Used
- **MySQL Workbench** — wrote 12 SQL queries including GROUP BY, CASE WHEN, 
  Window Functions, and CTEs to analyze delivery performance, sales, and profit
- **Python (Pandas, Matplotlib)** — loaded, cleaned, and visualized the dataset
- **Excel** — used Pivot Tables, COUNTIF, and SUMIF to validate data integrity
- **Power BI** — built an interactive dashboard with KPI cards, DAX measures, 
  bar charts, pie charts, and slicers to filter by region, market, and 
  shipping mode

---

## Dataset
- **Total Orders:** 180,519
- **Total Columns:** 53
- **Data includes:** Customer details, order information, delivery status, 
  shipping mode, market, region, sales, and profit per order

---

## SQL Queries Used

**Query 1: Total Number of Orders**
```sql
SELECT COUNT(*) AS Total_Orders
FROM supply_chain_cleaned;
```
Objective: Find the total number of orders in the dataset.

---

**Query 2: Delivery Status with Percentage**
```sql
SELECT 
    `Delivery Status`,
    COUNT(*) AS Total_Orders,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM supply_chain_cleaned), 1) AS Percentage
FROM supply_chain_cleaned
GROUP BY `Delivery Status`
ORDER BY Total_Orders DESC;
```
Objective: Count how many orders fall under each delivery status, with percentage share.

---

**Query 3: Orders by Shipping Mode**
```sql
SELECT 
    `Shipping Mode`,
    COUNT(*) AS Total_Orders,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM supply_chain_cleaned), 1) AS Percentage
FROM supply_chain_cleaned
GROUP BY `Shipping Mode`
ORDER BY Total_Orders DESC;
```
Objective: Find out which shipping mode is used most frequently.

---

**Query 4: Late Delivery Count by Shipping Mode**
```sql
SELECT 
    `Shipping Mode`,
    COUNT(*) AS Late_Orders,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM supply_chain_cleaned 
        WHERE `Delivery Status` = 'Late delivery'), 1) AS Pct_of_Total_Late
FROM supply_chain_cleaned
WHERE `Delivery Status` = 'Late delivery'
GROUP BY `Shipping Mode`
ORDER BY Late_Orders DESC;
```
Objective: Identify which shipping mode contributes the most to late deliveries.

---

**Query 5: Average Delay Days by Shipping Mode**
```sql
SELECT 
    `Shipping Mode`,
    ROUND(AVG(`Days for shipping (real)` - `Days for shipment (scheduled)`), 2) AS Avg_Delay_Days,
    ROUND(AVG(`Days for shipping (real)`), 1) AS Avg_Actual_Days,
    ROUND(AVG(`Days for shipment (scheduled)`), 1) AS Avg_Scheduled_Days
FROM supply_chain_cleaned
GROUP BY `Shipping Mode`
ORDER BY Avg_Delay_Days DESC;
```
Objective: Measure how many days, on average, each shipping mode is delayed compared to schedule.

---

**Query 6: Late Delivery % per Shipping Mode (CASE WHEN)**
```sql
SELECT 
    `Shipping Mode`,
    COUNT(*) AS Total_Orders,
    SUM(CASE WHEN `Delivery Status` = 'Late delivery' THEN 1 ELSE 0 END) AS Late_Orders,
    ROUND(SUM(CASE WHEN `Delivery Status` = 'Late delivery' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS Late_Pct
FROM supply_chain_cleaned
GROUP BY `Shipping Mode`
ORDER BY Late_Pct DESC;
```
Objective: Calculate the late delivery percentage within each shipping mode.

---

**Query 7: Total Sales and Profit by Market**
```sql
SELECT 
    `Market`,
    COUNT(*) AS Total_Orders,
    ROUND(SUM(`Sales`), 2) AS Total_Sales,
    ROUND(AVG(`Sales`), 2) AS Avg_Order_Value,
    ROUND(SUM(`Order Profit Per Order`), 2) AS Total_Profit,
    ROUND(AVG(`Order Profit Per Order`), 2) AS Avg_Profit_Per_Order
FROM supply_chain_cleaned
GROUP BY `Market`
ORDER BY Total_Sales DESC;
```
Objective: Compare total sales, average order value, and profit across markets.

---

**Query 8: Sales by Customer Segment**
```sql
SELECT 
    `Customer Segment`,
    COUNT(*) AS Total_Orders,
    ROUND(SUM(`Sales`), 2) AS Total_Sales,
    ROUND(AVG(`Sales`), 2) AS Avg_Sales,
    ROUND(AVG(`Order Profit Per Order`), 2) AS Avg_Profit
FROM supply_chain_cleaned
GROUP BY `Customer Segment`
ORDER BY Total_Sales DESC;
```
Objective: Identify which customer segment generates the most sales and profit.

---

**Query 9: Top 5 Order Regions by Sales**
```sql
SELECT 
    `Order Region`,
    COUNT(*) AS Total_Orders,
    ROUND(SUM(`Sales`), 2) AS Total_Sales,
    ROUND(AVG(`Order Profit Per Order`), 2) AS Avg_Profit
FROM supply_chain_cleaned
GROUP BY `Order Region`
ORDER BY Total_Sales DESC
LIMIT 5;
```
Objective: Find the top 5 regions contributing the most to overall sales.

---

**Query 10: Rank Markets by Total Sales (Window Function)**
```sql
SELECT 
    `Market`,
    ROUND(SUM(`Sales`), 2) AS Total_Sales,
    RANK() OVER (ORDER BY SUM(`Sales`) DESC) AS Sales_Rank
FROM supply_chain_cleaned
GROUP BY `Market`;
```
Objective: Rank all markets by total sales using a window function.

---

**Query 11: High Value Orders Above Average Sales (CTE)**
```sql
WITH avg_sales AS (
    SELECT AVG(`Sales`) AS overall_avg FROM supply_chain_cleaned
)
SELECT 
    `Order Id`,
    `Customer Segment`,
    `Market`,
    `Delivery Status`,
    ROUND(`Sales`, 2) AS Sales,
    ROUND(`Order Profit Per Order`, 2) AS Profit
FROM supply_chain_cleaned, avg_sales
WHERE `Sales` > overall_avg
ORDER BY Sales DESC
LIMIT 10;
```
Objective: Use a CTE to find the top 10 highest-value orders above the average sale amount.

---

**Query 12: Late Delivery Impact on Profit (CASE WHEN)**
```sql
SELECT 
    CASE 
        WHEN `Delivery Status` = 'Late delivery' THEN 'Late'
        WHEN `Delivery Status` = 'Shipping on time' THEN 'On Time'
        WHEN `Delivery Status` = 'Advance shipping' THEN 'Early'
        ELSE 'Cancelled'
    END AS Delivery_Category,
    COUNT(*) AS Total_Orders,
    ROUND(AVG(`Order Profit Per Order`), 2) AS Avg_Profit,
    ROUND(SUM(`Sales`), 2) AS Total_Sales
FROM supply_chain_cleaned
GROUP BY Delivery_Category
ORDER BY Total_Orders DESC;
```
Objective: Compare order count, average profit, and total sales across delivery categories.

---

## Key Findings

**Late delivery is the biggest problem** — 98,977 orders (54.83%) were delivered 
late, more than half of all orders. 41,448 were shipped early, 32,196 shipped 
on time, and 7,754 orders were canceled.

**Standard Class is the most used shipping mode** — 107,752 orders (59.7%) used 
Standard Class, but it also showed the highest average delay days, making it 
the biggest contributor to late deliveries.

**LATAM is the top market** by total sales, followed by Europe and Pacific Asia, 
together accounting for the majority of revenue.

**Consumer segment is the largest customer group**, generating the highest total 
sales and order volume, followed by Corporate and Home Office.

**Total profit across all orders** was approximately **$3.97M**, with late 
deliveries showing a noticeably lower average profit per order compared to 
on-time or early shipments — confirming that delays directly hurt profitability.

**High-value orders** (above the overall average sale) are concentrated in the 
Consumer segment and LATAM/Europe markets, identified using a CTE-based query.

---

## Dashboard Preview
![Power BI Dashboard](Supply%20chain%20Dashboard.png)

---

## Excel Pivot Table Analysis
![Pivot Table](pivot_table.png)

---

## Findings and Conclusion

- **Delivery Performance:** Late delivery affects 54.83% of all orders, with 
  Standard Class shipping being the primary contributor. This is the most 
  critical area for operational improvement.
- **Profit Impact:** Late deliveries are linked to lower average profit per 
  order, showing that delivery delays don't just hurt customer experience — 
  they directly reduce profitability.
- **Market Insights:** LATAM and Europe remain the strongest markets, making 
  them priority regions for both sales growth and delivery improvement.
- **Customer Segments:** The Consumer segment drives the most orders and 
  revenue, making it the key group to focus on for retention and service 
  quality.
- **High-Value Orders:** A focused subset of high-value orders (above-average 
  sales) represents an opportunity for prioritized handling to protect 
  high-revenue relationships.

This analysis provides a clear, data-driven view of supply chain performance, 
highlighting late delivery as the most pressing issue with direct financial 
consequences, and identifying the markets and segments most important to 
prioritize for improvement.

---

## Files
| File | Description |
|------|-------------|
| `analysis.py` | Python script for data loading, cleaning, and visualization |
| `supply chain.sql` | 12 SQL queries (GROUP BY, CASE WHEN, Window Functions, CTEs) |
| `supply_chain_cleaned.zip` | Cleaned dataset (180,519 rows, 53 columns) — zipped |
| `delivery_status.png` | Delivery status distribution chart |
| `Supply chain Dashboard.png` | Power BI dashboard screenshot |
| `pivot_table.png` | Excel Pivot Table analysis screenshot |

> **Note:** The Power BI `.pbix` file (11MB) wasn't uploaded due to GitHub's 
> display limits, but the dashboard is fully visible via the screenshot above. 
> All analysis logic is available in `analysis.py` and `supply chain.sql`.

---

## Author
**Sariya Khan** — Aspiring Data Analyst
GitHub: [Sariyaaa](https://github.com/Sariyaaa)
