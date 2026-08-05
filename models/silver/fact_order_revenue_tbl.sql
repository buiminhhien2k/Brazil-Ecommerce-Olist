{{ config(
    materialized='incremental',
    unique_key='order_id'
) }}

WITH CTE_NEW_ORDERS AS (

    SELECT *
    FROM {{ ref('stg_orders_vw') }}

    {% if is_incremental() %}

        WHERE order_purchase_timestamp >
        (
            SELECT MAX(order_purchase_timestamp)
            FROM {{ this }}
        )

    {% endif %}

),
CTE_ORDER_REVENUE_SINGLE_PAYMENT AS (
    SELECT 
        tbl_a.order_id as ORDER_ID,
        max(tbl_a.customer_id) as CUSTOMER_ID,
        max(tbl_a.order_status) as ORDER_STATUS,
        to_timestamp(max(tbl_a.order_purchase_timestamp), 'YYYY-MM-DD HH:MI:SS') as order_purchase_timestamp,
        to_timestamp(max(tbl_a.order_approved_at), 'YYYY-MM-DD HH:MI:SS') as order_approved_at,
        to_timestamp(max(tbl_a.order_delivered_carrier_date), 'YYYY-MM-DD HH:MI:SS') as order_delivered_carrier_date,
        to_timestamp(max(tbl_a.order_delivered_customer_date), 'YYYY-MM-DD HH:MI:SS') as order_delivered_customer_date,
        to_timestamp(max(tbl_a.order_estimated_delivery_date), 'YYYY-MM-DD HH:MI:SS') as order_estimated_delivery_date,
        max(tbl_b.payment_type) as main_payment_type,
        sum(tbl_b.payment_value) as revenue_payment
    FROM CTE_NEW_ORDERS as tbl_a
        LEFT JOIN {{ref('stg_order_payments_vw')}} as tbl_b
            ON (tbl_a.order_id = tbl_b.order_id)
    GROUP BY tbl_a.order_id
    HAVING COUNT(distinct tbl_b.payment_type) <= 1
),
CTE_ORDER_REVENUE_MULTI_PAYMENT AS (
    SELECT 
        tbl_a.order_id as ORDER_ID,
        max(tbl_a.customer_id) as CUSTOMER_ID,
        max(tbl_a.order_status) as ORDER_STATUS,
        to_timestamp(max(tbl_a.order_purchase_timestamp), 'YYYY-MM-DD HH:MI:SS') as order_purchase_timestamp,
        to_timestamp(max(tbl_a.order_approved_at), 'YYYY-MM-DD HH:MI:SS') as order_approved_at,
        to_timestamp(max(tbl_a.order_delivered_carrier_date), 'YYYY-MM-DD HH:MI:SS') as order_delivered_carrier_date,
        to_timestamp(max(tbl_a.order_delivered_customer_date), 'YYYY-MM-DD HH:MI:SS') as order_delivered_customer_date,
        to_timestamp(max(tbl_a.order_estimated_delivery_date), 'YYYY-MM-DD HH:MI:SS') as order_estimated_delivery_date,
        max(
            iff(
                payment_type <> 'voucher'
                , payment_type
                ,  null
            )
        ) as main_payment_type,
        sum(tbl_b.payment_value) as revenue_payment
    FROM CTE_NEW_ORDERS  as tbl_a
        LEFT JOIN {{ref('stg_order_payments_vw')}} as tbl_b
            ON (tbl_a.order_id = tbl_b.order_id)
    GROUP BY tbl_a.order_id
    HAVING COUNT(distinct tbl_b.payment_type) > 1

),
CTE_ORDER_REVENUE_PAYMENT AS (
    SELECT * 
    FROM CTE_ORDER_REVENUE_SINGLE_PAYMENT

    UNION ALL

    SELECT * 
    FROM CTE_ORDER_REVENUE_MULTI_PAYMENT
)
, 
CTE_ORDER_REVENUE_ITEMS as (
    SELECT 
        tbl_a.order_id as ORDER_ID
        , sum(tbl_b.price * tbl_b.quantity)
            + sum(tbl_b.freight_value) as revenue_items
    FROM CTE_NEW_ORDERS  as tbl_a
        LEFT JOIN {{ref('stg_order_items_vw')}} as tbl_b
            ON tbl_a.order_id = tbl_b.order_id
    GROUP BY tbl_a.order_id
)

SELECT 
    tbl_a.*
    , tbl_b.revenue_items
FROM CTE_ORDER_REVENUE_PAYMENT as tbl_a
    JOIN CTE_ORDER_REVENUE_ITEMS as tbl_b
        ON tbl_a.ORDER_ID = tbl_b.ORDER_ID
WHERE tbl_a.main_payment_type is not null