--3--Haftalık en yüksek toplam value’ya sahip kampanyayı bul (haftayı ve rekor değerini belirt).--

WITH weekly AS (
  SELECT DATE_TRUNC('week', f.ad_date) AS week_start, c.campaign_name, SUM(f.value) AS total_value
  FROM facebook_ads_basic_daily f
  JOIN facebook_campaign c ON c.campaign_id = f.campaign_id
  GROUP BY 1,2
  UNION ALL
  SELECT DATE_TRUNC('week', g.ad_date), g.campaign_name, SUM(g.value)
  FROM google_ads_basic_daily g
  GROUP BY 1,2
)
SELECT week_start, campaign_name, SUM(total_value) AS total_value
FROM weekly
GROUP BY 1,2
ORDER BY total_value DESC
LIMIT 1;