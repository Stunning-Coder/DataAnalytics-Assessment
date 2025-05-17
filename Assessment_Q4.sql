/*
	Q4: Customer Lifetime Value (CLV) Estimation
*/

SELECT 
    cust_user.id AS customer_id,
    CONCAT(cust_user.first_name,
            ' ',
            cust_user.last_name) AS name,
    TIMESTAMPDIFF(MONTH,
        cust_user.date_joined,
        CURRENT_DATE()) AS tenure_months,
    COUNT(savingsacc.transaction_date) AS total_transactions,
    ROUND((COUNT(savingsacc.transaction_date) / NULLIF(TIMESTAMPDIFF(MONTH,
                        cust_user.date_joined,
                        CURRENT_DATE()),
                    0)) * 12 * (0.001 * AVG(savingsacc.confirmed_amount)),
            2) AS estimated_clv
FROM
    adashi_staging.users_customuser cust_user
        LEFT JOIN
    adashi_staging.savings_savingsaccount savingsacc ON cust_user.id = savingsacc.owner_id
WHERE
    confirmed_amount IS NOT NULL
        AND transaction_status = 'success'
GROUP BY cust_user.id, cust_user.first_name, cust_user.last_name, tenure_months
ORDER BY estimated_clv DESC;