
SELECT 
    "customer_id" as customer_id,
    "customer_zip_code_prefix" as customer_zip_code_prefix
FROM {{ source('t1_bronze', 'customers') }}