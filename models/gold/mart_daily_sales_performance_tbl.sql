SELECT
    tbl_b.order_purchase_date,
    tbl_b.main_payment_type,
    sum(tbl_a.price * tbl_a.quantity) + sum(tbl_a.freight_value) AS total_sale,
    count(DISTINCT tbl_a.order_id) AS orders,
    (sum(tbl_a.price * tbl_a.quantity) + sum(tbl_a.freight_value))
    / (count(DISTINCT tbl_a.order_id)) AS aov,
    sum(tbl_a.quantity) AS items,
    sum(tbl_a.quantity) / count(DISTINCT tbl_a.order_id) AS ipo
FROM {{ ref('fact_order_items_tbl') }} AS tbl_a
INNER JOIN {{ ref('fact_order_shipping_vw') }} AS tbl_b
    ON tbl_a.order_id = tbl_b.order_id
GROUP BY
    tbl_b.order_purchase_date,
    tbl_b.main_payment_type
