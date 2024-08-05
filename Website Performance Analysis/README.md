# Website Performance Analysis for Maven Fuzzy Factory

## Project Overview
This project examines the performance of Maven Fuzzy Factory's website, focusing on user behavior, page effectiveness, and conversion funnel optimization.

## Data Source
- Database: Maven Fuzzy Factory SQL database
- Date Range: June 2012 to November 2012

## Key Files
- `website_performance_analysis.sql`: SQL queries for data extraction and analysis
- `performance_report.pdf`: Comprehensive report of findings and recommendations

## Analysis Highlights
1. Most Viewed Pages
2. Top Entry Pages
3. Bounce Rate Analysis
4. Conversion Funnel Analysis
5. A/B Testing Results (Homepage vs. Custom Landing Page)
6. Billing Page Optimization

## Key Findings
- Homepage (/home) accounted for 10,584 sessions, 98.8% of all website entries
- Custom landing page (/lander-1) showed 52.50% bounce rate vs. 58.99% for homepage
- Conversion funnel drop-offs:
  - Lander to Products: 52.93% drop-off
  - Mr. Fuzzy to Cart: 56.41% drop-off
- New billing page (/billing-2) increased conversion from 22.83% to 26.65%

## Recommendations
1. Implement /lander-1 for all paid search traffic
2. Optimize the transition from product pages to cart to reduce 56.41% drop-off
3. Fully implement /billing-2 across all traffic to leverage 16.73% improvement in conversion

## Technologies Used
- MySQL for data extraction and analysis

## How to Use
1. Clone the repository
2. Run the SQL queries in `website_performance_analysis.sql`
3. Review the detailed analysis in `performance_report.pdf`

## Contributors
[Your Name]

## License
This project is licensed under the MIT License - see the LICENSE.md file for details
