WITH date_series AS (
    SELECT
        DATEADD(
            DAY,
            ROW_NUMBER() OVER (ORDER BY SEQ4()) - 1,
            DATE '2016-01-01'
        ) AS date_value
    FROM TABLE(GENERATOR(ROWCOUNT => 10000))
)

SELECT
    date_value AS date_key,
    YEAR(date_value) AS year,
    QUARTER(date_value) AS quarter,
    MONTH(date_value) AS month,
    MONTHNAME(date_value) AS month_name,
    DAY(date_value) AS day,
    DAYOFWEEK(date_value) AS day_of_week,
    DAYNAME(date_value) AS day_name,
    DAYOFYEAR(date_value) AS day_of_year,
    WEEK(date_value) AS week_of_year,
    DATE_TRUNC('WEEK', date_value) AS week_start_date,
    DATE_TRUNC('MONTH', date_value) AS month_start_date,
    DATE_TRUNC('QUARTER', date_value) AS quarter_start_date,
    DATE_TRUNC('YEAR', date_value) AS year_start_date,
    LAST_DAY(date_value) AS month_end_date,
    COALESCE(DAYOFWEEK(date_value) IN (1, 7), FALSE) AS is_weekend
FROM date_series
WHERE date_value <= CURRENT_DATE()
