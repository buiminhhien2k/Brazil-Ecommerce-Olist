{{ config(
    materialized='incremental',
    unique_key='order_id',
    incremental_strategy='merge'
) }}

SELECT
    "order_id" AS order_id,
    "customer_id" AS customer_id,
    "order_status" AS order_status,
    "order_purchase_timestamp" AS order_purchase_timestamp,
    "order_approved_at" AS order_approved_at,
    "order_delivered_carrier_date" AS order_delivered_carrier_date,
    "order_delivered_customer_date" AS order_delivered_customer_date,
    "order_estimated_delivery_date" AS order_estimated_delivery_date,
    "ingested_at" AS ingested_at

FROM {{ source('t1_bronze', 'orders') }}

{% if is_incremental() %}

    WHERE "ingested_at" > (
        SELECT COALESCE(
            MAX(sub_tbl.ingested_at),
            '1900-01-01'::TIMESTAMP
        )
        FROM {{ this }} AS sub_tbl
    )

{% endif %}