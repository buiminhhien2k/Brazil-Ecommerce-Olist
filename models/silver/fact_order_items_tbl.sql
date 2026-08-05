SELECT 
    tbl_oi.order_id as order_id
    , tbl_oi.product_id as product_id
    , tbl_oi.seller_id as seller_id
    , tbl_oi.price as price
    , tbl_oi.freight_value as freight_value
    , tbl_oi.quantity as quantity
    , tbl_o.customer_id as customer_id
    , tbl_c1.customer_zip_code_prefix as customer_zip_code
    , tbl_s.seller_zip_code_prefix as seller_zip_code
    , tbl_p.product_category_name as product_category_name
    , tbl_p.product_package_volume_cm3 as product_package_volume_cm3
    , tbl_p.product_weight_g as product_weight_g
FROM {{ref('stg_order_items_vw')}} as tbl_oi
    LEFT JOIN {{ref('stg_orders_vw')}} as tbl_o
        ON tbl_oi.order_id = tbl_o.order_id
    LEFT JOIN {{ref('stg_customers_vw')}} as tbl_c1
        ON tbl_c1.customer_id = tbl_o.customer_id
    LEFT JOIN {{ref('stg_sellers_vw')}} as tbl_s
        ON tbl_oi.SELLER_ID = tbl_s.seller_id
    LEFT JOIN {{ref('stg_products_vw')}} as tbl_p
        ON tbl_oi.product_id = tbl_p.product_id