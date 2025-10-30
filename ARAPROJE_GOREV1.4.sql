--4--Aylık bazda en büyük erişim (reach) artışı yaşayan kampanya--

WITH all_ads_data AS
(
          SELECT    fabd.ad_date,
                    fc.campaign_name,
                    fa.adset_name,
                    fabd.spend,
                    fabd.impressions,
                    fabd.reach,
                    fabd.clicks,
                    fabd.leads,
                    fabd.value,
                    'Facebook' AS ad_source
          FROM      facebook_ads_basic_daily fabd
          LEFT JOIN facebook_adset fa
          ON        fa.adset_id = fabd.adset_id
          LEFT JOIN facebook_campaign fc
          ON        fc.campaign_id = fabd.campaign_id
          UNION ALL
          SELECT ad_date,
                 campaign_name,
                 adset_name,
                 spend,
                 impressions,
                 reach,
                 clicks,
                 leads,
                 value,
                 'Google' AS ad_source
          FROM   google_ads_basic_daily gabd ) , 


monthly_reach_camp AS (SELECT   Date_part('year', ad_date)
                           || '-'
                           || Date_part('month', ad_date) AS ad_month,
                  campaign_name,
                  COALESCE(Sum(reach), 0) monthly_reach
         FROM   all_ads_data  
         GROUP BY 1,
                  2)
SELECT   *,
         monthly_reach - COALESCE(Lag(monthly_reach) OVER (PARTITION BY campaign_name ORDER BY ad_month), 0) AS monthly_growth
FROM     monthly_reach_camp
ORDER BY monthly_growth DESC limit 1 ;