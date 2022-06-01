/*----------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------SAKILA DATABASE---------------------------
--------------------------------MySQL code------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
----------------------------------------------------------------------*/




/*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
1) QUERY: For all customers, retrive the customer_id and the number of 
rentals for that customer such that 'ACTION' is the category type for 
the rental. Also, retrieve a third column listing the category type
'ACTION' for each row produced by the above queries.

BABY STEP 1: For each customer, retrieve the customer_id and the number
of rentals for that customer.
------------baby step 1 code------------------*/
SELECT customer_id, 
    count(rental_id) AS num_rentals 
FROM rental 
GROUP BY customer_id;

/*BABY STEP 2: For each customer, retrieve the customer_id and the 
number of rentals for that customer such that 'ACTION' is the category
type for the rental.
------------baby step 2 code------------------*/
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

/*------------query code------------------*/
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
/*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^COMPLETE*/




/*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
2) QUERY: For each film, retrieve the film title and category name
to which that film corresponds. 
Also, create a column such that, for each row containing category name 
i, this additional column contains the number of films in category i; 

BABY STEP 1: For each film, retrieve the film title and category name
to which that film corresponds.
------------baby step 1 code------------------*/
SELECT f.title AS film_title, 
    c.name AS cat_name 
FROM film AS f 
INNER JOIN film_category AS fc 
ON f.film_id = fc.film_id 
INNER JOIN category AS c 
ON fc.category_id = c.category_id;

/*BABY STEP 2: For each category name, retrieve the count of film 
titles in that category and the category name.
------------baby step 2 code------------------*/
SELECT c.name AS cat_name, 
    count(fc.category_id) AS num_films_in_cat 
FROM film_category AS fc 
INNER JOIN category AS c 
ON fc.category_id = c.category_id 
GROUP BY fc.category_id;

/*-----------query code-----------------*/
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
/*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^COMPLETE*/




/*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
3) QUERY: For each customer, retrieve the average payment amount, 
as well as their full name.  
------------query code----------------*/
SELECT concat(c.first_name, " ", c.last_name) AS customer_name, 
    avg(p.amount) AS average_payment_amount 
FROM customer AS c 
INNER JOIN payment AS p 
ON c.customer_id = p.customer_id 
GROUP BY p.customer_id;
/*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^COMPLETE*/




/*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
4) QUERY: For each customer, we retrieve the amount paid at each
transaction. We retrieve two additional columns, one containing the
customer's id, the other containing the average amount paid by the 
customer over the life of their account. In these two additional
columns, the customer_id and the avgerage payment must correspond to
every row containing a transaction from that customer.

OBSERVATION: See Jupyter file query4.ipynb to see the note about 
customer_id order and how to find a specific customer in the pandas
DataFrame created with the python script. 

BABY STEP 1: For each customer, retrieve the amount paid at each
transaction. Also, retrieve an additional column containing the
customer's id, such that the customer_id corresponds to every row
containing a transaction from that customer.
------------baby step 1 code------------------*/
SELECT p.amount AS amount_per_transaction, 
    c.customer_id AS customer_id 
FROM payment AS p 
INNER JOIN customer AS c 
ON p.customer_id = c.customer_id;

/*-----------query code-----------------*/
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
/*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^COMPLETE*/




/*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
5) QUERY: From each customer, we retrieve all payment amount rows
that exceed their average payment. We retrieve two additional columns, 
one containing the customer's id, the other containing the average 
amount paid by the customer over the life of their account. 
In these two additional columns, the customer_id and the avgerage 
payment must correspond to every row containing a transaction from 
that customer.

OBSERVATION: See Jupyter file query5.ipynb to see the note about 
customer_id order and how to find a specific customer in the pandas
DataFrame created with the python script. 

BABY STEP 1: For each customer, retrieve the amount paid at each
transaction greater than that customer's average payment amount. 
Also, retrieve an additional column containing the
customer's id, such that the customer_id corresponds to every row
containing a transaction from that customer.
------------baby step 1 code------------------*/
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

/*-----------query code-----------------*/
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
/*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^COMPLETE*/




/*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
6) QUERY: For each customer, we retrieve all transaction amounts in one
column, transaction classification (low vs. high) in a second column,
and the customer id corresponding to each transaction in a third 
column. 

OBSERVATION: See Jupyter file query6.ipynb to see the note about 
customer_id order and how to find a specific customer in the pandas
DataFrame created with the python script. 

BABY STEP 1: For each customer, we retrieve all transaction amounts 
in one column and transaction classification (low vs. high) in a 
second column.
------------baby step 1 code------------------*/
SELECT p.amount AS transaction_amount, 
    CASE 
        WHEN p.amount > 8.00 
        THEN "high" 
        ELSE "low" 
        END AS pay_class 
FROM payment AS p;

/*-----------query code-----------------*/
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
/*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^COMPLETE*/




/*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
7) QUERY: We retrieve the number of films contained within the category, 
among all categories, holding the maximum number of films. 
Additionally, we retrieve a column listing that category name, such 
that the category name appears along the same row containing that 
category's number of films.
 
BABY STEP 1: We retrieve the number of films contained within each 
category. Additionally, we retrieve a column listing that category name, 
such that the category name appears along the same row containing that 
category's number of films.
------------baby step 1 code------------------*/
SELECT count(fc.category_id) AS cat_count, 
    cat.name AS cat_name
FROM film_category AS fc 
INNER JOIN category AS cat 
ON fc.category_id = cat.category_id 
GROUP BY fc.category_id;

/* OBSERVATION: Rendering the csv file for the query was tricky. With 
LIMIT 0, 1, the INTO OUTFILE csv returned only the column names from
the statement antecedant to the UNION ALL clause. With LIMIT 0, 2, the
INTO OUTFILE csv returned the column names and the desired output 
row, both of which will render in the terminal with LIMIT 0, 1.
----------query code-----------------*/
SELECT count(fc.category_id) AS cat_count, 
    cat.name AS cat_name 
FROM film_category AS fc 
INNER JOIN category AS cat 
ON fc.category_id = cat.category_id 
GROUP BY fc.category_id 
ORDER BY 1 DESC 
LIMIT 0, 1;
/*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^COMPLETE*/




/*8) result set: the number of films under the category containing the 
maximum, 
as well as the name of the category containing the maximum; We retrieve 
the number of films contained within the category holding the maximum 
among all categories, and we retrieve the name of that category.
----------query code-----------------*/
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

/*9) result set: film title, actor's names, category name; We retrieve
the name, actor's names, and category for each film.
----------query code-----------------*/
SELECT concat(a.first_name, " ", a.last_name) AS movie_actors, 
    f.title AS movie_title, 
    c.name AS movie_category 
FROM actor AS a 
INNER JOIN film_actor AS fa 
ON a.actor_id = fa.actor_id 
INNER JOIN film AS f 
ON fa.film_id = f.film_id 
INNER JOIN film_category AS fc 
ON f.film_id = fc.film_id 
INNER JOIN category AS c 
ON fc.category_id = c.category_id; 

/*10) result set: number of distinct last names from the actor table;
We retrieve the number of distinct last names of actors from the 
actor table.
----------query code-----------------*/
SELECT count(a.last_name) 
FROM (
    SELECT DISTINCT last_name 
    FROM actor
    ) AS a;

/*11) result set: all non-repeated names of actors. meaning, the
actor's name appears no more than once in the concatenated column; 
We retrieve the first and last name of each actor whose name appears
no more than once in the concatenated column, and we retrieve the 
number of times the first and last name appear together within the 
concatenated column. 
OBSERVATION: SUSAN DAVIS' name appears more than once
----------observation code-----------------*/
SELECT count(concat(first_name, " ",last_name)) AS name_count, 
    concat(first_name, " ", last_name) AS name 
FROM actor 
GROUP BY concat(first_name, " ", last_name) 
HAVING count(concat(first_name, " ", last_name)) > 0;
/*----------query code-----------------*/
SELECT count(concat(first_name, " ",last_name)) AS name_count, 
    concat(first_name, " ", last_name) AS name 
FROM actor 
GROUP BY concat(first_name, " ", last_name) 
HAVING count(concat(first_name, " ", last_name)) < 2;

/*12) result set: the last name of the actors whose last name 
appears at most once within the last name column, and the count of 
appearances for each of those last names;
----------query code-----------------*/
SELECT count(last_name), 
    last_name 
FROM actor 
GROUP BY last_name 
HAVING count(last_name) < 2;

/*13) result set: the last name of the actors whose last name
appears at least twice within the last name column, and the count of 
appearance for each of those last names;
----------query code-----------------*/
SELECT count(last_name), 
    last_name 
FROM actor 
GROUP BY last_name 
HAVING count(last_name) > 1;

/*14) result set: the maximum number of apearances for some last name
among all of those last names appearing more than once, and that last
name appearing the maximum number of times;
OBSERVATION: When we are order the counts on the last name column, 
we see the maximum count on the last name column is 5.
----------observation code-----------------*/
SELECT count(last_name) AS last_name_counts 
FROM actor 
GROUP BY last_name 
ORDER BY count(last_name);
/*----------query code-----------------*/
SELECT max(appearances.the_max) AS max_appearances 
FROM (
    SELECT count(last_name) AS the_max 
    FROM actor 
    GROUP BY last_name
    ) AS appearances;


/*15) result set: max count of films per actor;
OBSERVATION: When we are order the counts on the film_id column, 
we see the maximum count on the film_id column is 42.
----------observation code-----------------*/
SELECT count(film_id) 
FROM film_actor 
GROUP BY actor_id 
ORDER BY 1;
/*----------query code-----------------*/
SELECT max(roles.the_count) AS max_films_by_an_actor 
FROM (
    SELECT count(film_id) AS the_count 
    FROM film_actor 
    GROUP BY actor_id 
    ORDER BY 1
    ) AS roles;

