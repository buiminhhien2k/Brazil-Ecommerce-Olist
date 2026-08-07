select *
FROM {{ ref('stg_order_payments_vw') }}
WHERE payment_value < 0