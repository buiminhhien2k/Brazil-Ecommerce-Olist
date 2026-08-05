
WITH AVERAGE_LAT_LNG_CTE AS (
    SELECT 
        "geolocation_zip_code_prefix",
        avg("geolocation_lat") AS avg_lat,
        avg("geolocation_lng") AS avg_lng
    FROM {{ source('t1_bronze', 'geolocation') }}
    GROUP BY 
        "geolocation_zip_code_prefix"
),

LONGEST_CITY_NAME_CTE AS (
    SELECT 
        "geolocation_zip_code_prefix", 
        "geolocation_city", 
        "geolocation_state"
    FROM (
        SELECT 
            "geolocation_zip_code_prefix",
            "geolocation_city",
            "geolocation_state",
            ROW_NUMBER() OVER (
                PARTITION BY "geolocation_zip_code_prefix" 
                ORDER BY LENGTH("geolocation_city") DESC
            ) as rn
        FROM {{ source('t1_bronze', 'geolocation') }}
    )
    WHERE rn = 1
)

SELECT * 
FROM LONGEST_CITY_NAME_CTE
JOIN AVERAGE_LAT_LNG_CTE USING ("geolocation_zip_code_prefix")
