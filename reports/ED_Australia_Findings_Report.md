# Emergency Department Care in Australia, 2024–25
### Dashboard Findings and National Context — Brief Report

---

## 1. Purpose

This brief summarizes the results produced by the *AIHW Emergency Department Care 2024–25* dashboard and places them alongside the official national picture published by the Australian Institute of Health and Welfare (AIHW), to give the findings proper context.

---

## 2. Dashboard Headline Results

Based on the cleaned and modeled dataset (Table 4.4, Table 5.3, Table 4.12):

- **9M** total emergency department presentations across Australian public hospitals in 2024–25.
- **74%** average "seen on time" rate, calculated as a simple average across the five triage categories.
- **55.38%** on-time performance for **Urgent** cases (Triage 3) — the clearest bottleneck in the system.
- **99.42%** on-time performance for **Resuscitation** cases (Triage 1) — near-total compliance for the most critical patients.
- **414K patients (5% rate)** left the emergency department without being seen (Did Not Wait / Left At Own Risk).
- **58.56%** of episodes ended with the patient departing without being admitted or referred elsewhere (discharged); **30.25%** were admitted to hospital.
- Presentation volume peaks consistently between **10:00 AM and 2:00 PM**.

---

## 3. Comparing the Dashboard to the Official National Picture

AIHW's own national publication for the same reporting period reports an overall "seen on time" rate of **67%**, not 74%. This is not a data error — it reflects a **methodological difference in aggregation**:

- The dashboard's 74% is a **simple average across the five triage categories** (each category weighted equally).
- AIHW's official 67% is a **volume-weighted national average** — and Urgent and Semi-urgent categories, which perform worse (55.38% and 64.95% respectively), account for a much larger share of total presentation volume than Resuscitation, which performs almost perfectly but represents only about 1% of presentations.

This is a useful distinction to document explicitly in the dashboard: a category-level average tends to overstate system performance relative to a patient-weighted average, because it gives equal visual weight to a small, well-performing category and a large, under-performing one. Recommend adding a labeled note on the dashboard ("simple average across triage categories, not volume-weighted") to avoid the figure being read as the national KPI.

The **9M** total presentations figure aligns closely with AIHW's official count of **9.1 million** national ED presentations in 2024–25, confirming the ETL pipeline correctly reconstructed the underlying volume once the earlier filter issue was resolved.

---

## 4. State of the Question in Australia

Nationally, Australia's emergency department performance has been on a **downward trend** since the early 2020s pandemic-era baseline:

- The proportion of patients seen on time has fallen from **71% in 2020–21 to 67% in 2024–25**.
- The share of ED visits completed within 4 hours has dropped from **67% (2020–21) to 53% (2024–25)**.
- Median time to complete a 90th-percentile ED visit has grown by over **3 hours** since 2020–21; for patients later admitted to hospital, the increase is nearly **6 hours**.
- Total presentation volume has grown from **7.6 million (2015–16) to 9.1 million (2024–25)**, though the *rate* per population has actually declined slightly since 2020–21, suggesting the system is under more absolute pressure even as demand per capita eases somewhat.
- The share of presentations ending in hospital admission has risen from **32% (2015–16) to 38% (2024–25)**, meaning EDs are increasingly functioning as an admission gateway rather than a stand-alone acute-care service.
- Most presentations (70%) occur between 8 AM and 8 PM, and the busiest days nationally are **Sunday, Monday, and Tuesday**.

This national context reinforces what the dashboard shows at a more granular level: the strain in Australian EDs concentrates specifically in the **Urgent and Semi-urgent triage bands** — the "middle" of the acuity spectrum — rather than at the extremes (Resuscitation is essentially always met; low-acuity Non-urgent care performs comparatively well too, at 85.62%).

---

## 5. Key Takeaways

1. The dashboard's core numbers are directionally consistent with the official AIHW national report, once the earlier filter bug was corrected — a useful validation of the ETL pipeline's accuracy.
2. The 74% vs. 67% discrepancy is a methodological artifact worth labeling on the dashboard, not a data quality issue.
3. Both the dashboard and the national data point to the same operational conclusion: **Urgent-category patients (Triage 3) represent the primary pressure point** in Australian emergency departments, not the most critical (Resuscitation) or least critical (Non-urgent) cases.
4. The broader national trend — declining on-time performance and lengthening stays since 2020–21 — suggests this is a structural, system-wide pattern rather than an anomaly specific to this dataset or reporting year.

---

## Sources

- AIHW, *Emergency department care* — Hospitals sector overview, 2024–25: https://www.aihw.gov.au/reports-data/myhospitals/sectors/emergency-department-care
- AIHW, *Hospitals at a glance*, 2024–25: https://www.aihw.gov.au/hospitals/overview/hospitals-at-a-glance
- AIHW, *Care provided in emergency departments*: https://www.aihw.gov.au/hospitals/topics/emergency-departments/presentations-ee8c42a2d8474375cc9d3b7fda8e4635
- AIHW, *Emergency department presentations*: https://www.aihw.gov.au/hospitals/topics/emergency-departments/presentations
