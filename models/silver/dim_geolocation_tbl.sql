SELECT
    "geolocation_zip_code_prefix" AS zip_code,
    "geolocation_city" AS city,
    "geolocation_state" AS state,
    avg_lat AS latitude,
    avg_lng AS longtitude

FROM {{ ref('stg_geolocation_vw') }}
