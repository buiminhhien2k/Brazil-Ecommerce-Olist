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

SELECT *
FROM longest_city_name_cte
INNER JOIN average_lat_lng_cte USING ("geolocation_zip_code_prefix")
