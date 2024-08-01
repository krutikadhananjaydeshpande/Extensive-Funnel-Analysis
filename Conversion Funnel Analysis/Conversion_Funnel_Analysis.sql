USE mavenfuzzyfactory; 

SELECT 'order_item_refunds' AS table_name, COUNT(*) AS row_count FROM mavenfuzzyfactory.order_item_refunds
UNION ALL
SELECT 'order_items', COUNT(*) FROM mavenfuzzyfactory.order_items
UNION ALL
SELECT 'orders', COUNT(*) FROM mavenfuzzyfactory.orders
UNION ALL
SELECT 'products', COUNT(*) FROM mavenfuzzyfactory.products
UNION ALL
SELECT 'website_pageviews', COUNT(*) FROM mavenfuzzyfactory.website_pageviews
UNION ALL
SELECT 'website_sessions', COUNT(*) FROM mavenfuzzyfactory.website_sessions
ORDER BY table_name;




SELECT * FROM website_sessions LIMIT 5;

SELECT DISTINCT utm_source, utm_campaign, utm_content, http_referer
FROM website_sessions
WHERE created_at BETWEEN '2012-08-05' AND '2012-09-05';



SELECT * FROM website_pageviews LIMIT 5;

SELECT DISTINCT pageview_url
FROM website_pageviews
WHERE created_at BETWEEN '2012-08-05' AND '2012-09-05'
ORDER BY pageview_url;


SELECT DISTINCT pageview_url
FROM website_sessions
LEFT JOIN website_pageviews
    ON website_sessions.website_session_id = website_pageviews.website_session_id
WHERE website_sessions.created_at BETWEEN '2012-08-05' AND '2012-09-05'
    AND website_sessions.utm_source = 'gsearch'
    AND website_sessions.utm_campaign = 'nonbrand'
ORDER BY pageview_url;


SELECT
    website_sessions.website_session_id,
    website_pageviews.website_pageview_id,
    website_pageviews.pageview_url,
    CASE WHEN pageview_url = '/lander-1' THEN 1 ELSE 0 END AS lander1_flag,
    CASE WHEN pageview_url = '/products' THEN 1 ELSE 0 END AS product_flag,
    CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS mrfuzzy_flag,
    CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_flag,
    CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END AS shipping_flag,
    CASE WHEN pageview_url = '/billing' THEN 1 ELSE 0 END AS billing_flag,
    CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS thankyou_flag
FROM website_sessions
LEFT JOIN website_pageviews
    ON website_sessions.website_session_id = website_pageviews.website_session_id
WHERE website_sessions.created_at BETWEEN '2012-08-05' AND '2012-09-05'
    AND website_sessions.utm_source = 'gsearch'
    AND website_sessions.utm_campaign = 'nonbrand'
ORDER BY
    website_sessions.website_session_id,
    website_pageviews.created_at;
    
    

CREATE TEMPORARY TABLE session_level_made_it_flags_demo
SELECT
    website_session_id,
    MAX(lander1_flag) AS lander1_made_it,
    MAX(product_flag) AS product_made_it,
    MAX(mrfuzzy_flag) AS mrfuzzy_made_it,
    MAX(cart_flag) AS cart_made_it,
    MAX(shipping_flag) AS shipping_made_it,
    MAX(billing_flag) AS billing_made_it,
    MAX(thankyou_flag) AS thankyou_made_it
FROM (
    SELECT
        website_sessions.website_session_id,
        website_pageviews.pageview_url,
        CASE WHEN pageview_url = '/lander-1' THEN 1 ELSE 0 END AS lander1_flag,
        CASE WHEN pageview_url = '/products' THEN 1 ELSE 0 END AS product_flag,
        CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS mrfuzzy_flag,
        CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_flag,
        CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END AS shipping_flag,
        CASE WHEN pageview_url = '/billing' THEN 1 ELSE 0 END AS billing_flag,
        CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS thankyou_flag
    FROM website_sessions
    LEFT JOIN website_pageviews
        ON website_sessions.website_session_id = website_pageviews.website_session_id
    WHERE website_sessions.created_at BETWEEN '2012-08-05' AND '2012-09-05'
        AND website_sessions.utm_source = 'gsearch'
        AND website_sessions.utm_campaign = 'nonbrand'
) AS pageview_level
GROUP BY website_session_id;

SELECT * FROM session_level_made_it_flags_demo LIMIT 5;




SELECT
    COUNT(DISTINCT website_session_id) AS sessions,
    COUNT(DISTINCT CASE WHEN product_made_it = 1 THEN website_session_id ELSE NULL END) AS to_products,
    COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE NULL END) AS to_mrfuzzy,
    COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END) AS to_cart,
    COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END) AS to_shipping,
    COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL END) AS to_billing,
    COUNT(DISTINCT CASE WHEN thankyou_made_it = 1 THEN website_session_id ELSE NULL END) AS to_thankyou
FROM session_level_made_it_flags_demo;

SELECT
    COUNT(DISTINCT website_session_id) AS sessions,
    COUNT(DISTINCT CASE WHEN product_made_it = 1 THEN website_session_id ELSE NULL END) / COUNT(DISTINCT website_session_id) AS lander_click_rt,
    COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE NULL END) / COUNT(DISTINCT CASE WHEN product_made_it = 1 THEN website_session_id ELSE NULL END) AS products_click_rt,
    COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END) / COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE NULL END) AS mrfuzzy_click_rt,
    COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END) / COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END) AS cart_click_rt,
    COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL END) / COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END) AS shipping_click_rt,
    COUNT(DISTINCT CASE WHEN thankyou_made_it = 1 THEN website_session_id ELSE NULL END) / COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL END) AS billing_click_rt
FROM session_level_made_it_flags_demo;