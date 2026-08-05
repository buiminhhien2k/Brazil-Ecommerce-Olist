SELECT 
    zip_code
    , initcap(city) as city
    , state
    , latitude
    , longtitude
    , round(latitude, 0) as latitude_modified
    , round(longtitude, 0) as longitude_modified
    , concat(initcap(city), ', ', state) as city_state
FROM {{ ref('dim_geolocation_tbl') }}