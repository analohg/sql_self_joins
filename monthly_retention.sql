``` sql
WITH sales_data AS (
SELECT 
  table1.Date,
  table1.UserId,
  table1.Amount,
  table2.Date as Date2,
  table2.UserId as UserId2,
  table2.Amount as Amount2
FROM `nba-data-337623.Retention.retention` table1
LEFT JOIN `nba-data-337623.Retention.retention` table2
  ON table1.UserId = table2.UserId
  AND EXTRACT(month FROM table1.Date) = EXTRACT(month FROM table2.Date) + 1
ORDER BY table1.Date
),

sales_grouped AS (
  SELECT 
    EXTRACT(month FROM Date) as Month,
    COUNT(UserId) as this_month_count,
    COUNT(CASE WHEN Date2 IS NOT NULL THEN UserId2 END) as returning_users
  FROM sales_data
  GROUP BY 1
)

SELECT 
  Month,
  LAG(this_month_count, 1) OVER (ORDER BY Month) as last_month_count,
  returning_users, 
  ROUND(((returning_users / LAG(this_month_count, 1) OVER (ORDER BY Month)) * 100),2) as retention_rate
FROM sales_grouped
ORDER BY Month
```

