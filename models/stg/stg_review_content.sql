SELECT DISTINCT
    "review_id" AS review_id,
    "review_score" AS review_score,
    "review_comment_title" AS review_comment_title,
    "review_comment_message" AS review_comment_message,
    "review_creation_date" AS review_creation_date,
    "review_answer_timestamp" AS review_answer_timestamp
FROM {{ source('t1_bronze', 'order_reviews') }}
