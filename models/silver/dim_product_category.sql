SELECT
    "product_category_name" AS product_category_name,
    "product_category_name_english" AS product_category_name_english,
    initcap(replace("product_category_name_english", '_', ' '))
        AS product_category_name_english_txt

FROM {{ source('t1_bronze', 'product_category_name_translation') }}
