{{ config(
    materialized='incremental',
    unique_key='"order_id"'
) }}


SELECT 
    "order_id" as order_id,
    "customer_id" as customer_id,
    "order_status" as order_status,
    "order_purchase_timestamp" as order_purchase_timestamp,
    "order_approved_at" as order_approved_at,
    "order_delivered_carrier_date" as order_delivered_carrier_date,
    "order_delivered_customer_date" as order_delivered_customer_date,
    "order_estimated_delivery_date" as order_estimated_delivery_date

FROM {{ source('t1_bronze', 'orders') }}

{% if is_incremental() %}

where "order_purchase_timestamp" >
(
    select max("order_purchase_timestamp")
    from {{ this }}
)

{% endif %}
