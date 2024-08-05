# Traffic Source Analysis for Maven Fuzzy Factory

## Project Overview
This project analyzes the traffic sources for Maven Fuzzy Factory's e-commerce website, focusing on the performance of various marketing channels and their impact on user acquisition and conversion.

## Data Source
- Database: Maven Fuzzy Factory SQL database
- Date Range: January 2012 to November 2012

## Key Files
- `traffic_source_analysis.sql`: SQL queries for data extraction and analysis
- `traffic_source_report.pdf`: Detailed report of findings and recommendations

## Analysis Highlights
1. Channel Performance Comparison
   - Gsearch vs. Bsearch
   - Paid vs. Organic traffic
2. Device-Specific Analysis
   - Desktop vs. Mobile performance
3. Bid Optimization Impact
   - Effects of bid adjustments on traffic and conversion
4. Conversion Rate Analysis
   - By channel and device type

## Key Findings
- Gsearch nonbrand campaign accounts for 89.5% of total traffic (3,613 out of 4,035 sessions)
- Desktop conversion rate: 3.73% vs. Mobile conversion rate: 0.96%
- Bid reduction on April 15 decreased weekly sessions from 983 to 621
- Desktop-specific bid increase on May 19 raised desktop sessions from 403 to 661

## Recommendations
1. Optimize mobile experience to improve the 0.96% conversion rate
2. Implement device-specific bidding strategies, focusing on desktop's higher performance
3. Explore opportunities to diversify traffic sources beyond Gsearch

## Technologies Used
- MySQL for data extraction and analysis

## How to Use
1. Clone the repository
2. Execute the SQL queries in `traffic_source_analysis.sql`
3. Review the findings in `traffic_source_report.pdf`

## Contributors
Krutika Deshpande

## License
This project is licensed under the MIT License - see the LICENSE.md file for details
