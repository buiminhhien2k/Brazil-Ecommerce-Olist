SELECT 
    "review_id" as review_id,
    "order_id" as order_id
FROM
    {{ source('t1_bronze', 'order_reviews') }}