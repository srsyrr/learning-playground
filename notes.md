# SQL Bootcamp: From Foundations to Analysis (A 10-Day Journey)

This document summarizes my intensive 10-day SQL learning sprint, where I progressed from basic concepts to solving complex, real-world business problems using a Sakila sample database.

## 🎯 Objective

The main objective of this bootcamp was to build a strong, practical foundation in SQL for data analysis. The focus was not just on syntax, but on developing the analytical mindset required to translate business needs into effective and efficient queries. The goal was to become a competent junior analyst, ready to work with complex, real-world datasets.

## 🛠️ Approach

My learning was structured around a hands-on, problem-solving methodology. Rather than just memorizing functions, I focused on developing a systematic process for analysis.

* **Progressive Complexity:** I started with fundamental concepts in a controlled "lab" environment and then moved to a larger, more realistic 15-table database to apply these skills to plausible business problems.
* **"Checkpoint Method" for Query Building:** I adopted a crucial habit of building queries step-by-step. I write one part (like a `JOIN`), test it, and verify the logic before adding the next layer of complexity (`GROUP BY`, `HAVING`, etc.). This has made my debugging process logical and efficient.
* **"Data First" Mindset:** I learned the importance of Data Profiling. Before writing a complex query, I now run simple `GROUP BY` and `COUNT(*)` queries on key columns to understand their distribution and avoid making incorrect assumptions.
* **Focus on Business Logic:** I practiced translating ambiguous business requests (e.g., "every customer") into precise technical solutions by considering the implications of `INNER JOIN` vs. `LEFT JOIN` and asking clarifying questions.

## 💻 Code/Queries Showcase

This section highlights five key problems I solved, demonstrating my progression from foundational concepts to more advanced analytical techniques.

#### 1. Customer Segmentation with `CASE WHEN`
* **Business Goal:** To support a new marketing loyalty program by segmenting all customers into 'High', 'Medium', and 'Low' value tiers based on their lifetime spending.
* **Skills:** `LEFT JOIN`, `GROUP BY`, `SUM()`, `COALESCE`, `CASE WHEN`.
```sql

SELECT
    c.first_name,
    c.last_name,
    COALESCE(SUM(p.amount), 0) AS total_spending,
    CASE
        WHEN COALESCE(SUM(p.amount), 0) > 150 THEN 'High Value'
        WHEN COALESCE(SUM(p.amount), 0) BETWEEN 100 AND 150 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment
FROM
    customer c
LEFT JOIN
    payment p ON c.customer_id = p.customer_id
GROUP BY
    c.customer_id, c.first_name, c.last_name
ORDER BY
    total_spending DESC;

#### 2.Navigating a Complex Schema with Multi-Table JOINs
