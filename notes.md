# SARAH-CODE Learning Log - F1M2W3: Subqueries

**Date:** 8 - 14 September 2025

### Objective
My main goal this week was to level up my SQL skills from simple reporting to asking more complex, multi-step questions. I wanted to learn how to filter data based on the results of another query and how to combine different result sets together.

### Approach
I continued with our "Flipped Classroom" model. My approach was to first read the articles and watch the tutorials about `Subqueries` and `UNION`. `Subqueries` felt like a logic puzzle, so I spent a lot of time practicing on DB-Fiddle to understand how the "inner query" runs first before the "outer query". For `UNION`, I focused on understanding the rule that the columns must be the same data type. Our daily discussions with Pak Andra then helped to clarify the real-world use cases for these concepts.

### Code/Queries
This is a query I worked hard on this week. It answers a complex business question: "Find all customers who have spent more than the overall average spending per customer". This was impossible to answer without a subquery.

```sql
-- This query felt like a big achievement.
-- It uses a subquery in the WHERE clause to calculate an average on the fly.

SELECT
    customer_name,
    total_spent
FROM (
    -- First, I calculate the total amount spent by each customer
    SELECT
        c.customer_name,
        SUM(p.price * oi.quantity) AS total_spent
    FROM
        customers c
    JOIN
        orders o ON c.customer_id = o.customer_id
    JOIN
        order_items oi ON o.order_id = oi.order_id
    JOIN
        products p ON oi.product_id = p.product_id
    GROUP BY
        c.customer_name
) AS customer_spending
WHERE
    total_spent > (
        -- This subquery calculates the overall average spending across all customers
        SELECT AVG(total_spent)
        FROM (
            SELECT
                c.customer_name,
                SUM(p.price * oi.quantity) AS total_spent
            FROM
                customers c
            JOIN
                orders o ON c.customer_id = o.customer_id
            JOIN
                order_items oi ON o.order_id = oi.order_id
            JOIN
                products p ON oi.product_id = p.product_id
            GROUP BY
                c.customer_name
        ) AS avg_calculation
    );
