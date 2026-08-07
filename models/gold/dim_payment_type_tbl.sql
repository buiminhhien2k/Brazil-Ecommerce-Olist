SELECT DISTINCT
    main_payment_type,
    initcap(replace(main_payment_type, '_', ' ')) AS payment_type_name
FROM {{ ref('fact_order_shipping_vw') }}
