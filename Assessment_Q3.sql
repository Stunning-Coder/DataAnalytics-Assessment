/*
	Q3: Account Inactivity Alert
*/

SELECT DISTINCT
    plan.id AS plan_id,
    plan.owner_id,
    CASE
        WHEN is_regular_savings THEN 'Savings'
        WHEN is_a_fund THEN 'Investment'
        ELSE 'Others'
    END AS type,
    MAX(savingsacc.transaction_date) AS last_transaction_date,
    DATEDIFF(CURRENT_DATE(),
            MAX(savingsacc.transaction_date)) AS days_since_last_transaction
FROM
    adashi_staging.plans_plan plan
        LEFT JOIN
    adashi_staging.savings_savingsaccount savingsacc ON plan.id = savingsacc.plan_id
WHERE
    (is_a_fund = 1 OR is_regular_savings = 1)
        AND transaction_date IS NOT NULL
GROUP BY plan.id , plan.owner_id
HAVING MAX(savingsacc.transaction_date) < CURRENT_DATE() - INTERVAL 1 YEAR
ORDER BY days_since_last_transaction DESC
;