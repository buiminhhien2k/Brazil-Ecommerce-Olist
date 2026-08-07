{{ config(
    materialized='view',
    on_configuration_change='apply') 
    }}

SELECT
    order_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    main_payment_type,
    to_date(order_purchase_timestamp) AS order_purchase_date,
    CASE
        WHEN order_delivered_customer_date IS null THEN null
        WHEN
            order_delivered_customer_date > order_estimated_delivery_date
            THEN 0
        ELSE 1
    END AS is_sot,
    round(
        datediff(
            'hour',
            order_approved_at,
            order_delivered_customer_date
        ) / 24,
        2)
        AS delivery_days
FROM {{ ref('fact_order_revenue_tbl') }}
