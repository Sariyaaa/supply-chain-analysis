-- Supply Chain Analysis - SQL Queries
-- Author: Sariya Khan

-- Query 1: Total Orders
SELECT COUNT(*) AS total_orders 
FROM supply_chain_cleaned;

-- Query 2: Delivery Status
SELECT `Delivery Status`, COUNT(*) AS total
FROM supply_chain_cleaned
GROUP BY `Delivery Status`;

-- Query 3: Top Order Regions
SELECT `Order Region`, COUNT(*) AS total_orders
FROM supply_chain_cleaned
GROUP BY `Order Region`
ORDER BY total_orders DESC;

-- Query 4: Shipping Mode
SELECT `Shipping Mode`, COUNT(*) AS total
FROM supply_chain_cleaned
GROUP BY `Shipping Mode`
ORDER BY total DESC;

-- Query 5: Market Analysis
SELECT `Market`, COUNT(*) AS total_orders
FROM supply_chain_cleaned
GROUP BY `Market`
ORDER BY total_orders DESC;