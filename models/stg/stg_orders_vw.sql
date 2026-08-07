{{ config(
    materialized='incremental',
    unique_key='"order_id"'
) }}


SELECT
    "order_id" AS order_id,
    "customer_id" AS customer_id,
    "order_status" AS order_status,
    "order_purchase_timestamp" AS order_purchase_timestamp,
    "order_approved_at" AS order_approved_at,
    "order_delivered_carrier_date" AS order_delivered_carrier_date,
    "order_delivered_customer_date" AS order_delivered_customer_date,
    "order_estimated_delivery_date" AS order_estimated_delivery_date

FROM {{ source('t1_bronze', 'orders') }}

{% if is_incremental() %}

    WHERE
        "order_purchase_timestamp"
        > (
            SELECT max(tbl_a."order_purchase_timestamp")
            FROM {{ this }} AS tbl_a
        )

{% endif %}
