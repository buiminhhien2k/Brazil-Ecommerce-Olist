SELECT
    date_key,
    week_start_date,
    month_start_date,
    quarter_start_date
FROM {{ ref('dim_date_tbl') }}
WHERE
    date_key >= (
        SELECT MIN(TO_DATE(a.order_purchase_timestamp))
        FROM {{ ref('fact_order_revenue_tbl') }} AS a
    )
    AND date_key <= (
        SELECT MAX(TO_DATE(b.order_purchase_timestamp))
        FROM {{ ref('fact_order_revenue_tbl') }} AS b
    )
