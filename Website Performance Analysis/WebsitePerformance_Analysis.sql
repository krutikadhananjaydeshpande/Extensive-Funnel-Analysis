/*
Could you help me get my head around the site by pulling the most-viewed website pages, ranked by session volume?
*/

SELECT pageview_url,
       COUNT(DISTINCT website_session_id) AS sessions
FROM website_pageviews
WHERE created_at < "2012-06-09"
GROUP BY pageview_url
ORDER BY sessions DESC;

-- ANOTHER WAY OF GETTING Most-viewed website pages:
SELECT 
    pageview_url,
    COUNT(DISTINCT website_session_id) AS sessions
FROM website_pageviews
WHERE created_at < '2012-06-09'
GROUP BY pageview_url
ORDER BY sessions DESC;


/*
Would you be able to pull a list of the top entry pages? I want to confirm where our users are hitting the site. 
If you could pull all entry pages and rank them on entry volume, that would be great.
*/
-- Top entry pages:

CREATE TEMPORARY TABLE first_pageviews
SELECT website_session_id,
       MIN(website_pageview_id) AS min_pageview_id
FROM website_pageviews
WHERE created_at < "2012-06-12"
GROUP BY website_session_id;

SELECT wp.pageview_url AS landing_page,
       COUNT(first_pageviews.website_session_id) AS sessions_hitting_this_landing_page
FROM first_pageviews
LEFT OUTER JOIN website_pageviews AS wp
ON first_pageviews.min_pageview_id = wp.website_pageview_id
GROUP BY wp.pageview_url;


/* 
The other day you showed us that all of our traffic is landing on the homepage right now. We should check how that landing page is performing. 
Can you pull bounce rates for traffic landing on the homepage? I would like to see three numbers…Sessions, Bounced Sessions, and % of Sessions which Bounced 
(aka “Bounce Rate”).
*/
-- Bounce rates for homepage:

CREATE TEMPORARY TABLE first_pageview AS
SELECT 
    website_session_id, 
    MIN(website_pageview_id) AS first_pageview_id
FROM website_pageviews
WHERE created_at < '2012-06-14'
GROUP BY website_session_id;

CREATE TEMPORARY TABLE landing_page AS
SELECT 
    wp.pageview_url, 
    fp.website_session_id 
FROM first_pageview fp
JOIN website_pageviews wp
    ON fp.first_pageview_id = wp.website_pageview_id
WHERE wp.pageview_url = '/home';

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


/*
Based on your bounce rate analysis, we ran a new custom landing page (/lander-1) in a 50/50 test against the homepage (/home) for our gsearch nonbrand traffic. 
Can you pull bounce rates for the two groups so we can evaluate the new page? Make sure to just look at the time period where /lander-1 was getting traffic, so that it is a fair 
comparison
*/
-- Bounce rates comparison for /home and /lander-1:
DROP TEMPORARY TABLE IF EXISTS first_pageview;
DROP TEMPORARY TABLE IF EXISTS landing_page;
DROP TEMPORARY TABLE IF EXISTS bounce_session;

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


/*
Could you pull the volume of paid search nonbrand traffic landing on /home and /lander-1, trended weekly since June 1st? I want to confirm the traffic is all routed correctly.
Could you also pull our overall paid search bounce rate trended weekly? I want to make sure the lander change has improved the overall picture.
*/
-- Weekly trends for paid search traffic and bounce rates:

CREATE TEMPORARY TABLE sessions_min_view_count AS
SELECT 
    wp.website_session_id,    
    MIN(wp.website_pageview_id) AS first_pageview_id,
    COUNT(wp.website_pageview_id) AS count_pageview
FROM website_pageviews wp
JOIN website_sessions ws 
    ON wp.website_session_id = ws.website_session_id 
WHERE wp.created_at BETWEEN '2012-06-01' AND '2012-08-31'
    AND ws.utm_source = 'gsearch'
    AND ws.utm_campaign = 'nonbrand'
GROUP BY wp.website_session_id;

CREATE TEMPORARY TABLE sessions_counts_lander_and_created_at AS
SELECT 
    svc.website_session_id, 
    svc.first_pageview_id,
    svc.count_pageview, 
    wp.pageview_url AS landing_page,
    wp.created_at AS session_created_at
FROM sessions_min_view_count svc
LEFT JOIN website_pageviews wp
    ON svc.first_pageview_id = wp.website_pageview_id;

SELECT 
    DATE(MIN(session_created_at)) AS week_start_date,
    COUNT(DISTINCT CASE WHEN count_pageview = 1 THEN website_session_id END) / COUNT(DISTINCT website_session_id) AS bounce_rate,
    COUNT(DISTINCT CASE WHEN landing_page = '/home' THEN website_session_id END) AS home_sessions,
    COUNT(DISTINCT CASE WHEN landing_page = '/lander-1' THEN website_session_id END) AS lander_sessions
FROM sessions_counts_lander_and_created_at
GROUP BY YEARWEEK(session_created_at);



/*
I’d like to understand where we lose our gsearch visitors between the new /lander-1 page and placing an order. Can you build us a full conversion funnel, analyzing how many 
customers make it to each step? Start with /lander-1 and build the funnel all the way to our thank you page. Please use data since August 5th.
*/
-- Full conversion funnel analysis:

CREATE TEMPORARY TABLE lander1_thankyou AS
SELECT 
    website_session_id,
    MAX(products) AS products,
    MAX(fuzzy) AS fuzzy,
    MAX(cart) AS cart,
    MAX(shipping) AS shipping,
    MAX(billing) AS billing, 
    MAX(thankyou) AS thankyou
FROM (
    SELECT 
        wp.website_session_id, 
        wp.pageview_url, 
        CASE WHEN wp.pageview_url = '/products' THEN 1 ELSE 0 END AS products,
        CASE WHEN wp.pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS fuzzy,
        CASE WHEN wp.pageview_url = '/cart' THEN 1 ELSE 0 END AS cart,
        CASE WHEN wp.pageview_url = '/shipping' THEN 1 ELSE 0 END AS shipping,
        CASE WHEN wp.pageview_url = '/billing' THEN 1 ELSE 0 END AS billing,
        CASE WHEN wp.pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS thankyou
    FROM website_sessions ws
    LEFT JOIN website_pageviews wp
        ON wp.website_session_id = ws.website_session_id
    WHERE wp.created_at BETWEEN '2012-08-05' AND '2012-09-05'
        AND ws.utm_source = 'gsearch' 
        AND ws.utm_campaign = 'nonbrand'
) AS pageview_level
GROUP BY website_session_id;

SELECT 
    COUNT(website_session_id) AS sessions,
    SUM(products) AS to_products,
    SUM(fuzzy) AS to_fuzzy,
    SUM(cart) AS to_cart,
    SUM(shipping) AS to_shipping,
    SUM(billing) AS to_billing,
    SUM(thankyou) AS to_thankyou
FROM lander1_thankyou;

SELECT 
    SUM(products) / COUNT(website_session_id) AS lander_click_rt,
    SUM(fuzzy) / SUM(products) AS product_click_rt,
    SUM(cart) / SUM(fuzzy) AS fuzzy_click_rt,
    SUM(shipping) / SUM(cart) AS cart_click_rt,
    SUM(billing) / SUM(shipping) AS shipping_click_rt,
    SUM(thankyou) / SUM(billing) AS billing_click_rt
FROM lander1_thankyou;


/*
We tested an updated billing page based on your funnel analysis. Can you take a look and see whether /billing-2 is doing any better than the original /billing page? 
We’re wondering what % of sessions on those pages end up placing an order. FYI – we ran this test for all traffic, not just for our search visitors.
*/

-- Comparing performance of /billing and /billing-2 pages:

CREATE TEMPORARY TABLE sessions_orders AS
SELECT  
    wp.website_session_id, 
    wp.pageview_url, 
    o.order_id
FROM website_pageviews wp
LEFT JOIN orders o 
    ON wp.website_session_id = o.website_session_id
WHERE wp.pageview_url IN ('/billing', '/billing-2')
    AND wp.created_at BETWEEN '2012-09-10' AND '2012-11-10';

SELECT 
    pageview_url, 
    COUNT(website_session_id) AS sessions, 
    COUNT(order_id) AS orders,
    COUNT(order_id) / COUNT(website_session_id) AS billing_to_order_rt
FROM sessions_orders
GROUP BY pageview_url;







