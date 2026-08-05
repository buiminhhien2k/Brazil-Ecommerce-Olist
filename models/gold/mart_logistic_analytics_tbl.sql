SELECT 
    customer_zip_code
    , seller_zip_code
    , sum(price * quantity) + sum(freight_value) as sales
    , sum(quantity) as quantity
    , sum(freight_value) as cost
    , sum(product_package_volume_cm3) as total_product_volume
    , sum(product_weight_g) as total_product_weight
FROM {{ ref('fact_order_items_tbl') }} as tbl_a
GROUP BY
    customer_zip_code
    , seller_zip_code
