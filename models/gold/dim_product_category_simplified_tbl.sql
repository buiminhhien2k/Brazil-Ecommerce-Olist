SELECT 
    product_category_name
    , product_category_name_english_txt as product_category_name_english
FROM {{ ref('dim_product_category') }}