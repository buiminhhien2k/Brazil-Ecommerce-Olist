SELECT
    "seller_id" AS seller_id,
    "seller_zip_code_prefix" AS seller_zip_code_prefix
FROM {{ source('t1_bronze', 'sellers') }}
