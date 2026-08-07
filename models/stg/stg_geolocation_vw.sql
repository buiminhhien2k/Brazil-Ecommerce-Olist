WITH average_lat_lng_cte AS (
    SELECT
        "geolocation_zip_code_prefix",
        avg("geolocation_lat") AS avg_lat,
        avg("geolocation_lng") AS avg_lng
    FROM {{ source('t1_bronze', 'geolocation') }}
    GROUP BY
        "geolocation_zip_code_prefix"
),

longest_city_name_cte AS (
    SELECT
        "geolocation_zip_code_prefix",
        "geolocation_city",
        "geolocation_state"
    FROM (
        SELECT
            "geolocation_zip_code_prefix",
            "geolocation_city",
            "geolocation_state",
            row_number() OVER (
                PARTITION BY "geolocation_zip_code_prefix"
                ORDER BY length("geolocation_city") DESC
            ) AS rn
        FROM {{ source('t1_bronze', 'geolocation') }}
    )
    WHERE rn = 1
)

SELECT
    tbl_a.*,
    tbl_b.avg_lat,
    tbl_b.avg_lng
FROM longest_city_name_cte AS tbl_a
INNER JOIN average_lat_lng_cte AS tbl_b
    ON tbl_a."geolocation_zip_code_prefix" = tbl_b."geolocation_zip_code_prefix"
