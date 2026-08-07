SELECT
    "order_id" AS order_id,
    "product_id" AS product_id,
    max("seller_id") AS seller_id,
    max("price") AS price,
    max("freight_value") AS freight_value,
    count(*) AS quantity
FROM {{ source('t1_bronze', 'order_items') }}
GROUP BY "order_id", "product_id"
