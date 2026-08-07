SELECT
    "customer_id" AS customer_id,
    "customer_zip_code_prefix" AS customer_zip_code_prefix
FROM {{ source('t1_bronze', 'customers') }}
