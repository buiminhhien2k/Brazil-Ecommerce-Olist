SELECT
    date_key,
    week_start_date,
    month_start_date,
    quarter_start_date
FROM {{ ref('dim_date_tbl') }}
WHERE
    date_key >= (
        SELECT MIN(TO_DATE(order_purchase_timestamp))
        FROM {{ ref('fact_order_revenue_tbl') }}
    )
    AND date_key <= (
        SELECT MAX(TO_DATE(order_purchase_timestamp))
        FROM {{ ref('fact_order_revenue_tbl') }}
    )
