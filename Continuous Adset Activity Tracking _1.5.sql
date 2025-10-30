--En uzun kesintisiz gösterime sahip adset_name’i (Google + Facebook) ve süresini gösteren sorguyu yaz.---

WITH all_ads AS (
    SELECT adset_name, ad_date::date
    FROM facebook_ads_basic_daily f
    JOIN facebook_adset a ON f.adset_id = a.adset_id
    UNION
    SELECT adset_name, ad_date::date
    FROM google_ads_basic_daily
),

distinct_dates AS (
    SELECT adset_name, ad_date
    FROM all_ads
    GROUP BY adset_name, ad_date
),

grp AS (
    SELECT
        adset_name,
        ad_date,
        ad_date - (ROW_NUMBER() OVER (PARTITION BY adset_name ORDER BY ad_date)::int * INTERVAL '1 day') AS grp_key
    FROM distinct_dates
),

streaks AS (
    SELECT
        adset_name,
        MIN(ad_date) AS streak_start,
        MAX(ad_date) AS streak_end,
        COUNT(*) AS streak_length
    FROM grp
    GROUP BY adset_name, grp_key
)

SELECT adset_name, streak_start, streak_end, streak_length
FROM streaks
ORDER BY streak_length DESC, streak_start
LIMIT 1;
