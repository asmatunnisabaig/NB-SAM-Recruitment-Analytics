DROP TABLE IF EXISTS recruitment_data;
CREATE TABLE recruitment_data (
    "S.No." INTEGER PRIMARY KEY,
    "Date" VARCHAR(50),
    "Day" VARCHAR(50),
    "Skill" VARCHAR(100),
    "Candidate Name" VARCHAR(255),
    "Phone Number" VARCHAR(50),
    "Email" VARCHAR(255),
    "Referred By" VARCHAR(255),
    "Location" VARCHAR(100),
    "Relevant Experience (Yrs)" NUMERIC(5,2),
    "Total Experience (Yrs)" NUMERIC(5,2),
    "Notice Period (Days)" NUMERIC,
    "Current CTC" NUMERIC(12,2),
    "Expected CTC" NUMERIC(12,2),
    "Profile Status" VARCHAR(150),
    "Client Name" VARCHAR(255),
    "Client Share Date" VARCHAR(50),
    "Assigned Recruiter Follow-up" TEXT,
    "Client Database Duplicate" VARCHAR(50),
    "Client Update" TEXT,
    "Client Remarks" TEXT
);


select * from recruitment_data;


-- NB SAM INSIGHTS
--1. What is each recruiter's sourcing volume and percentage contribution to total candidates?
SELECT
    CASE
        WHEN "Referred By" IS NULL OR TRIM("Referred By") = '' THEN 'Unknown / Direct'
        ELSE "Referred By"
    END AS recruiter_name,

    COUNT(*) AS sourcing_volume,

    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS contribution_percentage

FROM recruitment_data

GROUP BY
    CASE
        WHEN "Referred By" IS NULL OR TRIM("Referred By") = '' THEN 'Unknown / Direct'
        ELSE "Referred By"
    END

ORDER BY sourcing_volume DESC;

--2. What is each recruiter's internal rejection rate — how often do they source candidates that fail internal review?
SELECT
    CASE
        WHEN "Referred By" IS NULL OR TRIM("Referred By") = '' THEN 'Unknown / Direct'
        ELSE "Referred By"
    END AS recruiter_name,

    COUNT(*) AS total_candidates_sourced,

    COUNT(
        CASE
            WHEN "Profile Status" = 'Internal Reject' THEN 1
        END
    ) AS internally_rejected_candidates,

    ROUND(
        COUNT(
            CASE
                WHEN "Profile Status" = 'Internal Reject' THEN 1
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS internal_rejection_rate

FROM recruitment_data

GROUP BY
    CASE
        WHEN "Referred By" IS NULL OR TRIM("Referred By") = '' THEN 'Unknown / Direct'
        ELSE "Referred By"
    END

ORDER BY internal_rejection_rate DESC;

--3. What is each recruiter's duplicate submission rate — how often are their candidates already in the client database?
SELECT
    CASE
        WHEN "Referred By" IS NULL OR TRIM("Referred By") = '' THEN 'Unknown / Direct'
        ELSE "Referred By"
    END AS recruiter_name,

    COUNT(*) AS total_candidates_sourced,

    COUNT(
        CASE
            WHEN "Client Database Duplicate" = 'Yes'
              OR "Profile Status" = 'Rejected by Client (Duplicate)'
            THEN 1
        END
    ) AS duplicate_submissions,

    ROUND(
        COUNT(
            CASE
                WHEN "Client Database Duplicate" = 'Yes'
                  OR "Profile Status" = 'Rejected by Client (Duplicate)'
                THEN 1
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS duplicate_submission_rate_percentage

FROM recruitment_data

GROUP BY
    CASE
        WHEN "Referred By" IS NULL OR TRIM("Referred By") = '' THEN 'Unknown / Direct'
        ELSE "Referred By"
    END

ORDER BY duplicate_submission_rate_percentage DESC;

--4. Which recruiters consistently deliver the highest-quality candidate pipeline, as measured by submission rates, internal rejection rates, and duplicate submission rates?
SELECT 
    CASE 
        WHEN "Referred By" IS NULL OR TRIM("Referred By") = '' THEN 'Unknown / Direct'
        ELSE "Referred By"
    END AS recruiter_name,
    COUNT(*) AS total_sourced,
    COUNT(CASE WHEN "Profile Status" = 'Shared' THEN 1 END) AS client_submissions,
    COUNT(CASE WHEN "Profile Status" = 'Internal Reject' THEN 1 END) AS internal_rejects,
    COUNT(CASE WHEN "Profile Status" = 'Rejected by Client (Duplicate)' OR "Client Database Duplicate" = 'Yes' THEN 1 END) AS duplicate_submissions,
    
    -- Quality Metric 1: Submission Rate 
    ROUND(
        (COUNT(CASE WHEN "Profile Status" = 'Shared' THEN 1 END) * 100.0) / COUNT(*), 
        2
    ) AS submission_rate_percentage,
    
    -- Quality Metric 2: Internal Rejection Rate 
    ROUND(
        (COUNT(CASE WHEN "Profile Status" = 'Internal Reject' THEN 1 END) * 100.0) / COUNT(*), 
        2
    ) AS internal_rejection_rate_percentage,
    
    -- Quality Metric 3: Duplicate Submission Rate 
    ROUND(
        (COUNT(CASE WHEN "Profile Status" = 'Rejected by Client (Duplicate)' OR "Client Database Duplicate" = 'Yes' THEN 1 END) * 100.0) / COUNT(*), 
        2
    ) AS duplicate_submission_rate_percentage
FROM 
    recruitment_data
GROUP BY 
    "Referred By"
ORDER BY 
    submission_rate_percentage DESC, 
    internal_rejection_rate_percentage ASC,
    duplicate_submission_rate_percentage ASC;

--5. Which clients generated the highest demand for candidate submissions during the analysis period, and how concentrated is NB SAM's recruitment business across clients?
WITH client_submissions AS (
    SELECT
        "Client Name" AS client_name,
        COUNT(*) AS submission_volume,
        ROUND(
            COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
            2
        ) AS dependency_percentage
    FROM recruitment_data
    WHERE "Client Name" NOT LIKE 'N/A%'
    GROUP BY
        "Client Name"
)

SELECT
    client_name,
    submission_volume,
    dependency_percentage,
    ROUND(
        SUM(dependency_percentage)
        OVER (
            ORDER BY submission_volume DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ),
        2
    ) AS cumulative_concentration_percentage
FROM client_submissions
ORDER BY submission_volume DESC;

--6. Top 5 Most Sourced Skills
SELECT 
    "Skill", 
    COUNT(*) AS sourcing_volume
FROM 
    recruitment_data
GROUP BY 
    "Skill"
ORDER BY 
    sourcing_volume DESC
LIMIT 5;

--7. Is NB SAM staying true to its SAP-focused core business?
SELECT 
    CASE 
        WHEN UPPER("Skill") LIKE 'SAP%' THEN 'SAP Core Business'
        ELSE 'Non-SAP / General Tech'
    END AS business_segment,
    COUNT(*) AS candidates_sourced,
    ROUND((COUNT(*) * 100.0) / SUM(COUNT(*)) OVER(), 2) AS share_percentage
FROM 
    recruitment_data
GROUP BY 
    1
ORDER BY 
    candidates_sourced DESC;

--8. Which technical skills command the highest current salaries, and how do salary ranges vary across the skills sourced by NB SAM?
SELECT
    "Skill",
    COUNT("Current CTC") AS candidate_count,
    ROUND(AVG("Current CTC"), 2) AS average_current_ctc,
    MIN("Current CTC") AS minimum_current_ctc,
    MAX("Current CTC") AS maximum_current_ctc
FROM recruitment_data
WHERE
    "Current CTC" IS NOT NULL
GROUP BY
    "Skill"
HAVING
    COUNT("Current CTC") >= 2
ORDER BY
    average_current_ctc DESC,
    candidate_count DESC;

--9. How did recruitment activity vary across months during the analysis period?
WITH monthly_activity AS (
    SELECT
        TO_CHAR("Date"::DATE, 'YYYY-MM') AS recruitment_month,
        COUNT(*) AS candidates_sourced
    FROM recruitment_data
    WHERE "Date" IS NOT NULL
    GROUP BY TO_CHAR("Date"::DATE, 'YYYY-MM')
)

SELECT
    recruitment_month,
    candidates_sourced,

    ROUND(
        candidates_sourced * 100.0 /
        SUM(candidates_sourced) OVER (),
        2
    ) AS activity_percentage,

    LAG(candidates_sourced) OVER (
        ORDER BY recruitment_month
    ) AS previous_month_sourcing,

    ROUND(
        (
            (candidates_sourced - LAG(candidates_sourced) OVER (ORDER BY recruitment_month))
            * 100.0
        ) /
        NULLIF(LAG(candidates_sourced) OVER (ORDER BY recruitment_month), 0),
        2
    ) AS month_over_month_growth_percentage

FROM monthly_activity

ORDER BY recruitment_month;

--10. Which recruiters are the sole source of specific technical skills, creating potential operational dependency if they become unavailable?
SELECT
    CASE
        WHEN "Referred By" IS NULL OR TRIM("Referred By") = ''
        THEN 'Unknown / Direct'
        ELSE "Referred By"
    END AS recruiter_name,

    COUNT(*) AS total_candidates_sourced,

    COUNT(DISTINCT "Skill") AS technical_skill_diversity,

    STRING_AGG(
        DISTINCT "Skill",
        ', '
        ORDER BY "Skill"
    ) AS sourced_skills

FROM recruitment_data

GROUP BY
    CASE
        WHEN "Referred By" IS NULL OR TRIM("Referred By") = ''
        THEN 'Unknown / Direct'
        ELSE "Referred By"
    END

ORDER BY
    technical_skill_diversity DESC,
    total_candidates_sourced DESC;

-- SYNTHETIC DATA GENERATION METRICS

--1. How is candidate sourcing distributed across recruiters, and is the recruitment workload balanced among the team?
SELECT
    CASE
        WHEN "Referred By" IS NULL OR TRIM("Referred By") = ''
        THEN 'Unknown / Direct'
        ELSE "Referred By"
    END AS recruiter_name,

    COUNT(*) AS candidate_count,

    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS distribution_percentage,

    ROUND(
        COUNT(*) * 1.0 /
        SUM(COUNT(*)) OVER (),
        6
    ) AS probability_weight

FROM recruitment_data

GROUP BY
    CASE
        WHEN "Referred By" IS NULL OR TRIM("Referred By") = ''
        THEN 'Unknown / Direct'
        ELSE "Referred By"
    END

ORDER BY candidate_count DESC;

--2. What is the distribution of technical skills across sourced candidates, and is the recruitment pipeline concentrated around a few core technologies or diversified across multiple skill areas?
WITH skill_distribution AS (
    SELECT
        "Skill" AS skill,
        COUNT(*) AS candidate_count,
        ROUND(
            COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
            2
        ) AS pipeline_percentage,
        ROUND(
            COUNT(*) * 1.0 / SUM(COUNT(*)) OVER (),
            6
        ) AS probability_weight
    FROM recruitment_data
    WHERE
        "Skill" IS NOT NULL
        AND TRIM("Skill") <> ''
    GROUP BY
        "Skill"
)

SELECT
    skill,
    candidate_count,
    pipeline_percentage,
    probability_weight,
    ROUND(
        SUM(pipeline_percentage)
        OVER (
            ORDER BY candidate_count DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ),
        2
    ) AS cumulative_pipeline_percentage
FROM skill_distribution
ORDER BY
    candidate_count DESC,
    skill ASC;

--3. How are candidate submissions distributed across clients, and which clients account for the largest share of recruitment activity?
SELECT 
    "Client Name",
    COUNT(*) AS total_submissions,
    -- Calculates percentage of total submissions
    ROUND(
        (COUNT(*) * 100.0) / SUM(COUNT(*)) OVER(), 
        2
    ) AS submission_share_percentage
FROM 
    recruitment_data
WHERE 
    "Profile Status" = 'Shared'
    AND "Client Name" IS NOT NULL
GROUP BY 
    "Client Name"
ORDER BY 
    total_submissions DESC;

--4. What is the distribution of recruitment outcomes, and how frequently do candidates progress through each stage of the recruitment pipeline?
WITH outcome_distribution AS (
    SELECT
        "Profile Status" AS profile_status,
        COUNT(*) AS candidate_count,
        ROUND(
            COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
            2
        ) AS pipeline_percentage,
        ROUND(
            COUNT(*) * 1.0 / SUM(COUNT(*)) OVER (),
            6
        ) AS probability_weight
    FROM recruitment_data
    GROUP BY "Profile Status"
)

SELECT
    profile_status,
    candidate_count,
    pipeline_percentage,
    probability_weight,
    ROUND(
        SUM(pipeline_percentage)
        OVER (
            ORDER BY candidate_count DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ),
        2
    ) AS cumulative_pipeline_percentage
FROM outcome_distribution
ORDER BY
    candidate_count DESC,
    profile_status;

--5. How are sourced candidates geographically distributed, and which locations contribute the largest share of the talent pipeline?
WITH location_distribution AS (
    SELECT
        CASE
            WHEN "Location" IS NULL OR TRIM("Location") = ''
            THEN 'Unknown'
            ELSE "Location"
        END AS location,
        COUNT(*) AS candidate_count,
        ROUND(
            COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
            2
        ) AS location_share_percentage,
        ROUND(
            COUNT(*) * 1.0 / SUM(COUNT(*)) OVER (),
            6
        ) AS probability_weight
    FROM recruitment_data
    GROUP BY
        CASE
            WHEN "Location" IS NULL OR TRIM("Location") = ''
            THEN 'Unknown'
            ELSE "Location"
        END
)

SELECT
    location,
    candidate_count,
    location_share_percentage,
    probability_weight,
    ROUND(
        SUM(location_share_percentage)
        OVER (
            ORDER BY candidate_count DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ),
        2
    ) AS cumulative_location_share_percentage
FROM location_distribution
ORDER BY
    candidate_count DESC,
    location;

--6. How do candidate experience and current salary vary across different technical skills, and what are the typical compensation patterns associated with each skill?
SELECT
    "Skill" AS skill,
    COUNT(*) AS candidate_count,

    -- Experience Statistics
    ROUND(AVG("Total Experience (Yrs)"::NUMERIC), 2) AS avg_total_experience,
    PERCENTILE_CONT(0.5) WITHIN GROUP (
        ORDER BY "Total Experience (Yrs)"::NUMERIC
    ) AS median_total_experience,
    MIN("Total Experience (Yrs)") AS min_total_experience,
    MAX("Total Experience (Yrs)") AS max_total_experience,
    ROUND(STDDEV("Total Experience (Yrs)"::NUMERIC), 2) AS stddev_total_experience,

    -- Current CTC Statistics
    ROUND(AVG("Current CTC"::NUMERIC), 2) AS avg_current_ctc,
    PERCENTILE_CONT(0.5) WITHIN GROUP (
        ORDER BY "Current CTC"::NUMERIC
    ) AS median_current_ctc,
    MIN("Current CTC") AS min_current_ctc,
    MAX("Current CTC") AS max_current_ctc,
    ROUND(STDDEV("Current CTC"::NUMERIC), 2) AS stddev_current_ctc

FROM recruitment_data

WHERE
    "Skill" IS NOT NULL
    AND TRIM("Skill") <> ''
    AND "Total Experience (Yrs)" IS NOT NULL
    AND "Current CTC" IS NOT NULL

GROUP BY
    "Skill"

ORDER BY
    candidate_count DESC,
    avg_current_ctc DESC;

--7. What is the distribution of candidate notice periods, and how readily available are candidates for client opportunities?
WITH notice_period_distribution AS (
    SELECT
        CASE
            WHEN "Notice Period (Days)" IS NULL
                 OR TRIM("Notice Period (Days)"::TEXT) = ''
            THEN 'Unknown'
            ELSE "Notice Period (Days)"::TEXT
        END AS notice_period,

        COUNT(*) AS candidate_count,

        ROUND(
            COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
            2
        ) AS pipeline_percentage,

        ROUND(
            COUNT(*) * 1.0 / SUM(COUNT(*)) OVER (),
            6
        ) AS probability_weight

    FROM recruitment_data

    GROUP BY
        CASE
            WHEN "Notice Period (Days)" IS NULL
                 OR TRIM("Notice Period (Days)"::TEXT) = ''
            THEN 'Unknown'
            ELSE "Notice Period (Days)"::TEXT
        END
)

SELECT
    notice_period,
    candidate_count,
    pipeline_percentage,
    probability_weight,

    ROUND(
        SUM(pipeline_percentage)
        OVER (
            ORDER BY candidate_count DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ),
        2
    ) AS cumulative_pipeline_percentage

FROM notice_period_distribution

ORDER BY
    candidate_count DESC,
    notice_period;

--8. How do salary expectations vary across technical skills, and which skills exhibit the largest gap between current and expected compensation?
SELECT
    "Skill" AS skill,

    COUNT(*) AS candidate_count,

    ROUND(AVG("Current CTC"::NUMERIC), 2) AS avg_current_ctc,

    ROUND(AVG("Expected CTC"::NUMERIC), 2) AS avg_expected_ctc,

    ROUND(
        AVG(
            "Expected CTC"::NUMERIC -
            "Current CTC"::NUMERIC
        ),
        2
    ) AS avg_ctc_gap,

    ROUND(
        AVG(
            (
                "Expected CTC"::NUMERIC -
                "Current CTC"::NUMERIC
            ) * 100.0 /
            NULLIF("Current CTC"::NUMERIC, 0)
        ),
        2
    ) AS avg_percentage_hike,

    ROUND(
        MAX(
            (
                "Expected CTC"::NUMERIC -
                "Current CTC"::NUMERIC
            ) * 100.0 /
            NULLIF("Current CTC"::NUMERIC, 0)
        ),
        2
    ) AS highest_percentage_hike

FROM recruitment_data

WHERE
    "Skill" IS NOT NULL
    AND TRIM("Skill") <> ''
    AND "Current CTC" IS NOT NULL
    AND "Expected CTC" IS NOT NULL

GROUP BY
    "Skill"

HAVING
    COUNT(*) >= 2

ORDER BY
    avg_percentage_hike DESC,
    candidate_count DESC;

--9. How did recruitment activity vary across the analysis period, and which months recorded the highest and lowest sourcing volumes?
SELECT
    TO_CHAR("Date"::DATE, 'YYYY-MM') AS sourcing_month,

    COUNT(*) AS candidates_sourced,

    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS activity_percentage,

    LAG(COUNT(*)) OVER (
        ORDER BY TO_CHAR("Date"::DATE, 'YYYY-MM')
    ) AS previous_month_volume,

    ROUND(
        (
            COUNT(*) -
            LAG(COUNT(*)) OVER (
                ORDER BY TO_CHAR("Date"::DATE, 'YYYY-MM')
            )
        ) * 100.0 /
        NULLIF(
            LAG(COUNT(*)) OVER (
                ORDER BY TO_CHAR("Date"::DATE, 'YYYY-MM')
            ),
            0
        ),
        2
    ) AS month_over_month_growth_percentage

FROM recruitment_data

WHERE "Date" IS NOT NULL

GROUP BY
    TO_CHAR("Date"::DATE, 'YYYY-MM')

ORDER BY
    sourcing_month;

--10. Are there recurring day-of-the-week patterns in recruitment activity, indicating preferred sourcing days or operational workload peaks?
SELECT
    TO_CHAR("Date"::DATE, 'FMDay') AS day_of_week,

    EXTRACT(ISODOW FROM "Date"::DATE) AS day_index,

    COUNT(*) AS candidates_sourced,

    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS activity_percentage

FROM recruitment_data

WHERE "Date" IS NOT NULL

GROUP BY
    TO_CHAR("Date"::DATE, 'FMDay'),
    EXTRACT(ISODOW FROM "Date"::DATE)

ORDER BY
    day_index;

--11. Which candidate information fields are most frequently incomplete, and which areas require improvement to enhance recruitment data quality?
WITH data_quality_audit AS (

    SELECT 'Date' AS field_name,
           SUM(CASE WHEN "Date" IS NULL THEN 1 ELSE 0 END) AS missing_count
    FROM recruitment_data

    UNION ALL
    SELECT 'Day',
           SUM(CASE WHEN "Day" IS NULL OR TRIM("Day") = '' THEN 1 ELSE 0 END)
    FROM recruitment_data

    UNION ALL
    SELECT 'Skill',
           SUM(CASE WHEN "Skill" IS NULL OR TRIM("Skill") = '' THEN 1 ELSE 0 END)
    FROM recruitment_data

    UNION ALL
    SELECT 'Candidate Name',
           SUM(CASE WHEN "Candidate Name" IS NULL OR TRIM("Candidate Name") = '' THEN 1 ELSE 0 END)
    FROM recruitment_data

    UNION ALL
    SELECT 'Phone Number',
           SUM(CASE WHEN "Phone Number" IS NULL OR TRIM("Phone Number") = '' THEN 1 ELSE 0 END)
    FROM recruitment_data

    UNION ALL
    SELECT 'Email',
           SUM(CASE WHEN "Email" IS NULL OR TRIM("Email") = '' THEN 1 ELSE 0 END)
    FROM recruitment_data

    UNION ALL
    SELECT 'Referred By',
           SUM(CASE WHEN "Referred By" IS NULL OR TRIM("Referred By") = '' THEN 1 ELSE 0 END)
    FROM recruitment_data

    UNION ALL
    SELECT 'Location',
           SUM(CASE WHEN "Location" IS NULL OR TRIM("Location") = '' THEN 1 ELSE 0 END)
    FROM recruitment_data

    UNION ALL
    SELECT 'Relevant Experience (Yrs)',
           SUM(CASE WHEN "Relevant Experience (Yrs)" IS NULL THEN 1 ELSE 0 END)
    FROM recruitment_data

    UNION ALL
    SELECT 'Total Experience (Yrs)',
           SUM(CASE WHEN "Total Experience (Yrs)" IS NULL THEN 1 ELSE 0 END)
    FROM recruitment_data

    UNION ALL
    SELECT 'Notice Period (Days)',
           SUM(CASE WHEN "Notice Period (Days)" IS NULL THEN 1 ELSE 0 END)
    FROM recruitment_data

    UNION ALL
    SELECT 'Current CTC',
           SUM(CASE WHEN "Current CTC" IS NULL THEN 1 ELSE 0 END)
    FROM recruitment_data

    UNION ALL
    SELECT 'Expected CTC',
           SUM(CASE WHEN "Expected CTC" IS NULL THEN 1 ELSE 0 END)
    FROM recruitment_data

    UNION ALL
    SELECT 'Profile Status',
           SUM(CASE WHEN "Profile Status" IS NULL OR TRIM("Profile Status") = '' THEN 1 ELSE 0 END)
    FROM recruitment_data

    UNION ALL
    SELECT 'Client Name',
           SUM(CASE WHEN "Client Name" IS NULL OR TRIM("Client Name") = '' THEN 1 ELSE 0 END)
    FROM recruitment_data

    UNION ALL
    SELECT 'Client Share Date',
           SUM(CASE WHEN "Client Share Date" IS NULL THEN 1 ELSE 0 END)
    FROM recruitment_data

    UNION ALL
    SELECT 'Assigned Recruiter Follow-up',
           SUM(CASE WHEN "Assigned Recruiter Follow-up" IS NULL
                    OR TRIM("Assigned Recruiter Follow-up") = '' THEN 1 ELSE 0 END)
    FROM recruitment_data

    UNION ALL
    SELECT 'Client Database Duplicate',
           SUM(CASE WHEN "Client Database Duplicate" IS NULL
                    OR TRIM("Client Database Duplicate") = '' THEN 1 ELSE 0 END)
    FROM recruitment_data

    UNION ALL
    SELECT 'Client Update',
           SUM(CASE WHEN "Client Update" IS NULL
                    OR TRIM("Client Update") = '' THEN 1 ELSE 0 END)
    FROM recruitment_data

    UNION ALL
    SELECT 'Client Remarks',
           SUM(CASE WHEN "Client Remarks" IS NULL
                    OR TRIM("Client Remarks") = '' THEN 1 ELSE 0 END)
    FROM recruitment_data

)

SELECT
    field_name,
    missing_count,
    ROUND(
        missing_count * 100.0 /
        (SELECT COUNT(*) FROM recruitment_data),
        2
    ) AS missing_percentage,
    ROUND(
        100 -
        (missing_count * 100.0 /
        (SELECT COUNT(*) FROM recruitment_data)),
        2
    ) AS completeness_percentage

FROM data_quality_audit

ORDER BY
    missing_percentage DESC,
    field_name;

--12. How does candidate experience vary across different technical skills, and are certain technologies predominantly associated with junior, mid-level, or senior professionals?
SELECT
    "Skill" AS skill,

    COUNT(*) AS candidate_count,

    ROUND(
        AVG("Total Experience (Yrs)"::NUMERIC),
        1
    ) AS average_experience_years,

    PERCENTILE_CONT(0.5)
    WITHIN GROUP (
        ORDER BY "Total Experience (Yrs)"::NUMERIC
    ) AS median_experience_years,

    MIN("Total Experience (Yrs)"::NUMERIC) AS minimum_experience_years,

    MAX("Total Experience (Yrs)"::NUMERIC) AS maximum_experience_years,

    SUM(
        CASE
            WHEN "Total Experience (Yrs)"::NUMERIC < 5
            THEN 1
            ELSE 0
        END
    ) AS junior_candidates,

    SUM(
        CASE
            WHEN "Total Experience (Yrs)"::NUMERIC BETWEEN 5 AND 9
            THEN 1
            ELSE 0
        END
    ) AS mid_level_candidates,

    SUM(
        CASE
            WHEN "Total Experience (Yrs)"::NUMERIC > 9
            THEN 1
            ELSE 0
        END
    ) AS senior_candidates

FROM recruitment_data

WHERE
    "Skill" IS NOT NULL
    AND TRIM("Skill") <> ''
    AND "Total Experience (Yrs)" IS NOT NULL

GROUP BY
    "Skill"

ORDER BY
    candidate_count DESC,
    average_experience_years DESC;



SELECT 
    -- Average Calculations (NULL values are automatically ignored by AVG)
    ROUND(AVG("Relevant Experience (Yrs)"::NUMERIC), 2) AS avg_relevant_experience,
    ROUND(AVG("Current CTC"::NUMERIC), 2)              AS avg_current_ctc,
    ROUND(AVG("Expected CTC"::NUMERIC), 2)             AS avg_expected_ctc,

    -- Duplicate Percentage
    ROUND(
        100.0 * COUNT(CASE WHEN "Client Database Duplicate" = 'Yes' THEN 1 END) / COUNT(*), 
        2
    ) AS duplicate_percentage,

    -- Candidate Share Percentage
    ROUND(
        100.0 * COUNT(CASE WHEN "Profile Status" = 'Shared' THEN 1 END) / COUNT(*), 
        2
    ) AS candidate_share_percentage

FROM recruitment_data;
