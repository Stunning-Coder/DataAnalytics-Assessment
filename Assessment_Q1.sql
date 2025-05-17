/*
	Q1: High-Value Customers with Multiple Products
*/
SELECT 
    cust_user.id AS owner_id,
    CONCAT(cust_user.first_name,
            ' ',
            cust_user.last_name) AS name,
    COUNT(DISTINCT CASE
            WHEN plan.is_regular_savings = 1 THEN plan.id
        END) AS savings_count,
    COUNT(DISTINCT CASE
            WHEN plan.is_a_fund = 1 THEN plan.id
        END) AS investment_count,
    ROUND(SUM(savingsacc.confirmed_amount), 2) AS total_deposits
FROM
    adashi_staging.users_customuser cust_user
        LEFT JOIN
    adashi_staging.plans_plan plan ON cust_user.id = plan.owner_id
        LEFT JOIN
    adashi_staging.savings_savingsaccount savingsacc ON plan.id = savingsacc.plan_id
WHERE
    plan.locked = 1
GROUP BY cust_user.id , cust_user.first_name , cust_user.last_name
HAVING COUNT(DISTINCT CASE
        WHEN plan.is_regular_savings = 1 THEN plan.id
    END) > 0
    AND COUNT(DISTINCT CASE
        WHEN plan.is_a_fund = 1 THEN plan.id
    END) > 0
ORDER BY total_deposits DESC
;

