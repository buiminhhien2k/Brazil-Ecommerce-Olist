SELECT
    customer_zip_code,
    seller_zip_code,
    sum(price * quantity) + sum(freight_value) AS sales,
    sum(quantity) AS quantity,
    sum(freight_value) AS cost,
    sum(product_package_volume_cm3) AS total_product_volume,
    sum(product_weight_g) AS total_product_weight
FROM {{ ref('fact_order_items_tbl') }}
GROUP BY
    customer_zip_code,
    seller_zip_code
