SELECT 
    tbl_b.order_purchase_date
    , tbl_a.product_category_name
    , sum(tbl_a.price * tbl_a.quantity) + sum(tbl_a.freight_value) as revenue
    , sum(tbl_a.freight_value) as freight_value
    , sum(tbl_a.quantity) as quantity
    , round(sum(tbl_a.product_package_volume_cm3), 2) as total_product_volume
    , round(sum(tbl_a.product_weight_g), 2) as total_product_weight
    , round(avg(tbl_b.delivery_days), 2) as avg_delivery_days
    , round(avg(tbl_b.is_sot), 2) as sot_rate
FROM {{ ref('fact_order_items_tbl') }} as tbl_a
LEFT JOIN {{ ref('fact_order_shipping_vw') }} as tbl_b
ON tbl_a.order_id = tbl_b.order_id
GROUP BY 
    tbl_b.order_purchase_date
    , tbl_a.product_category_name
    