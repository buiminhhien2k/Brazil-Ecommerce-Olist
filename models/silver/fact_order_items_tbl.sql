SELECT
    tbl_oi.order_id,
    tbl_oi.product_id,
    tbl_oi.seller_id,
    tbl_oi.price,
    tbl_oi.freight_value,
    tbl_oi.quantity,
    tbl_o.customer_id,
    tbl_c1.customer_zip_code_prefix AS customer_zip_code,
    tbl_s.seller_zip_code_prefix AS seller_zip_code,
    tbl_p.product_category_name,
    tbl_p.product_package_volume_cm3,
    tbl_p.product_weight_g
FROM {{ ref('stg_order_items_vw') }} AS tbl_oi
LEFT JOIN {{ ref('stg_orders_vw') }} AS tbl_o
    ON tbl_oi.order_id = tbl_o.order_id
LEFT JOIN {{ ref('stg_customers_vw') }} AS tbl_c1
    ON tbl_o.customer_id = tbl_c1.customer_id
LEFT JOIN {{ ref('stg_sellers_vw') }} AS tbl_s
    ON tbl_oi.seller_id = tbl_s.seller_id
LEFT JOIN {{ ref('stg_products_vw') }} AS tbl_p
    ON tbl_oi.product_id = tbl_p.product_id
