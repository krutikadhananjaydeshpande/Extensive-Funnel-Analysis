# Maven Fuzzy Factory Conversion Funnel Analysis

## Project Overview
This project conducts a comprehensive analysis of the conversion funnel for Maven Fuzzy Factory's e-commerce website. It examines user behavior and conversion rates through various stages of the purchasing process, providing insights for optimization.

## Data Source
- Database: Maven Fuzzy Factory SQL database
- Time Period: August 5 to September 5, 2012
- Focus: Sessions from Google search (gsearch) non-branded campaigns

## Key Files
- `conversion_funnel_analysis.sql`: SQL queries for data extraction and analysis
- `funnel_analysis_report.pdf`: Detailed report of findings and recommendations
- `funnel_visualizations.ipynb`: Jupyter notebook for data visualization

## Technical Stack
- Database: MySQL 5.7
- Analysis: SQL, Python 3.8
- Data Processing: pandas 1.2.3, numpy 1.20.1
- Visualization: matplotlib 3.3.4, seaborn 0.11.1
- Environment: Jupyter Notebook 6.2.0

## Funnel Stages Analyzed
1. Lander Page (/lander-1)
2. Products Page
3. Mr. Fuzzy Product Page
4. Cart
5. Shipping Information
6. Billing Information
7. Thank You Page (Purchase Confirmation)

## Key SQL Techniques Used
- Subqueries and Common Table Expressions (CTEs)
- Window functions for session-level aggregations
- CASE statements for funnel stage flags
- JOIN operations to combine session and pageview data
- Aggregate functions (COUNT, SUM) for conversion calculations

## Data Processing Steps
1. Session identification and deduplication
2. Funnel stage flagging for each session
3. Conversion rate calculation between stages
4. Identification of drop-off points

## Key Metrics Calculated
- Stage-by-stage conversion rates
- Overall funnel conversion rate
- Bounce rate
- Cart abandonment rate
- Checkout abandonment rate

## Visualization Techniques
- Funnel charts for overall conversion flow
- Bar charts for stage-by-stage conversion rates
- Heat maps for identifying critical drop-off points

## How to Use
1. Clone the repository
2. Set up a MySQL database and import the Maven Fuzzy Factory dataset
3. Execute the SQL queries in `conversion_funnel_analysis.sql`
4. Run the Jupyter notebook `funnel_visualizations.ipynb` for data visualization
5. Review the analysis results and visualizations

## Future Enhancements
- Implement A/B testing analysis for landing page optimization
- Develop predictive models for customer behavior
- Integrate real-time dashboarding for continuous monitoring

## License
This project is licensed under the MIT License - see the LICENSE.md file for details
