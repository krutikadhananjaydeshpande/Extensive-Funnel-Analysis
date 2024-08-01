/* 
We've been live for almost a month now and we’re starting to generate sales. Can you help me understand where the bulk of our website sessions are coming from, 
through yesterday? I’d like to see a breakdown by UTM source, campaign and referring domain if possible. Thanks!
*/
-- Traffic Source Analysis

-- To understand where our website sessions are coming from, we ran the following query:


SELECT 
    IFNULL(utm_source, 'None') AS utm_source, 
    IFNULL(utm_campaign, 'None') AS utm_campaign, 
    IFNULL(http_referer, 'None') AS http_referer,
    COUNT(website_session_id) AS sessions 
FROM website_sessions
WHERE created_at < '2012-04-12'  -- Extended the date range
GROUP BY 
    IFNULL(utm_source, 'None'), 
    IFNULL(utm_campaign, 'None'), 
    IFNULL(http_referer, 'None')
ORDER BY sessions DESC;
/*
This (ABOVE) query gave us the following insights:

1. Our primary source of traffic is the gsearch nonbrand campaign, accounting for [calculate percentage] of our total sessions.
2. We're seeing some organic search traffic from both gsearch and bsearch.
3. Our brand campaigns (both gsearch and bsearch) are driving some traffic, but significantly less than the nonbrand campaigns.
4. We have a small amount of direct traffic, which could indicate some brand awareness.

Based on these results, we should focus on optimizing our gsearch nonbrand campaign as it's our main traffic driver. 
We should also investigate ways to improve our organic search presence and consider strategies to increase our brand awareness to drive more direct and branded search traffic.

*/


/*
We've been live for almost a month now and we’re starting to generate sales. Can you help me understand where the bulk of our website sessions are coming 
from, through yesterday? I’d like to see a breakdown by UTM source, campaign and referring domain if possible. Thanks!
*/
-- Analyzing conversion rates for gsearch nonbrand traffic:
SELECT COUNT(ws.website_session_id) AS sessions,
       COUNT(o.order_id) AS orders,
       COUNT(o.order_id) / COUNT(ws.website_session_id) AS session_to_order_conv_rate
FROM website_sessions AS ws
LEFT OUTER JOIN orders AS o
	ON ws.website_session_id = o.website_session_id
WHERE ws.created_at < "2012-04-14" 
AND ws.utm_source = "gsearch" 
AND ws.utm_campaign = "nonbrand";


/*
Based on your conversion rate analysis, we bid down gsearch nonbrand on 2012-04-15. Can you pull gsearch nonbrand trended session volume, by week, to see if the bid 
changes have caused volume to drop at all?
*/
-- Trended session volume for gsearch nonbrand, by week:

SELECT 
    DATE(MIN(created_at)) AS week_start_date,
    COUNT(website_session_id) AS sessions
FROM website_sessions
WHERE created_at < '2012-05-12' 
    AND utm_source = 'gsearch' 
    AND utm_campaign = 'nonbrand'
GROUP BY YEARWEEK(created_at);

/*
I was trying to use our site on my mobile device the other day, and the experience was not great. Could you pull conversion rates from session to order, by device type?
If desktop performance is better than on mobile we may be able to bid up for desktop specifically to get more volume?
*/
-- Conversion rates from session to order, by device type:

SELECT 
    ws.device_type,
    COUNT(DISTINCT ws.website_session_id) AS sessions,
    COUNT(DISTINCT o.order_id) AS orders,
    COUNT(DISTINCT o.order_id) / COUNT(DISTINCT ws.website_session_id) AS conv_rate
FROM website_sessions ws
LEFT JOIN orders o
    ON ws.website_session_id = o.website_session_id
WHERE ws.created_at < '2012-05-11' 
    AND ws.utm_source = 'gsearch' 
    AND ws.utm_campaign = 'nonbrand'
GROUP BY ws.device_type;


/*
After your device-level analysis of conversion rates, we realized desktop was doing well, so we bid our gsearch nonbrand desktop campaigns up on 2012-05-19. 
Could you pull weekly trends for both desktop and mobile so we can see the impact on volume? You can use 2012-04-15 until the bid change as a baseline
*/
-- Weekly trends for desktop and mobile sessions:

SELECT 
    DATE(MIN(created_at)) AS week_start_date,
    COUNT(DISTINCT CASE WHEN device_type = 'desktop' THEN website_session_id END) AS desktop_sessions, 
    COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN website_session_id END) AS mobile_sessions
FROM website_sessions
WHERE created_at BETWEEN '2012-04-15' AND '2012-06-09' 
    AND utm_source = 'gsearch' 
    AND utm_campaign = 'nonbrand'
GROUP BY YEARWEEK(created_at);



