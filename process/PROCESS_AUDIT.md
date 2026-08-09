# As-Is Recruitment Process & Data Audit

During the internship, the recruitment team maintained candidate information through an Excel-based **Daily Update** file. The file was primarily used as an operational tracker and was manually updated as candidates progressed through different stages of the recruitment process.

The audit was conducted to understand how the existing recruitment process worked, what information was being captured, and what issues would need to be addressed before the data could be used for recruitment analytics.

## As-Is Recruitment Process

The recruitment workflow identified from the existing process broadly followed:

**Sourcing → Initial Call → Profile & Credential Verification → Suitability Decision → Training/Coaching Pitch → Candidate Tracking → Technical Training & Interview Preparation → Client Submission → Client Assessment/Interview → Selection/Placement**

Candidates were primarily sourced through **referrals, job portals, and recruiter searches** based on relevant skills. HR then contacted candidates to verify their profiles and assess factors such as experience, technical skills, notice period, CTC, location, and client requirements.

Suitable candidates could be offered training, coaching, and placement assistance. Candidates who proceeded were tracked in the Daily Update and could receive technical training and interview preparation before their profiles were shared with relevant enterprise clients.

The client then conducted the assessment and interview process. Although the broader process continued through **Selected / Not Selected / Placement**, these final outcomes were not reliably captured in the tracking data available for analysis.

## How the Daily Update Was Structured

The Daily Update contained operational information such as:

- Candidate details
- Date and recruitment activity information
- Skill
- Relevant and total experience
- Notice period
- Current and expected CTC
- Recruiter
- Location
- Profile status
- Client information
- Profile-sharing information
- Recruiter follow-up
- Duplicate indicators
- Client updates and remarks

The file provided useful information about the recruitment pipeline, but it was created for day-to-day HR operations rather than as a structured analytical database.

## Key Problems Identified

### 1. Manual Data Entry

The Daily Update was manually maintained, resulting in inconsistencies across dates, skill names, statuses, experience, notice periods, and compensation fields.

Some values appeared in different formats or as text rather than standardized numeric values. These inconsistencies needed to be resolved before SQL analysis and dashboard development.

### 2. Incomplete Sourcing Funnel

The recruitment process began before candidates appeared in the Daily Update. Searches, profiles reviewed, referrals, and initial sourcing activity were not consistently captured as structured records.

This made it difficult to measure the complete sourcing-to-interview funnel or compare sourcing effort with downstream conversion.

### 3. Early-Stage Candidate Outcomes Were Not Fully Captured

Candidates could decline the training/coaching proposition or be found unsuitable during early screening. These outcomes were not always represented through standardized statuses.

This created ambiguity between candidates who were **declined, unreachable, unsuitable, or simply not updated**.

### 4. Client Updates Were Partly Free-Text

Client progress and updates were partly recorded through remarks rather than dedicated structured fields.

This made it difficult to consistently identify a candidate's current stage, latest client status, interview outcome, or required follow-up through automated analysis.

### 5. Final Outcomes Were Missing

The operational process continued beyond:

**Client Submission → Interview → Selected / Not Selected → Placement**

However, final outcomes were not reliably captured in the Daily Update.

As a result, important recruitment KPIs such as **Selection Rate, Placement Rate, Time-to-Fill, Offer Acceptance Rate, Cost-per-Hire, and Source-to-Placement Conversion** could not be reliably calculated.

See `SOLUTIONS.md`, **Finding 5: Final Outcomes Are Missing**, for the detailed business impact and proposed solution.

### 6. Candidate PII Was Present in the Operational Dataset

The Daily Update contained candidate-level information such as names, phone numbers, and email addresses alongside recruitment and analytical fields.

For analytical work, this information was not required. The project therefore used an anonymized analytical dataset for public-facing analysis and dashboard development.

## Audit Conclusion

The Daily Update was useful as an **operational recruitment tracker**, but it was not structured as an analytics-ready dataset.

The audit identified three main requirements:

**Standardize the existing data → Capture missing recruitment outcomes → Separate operational PII from analytical data**

These findings formed the basis for the subsequent **Python data cleaning, PostgreSQL analysis, synthetic-data generation, Tableau dashboard development, and business recommendations**.

The project therefore progressed from:

**As-Is Excel Tracking → Clean Structured Data → Analysis → Dashboard → Business Recommendations**

> **Confidentiality:** The original Daily Update and real candidate-level data are confidential and are not included in this public repository.
