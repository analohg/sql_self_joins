``` sql

WITH sales_data AS ( 
SELECT    
table1.Date,   
table1.UserId,   
table1.Amount as Revenue,   
table2.Date as Date2,   
table2.UserId as UserId2,   
table2.Amount as Previous_Revenue 
FROM `nba-data-337623.Retention.retention` table1 
LEFT JOIN `nba-data-337623.Retention.retention` table2   
ON table1.UserId = table2.UserId   
AND EXTRACT(month FROM table1.Date) + 1 = EXTRACT(month FROM table2.Date) ORDER BY table1.Date ),

sales_grouped AS (SELECT 
  EXTRACT(month FROM Date) as month,
  SUM(Revenue) as Revenue,
  SUM(Previous_Revenue) as Next_Revenue
FROM sales_data
GROUP By 1)

SELECT 
  Revenue,
  Next_Revenue,
  ROUND(((Next_Revenue / Revenue) * 100),2) as retained_revenue 
FROM sales_grouped


```
