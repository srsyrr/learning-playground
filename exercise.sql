Case 1: Mastering Aggregation with GROUP BY and HAVING
Business Goal: To identify high-performing product categories by finding which ones had a total sales quantity of more than one. This was a foundational challenge to differentiate between filtering raw data (WHERE) and filtering aggregated data (HAVING).

Key Skills: JOIN, GROUP BY, SUM(), HAVING.

SQL

-- Find product categories with a total sales quantity greater than 1
SELECT
    p.category,
    SUM(o.quantity) AS total_quantity_sold
FROM
    products p
JOIN
    orders o ON p.product_id = o.product_id
GROUP BY
    p.category
HAVING
    SUM(o.quantity) > 1;
Insight: This simple query effectively filters for categories that have significant sales activity, a crucial first step in inventory analysis.

Case 2: Navigating a Complex Schema with Multi-Table JOINs
Business Goal: To help the inventory team decide which film genres to invest in by identifying the most rented categories.

Key Skills: Navigating a normalized database by chaining five JOINs across different tables to connect a high-level concept (category) to a specific action (rental).

SQL

-- Calculate the total number of rentals per film category
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
Insight: This query produces a clear, ranked list of category popularity, providing an immediate, data-driven recommendation for the inventory team (e.g., "Invest in Sports and Animation films").

Case 3: Customer Segmentation with CASE WHEN
Business Goal: To support a new marketing loyalty program by segmenting all customers into 'High', 'Medium', and 'Low' value tiers based on their lifetime spending.

Key Skills: LEFT JOIN (to include customers with zero purchases), GROUP BY, SUM(), and CASE WHEN to create custom business logic within the query.

SQL

-- Segment all customers based on their total lifetime spending
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
Insight: This query provides a complete customer list segmented into actionable tiers, allowing the marketing team to target each group with appropriate offers.

Case 4: Multi-Step Analysis with a Subquery (Derived Table)
Business Goal: To identify and reward the top 5 most valuable customers based on their total spending.

Key Skills: Using a subquery in the FROM clause (a derived table) to perform a two-step analysis: first, calculate the total spending for all customers, and second, join that result back to the customer table to get their names and select the top 5.

SQL

-- Find the top 5 customers by total spending
SELECT
    c.first_name,
    c.last_name,
    customer_spending.total_belanja AS total_spending
FROM
    customer c
JOIN (
    -- Step 1: Calculate total spending for each customer
    SELECT
        customer_id,
        SUM(amount) AS total_belanja
    FROM payment
    GROUP BY customer_id
) AS customer_spending ON c.customer_id = customer_spending.customer_id
ORDER BY
    total_spending DESC
LIMIT 5;
Insight: This query efficiently solves a common business problem by breaking it down into logical steps, demonstrating how to handle aggregations of aggregations.

Case 5: Efficient Filtering with EXISTS
Business Goal: To create a targeted email campaign for customers who have shown interest in the 'Horror' genre.

Key Skills: Using a correlated subquery with EXISTS for a highly efficient "yes/no" check. This is more performant than a JOIN + DISTINCT for this type of problem because it stops searching as soon as it finds the first match.

SQL

-- Find all customers who have ever rented a 'Horror' film
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
Insight: This query produces a clean list of the target audience without any duplicates, demonstrating an understanding of advanced and performant SQL techniques.
