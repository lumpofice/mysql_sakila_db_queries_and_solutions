/*----------------------------------------------------------------
------------------------------------------------------------------
------------------------------------------------------------------
------------------------------------------------------------------
-------------------------------------SAKILA DATABASE--------------
--------------------------------------MySQL code------------------
------------------------------------------------------------------
------------------------------------------------------------------
----------------------------------------------------------------*/

/*1) result set: customer_id, num_action_rentals, category = 'ACTION';
We retrive the customer_id and the number rentals such that 'ACTION' is 
the category type for each rental.
------------code------------------*/
SELECT r.customer_id AS customer_id, 
    count(r.rental_id) AS num_action_rentals, 
    ca.name AS cat_type 
FROM rental AS r
INNER JOIN inventory AS i 
ON r.inventory_id = i.inventory_id 
INNER JOIN film_category AS fc 
ON i.film_id = fc.film_id 
INNER JOIN category AS ca 
ON fc.category_id = ca.category_id 
WHERE ca.name = 'ACTION' 
GROUP BY r.customer_id;

/*2) result set: film title, category name, number of films in each 
category; 
We retrieve the title of each film, the category of that film, and 
the number of films in each category. 
-----------code-----------------*/
SELECT f.title, 
    c.name, 
    count.count_of_category 
FROM film AS f 
INNER JOIN film_category AS fc 
ON f.film_id = fc.film_id 
INNER JOIN category AS c 
ON fc.category_id = c.category_id 
INNER JOIN (
    SELECT count(*) AS count_of_category, 
        category_id 
    FROM film_category 
    GROUP BY category_id
    ) AS count 
ON c.category_id = count.category_id;

/*3) result set: avg_payment_amount, customer_first_name, 
customer_last_name; 
We retrieve average payment for each customer, as well as each 
customer's name.
------------code----------------*/
SELECT avg(p.amount) AS avg_payment_amount, 
    c.first_name, 
    c.last_name 
FROM customer AS c 
INNER JOIN payment AS p 
ON c.customer_id = p.customer_id 
GROUP BY c.customer_id;

/*4) result set: payment amount, customer id, average payment per 
customer; 
We retrieve each amount paid by the customer,the customer's id, and 
the average amount paid by this customer over the lifetime of their 
active membership.
----------code-----------------*/
SELECT p.amount, 
    c.customer_id, 
    averag.cust_averag 
FROM payment AS p 
INNER JOIN customer AS c 
ON p.customer_id = c.customer_id 
INNER JOIN (
    SELECT avg(amount) AS cust_averag, 
        customer_id 
    FROM payment 
    GROUP BY customer_id
    ) AS averag 
ON c.customer_id = averag.customer_id;

/*5) result set: for each customer, a list of payment amounts such 
that each payment amount is greater than average payment for the 
customer, each customer's id, average payment of each customer; 
We retrieve each amount paid by the customer, on condition that the 
amount is greater than the customer's average, we retrieve the 
customer's id, and we retrieve the average amount paid by the customer 
over the lifetime of their active membership.
-------------code--------------*/
SELECT p.amount, 
    c.customer_id, 
    averag.cust_averag 
FROM payment AS p 
INNER JOIN customer AS c 
ON p.customer_id = c.customer_id 
INNER JOIN (
    SELECT avg(amount) AS cust_averag, 
        customer_id 
    FROM payment 
    GROUP BY customer_id
    ) AS averag 
ON c.customer_id = averag.customer_id 
WHERE p.amount > averag.cust_averag;

/*6) result set: payment amount, payment classificaton (high vs. low); 
We retrieve the amount for each payment, and we retrieve a column that 
classifies each payment as 'high' or 'low', depending on the 
condition(s) we set on the payment attribute.
-----------code----------------*/
SELECT p.amount AS payment_amount, 
    CASE WHEN p.amount > 6.00 
        THEN 'high' 
        ELSE 'low' 
        END AS transaction_type 
FROM payment AS p;

/*7) result set: the number of films under the category containing the 
maximum; 
We retrieve the number of films contained within the category holding 
the maximum among all categories.
----------code-----------------*/
SELECT max(the_max.cat_count) AS max_num_films_by_category 
FROM (
    SELECT count(category_id) AS cat_count, 
        category_id 
    FROM film_category 
    GROUP BY category_id
    ) AS the_max;

/*8) result set: the number of films under the category containing the 
maximum, 
as well as the name of the category containing the maximum; We retrieve 
the number of films contained within the category holding the maximum 
among all categories, and we retrieve the name of that category.
----------code-----------------*/
SELECT max(the_max.cat_count) AS num_films, 
    c.name AS category_with_greatest_num_films 
FROM category AS c 
INNER JOIN (
    SELECT count(category_id) AS cat_count, 
        category_id 
    FROM film_category 
    GROUP BY category_id
    ) AS the_max 
ON c.category_id = the_max.category_id;




