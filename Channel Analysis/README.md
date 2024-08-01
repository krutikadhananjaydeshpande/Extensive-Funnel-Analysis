# Channel Management Analysis

## Project Description

This project focuses on analyzing and managing different marketing channels for an e-commerce website using SQL queries on the Maven Fuzzy Factory database. The goal is to understand the performance of various channels, compare their effectiveness, and make data-driven decisions for channel optimization.

## Database Used

Maven Fuzzy Factory

## Queries and Their Purposes

1. **Comparing gsearch and bsearch session volume**:
   ```sql
   SELECT 
       DATE(MIN(created_at)) AS week_start_date,
       COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' THEN website_session_id END) AS gsearch_sessions,
       COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' THEN website_session_id END) AS bsearch_sessions
   FROM website_sessions
   WHERE created_at BETWEEN '2012-08-22' AND '2012-11-29' 
       AND utm_campaign = 'nonbrand'
   GROUP BY YEARWEEK(created_at);
``` 

This query compares the weekly session volume between gsearch and bsearch, helping us understand the relative performance of these two channels over time.

2. **Analyzing mobile traffic percentage for gsearch and bsearch**:


This query analyzes the percentage of mobile traffic for gsearch and bsearch, helping us understand device preferences across different channels

3. **Comparing conversion rates for gsearch and bsearch by device type**:

```sql
SELECT 
    ws.device_type, 
    ws.utm_source,
    COUNT(DISTINCT ws.website_session_id) AS sessions,
    COUNT(DISTINCT o.order_id) AS orders,
    COUNT(DISTINCT o.order_id) / COUNT(DISTINCT ws.website_session_id) AS conv_rate 
FROM website_sessions ws
LEFT JOIN orders o
    ON ws.website_session_id = o.website_session_id
WHERE ws.created_at BETWEEN '2012-08-22' AND '2012-09-18' 
    AND ws.utm_campaign = 'nonbrand' 
GROUP BY ws.device_type, ws.utm_source;
```

This query compares conversion rates between gsearch and bsearch, segmented by device type, allowing us to identify which channel performs better on different devices.

4. **Analyzing weekly session volume for gsearch and bsearch by device:**

```sql
SELECT 
    DATE(MIN(created_at)) AS week_start_date,
    COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' AND device_type = 'desktop' THEN website_session_id END) AS g_dtop_sessions, 
    COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' AND device_type = 'desktop' THEN website_session_id END) AS b_dtop_sessions, 
    COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' AND device_type = 'desktop' THEN website_session_id END) / 
        COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' AND device_type = 'desktop' THEN website_session_id END) AS b_pct_of_g_dtop, 
    COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' AND device_type = 'mobile' THEN website_session_id END) AS g_mob_sessions, 
    COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' AND device_type = 'mobile' THEN website_session_id END) AS b_mob_sessions, 
    COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' AND device_type = 'mobile' THEN website_session_id END) / 
        COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' AND device_type = 'mobile' THEN website_session_id END) AS b_pct_of_g_mob
FROM website_sessions
WHERE created_at BETWEEN '2012-11-04' AND '2012-12-22' 
    AND utm_campaign = 'nonbrand'
GROUP BY YEARWEEK(created_at);
```
This query provides a detailed weekly breakdown of session volume for gsearch and bsearch, segmented by device type, and calculates the relative performance of bsearch compared to gsearch.

## Key Insights

* Understand the relative performance of different marketing channels (gsearch vs bsearch)
* Analyze the impact of device type on channel performance
* Track changes in channel performance over time
* Identify opportunities for channel optimization based on conversion rates and traffic volume

## Recommendations
Based on the analysis, we can make the following recommendations:

* Allocate budget based on the relative performance of gsearch and bsearch
* Optimize campaigns for different devices based on their performance in each channel
* Consider creating device-specific campaigns if there are significant differences in performance
* Monitor trends in channel performance to quickly identify and respond to changes

## Future Work

* Analyze the impact of bid adjustments on channel performance
* Investigate the quality of traffic from different channels (e.g., time on site, pages per session)
* Conduct cohort analysis to understand long-term value of users acquired from different channels
* Explore additional channels and compare their performance to existing ones

This analysis provides valuable insights into channel performance, allowing for data-driven decisions in marketing strategy and budget allocation to optimize overall e-commerce performance.

