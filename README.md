
# **Lifecycle Analytics Project**

### *A Behavioral, Economic, and Strategic Analysis of Artist Performance Using Simulated Streaming Data*

---

## **Project Overview**

This project analyzes the lifecycle performance of two anonymized pop artists (**Artist A** and **Artist B**) using a custom-generated synthetic dataset modeled on real industry patterns. The goal is to measure not just streaming totals, but the **underlying behavioral dynamics** that determine whether an artist is a short-term spike or a long-term strategic asset.

The project uses:

* **PostgreSQL (Supabase)** for the analytical data warehouse
* **Advanced SQL** (window functions, CTEs, date arithmetic) for modeling
* **KPI Framework** designed to mirror label & DSP Strategy teams
* **Tableau**/ **Power BI** for dashboards and executive-facing visuals
* **GitHub** for reproducible documentation

All artist and release names are anonymized to shift focus toward insights rather than celebrity context.

---

## **Core Business Questions**

1. How fast does an artist build momentum post-release?
2. How long does hype last before attention declines?
3. Do listeners explore the full album or only the lead singles?
4. How efficiently does social conversation convert into streaming behavior?
5. Which cohorts of fans stay loyal across eras?
6. Are listeners actively choosing the artist or passively receiving them via playlists?

These questions drive the KPI framework and SQL modeling throughout the project.

---


##  **Analytical SQL Models**

All major analytical logic is implemented as SQL views.
These include:

### **1. Weekly Decay Model**

`vw_weekly_decay`
Calculates weekly streams per release.

### **2. Hype Half-Life**

`vw_decay_normalized`
Measures retention relative to Week Zero peak.

### **3. Velocity Index**

`vw_velocity_index`
Captures early acceleration rate.

### **4. Catalog Stickiness**

`vw_catalog_stickiness`
Quantifies deep-cut vs single-driven consumption.

### **5. Return on Hype**

`vw_return_on_hype`
Compares social impressions to streaming output.

### **6. Source Mix**

`vw_weekly_source_mix`
Identifies active-search vs playlist-driven streams.

### **7. Sentiment Impact**

`vw_sentiment_streams` and `vw_sentiment_streams_lag`
Correlation between sentiment and streaming behavior.

### **8. Cohort Analysis**

`vw_user_cohorts`, `vw_cohort_growth`, `vw_cohort_recency`
Models onboarding and retention patterns.


---

## **Key KPIs**

### **Hype Half-Life**

How long it takes for weekly performance to fall below 50% of peak.

### **Velocity Index (VI)**

Speed at which a release reaches 20% of lifecycle streams.

### **Catalog Stickiness Score (CSS)**

Percent of album streaming that comes from non-singles.

### **Return on Hype (ROH)**

Streams generated per social impression.

### **Source-of-Stream Mix**

Active vs passive listening behavior.

### **Cohort Retention Proxy**

Recency-weighted retention measure using first-stream-date data.

---

##  **Summary of Insights**

* **Artist A** demonstrates strong launch momentum and high early acceleration but steep post-release decay. Catalog engagement is shallow and reliance on algorithmic listening is high. ROH is moderate, indicating inefficiency in converting social hype into streams.

* **Artist B** shows slower initial growth but far stronger long-term retention, deeper catalog exploration, and higher loyalty across cohorts. Social sentiment has a measurable impact on streams, and ROH is significantly higher, indicating marketing efficiency and strong organic traction.

These differences map to two distinct archetypes:

* **Artist A: The Viral Sprinter**
* **Artist B: The Slow-Build Marathoner**

Each requires different marketing, DSP, and promotional strategies.

---

##  **Full Report**

A complete narrative PDF summarizing:

* Project context
* KPI framework
* Analytical methods
* Behavioral insights
* Strategic recommendations


---

