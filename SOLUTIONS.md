# NB SAM Recruitment Analytics --- Detailed Findings & Solutions

This document contains the detailed business analysis behind the
project. The main `README.md` is intentionally kept short for portfolio
visitors; this file provides the deeper findings, methodology, and
recommendations.

------------------------------------------------------------------------

## 1. Business Process

The operational recruitment process broadly follows:

`Sourcing → Initial Call → Profile & Credential Verification → Suitability Decision → Coaching/Training Pitch → Candidate Tracking → Client Submission → Client Assessment/Interview → Selection/Placement`

The process analysis identified gaps in data capture at several stages.

### Major process gaps

-   Candidate searches and calls from recruitment portals are not
    consistently tracked.
-   Candidates who reject the training/coaching pitch may disappear from
    the tracking system.
-   Candidate details are manually entered into Excel.
-   Client updates are often stored as free-text remarks.
-   Final selected/not-selected/placed outcomes are not reliably
    captured in the dataset.

------------------------------------------------------------------------

## 2. Data Methodology

### Real dataset

The project began with **77 real recruitment records**.

Python/Google Colab was used to:

-   standardize skill names
-   clean date formats
-   convert notice periods to numeric values
-   replace placeholder values with nulls
-   standardize categorical fields
-   prepare the dataset for PostgreSQL analysis

### PostgreSQL

The real 77-row dataset was analyzed in PostgreSQL to:

1.  understand the real data distributions for synthetic-data generation
2.  identify operational patterns used in the business recommendations

### Synthetic dataset

**723 synthetic rows** were generated using Faker and NumPy.

Final dataset:

`77 real + 723 synthetic = 800 analytical records`

The synthetic records are explicitly treated as analytical/simulation
data rather than real company candidates.

### Validation

  Metric                      Combined (800)   Real (77)
  ------------------------- ---------------- -----------
  Avg Relevant Experience            7.2 yrs    7.72 yrs
  Avg Current CTC                      14.9L      15.65L
  Avg Expected CTC                     19.9L      21.22L
  Candidate Share %                    77.1%      75.32%
  Duplicate %                           4.6%        3.9%

The first four metrics remain reasonably close to the real-data
baseline. Duplicate percentage differs by only 0.7 percentage points,
with the relative difference amplified by the small number of real
duplicates.

------------------------------------------------------------------------

## 3. Finding: Interview Conversion

Only **8.4% of shared profiles reach the interview stage**.

Masarrat handles the highest volume at **255 shared profiles**, but has
an interview rate of **5.1%**. Sharf has an interview rate of **12.4%**
on less than half the volume.

### Business interpretation

High recruiter activity does not necessarily translate into high-quality
client progression.

### Recommendation

Audit the screening and **Profile & Credential Verification** practices
used by higher-converting recruiters and identify practices that can be
standardized.

Recruiter performance should therefore consider both:

-   activity/volume
-   conversion/quality

rather than volume alone.

------------------------------------------------------------------------

## 4. Finding: Internal Rejection

The **Internal Reject rate is 18.3%**.

This means a substantial proportion of profiles do not progress beyond
internal review.

### Business interpretation

Some mismatches may be detected relatively late in the screening
process.

### Recommendation

Introduce a lightweight suitability checklist during the initial
candidate phone call and profile-verification stages.

Possible fields:

-   Required skill match
-   Relevant experience
-   Total experience
-   Notice period
-   Expected CTC
-   Location
-   Client-specific requirements

This can reduce recruiter effort spent on unsuitable profiles.

------------------------------------------------------------------------

## 5. Finding: Missing Final Outcomes

The broader operational process continues to:

`Client Assessment → Selected / Not Selected → Placement`

However, the available recruitment dataset does not reliably capture
these final outcomes.

Therefore, the analytical funnel currently stops at:

`Candidate Records → Profiles Shared → Interview`

### Business impact

The absence of final outcomes prevents reliable calculation of:

-   Final placement rate
-   Time-to-Fill
-   Offer Acceptance Rate
-   Cost-per-Hire

### Recommendation

Extend the tracking system with structured outcome fields:

-   Client Interview Date
-   Interview Result
-   Selection Status
-   Offer Date
-   Offer Accepted
-   Placement Date
-   Final Outcome

This is the highest-value data improvement identified in the project.

------------------------------------------------------------------------

## 6. Finding: Duplicate Records

Duplicate rates are approximately **3.5%--5.4% across recruiters**.

No single recruiter is a clear duplicate outlier.

### Business interpretation

The issue appears more suitable for a process-level solution than
individual recruiter retraining.

### Recommendation

Introduce a centralized duplicate check before client submission using
identifiers such as:

-   email
-   phone number
-   candidate ID
-   normalized name + skill combination where appropriate

------------------------------------------------------------------------

## 7. Finding: Compensation Expectations

Most candidates expect a CTC higher than their current CTC.

Current CTC has only a weak relationship with experience.

### Business interpretation

Years of experience alone may not explain compensation expectations.
Skill and client requirements may also influence expected compensation.

### Recommendation

Consider a skill/client-oriented compensation or rate-card framework
instead of relying primarily on years of experience.

> Salary-hike analysis represents candidate expectations, not confirmed
> offers, because final placement outcomes are not available in the
> tracking data.

------------------------------------------------------------------------

## 8. Finding: Skill Concentration

Recruitment activity is concentrated in a relatively small number of
skills, including:

-   SAP MM
-   Senior Oracle Retail
-   SAP ABAP
-   SAP FICO

### Recommendation

Prioritize:

-   candidate sourcing
-   recruiter search effort
-   coaching capacity
-   training resources

around consistently high-demand skills.

------------------------------------------------------------------------

## 9. Data-Quality Recommendations

### Standardize candidate status

Replace inconsistent/free-text statuses with controlled stages:

`Sourced → Contacted → Screened → Training Pitched → Client Shared → Interview → Selected/Rejected → Placed`

### Standardize client updates

Use structured fields instead of relying primarily on remarks.

### Centralize candidate data

Move from fragmented/manual Excel tracking toward a structured database
or lightweight CRM.

### Track all candidates

Candidates who reject training/coaching should still receive a recorded
outcome rather than disappearing from the dataset.

### Add validation

Use dropdowns, mandatory fields, date validation, and standardized
categories.

------------------------------------------------------------------------

## 10. Recommended Future KPI Framework

Once final outcome data is captured, the company can expand its KPI
framework to include:

### Current KPIs

-   Total Candidates
-   Profiles Shared
-   Interview Rate
-   Internal Reject Rate
-   Duplicate Rate
-   Average Experience
-   Current CTC
-   Expected CTC
-   Notice Period

### Future KPIs

-   Selection Rate
-   Placement Rate
-   Time-to-Fill
-   Offer Acceptance Rate
-   Cost-per-Hire
-   Client Conversion Rate
-   Recruiter Quality/Conversion
-   Source-to-Interview Conversion
-   Source-to-Placement Conversion

------------------------------------------------------------------------

## 11. Dashboard Purpose

### Executive Overview

Answers:

> **How healthy is recruitment?**

Focuses on overall funnel performance, trends, clients, skills, and
KPIs.

### Recruitment Operations

Answers:

> **How is recruitment performance distributed across recruiters and
> clients?**

Focuses on recruiter conversion, duplicate patterns, skill demand, and
client requirements.

### Market & Candidate Analytics

Answers:

> **What does the candidate pool look like?**

Focuses on experience, compensation expectations, skills, and locations.

------------------------------------------------------------------------

## 12. Final Business Value

The project moves the recruitment function from:

`Manual Tracking → Structured Data → Analysis → Measurement → Decision Support`

The most important outcome is not the Tableau dashboard itself. The
project establishes a framework for NB SAM to:

-   understand its recruitment funnel
-   identify process bottlenecks
-   compare recruiter performance
-   understand skill demand
-   improve candidate screening
-   reduce duplicate records
-   capture missing outcomes
-   build a more reliable recruitment analytics system
