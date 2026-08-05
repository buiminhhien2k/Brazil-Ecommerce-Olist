{{ config(
    materialized='view',
    on_configuration_change='apply') 
    }}

SELECT
    order_id
    , order_status
    , to_date(order_purchase_timestamp) as order_purchase_date
    , order_purchase_timestamp
    , order_approved_at
    , main_payment_type
    , CASE 
        WHEN order_delivered_customer_date is null THEN null
        WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 0
        ELSE 1
    END as IS_SOT
    , round(
        datediff(
            'hour', 
            order_approved_at, 
            order_delivered_customer_date
            )/24
        , 2) 
        as delivery_days
FROM {{ ref('fact_order_revenue_tbl') }}

