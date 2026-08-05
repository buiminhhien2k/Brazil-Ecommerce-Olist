SELECT 
    DATE_KEY
    , week_start_date
    , month_start_date
    , quarter_start_date
FROM {{ ref('dim_date_tbl') }}
WHERE 
    DATE_KEY >= (
        SELECT MIN(to_date(order_purchase_timestamp)) 
        FROM {{ref('fact_order_revenue_tbl') }}
        ) AND
    DATE_KEY <= (
        SELECT MAX(to_date(order_purchase_timestamp)) 
        FROM {{ ref('fact_order_revenue_tbl') }}
    )