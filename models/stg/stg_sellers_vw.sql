SELECT "seller_id" as seller_id, "seller_zip_code_prefix" as seller_zip_code_prefix
FROM {{ source('t1_bronze', 'sellers') }}
