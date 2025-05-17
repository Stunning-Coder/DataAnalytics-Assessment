-- Q2: Transaction Frequency Analysis

WITH monthly_activity AS (
    SELECT 
        cust_user.id AS customer_id,
        DATE_FORMAT(savingsacc.transaction_date, '%Y-%m') AS month,
        COUNT(*) AS transaction_count
    FROM adashi_staging.users_customuser cust_user
    JOIN adashi_staging.savings_savingsaccount savingsacc
        ON cust_user.id = savingsacc.owner_id
    WHERE savingsacc.transaction_status = 'success'
    GROUP BY cust_user.id, DATE_FORMAT(savingsacc.transaction_date, '%Y-%m')
)

SELECT 
    CASE 
        WHEN transaction_count >= 10 THEN 'High Frequency'
        WHEN transaction_count BETWEEN 3 AND 9 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
    END AS frequency_category,
    COUNT(DISTINCT customer_id) AS customer_count,
    ROUND(AVG(transaction_count), 2) AS avg_transactions_per_month
FROM monthly_activity
GROUP BY frequency_category
ORDER BY avg_transactions_per_month DESC;