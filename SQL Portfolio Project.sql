#Query1
WITH CustomerData AS (
    SELECT 
        customer_id,
        AVG(monthly_charge) OVER (PARTITION BY customer_id) AS spending_variable
    FROM churned_customer
),
GroupedData AS (
    SELECT 
        customer_id,
        spending_variable,
        CASE
            WHEN spending_variable < 20 THEN 'Very Low-Spending'
            WHEN spending_variable BETWEEN 20 AND 30 THEN 'Low-Spending'
            WHEN spending_variable BETWEEN 31 AND 40 THEN 'Slightly Low-Spending'
            WHEN spending_variable BETWEEN 41 AND 50 THEN 'Below Average'
            WHEN spending_variable BETWEEN 51 AND 60 THEN 'Average'
            WHEN spending_variable BETWEEN 61 AND 70 THEN 'Slightly Above Average'
            WHEN spending_variable BETWEEN 71 AND 80 THEN 'Above Average'
            WHEN spending_variable BETWEEN 81 AND 90 THEN 'High-Spending'
            WHEN spending_variable BETWEEN 91 AND 100 THEN 'Very High-Spending'
            ELSE 'Extremely High-Spending'
        END AS spending_group
    FROM CustomerData
)
SELECT * FROM GroupedData;

SELECT customer_id, age, gender, contract_type
FROM churned_customer
WHERE spending_variable IN ('Extremely High-Spending', 'Very High-Spending', 'High Spending', 'Above Average', 'Slightly Above Average');

SELECT 
    Age_group, gender, contract_type,
    AVG(spending_variable) AS avg_spending
FROM (
    SELECT 
        customer_id,
        AVG(monthly_charge) OVER (PARTITION BY customer_id) AS spending_variable,
        CASE
            WHEN age < 30 THEN 'Young'
            WHEN age >= 30 AND age < 50 THEN 'Middle-Aged'
            ELSE 'Older'
        END AS age_group,
        gender,
        contract_type
    FROM churned_customer
) AS grouped_data
GROUP BY age_group, gender, contract_type;

#Query2

SELECT churn_reason, COUNT(*) AS churn_count
FROM churned_customer
WHERE customer_status = 'Churned';

#Query3

SELECT payment_method, COUNT(*) AS churned_count
FROM churned_customer
GROUP BY payment_method;


