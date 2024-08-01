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


This query analyzes the full conversion funnel, showing how many users reach each step of the purchasing process.

##Key Insights

-Understand where users are dropping off in the purchase process
-Identify which steps of the funnel have the highest and lowest conversion rates
-Compare the performance of different landing pages
-Analyze the effectiveness of each stage in the purchasing funnel


##Recommendations
Based on the analysis, we can make the following recommendations:

-Optimize the step with the highest drop-off rate to improve overall conversions
-A/B test different versions of the landing pages to reduce bounce rates
-Simplify the checkout process if there's a significant drop-off between cart and purchase
-Ensure product pages are informative and compelling to encourage adding items to cart

##Future Work

-Segment the funnel analysis by user characteristics or traffic sources
-Conduct A/B tests on steps with low conversion rates to improve performance
-Analyze changes in funnel performance over time
-Investigate the impact of pricing, promotions, or seasonal trends on the conversion funnel

This analysis provides valuable insights into user behavior and website performance, allowing for data-driven decisions to optimize the conversion funnel and improve overall e-commerce performance.

