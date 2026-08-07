SELECT
    "product_id" AS product_id,
    "product_category_name" AS product_category_name,
    "product_weight_g" AS product_weight_g,
    "product_width_cm" AS product_width_cm,
    "product_length_cm" AS product_length_cm,
    "product_height_cm" AS product_height_cm,
    "product_width_cm"
    * "product_length_cm"
    * "product_height_cm" AS product_package_volume_cm3
FROM {{ source('t1_bronze', 'products') }}
