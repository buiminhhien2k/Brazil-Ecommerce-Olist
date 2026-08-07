SELECT
    "review_id" AS review_id,
    "order_id" AS order_id
FROM
    {{ source('t1_bronze', 'order_reviews') }}
