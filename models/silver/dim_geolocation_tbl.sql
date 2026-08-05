SELECT 
    "geolocation_zip_code_prefix" as zip_code
    , "geolocation_city" as city
    , "geolocation_state" as state
    , AVG_LAT as latitude
    , avg_lng as longtitude
    
FROM {{ref('stg_geolocation_vw')}} as tbl_g