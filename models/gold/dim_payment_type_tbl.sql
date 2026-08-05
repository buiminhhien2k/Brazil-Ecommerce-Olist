select 
    distinct 
    main_payment_type,
    initcap(replace(main_payment_type, '_', ' ')) as payment_type_name
from {{ ref('fact_order_shipping_vw') }}