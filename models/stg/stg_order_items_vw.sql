SELECT 
    "order_id" as order_id, 
    "product_id" as product_id, 
    max("seller_id") as seller_id, 
    max("price") as price, 
    max("freight_value") as freight_value, 
    count(*) as quantity
FROM {{source('t1_bronze', 'order_items')}}
GROUP BY "order_id", "product_id"
