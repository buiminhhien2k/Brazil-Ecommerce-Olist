SELECT
    zip_code,
    state,
    latitude,
    longtitude,
    initcap(city) AS city,
    round(latitude, 0) AS latitude_modified,
    round(longtitude, 0) AS longitude_modified,
    concat(initcap(city), ', ', state) AS city_state
FROM {{ ref('dim_geolocation_tbl') }}
