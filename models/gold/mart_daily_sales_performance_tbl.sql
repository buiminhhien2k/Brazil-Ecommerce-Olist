SELECT 
    tbl_b.order_purchase_date
    , tbl_b.main_payment_type
    , sum(tbl_a.price * tbl_a.quantity) + sum(tbl_a.freight_value) as total_sale
    , count(distinct tbl_a.order_id) as orders
    , (sum(tbl_a.price * tbl_a.quantity) + sum(tbl_a.freight_value)) / (count(distinct tbl_a.order_id)) as AOV
    , sum(tbl_a.quantity) as items
    , sum(tbl_a.quantity) / count(distinct tbl_a.order_id) as ipo
FROM {{ ref('fact_order_items_tbl') }} as tbl_a
JOIN {{ ref('fact_order_shipping_vw') }} as tbl_b
ON tbl_a.order_id = tbl_b.order_id
GROUP BY
    tbl_b.order_purchase_date
    , tbl_b.main_payment_type
