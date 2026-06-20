```sql
USE supply_chain;

-- Query 1: Total Orders
SELECT COUNT(*) AS Total_Orders
FROM supply_chain_cleaned;

-- Query 2: Delivery Status with Percentage
SELECT 
    `Delivery Status`,
    COUNT(*) AS Total_Orders,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM supply_chain_cleaned), 1) AS Percentage
FROM supply_chain_cleaned
GROUP BY `Delivery Status`
ORDER BY Total_Orders DESC;

-- Query 3: Orders by Shipping Mode
SELECT 
    `Shipping Mode`,
    COUNT(*) AS Total_Orders,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM supply_chain_cleaned), 1) AS Percentage
FROM supply_chain_cleaned
GROUP BY `Shipping Mode`
ORDER BY Total_Orders DESC;


-- SECTION 2: DELIVERY PERFORMANCE ANALYSIS

-- Query 4: Late Delivery Count by Shipping Mode
SELECT 
    `Shipping Mode`,
    COUNT(*) AS Late_Orders,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM supply_chain_cleaned WHERE `Delivery Status` = 'Late delivery'), 1) AS Pct_of_Total_Late
FROM supply_chain_cleaned
WHERE `Delivery Status` = 'Late delivery'
GROUP BY `Shipping Mode`
ORDER BY Late_Orders DESC;

-- Query 5: Average Delay Days by Shipping Mode
SELECT 
    `Shipping Mode`,
    ROUND(AVG(`Days for shipping (real)` - `Days for shipment (scheduled)`), 2) AS Avg_Delay_Days,
    ROUND(AVG(`Days for shipping (real)`), 1) AS Avg_Actual_Days,
    ROUND(AVG(`Days for shipment (scheduled)`), 1) AS Avg_Scheduled_Days
FROM supply_chain_cleaned
GROUP BY `Shipping Mode`
ORDER BY Avg_Delay_Days DESC;

-- Query 6: Late Delivery % per Shipping Mode (using CASE WHEN)
SELECT 
    `Shipping Mode`,
    COUNT(*) AS Total_Orders,
    SUM(CASE WHEN `Delivery Status` = 'Late delivery' THEN 1 ELSE 0 END) AS Late_Orders,
    ROUND(SUM(CASE WHEN `Delivery Status` = 'Late delivery' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS Late_Pct
FROM supply_chain_cleaned
GROUP BY `Shipping Mode`
ORDER BY Late_Pct DESC;


-- SECTION 3: SALES & PROFIT ANALYSIS

-- Query 7: Total Sales and Profit by Market
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

-- Query 8: Sales by Customer Segment
SELECT 
    `Customer Segment`,
    COUNT(*) AS Total_Orders,
    ROUND(SUM(`Sales`), 2) AS Total_Sales,
    ROUND(AVG(`Sales`), 2) AS Avg_Sales,
    ROUND(AVG(`Order Profit Per Order`), 2) AS Avg_Profit
FROM supply_chain_cleaned
GROUP BY `Customer Segment`
ORDER BY Total_Sales DESC;

-- Query 9: Top 5 Order Regions by Sales
SELECT 
    `Order Region`,
    COUNT(*) AS Total_Orders,
    ROUND(SUM(`Sales`), 2) AS Total_Sales,
    ROUND(AVG(`Order Profit Per Order`), 2) AS Avg_Profit
FROM supply_chain_cleaned
GROUP BY `Order Region`
ORDER BY Total_Sales DESC
LIMIT 5;


-- SECTION 4: ADVANCED QUERIES (Window Functions + CTE)

-- Query 10: Rank Markets by Total Sales (Window Function)
SELECT 
    `Market`,
    ROUND(SUM(`Sales`), 2) AS Total_Sales,
    RANK() OVER (ORDER BY SUM(`Sales`) DESC) AS Sales_Rank
FROM supply_chain_cleaned
GROUP BY `Market`;

-- Query 11: CTE — High Value Orders Above Average Sales
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

-- Query 12: Late Delivery Impact on Profit (CASE WHEN)
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


-- SECTION 5: REVENUE IMPACT ANALYSIS

-- Query 13: Sales Revenue Impact of Late Deliveries
SELECT 
    `Delivery Status`,
    COUNT(*) AS Total_Orders,
    ROUND(SUM(`Sales`), 2) AS Total_Sales,
    ROUND(SUM(`Sales`) * 100.0 / (SELECT SUM(`Sales`) FROM supply_chain_cleaned), 1) AS Pct_of_Total_Sales
FROM supply_chain_cleaned
WHERE `Delivery Status` = 'Late delivery'
GROUP BY `Delivery Status`;
```
