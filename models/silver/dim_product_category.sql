SELECT 
    "product_category_name" as product_category_name
    , "product_category_name_english" as product_category_name_english
    , initcap(replace("product_category_name_english", '_', ' ')) as product_category_name_english_txt

FROM {{ source('t1_bronze', 'product_category_name_translation') }}