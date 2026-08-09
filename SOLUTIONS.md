# NB SAM Recruitment Analytics — Detailed Findings & Solutions

This document contains the detailed business analysis behind the project. The main `README.md` is kept short for portfolio visitors; this file provides the deeper findings, methodology, and recommendations.

---

## 1. Business Process

The operational recruitment process broadly follows:

**Sourcing → Initial Call → Profile & Credential Verification → Suitability Decision → Coaching/Training Pitch → Candidate Tracking → Client Submission → Client Assessment/Interview → Selection/Placement**

Process analysis identified gaps in data capture at several stages:

- Candidate searches and calls from recruitment portals are not consistently tracked
- Candidates who reject the training/coaching pitch may disappear from the tracking system entirely, rather than being logged as a "declined" outcome
- Candidate details are entered manually into Excel — no validation, no structured status field
- Client updates are stored as free-text remarks rather than structured fields
- Final selected/not-selected/placed outcomes are not reliably captured

---

## 2. Data Methodology

**Real dataset**: 77 real recruitment records.

**Python (Google Colab)** was used to standardize skill names, fix date formats, convert notice periods to numeric values, replace placeholders with true nulls, and standardize categorical fields ahead of PostgreSQL analysis.

**PostgreSQL** analysis on the 77-row real dataset served two purposes: (1) extracting real distribution parameters to guide synthetic data generation, and (2) surfacing the operational patterns behind the recommendations in this document.

**Synthetic dataset**: 723 rows generated with Faker and NumPy, matched to the real data's distributions. Final dataset: 77 real + 723 synthetic = **800 analytical records**. Synthetic records are explicitly analytical/simulation data, not real candidates.

**Validation** — combined (800) metrics against the real (77) baseline:

| Metric | Combined (800) | Real (77) | Difference |
|---|---:|---:|---:|
| Avg Relevant Experience | 7.2 yrs | 7.72 yrs | -6.7% |
| Avg Current CTC | 14.9L | 15.65L | -4.8% |
| Avg Expected CTC | 19.9L | 21.22L | -6.2% |
| Candidate Share % | 77.1% | 75.32% | +2.4 pp |
| Duplicate % | 4.6% | 3.9% | +0.7 pp |

The first four metrics stay close to the real-data baseline — normal sampling variance for a distribution-matched synthetic sample. Duplicate % differs by only 0.7 percentage points in absolute terms — the larger relative gap (~18%) is a small-base-rate artifact (~3 real duplicates out of 77 candidates), not a generator defect.

---

## 3. Finding: Interview Conversion Is Low, and Volume ≠ Quality

Only **8.4%** of shared profiles reach the interview stage.

**Masarrat** handles the highest volume (255 shared profiles) but converts at just **5.1%**. **Sharf** converts at **12.4%** — more than double the rate — on less than half the volume.

**Business interpretation**: high recruiter activity does not necessarily translate into high-quality client progression. Recruiter performance should be evaluated on both activity/volume *and* conversion/quality, not volume alone.

**So what**: if Masarrat's interview rate matched Sharf's 12.4% rate on the same 255-profile volume, it would theoretically result in approximately **19 additional interviews** — a hypothetical illustration of the efficiency gap, not an actual historical result.

**Recommendation**: audit the screening and Profile & Credential Verification practices used by higher-converting recruiters and standardize what works across the team.

---

## 4. Finding: Internal Rejection Rate Suggests Screening Needs Tightening

The Internal Reject rate is **18.3%** — nearly 1 in 5 profiles never progress beyond internal review.

**Business interpretation**: a meaningful share of mismatches are being caught later in the process than they need to be, after recruiter time has already been spent.

**So what**: cutting this by even 5 points would mean roughly **40 fewer wasted submissions** per 800 candidates processed — time recruiters could redirect toward higher-converting profiles instead.

**Recommendation**: introduce a lightweight suitability checklist at the Initial Candidate Phone Call / Profile Verification stage, covering: required skill match, relevant experience, total experience, notice period, expected CTC, location, and client-specific requirements.

---

## 5. Finding: Final Outcomes Are Missing — the Highest-Value Data Gap

The broader operational process continues past Interview to **Client Assessment → Selected/Not Selected → Placement**. The dataset does not reliably capture these final outcomes, so the analytical funnel currently stops at **Candidate Records → Profiles Shared → Interview**.

**Business impact**: without final outcomes, it's not possible to calculate Final Placement Rate, Time-to-Fill, Offer Acceptance Rate, or Cost-per-Hire — four of the metrics a staffing business would typically use to evaluate its own performance.

**Recommendation**: extend the tracking system with structured outcome fields — Client Interview Date, Interview Result, Selection Status, Offer Date, Offer Accepted, Placement Date, Final Outcome. This is the single highest-value data improvement identified in this project, since it unlocks four new KPIs from data the company is likely already generating but not capturing.

---

## 6. Finding: Duplicate Records — a Process Issue, Not a Recruiter Issue

Duplicate rates run **3.5%–5.4%** across recruiters, with no single recruiter standing out as a clear outlier.

**Business interpretation**: since the rate is consistent across the team, this points to a process-level gap (no shared pre-submission check) rather than an individual training issue.

**Recommendation**: introduce a centralized duplicate check before client submission, using email, phone number, candidate ID, or a normalized name + skill combination as the match key.

---

## 7. Finding: Compensation Expectations Are Hike-Driven, Not Experience-Driven

Most candidates expect a CTC higher than their current CTC. Current CTC has only a **weak** relationship with experience.

**Business interpretation**: years of experience alone does not fully explain compensation expectations, suggesting that skill and client requirements may also play a role. Note that this analysis reflects candidate *expectations*, not confirmed offers, since final placement outcomes aren't available in the tracking data (see Finding 5).

**Recommendation**: consider a skill/client-oriented rate-card framework for compensation conversations, rather than one anchored primarily on years of experience.

---

## 8. Finding: Skill Concentration

Recruitment activity concentrates in a small set of skills: **SAP MM, Senior Oracle Retail, SAP ABAP, SAP FICO**.

**Recommendation**: prioritize sourcing effort, recruiter search time, and coaching/training capacity around these consistently high-demand skills rather than spreading effort evenly.

---

## 9. Data-Quality Recommendations

- **Standardize candidate status** — replace inconsistent free-text statuses with a controlled pipeline: Sourced → Contacted → Screened → Training Pitched → Client Shared → Interview → Selected/Rejected → Placed
- **Standardize client updates** — structured fields instead of free-text remarks
- **Centralize candidate data** — move from fragmented Excel tracking to a structured database or lightweight CRM
- **Track all candidates** — candidates who decline the training/coaching pitch should get a recorded outcome, not disappear from the dataset
- **Add input validation** — dropdowns, mandatory fields, date validation, standardized categories

---

## 10. Recommended Future KPI Framework

**Currently measurable**: Total Candidates, Profiles Shared, Interview Rate, Internal Reject Rate, Duplicate Rate, Average Experience, Current CTC, Expected CTC, Notice Period.

**Unlocked once outcome data is captured** (Finding 5): Selection Rate, Placement Rate, Time-to-Fill, Offer Acceptance Rate, Cost-per-Hire, Client Conversion Rate, Recruiter Quality/Conversion, Source-to-Interview Conversion, Source-to-Placement Conversion.

---

## 11. Dashboard Purpose

- **Executive Overview** — "How healthy is recruitment?" Overall funnel, trends, clients, skills, top-level KPIs.
- **Recruitment Operations** — "How is performance distributed across recruiters and clients?" Recruiter conversion, duplicate patterns, skill demand, client requirements.
- **Market & Candidate Analytics** — "What does the candidate pool look like?" Experience, compensation expectations, skills, locations.

---

## 12. Known Limitations

- **CTC Scatter outlier**: one candidate in the internal dataset shows a ~302% expected-hike ask. The point was flagged as a known outlier, either a legitimate senior-role jump or a possible data-entry anomaly, and was retained rather than silently removed.
- **Combo-recruiter entries retained**: the recruiter field includes joint-credit entries (e.g. two recruiters sharing a candidate). These were kept as a distinct category rather than split between individuals, to avoid double-counting placements across recruiters.

---

## 13. Final Business Value

The project moves the recruitment function from:

**Manual Tracking → Structured Data → Analysis → Measurement → Decision Support**

The Tableau dashboard is the visible output, but the underlying value is the framework it establishes for NB SAM to understand its recruitment funnel, identify process bottlenecks, compare recruiter performance, understand skill demand, improve candidate screening, reduce duplicate records, capture missing outcomes, and build a more reliable recruitment analytics system going forward.
