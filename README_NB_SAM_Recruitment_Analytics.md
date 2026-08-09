# NB SAM IT Solutions --- Recruitment Analytics

A 3-dashboard Tableau analytics suite developed during a Business
Analyst internship at **NB SAM IT Solutions Pvt. Ltd.**, an SAP
consulting and staffing organization that sources, screens, trains, and
submits IT professionals to enterprise clients.

The project combines **Business Analysis, data cleaning, PostgreSQL
analysis, synthetic-data generation, and Tableau Business Intelligence**
to understand recruitment performance and identify process and
data-tracking improvements.

> **Project flow:** Business Process Audit → Data Cleaning → PostgreSQL
> Analysis → Synthetic Data Augmentation → Tableau Dashboards → Business
> Recommendations

------------------------------------------------------------------------

## Business Context

NB SAM's recruitment process involves sourcing IT professionals through
recruitment portals and referrals, conducting initial screening and
credential verification, pitching coaching/training services where
applicable, and submitting suitable candidates to enterprise clients.

The As-Is process analysis identified important data-tracking gaps at
the sourcing, screening, training-interest, and client-outcome stages.
In particular, some early-stage candidates were not consistently
recorded, while client updates were often stored as free-text remarks
rather than structured pipeline stages.

The project was therefore designed not simply as a dashboard exercise,
but as an analysis of both **recruitment performance and the underlying
data-collection process**.

------------------------------------------------------------------------

## Data & Method

### 1. Real recruitment data

The project started with **77 real recruitment records** from NB SAM's
operational data.

Cleaning was performed in Python/Google Colab and included:

-   Standardizing skill-name variants
-   Replacing placeholder strings with true null values
-   Converting notice-period fields into numeric days
-   Parsing and standardizing dates
-   Cleaning inconsistent categorical values
-   Preparing the data for database analysis

### 2. PostgreSQL analysis

The cleaned 77-row dataset was loaded into PostgreSQL.

**23 SQL queries** were used for two purposes:

1.  Extract distribution parameters from the real data to guide
    synthetic-data generation.
2.  Surface the operational findings used in the business
    recommendations.

The analysis covered areas including:

-   Candidate experience
-   Current and expected CTC
-   Skills
-   Notice period
-   Client sharing
-   Recruiter activity
-   Profile outcomes
-   Duplicate and internal-rejection patterns

### 3. Synthetic data augmentation

Using the distributions observed in the real dataset, **723 synthetic
records** were generated using **Faker and NumPy**, bringing the
analytical dataset to **800 rows**.

The synthetic records are used to provide sufficient volume for
dashboard-scale analysis. They are **not presented as additional real
company candidates**.

The final analytical dataset therefore consists of:

-   **77 real records**
-   **723 synthetic records**
-   **800 records total**

### 4. Validation

The combined dataset was compared against the original 77-row baseline:

  Metric                      Combined (800)   Real (77)   Difference
  ------------------------- ---------------- ----------- ------------
  Avg Relevant Experience            7.2 yrs    7.72 yrs        -6.7%
  Avg Current CTC                      14.9L      15.65L        -4.8%
  Avg Expected CTC                     19.9L      21.22L        -6.2%
  Candidate Share %                    77.1%      75.32%        +2.4%
  Duplicate %                           4.6%        3.9%      +0.7 pp

The first four metrics remain close to the real-data baseline. The
duplicate rate differs by only **0.7 percentage points**; the larger
relative difference is expected because the real dataset contains only a
very small number of duplicate records.

------------------------------------------------------------------------

## Important Scope Limitation

The company's operational recruitment process extends beyond the
analytical funnel.

The broader process includes:

**Candidate Sourcing → Screening → Training/Preparation → Client
Submission → Client Assessment/Interview → Selection → Placement**

However, the available tracking dataset does not reliably capture the
final **Selected / Not Selected / Placed** outcome.

Therefore, the Tableau recruitment funnel intentionally stops at:

**Candidate Records → Profiles Shared → Interview**

This limitation is itself an important business finding because
capturing final outcomes would enable additional metrics such as:

-   Time-to-Fill
-   Offer Acceptance Rate
-   Cost-per-Hire
-   Final Placement Rate

------------------------------------------------------------------------

# Dashboards

## 1. Executive Overview

**Audience:** CEO, Director, HR Head

**Question:** *How healthy is recruitment?*

Key components:

-   8 recruitment KPIs
-   Recruitment funnel
-   Monthly recruitment trend
-   Client distribution
-   Top skills
-   Executive insights

------------------------------------------------------------------------

## 2. Recruitment Operations

**Audience:** HR Manager, Recruitment Lead

**Question:** *How is recruitment performance distributed across
recruiters and clients?*

Key components:

-   Recruiter performance
-   Recruiter interview-rate comparison
-   Duplicate analysis
-   Skill demand
-   Client × Skill heatmap
-   Recruitment operations insights

------------------------------------------------------------------------

## 3. Market & Candidate Analytics

**Audience:** Business, HR Strategy, Compensation

**Question:** *What kind of candidates are present in the recruitment
pool?*

Key components:

-   Average current CTC
-   Average expected CTC
-   Average salary hike
-   Average experience
-   Current vs. expected CTC scatter plot
-   Experience distribution
-   Experience vs. salary
-   Candidate locations
-   Market and compensation insights

> Salary-hike analysis represents **candidate expectations**, not
> confirmed offers, because placement outcomes are not captured in the
> available dataset.

------------------------------------------------------------------------

# Key Findings & Recommendations

## 1. Interview conversion is low, and volume does not equal quality

Only **8.4% of shared profiles reach the interview stage**.

Masarrat handles the highest volume at **255 profiles**, but converts at
only **5.1%**, while Sharf reaches a **12.4% interview rate** on less
than half the volume.

### Recommendation

Audit what Sharf does differently during the **Profile & Credential
Verification** stage and identify screening practices that can be
standardized across recruiters.

Recruiter performance should not be evaluated using volume alone.

------------------------------------------------------------------------

## 2. Internal rejection indicates an opportunity to strengthen early screening

The **Internal Reject rate is 18.3%**, meaning nearly one in five
profiles does not progress beyond internal review.

### Recommendation

Introduce a lightweight suitability checklist during the **Initial
Candidate Phone Call** and verification stages to identify mismatches
earlier and reduce downstream recruiter effort.

------------------------------------------------------------------------

## 3. The pipeline does not capture the outcome that matters most

The operational process ultimately reaches client assessment and
selection, but the tracking dataset does not reliably capture the final:

**Selected / Not Selected / Placed**

outcome.

### Recommendation

Extend the tracking system, or move to a lightweight CRM/database, to
record:

-   Client interview status
-   Selection status
-   Placement date
-   Final outcome
-   Offer details where applicable

This is the highest-value data gap because it would unlock several
currently unavailable recruitment KPIs.

------------------------------------------------------------------------

## 4. Duplicate rates are broadly consistent across recruiters

Duplicate rates fall within a relatively narrow range of approximately
**3.5%--5.4%** across recruiters.

No single recruiter appears to be a major duplicate outlier.

### Recommendation

Implement a centralized duplicate check before client submission instead
of treating duplication primarily as an individual recruiter training
issue.

------------------------------------------------------------------------

## 5. Compensation expectations are strongly hike-oriented

Most candidates in the dataset expect compensation above their current
CTC.

Current CTC also shows only a weak relationship with experience,
suggesting that **skill and client requirements may also influence
compensation expectations**.

### Recommendation

Consider developing a skill/client-oriented compensation or rate-card
framework rather than relying primarily on years of experience when
discussing candidate expectations and client requirements.

------------------------------------------------------------------------

## 6. Recruitment is concentrated in a small number of skills

A relatively small set of skills accounts for a substantial share of
recruitment activity, including:

-   SAP MM
-   Senior Oracle Retail
-   SAP ABAP
-   SAP FICO

### Recommendation

Prioritize sourcing activity and coaching/training capacity around
high-demand skill categories instead of distributing recruitment effort
evenly across all skills.

------------------------------------------------------------------------

# Business Analysis Findings

The As-Is process audit identified several structural data gaps:

### Sourcing

Candidate searches and calls made through recruitment portals were not
consistently tracked.

**Impact:** Top-of-funnel recruiter efficiency and portal ROI cannot be
measured reliably.

### Training Pitch

Candidates who rejected the training/coaching pitch could disappear from
the tracking system.

**Impact:** Training-pitch conversion and rejection reasons cannot be
analyzed.

### Data Entry

Candidate details were manually entered into Excel with limited
validation.

**Impact:** Typos, trailing spaces, inconsistent formats, and category
variations affect data quality.

### Client Updates

Client progress was often recorded as free-text remarks.

**Impact:** Structured pipeline transitions and automated follow-ups are
difficult to measure.

------------------------------------------------------------------------

# Technology Stack

  -----------------------------------------------------------------------
  Technology                          Purpose
  ----------------------------------- -----------------------------------
  **Python / Google Colab**           Data cleaning, validation,
                                      synthetic-data generation

  **Pandas / NumPy / Faker**          Data processing and synthetic data
                                      generation

  **PostgreSQL**                      SQL-based distribution and
                                      operational analysis

  **Plotly.js / HTML**                Exploratory dashboard prototype

  **Tableau**                         Final 3-dashboard BI suite
  -----------------------------------------------------------------------

------------------------------------------------------------------------

# Project Architecture

``` text
                   NB SAM Recruitment Data
                            │
                            ▼
                   Business Process Audit
                            │
                            ▼
                     Data Cleaning
                            │
                            ▼
                     77 Real Records
                            │
                            ▼
                  PostgreSQL Analysis
                            │
                  ┌─────────┴─────────┐
                  ▼                   ▼
          Distribution Analysis   Business Findings
                  │
                  ▼
          Synthetic Data Generation
                  │
                  ▼
           723 Synthetic Records
                  │
                  ▼
             800-Row Dataset
                  │
                  ▼
           Tableau BI Dashboards
                  │
                  ▼
       Insights & Business Recommendations
```

------------------------------------------------------------------------

# Project Files

``` text
NB-SAM-Recruitment-Analytics/
│
├── README.md
│
├── data/
│   └── NB_SAM_Recruitment_Master_Anonymized.xlsx
│
├── dashboard/
│   └── NB_SAM_Recruitment_Dashboard.twbx
│
├── process/
│   └── Flowchart with swimlanes.png
│
└── documentation/
    └── As-Is Recruitment Process & Data Audit.docx
```

### Included dataset

`NB_SAM_Recruitment_Master_Anonymized.xlsx`

-   800 analytical records
-   Candidate names replaced with `Candidate-001`, `Candidate-002`, etc.
-   Phone numbers removed
-   Email addresses removed
-   Suitable for portfolio/project sharing

> The original company dataset contained candidate PII and should not be
> published publicly. Only the anonymized version should be uploaded to
> a public repository.

------------------------------------------------------------------------

# What the Project Demonstrates

This project demonstrates an end-to-end Business Analytics workflow:

-   Business process analysis
-   As-Is process mapping
-   Data-quality auditing
-   Data cleaning
-   SQL analysis
-   Statistical distribution analysis
-   Synthetic-data generation
-   KPI development
-   Dashboard design
-   Data storytelling
-   Business recommendations

The key objective was to move NB SAM's recruitment analysis from
**manual, fragmented tracking toward structured and measurable
decision-making**.
