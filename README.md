# Conversion Funnel Analysis

## Project Description

This project analyzes the conversion funnel for an e-commerce website using SQL queries on the Maven Fuzzy Factory database. The goal is to understand how users move through the website, from landing on a page to making a purchase, and identify areas for improvement in the conversion process.

## Database Used

Maven Fuzzy Factory

## Queries and Their Purposes

1. **Identifying Funnel Steps**:
   ```sql
   CREATE TEMPORARY TABLE first_pageview AS
   SELECT 
       wp.website_session_id, 
       MIN(wp.website_pageview_id) AS first_pageview_id
   FROM website_pageviews wp
   JOIN website_sessions ws
       ON wp.website_session_id = ws.website_session_id
   WHERE ws.created_at BETWEEN '2012-06-19' AND '2012-07-28'
       AND ws.utm_source = 'gsearch'
       AND ws.utm_campaign = 'nonbrand'
   GROUP BY wp.website_session_id;

   CREATE TEMPORARY TABLE landing_page AS
   SELECT 
       wp.pageview_url, 
       fp.website_session_id 
   FROM first_pageview fp
   JOIN website_pageviews wp
       ON fp.first_pageview_id = wp.website_pageview_id
   WHERE wp.pageview_url IN ('/home', '/lander-1');

   CREATE TEMPORARY TABLE bounce_session AS
   SELECT 
       lp.pageview_url, 
       lp.website_session_id, 
       COUNT(wp.website_session_id) AS pageview_count
   FROM landing_page lp
   JOIN website_pageviews wp
       ON lp.website_session_id = wp.website_session_id
   GROUP BY 1, 2
   HAVING COUNT(wp.website_session_id) = 1;

   SELECT 
       lp.pageview_url,
       COUNT(lp.website_session_id) AS sessions,
       COUNT(bs.website_session_id) AS bounced_sessions,
       COUNT(bs.website_session_id) / COUNT(lp.website_session_id) AS bounce_rate
   FROM landing_page lp
   LEFT JOIN bounce_session bs
       ON lp.website_session_id = bs.website_session_id
   GROUP BY lp.pageview_url;


This query identifies the steps in our conversion funnel by looking at landing pages and calculating bounce rates.


2. **Analyzing Full Conversion Funnel:**:
```sql
CREATE TEMPORARY TABLE session_level_made_it_flags AS
SELECT 
    website_session_id,
    MAX(products_page) AS product_made_it,
    MAX(mrfuzzy_page) AS mrfuzzy_made_it,
    MAX(cart_page) AS cart_made_it,
    MAX(shipping_page) AS shipping_made_it,
    MAX(billing_page) AS billing_made_it,
    MAX(thankyou_page) AS thankyou_made_it
FROM (
    SELECT 
        website_session_id,
        CASE WHEN pageview_url = '/products' THEN 1 ELSE 0 END AS products_page,
        CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS mrfuzzy_page,
        CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page,
        CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END AS shipping_page,
        CASE WHEN pageview_url = '/billing' THEN 1 ELSE 0 END AS billing_page,
        CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS thankyou_page
    FROM website_pageviews
    WHERE created_at BETWEEN '2012-08-05' AND '2012-09-05'
) AS pageview_level
GROUP BY website_session_id;

SELECT 
    COUNT(DISTINCT website_session_id) AS sessions,
    COUNT(DISTINCT CASE WHEN product_made_it = 1 THEN website_session_id ELSE NULL END) AS to_products,
    COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE NULL END) AS to_mrfuzzy,
    COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END) AS to_cart,
    COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END) AS to_shipping,
    COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL END) AS to_billing,
    COUNT(DISTINCT CASE WHEN thankyou_made_it = 1 THEN website_session_id ELSE NULL END) AS to_thankyou
FROM session_level_made_it_flags;
