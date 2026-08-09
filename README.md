# NB SAM IT Solutions --- Recruitment Analytics

A 3-dashboard Tableau project developed during a **Business Analyst
internship at NB SAM IT Solutions Pvt. Ltd.**, an SAP consulting and
staffing organization.

The project analyzes recruitment performance and converts operational
recruitment data into business insights using Python, PostgreSQL, and
Tableau.

## Project Overview

**Workflow**

`Process Audit → Data Cleaning → PostgreSQL Analysis → Synthetic Data Augmentation → Tableau → Recommendations`

-   **77 real recruitment records** were cleaned and analyzed.
-   **723 synthetic records** were generated from distributions observed
    in the real data.
-   Final analytical dataset: **800 records** (77 real + 723 synthetic).
-   The synthetic records are used for dashboard-scale analysis and are
    not presented as real company candidates.
-   The project includes a **3-dashboard Tableau suite** covering
    executive, operational, and candidate/market analytics.

## Dashboards

### 1. Executive Overview

Recruitment funnel, monthly trend, client distribution, top skills, and
key recruitment KPIs.

### 2. Recruitment Operations

Recruiter performance, interview-rate comparison, duplicate analysis,
and client × skill analysis.

### 3. Market & Candidate Analytics

Current vs. expected CTC, experience distribution, salary analysis, and
candidate locations.

## Key Business Takeaways

-   Interview conversion is low, indicating an opportunity to improve
    screening and profile quality.
-   Internal rejection is significant, suggesting that early-stage
    suitability screening can be strengthened.
-   Final client selection/placement outcomes are not captured reliably,
    limiting downstream recruitment KPIs.
-   Duplicate rates are relatively consistent across recruiters,
    supporting a centralized duplicate-check approach.
-   Recruitment activity is concentrated in a small number of
    high-demand skills.
-   Candidate compensation expectations are generally above current CTC,
    while experience alone is not a strong salary predictor.

## Technology

**Python / Google Colab · PostgreSQL · Tableau · Pandas · NumPy ·
Faker**

## Repository Contents

- `data/` — anonymized analytical dataset
- `dashboard/` — packaged Tableau workbook
- `process/` — recruitment process flowchart
- `notebooks/` — Python notebooks for data cleaning, synthetic data generation, and data-quality analysis
- `README.md` — project overview
- `SOLUTIONS.md` — detailed findings, analysis, and recommendations

## Data Privacy

The public repository contains only anonymized data. Candidate names,
phone numbers, and email addresses from the original operational data
are not included.
