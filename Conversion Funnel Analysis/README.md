# Conversion Funnel Analysis for Maven Fuzzy Factory

## Project Overview
This project examines the conversion funnel of Maven Fuzzy Factory's e-commerce website, identifying key drop-off points and opportunities for optimization to improve overall conversion rates.

## Data Source
- Database: Maven Fuzzy Factory SQL database
- Date Range: June 2012 to November 2012

## Key Files
- `funnel_analysis.sql`: SQL queries for conversion funnel analysis
- `funnel_optimization_report.pdf`: Detailed report of findings and optimization strategies

## Analysis Highlights
1. Step-by-Step Funnel Visualization
2. Identification of Major Drop-off Points
3. Device-Specific Funnel Analysis
4. Impact of Website Changes on Funnel Performance
5. Product-Specific Conversion Patterns

## Key Findings
- Overall conversion rate from lander to purchase: 6.90%
- Largest drop-offs: Lander to Products (52.93%) and Mr. Fuzzy to Cart (56.41%)
- Mobile users show 2.77% lower conversion rates compared to desktop (1.30% vs 4.07%)
- New lander page (/lander-1) improved bounce rate from 58.99% to 52.50%
- Product-specific conversion rates: Mr. Fuzzy 10.50%, Love Bear 11.58%

## Recommendations
1. Optimize the transition from lander to products page to reduce 52.93% drop-off
2. Implement mobile-specific funnel enhancements to improve 1.30% conversion rate
3. A/B test critical stages, particularly the cart page, to reduce 56.41% drop-off
4. Develop product-specific conversion strategies based on Love Bear's higher performance

## Technologies Used
- MySQL for data extraction and funnel analysis

## How to Use
1. Clone the repository
2. Execute the SQL queries in `funnel_analysis.sql`
3. Review the comprehensive analysis and strategies in `funnel_optimization_report.pdf`

## Contributors
Krutika Deshpande

## License
This project is licensed under the MIT License - see the LICENSE.md file for details
