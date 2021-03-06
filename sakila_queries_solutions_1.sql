------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------SAKILA DATABASE---------------------------
--------------------------------MySQL code------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------




--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--1) QUERY: For all customers, retrive the customer_id and the number of 
--rentals for that customer such that 'ACTION' is the category type for 
--the rental. Also, retrieve a third column listing the category type
--'ACTION' for each row produced by the above queries.

--BABY STEP 1: For each customer, retrieve the customer_id and the 
--number of rentals for that customer.
------------baby step 1 code------------------
SELECT customer_id, 
    count(rental_id) AS num_rentals 
FROM rental 
GROUP BY customer_id;

--BABY STEP 2: For each customer, retrieve the customer_id and the 
--number of rentals for that customer such that 'ACTION' is the category
--type for the rental.
------------baby step 2 code------------------
SELECT r.customer_id AS customer_id, 
    count(r.rental_id) AS num_action_rentals 
FROM rental AS r 
INNER JOIN inventory AS i 
ON r.inventory_id = i.inventory_id 
INNER JOIN film_category AS fc 
ON i.film_id = fc.film_id 
INNER JOIN category AS ca 
ON fc.category_id = ca.category_id 
WHERE ca.name = 'ACTION' 
GROUP BY r.customer_id;

--------------query code------------------
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
--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^COMPLETE




--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--2) QUERY: For each film, retrieve the film title and category name
--to which that film corresponds. 
--Also, create a column such that, for each row containing category name 
--i, this additional column contains the number of films in category i. 

--BABY STEP 1: For each film, retrieve the film title and category name
--to which that film corresponds.
------------baby step 1 code------------------
SELECT f.title AS film_title, 
    c.name AS cat_name 
FROM film AS f 
INNER JOIN film_category AS fc 
ON f.film_id = fc.film_id 
INNER JOIN category AS c 
ON fc.category_id = c.category_id;

--BABY STEP 2: For each category name, retrieve the count of film 
--titles in that category and the category name.
------------baby step 2 code------------------
SELECT c.name AS cat_name, 
    count(fc.category_id) AS num_films_in_cat 
FROM film_category AS fc 
INNER JOIN category AS c 
ON fc.category_id = c.category_id 
GROUP BY fc.category_id;

-----------query code-----------------
SELECT f.title AS film_title, 
    c.name AS cat_name, 
    count.count_of_category AS num_films_in_cat 
FROM film AS f 
INNER JOIN film_category AS fc 
ON f.film_id = fc.film_id 
INNER JOIN category AS c 
ON fc.category_id = c.category_id 
INNER JOIN (
    SELECT count(category_id) AS count_of_category, 
        category_id 
    FROM film_category 
    GROUP BY category_id
    ) AS count 
ON c.category_id = count.category_id;
--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^COMPLETE




--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--3) QUERY: For each customer, retrieve the average payment amount, 
--as well as their full name.  
------------query code----------------
SELECT concat(c.first_name, " ", c.last_name) AS customer_name, 
    avg(p.amount) AS average_payment_amount 
FROM customer AS c 
INNER JOIN payment AS p 
ON c.customer_id = p.customer_id 
GROUP BY p.customer_id;
--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^COMPLETE




--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--4) QUERY: For each customer, we retrieve the amount paid at each
--transaction. We retrieve two additional columns, one containing the
--customer's id, the other containing the average amount paid by the 
--customer over the life of their account. In these two additional
--columns, the customer_id and the avgerage payment must correspond to
--every row containing a transaction from that customer.

--OBSERVATION: See Jupyter file query4.ipynb to see the note about 
--customer_id order and how to find a specific customer in the pandas
--DataFrame created with the python script. 

--BABY STEP 1: For each customer, retrieve the amount paid at each
--transaction. Also, retrieve an additional column containing the
--customer's id, such that the customer_id corresponds to every row
--containing a transaction from that customer.
------------baby step 1 code------------------
SELECT p.amount AS amount_per_transaction, 
    c.customer_id AS customer_id 
FROM payment AS p 
INNER JOIN customer AS c 
ON p.customer_id = c.customer_id;

-----------query code-----------------
SELECT p.amount AS amount_per_transaction, 
    c.customer_id AS customer_id, 
    cust_avg_table.avg AS cust_avg_payment 
FROM payment AS p 
INNER JOIN customer AS c 
ON p.customer_id = c.customer_id 
INNER JOIN (
    SELECT avg(amount) AS avg, 
        customer_id 
    FROM payment 
    GROUP BY customer_id
    ) AS cust_avg_table 
ON p.customer_id = cust_avg_table.customer_id;
--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^COMPLETE




--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--5) QUERY: From each customer, we retrieve all payment amount rows
--that exceed their average payment. We retrieve two additional columns, 
--one containing the customer's id, the other containing the average 
--amount paid by the customer over the life of their account. 
--In these two additional columns, the customer_id and the avgerage 
--payment must correspond to every row containing a transaction from 
--that customer.

--OBSERVATION: See Jupyter file query5.ipynb to see the note about 
--customer_id order and how to find a specific customer in the pandas
--DataFrame created with the python script. 

--BABY STEP 1: For each customer, retrieve the amount paid at each
--transaction greater than that customer's average payment amount. 
--Also, retrieve an additional column containing the
--customer's id, such that the customer_id corresponds to every row
--containing a transaction from that customer.
------------baby step 1 code------------------
SELECT p.amount AS amount_above_avg, 
    c.customer_id AS cust_id 
FROM payment AS p 
INNER JOIN customer AS c 
ON p.customer_id = c.customer_id 
INNER JOIN (
    SELECT avg(amount) AS cust_avg, 
        customer_id 
    FROM payment 
    GROUP BY customer_id
    ) AS cust_amount 
ON p.customer_id = cust_amount.customer_id 
WHERE p.amount > cust_amount.cust_avg; 

-----------query code-----------------
SELECT p.amount AS amount_above_avg, 
    c.customer_id AS cust_id, 
    cust_amount.cust_avg AS avg_per_customer 
FROM payment AS p 
INNER JOIN customer AS c 
ON p.customer_id = c.customer_id 
INNER JOIN (
    SELECT avg(amount) AS cust_avg, 
        customer_id 
    FROM payment 
    GROUP BY customer_id
    ) AS cust_amount 
ON p.customer_id = cust_amount.customer_id 
WHERE p.amount > cust_amount.cust_avg;
--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^COMPLETE




--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--6) QUERY: For each customer, we retrieve all transaction amounts in 
--one column, transaction classification (low vs. high) in a second 
--column, and the customer id corresponding to each transaction in a 
--third column. 

--OBSERVATION: See Jupyter file query6.ipynb to see the note about 
--customer_id order and how to find a specific customer in the pandas
--DataFrame created with the python script. 

--BABY STEP 1: For each customer, we retrieve all transaction amounts 
--in one column and transaction classification (low vs. high) in a 
--second column.
------------baby step 1 code------------------
SELECT p.amount AS transaction_amount, 
    CASE 
        WHEN p.amount > 8.00 
        THEN "high" 
        ELSE "low" 
        END AS pay_class 
FROM payment AS p;

-----------query code-----------------
SELECT c.customer_id AS cust_id, 
    p.amount AS transaction_amount, 
    CASE 
        WHEN p.amount > 8.00 
        THEN "high" 
        ELSE "low" 
        END AS pay_class 
FROM payment AS p 
INNER JOIN customer AS c 
ON p.customer_id = c.customer_id;
--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^COMPLETE




--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--7) QUERY: We retrieve the number of films contained within the 
--category, among all categories, holding the maximum number of films. 
--Additionally, we retrieve a column listing that category name, such 
--that the category name appears along the same row containing that 
--category's number of films.
 
--BABY STEP 1: We retrieve the number of films contained within each 
--category. Additionally, we retrieve a column listing that category 
--name, such that the category name appears along the same row 
--containing that category's number of films.
------------baby step 1 code------------------
SELECT count(fc.category_id) AS cat_count, 
    cat.name AS cat_name
FROM film_category AS fc 
INNER JOIN category AS cat 
ON fc.category_id = cat.category_id 
GROUP BY fc.category_id;

--OBSERVATION: Rendering the csv file for the query was tricky. With 
--LIMIT 0, 1, the INTO OUTFILE csv returned only the column names from
--the statement antecedant to the UNION ALL clause. With LIMIT 0, 2, the
--INTO OUTFILE csv returned the column names and the desired output 
--row, both of which will render in the terminal with LIMIT 0, 1.

----------query code-----------------
SELECT count(fc.category_id) AS cat_count, 
    cat.name AS cat_name 
FROM film_category AS fc 
INNER JOIN category AS cat 
ON fc.category_id = cat.category_id 
GROUP BY fc.category_id 
ORDER BY 1 DESC 
LIMIT 0, 1;
--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^COMPLETE




--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--8) QUERY: We retrieve the title, full name of the actors, and 
--the category name for each film.
----------query code-----------------
SELECT f.title AS film_title, 
    concat(a.first_name, " ", a.last_name) AS actor_name, 
    c.name AS cat_name 
FROM actor AS a 
INNER JOIN film_actor AS fa 
ON a.actor_id = fa.actor_id 
INNER JOIN film AS f 
ON fa.film_id = f.film_id 
INNER JOIN film_category AS fc 
ON f.film_id = fc.film_id 
INNER JOIN category AS c 
ON fc.category_id = c.category_id; 

--OBSERVATION: Above we found a single path from one table to the next, 
--leading us from one variable to one variable. Below, we will find 
--two paths from the film_actor table, leading us to two different 
--variables, film_id in the film table and film_id in the 
--film_category table.

----------alternative query code-----------------
SELECT f.title AS film_title, 
    concat(a.first_name, " ", a.last_name) AS actor_name, 
    cat.name AS cat_name 
FROM film AS f 
INNER JOIN film_actor AS fa 
ON f.film_id = fa.film_id 
INNER JOIN actor AS a 
ON fa.actor_id = a.actor_id 
INNER JOIN film_category AS fc 
ON fa.film_id = fc.film_id 
INNER JOIN category AS cat 
ON fc.category_id = cat.category_id; 
--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^COMPLETE




--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--9) QUERY: Retrieve all the film titles that are in the title column
--of the film table but not in the title column of the film_list table.
----------query code-----------------
SELECT f.title AS missing_titles 
FROM film AS f 
WHERE f.title NOT IN (
    SELECT fl.title 
    FROM film_list AS fl
    );
    
--OBSERVATION: We can further support our above query by showing 
--none of the three listed films from the above query belong to the set 
--of results from a query in search of, within the title column of the 
--film_list table, titles within a set consisting of those three film 
--titles and a fourth, different from the other three, film title.

----------supporting query code-----------------
SELECT title AS retrieved_titles 
FROM film_list 
WHERE title 
    REGEXP 'DRUMLINE CYCLONE|FLIGHT LIES|SLACKER LIAISONS|NUTS TIES';
--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^COMPLETE




--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--10) QUERY: We retrieve the number of distinct last names of actors 
--from the actor table.
----------query code-----------------
SELECT count(last_names.distincts) AS distinct_last_names 
FROM (
    SELECT DISTINCT last_name AS distincts 
    FROM actor
    ) AS last_names;
--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^COMPLETE




--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--11) QUERY: We retrieve the categories for those three movies that
--exist within the title column of the film table and not in the title
--column of the film_list table. However, we must not assume that we 
--have the names of these films prior to our query.
----------query code-----------------
SELECT f.title AS movie_title, 
    cat.name AS movie_category 
FROM film AS f 
INNER JOIN film_category AS fc 
ON f.film_id = fc.film_id 
INNER JOIN category AS cat 
ON fc.category_id = cat.category_id 
WHERE f.title NOT IN (
    SELECT title 
    FROM film_list);
--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^COMPLETE




--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--12) QUERY: Use two different approaches to find the total number of 
--films in the union of all films from both the 'Documentary' and 
--'Horror' categories.
----------query code 1-----------------
SELECT count(title) + (
    SELECT count(title) 
    FROM film_list 
    WHERE category = 'Documentary'
    ) AS total_num_films_in_horror_and_documentary 
FROM film_list 
WHERE category = 'Horror';

----------query code 2-----------------
SELECT count(title) + (
    SELECT count(f.title) 
    FROM film AS f 
    INNER JOIN film_category AS fc 
    ON f.film_id = fc.film_id 
    INNER JOIN category AS cat 
    ON fc.category_id = cat.category_id 
    WHERE cat.name = 'Documentary'
    ) AS total_num_films_in_horror_and_documentary 
FROM film_list 
WHERE category = 'Horror';
--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^COMPLETE




--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--13) QUERY: We retrieve the first and last name of each actor whose 
--name appears no more than once in the concatenated column. 
--Additionally, we retrieve a column displaying in each row the 
--number of times the first and last name appear together within the 
--concatenated column. 

--OBSERVATION: SUSAN DAVIS' name appears more than once
----------observation code-----------------
SELECT concat(first_name, " ", last_name) AS actor_name, 
    count(concat(first_name, " ", last_name)) 
        AS num_appearances_of_actor_name 
FROM actor 
GROUP BY concat(first_name, " ", last_name) 
HAVING count(concat(first_name, " ", last_name)) >= 2;

----------query code-----------------
SELECT concat(first_name, " ", last_name) AS actor_name, 
    count(concat(first_name, " ", last_name)) 
        AS num_appearances_of_actor_name 
FROM actor 
GROUP BY concat(first_name, " ", last_name) 
HAVING count(concat(first_name, " ", last_name)) < 2;
--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^COMPLETE




--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--14) QUERY: We retrieve the maximum number of apearances for the last 
--name, among all of those last names appearing more than once, and 
--we retrieve the last name appearing the maximum number of times.

--OBSERVATION: Rendering the csv file for the query was tricky. With 
--LIMIT 0, 1, the INTO OUTFILE csv returned only the column names from
--the statement antecedant to the UNION ALL clause. With LIMIT 0, 2, the
--INTO OUTFILE csv returned the column names and the desired output 
--row, both of which will render in the terminal with LIMIT 0, 1.

----------query code-----------------
SELECT count(last_name) AS the_counts, 
    last_name AS actor_last_name 
FROM actor 
GROUP BY last_name 
HAVING count(last_name) > 1 
ORDER BY the_counts DESC 
LIMIT 0, 1;
--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^COMPLETE




--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--15) QUERY: We retrieve the maximum, among all numbers
--corresponding to the qauntity of films in which an actor has appeared, 
--and we retrieve the name of the actor with the maximum number of 
--film appearances. 

--OBSERVATION: Rendering the csv file for the query was tricky. With 
--LIMIT 0, 1, the INTO OUTFILE csv returned only the column names from
--the statement antecedant to the UNION ALL clause. With LIMIT 0, 2, the
--INTO OUTFILE csv returned the column names and the desired output 
--row, both of which will render in the terminal with LIMIT 0, 1.
 
----------query code-----------------
SELECT count(fa.film_id) AS the_count, 
    concat(a.first_name, " ", a.last_name) AS actor_name 
FROM film_actor AS fa 
INNER JOIN actor AS a 
ON fa.actor_id = a.actor_id 
GROUP BY fa.actor_id 
ORDER BY the_count DESC 
LIMIT 0, 1;
--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^COMPLETE


