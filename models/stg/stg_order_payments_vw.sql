SELECT 
    "order_id" as order_id,
    "payment_type" as payment_type,
    sum("payment_value") as payment_value
FROM {{ source('t1_bronze', 'order_payments') }}
GROUP BY "order_id", "payment_type"