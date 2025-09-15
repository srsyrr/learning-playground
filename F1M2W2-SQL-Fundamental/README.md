# Week 2: From Foundations to Analysis 

This document summarizes my intensive second week of SQL learning sprint, where I progressed from basic concepts to solving complex, real-world business problems using a Sakila sample database.

## Objective

The main objective of this bootcamp was to build a strong, practical foundation in SQL for data analysis. The focus was not just on syntax, but on developing the analytical mindset required to translate business needs into effective and efficient queries. The goal was to become a competent junior analyst, ready to work with complex, real-world datasets.

## Approach

My learning was structured around a hands-on, problem-solving methodology. Rather than just memorizing functions, I focused on developing a systematic process for analysis.

* **Progressive Complexity:** I started with fundamental concepts in a controlled "lab" environment and then moved to a larger, more realistic 15-table database to apply these skills to plausible business problems.
* **"Checkpoint Method" for Query Building:** I adopted a crucial habit of building queries step-by-step. I write one part (like a `JOIN`), test it, and verify the logic before adding the next layer of complexity (`GROUP BY`, `HAVING`, etc.). This has made my debugging process logical and efficient.
* **"Data First" Mindset:** I learned the importance of Data Profiling. Before writing a complex query, I now run simple `GROUP BY` and `COUNT(*)` queries on key columns to understand their distribution and avoid making incorrect assumptions.
* **Focus on Business Logic:** I practiced translating ambiguous business requests (e.g., "every customer") into precise technical solutions by considering the implications of `INNER JOIN` vs. `LEFT JOIN` and asking clarifying questions.

## Code/Queries Showcase

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

```

#### 2. Navigating a Complex Schema with Multi-Table JOINs
* **Business Goal:** To help the inventory team decide which film genres to invest in by identifying the most rented categories.

* **Skills**: Navigating a normalized database by chaining five `JOIN`s.

```sql
SELECT
    c.name AS category_name,
    COUNT(r.rental_id) AS total_rentals
FROM
    category c
JOIN
    film_category fc ON c.category_id = fc.category_id
JOIN
    inventory i ON fc.film_id = i.film_id
JOIN
    rental r ON i.inventory_id = r.inventory_id
GROUP BY
    category_name
ORDER BY
    total_rentals DESC;
```

#### 3. Multi-Step Analysis with a Subquery
* **Business Goal:** To identify and reward the top 5 most valuable customers based on their total spending.

* **Skills:** Using a subquery in the `FROM` clause (a derived table) to perform a two-step analysis.

```sql
SELECT
    c.first_name,
    c.last_name,
    customer_spending.total_belanja AS total_spending
FROM
    customer c
JOIN (
    SELECT
        customer_id,
        SUM(amount) AS total_belanja
    FROM payment
    GROUP BY customer_id
) AS customer_spending ON c.customer_id = customer_spending.customer_id
ORDER BY
    total_spending DESC
LIMIT 5;

```

#### 4. Efficient Filtering with EXISTS
* **Business Goal:** To create a targeted email campaign for customers who have shown interest in the 'Horror' genre.

* **Skills:** Using a correlated subquery with `EXISTS` for a highly efficient "yes/no" check, which is more performant than a `JOIN` + `DISTINCT`.

```sql
SELECT
    c.first_name,
    c.last_name
FROM
    customer c
WHERE
    EXISTS (
        SELECT 1
        FROM rental r
        JOIN inventory i ON r.inventory_id = i.inventory_id
        JOIN film_category fc ON i.film_id = fc.film_id
        JOIN category cat ON fc.category_id = cat.category_id
        WHERE
            r.customer_id = c.customer_id
            AND cat.name = 'Horror'
    );

```

#### 5. Time-Based Analysis
* **Business Goal:** To provide the finance team with a monthly revenue report for the year 2005 to track performance.

* **Skills:** Filtering by date parts, using the SQLite-specific `strftime` function.

```sql
SELECT
    strftime('%m', payment_date) AS month,
    SUM(amount) AS total_revenue
FROM
    payment
WHERE
    strftime('%Y', payment_date) = '2005'
GROUP BY
    month
ORDER BY
    month ASC;

```

## Results & Key Takeaways
Technical Proficiency: I am now capable of writing complex, multi-step analytical queries to answer specific business questions.

Analytical Mindset: My biggest takeaway is the importance of a systematic process. By breaking down problems, profiling data first, and clarifying ambiguity, I can solve challenges more effectively.

## Next Steps
My SQL journey continues. My plan for moving forward is:

Deepen Technical Skills: My immediate next goal is to master Window Functions (`RANK()`, `LAG()`, etc.) for more advanced ranking and time-series analysis.

Build Independent Projects: I will find a new dataset on Kaggle, define my own business questions, and complete a full end-to-end analysis.

Continue Daily Practice: I will use platforms like StrataScratch and LeetCode (SQL) to keep my problem-solving skills sharp.
