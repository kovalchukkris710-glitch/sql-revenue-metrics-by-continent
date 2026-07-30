-- Calculate total revenue and revenue by device type
WITH revenue_usd AS (
  SELECT
    sp.continent,
    ROUND(SUM(CAST(p.price AS NUMERIC)),2) AS revenue,
    ROUND(SUM(
      CASE WHEN sp.device = 'mobile' THEN CAST(p.price AS NUMERIC) ELSE 0 END
      ),2) AS revenue_from_mobile,
    ROUND(SUM(
        CASE WHEN sp.device = 'desktop' THEN CAST(p.price AS NUMERIC) ELSE 0 END
      ),2 ) AS revenue_from_desktop
  FROM `DA.order` AS o
  JOIN `DA.product` AS p
    ON o.item_id = p.item_id
  JOIN `DA.session_params` AS sp
    ON o.ga_session_id = sp.ga_session_id
  GROUP BY sp.continent
),
-- Calculate unique sessions and accounts by continent
registrations AS (
SELECT
    sp.continent AS continent,
    COUNT(DISTINCT sp.ga_session_id) AS session_cnt,
    COUNT(DISTINCT acs.account_id) AS account_cnt
FROM `DA.session_params` sp
LEFT JOIN `DA.account_session` acs
  ON sp.ga_session_id=acs.ga_session_id
GROUP BY sp.continent
),

-- Calculate the number of unique verified accounts by continent
verified AS(
SELECT
    sp.continent,
    COUNT(DISTINCT a.id) AS verified_account
FROM `DA.account` a
JOIN `DA.account_session` acs 
  ON a.id =acs.account_id
JOIN `DA.session_params` sp 
  ON acs.ga_session_id = sp.ga_session_id
WHERE a.is_verified = 1
GROUP BY  sp.continent
)

-- Combine revenue, account and session metrics
SELECT
    registrations.continent,
    revenue_usd.revenue,
    revenue_usd.revenue_from_mobile,
    revenue_usd.revenue_from_desktop,
    -- Calculate each continent's share of total revenue
    ROUND(
      SAFE_DIVIDE(
      revenue_usd.revenue,
      (
      SELECT SUM(p.price)
      FROM `DA.order` AS o
      JOIN `DA.product` AS p
        ON o.item_id = p.item_id
      )
      ) * 100, 2) AS percent_revenue_from_total,
    registrations.account_cnt,
    verified.verified_account,
    registrations.session_cnt
FROM registrations
LEFT JOIN revenue_usd 
  ON registrations.continent=revenue_usd.continent
LEFT JOIN verified 
  ON registrations.continent=verified.continent
ORDER BY revenue DESC;


