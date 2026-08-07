SELECT
    "order_id" AS order_id,
    "payment_type" AS payment_type,
    sum("payment_value") AS payment_value
FROM {{ source('t1_bronze', 'order_payments') }}
GROUP BY "order_id", "payment_type"
