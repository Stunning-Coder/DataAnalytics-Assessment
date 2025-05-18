# Cowrywise Data Analyst SQL Assessment Test (05-25)

This repository contains a set of solutions to a SQL proficiency assessment provided by the Talent Team of Cowrywise. These questions replicate real-world scenarios around account behavior, transaction patterns, customer analytics, and an estimation of the lifetime value of customers.
The queries were written in standard MySQL syntax and tested against a normalized schema `adashi_staging`. This schema included the following tables:
- `users_customuser` - contains customer information
- `plans_plan` - contains records of investment and saving plans created by customer
- `savings_savingsaccount` - contains transactions/deposits details
- `withdrawals_withdrawal` -  records of withdrawal transactions (though this table was rarely used as it wasn't significant to answering any of the provided assessment questions.

## Assessment Tasks & SQL Solutions
### Q1: High-Value Customers with Multiple Products
#### Objective
Identify customers who have both a savings and investment plan, with locked (funded) status. Sort them by total confirmed deposits.

**Approach**
- Counted savings (`is_regular_savings`) and investment (`is_a_fund`) plans per customer.
- Filtered for customers having at least one of each type.
- Aggregated the total confirmed deposits from the `savings_savingsaccount` table.
- Used the `HAVING` clause to enforce multi-product criteria (i.e. ensured it's only customers with at least one funded savings plan AND one funded investment plan).

**Challenge**
- Ensured no plan duplication by counting only distinct plans (e.g. `COUNT(DISTINCT plan.id`).
- Assumed **locked funds signify funding** based on personal familiarity with the Cowrywise Mobile App.

### Q2: Transaction Frequency Analysis
#### Objective
Categorize customers by how often they transact:
- **High Frequency**: >= 10/month
- Medium Frequency**: 3–9/month
- Low Frequency**: <=2/month

**Approach**
- Built a CTE (`WITH` clause) summarizing a monthly transaction activity per customers.
- Applied conditional logic to assign frequency labels (i.e. `CASE 
        WHEN transaction_count >= 10 THEN 'High Frequency'
        WHEN transaction_count BETWEEN 3 AND 9 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
    END AS frequency_category,`).
- Counted distinct customers per category and computed average transactions.

**Challenge**
- Grouped across dynamic monthly periods.
- Counted distinct customers per category and computed average transactions.

### Q3: Account Activity Alert
#### Objective
Find all savings or investment accounts with no transaction in the **past year (365 days)**.

**Approach**
- Focused only on plans tagged as `is_regular_savings` or `is_a_fund`.
- Used `MAX(transaction_date)` to identify last activity.
- Filtered out plans inactive for 1+ years.
- Returned last transaction dates and their inactivity duration.

**Challenge**
- Ensured exclusion of accounts with no recorded activity using `transaction_date IS NOT NULL`.

### Q4: Customer Lifetime Value (Estimated)
#### Objective

Estimate a simple CLV for each customer using:
- Account tenure (i.e. the number of months since the signup of each customer).
- Number of `successful` transactions
- Profit per transaction calculated as 0.1% of the `confirmed_value` transacted.

**Approach**
- Used the MySQL function `TIMESTAMPDIFF()` to calculate the account tenures of each customer.
- Counted & filetered for successful and confirmed transactions.
- Applied the formula for CLV:
 `(total_transactions / tenure) * 12 * avg_profit_per_transaction`.
-  Used `NULLIF()` to avoid division by zero for new customers.

**Challenge**
- Protected against division-by-zero for new signups.
- Ensured only valid transactions (i.e., **successful and confirmed**) were included in calculations.

## Summary
This assessment required blending SQL proficiency with applied business logic. Each query reflects how real product, finance, and growth teams might use data to:

- Identify high-value or inactive users,
- Inform engagement strategies,
- Evaluate customer value and behavioral segments.

The process emphasized not just querying, but reasoning, data hygiene, and analytical storytelling.


p.s.
 Upon upload, made some changes to the committed scripts, including:
 - dividing by 100 since the amount values are in kobo not naira hence a division by 100
 - optimal efficiency
