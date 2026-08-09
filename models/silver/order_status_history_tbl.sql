{{ config(
    materialized='incremental',
    unique_key='status_history_id',
    incremental_strategy='merge'
) }}

WITH new_order_states AS (

    SELECT
        order_id,
        order_status,
        order_purchase_timestamp,
        order_approved_at,
        order_delivered_carrier_date,
        order_delivered_customer_date,
        ingested_at

    FROM {{ ref('stg_orders_vw') }}

    {% if is_incremental() %}

    WHERE ingested_at > (
        SELECT COALESCE(
            MAX(ingested_at),
            '1900-01-01'::TIMESTAMP
        )
        FROM {{ this }}
    )

    {% endif %}

),

order_status_events AS (

    SELECT
        order_id,
        order_status,

        CASE
            WHEN order_status = 'approved'
                THEN order_approved_at

            WHEN order_status = 'shipped'
                THEN order_delivered_carrier_date

            WHEN order_status = 'delivered'
                THEN order_delivered_customer_date

            ELSE NULL
        END AS status_at,

        ingested_at,

    FROM new_order_states
    

),

final AS (

    SELECT
        SHA2(
            CONCAT(
                order_id,
                '|',
                order_status,
                '|',
                COALESCE(
                    TO_VARCHAR(status_at),
                    TO_VARCHAR(ingested_at)
                )
            ),
            256
        ) AS status_history_id,

        order_id,
        order_status,
        status_at,
        ingested_at

    FROM order_status_events

)

SELECT *
FROM final