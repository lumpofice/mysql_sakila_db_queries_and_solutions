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
--1) QUERY: We find rental payment amount totals for each category

--i) We create a temporary table with film_id and the category name
--for each film

--i_j) We must check to make sure the film table and the 
--film_category table contain an identical set of film ids.
--We require two tables for this: k) and kk) 
--------------i_j) query code------------------
--k)
SELECT 
f.film_id AS f_film_id
FROM
film AS f
WHERE
f.film_id 
NOT IN
(SELECT
fc.film_id AS fc_film_id
FROM
film_category AS fc
);
--kk)
SELECT 
fc.film_id AS fc_film_id
FROM
film_category AS fc
WHERE
fc.film_id 
NOT IN
(SELECT
f.film_id AS f_film_id
FROM
film AS f
);
--both queries returned the empty set, which allows us to use
--INNER JOIN between these two tables on this film_id column

--i_jj) We must check to make sure the film_category table and the 
--category table contain an identical set of category ids.
--We require two tables for this: k) and kk)
--------------i_jj) query code------------------
--k)
SELECT
fc.category_id AS fc_cat_id
FROM
film_category AS fc
WHERE
fc.category_id
NOT IN
(SELECT
cat.category_id AS cat_cat_is
FROM 
category AS cat
);
--kk)
SELECT
cat.category_id AS cat_cat_id
FROM
category AS cat
WHERE
cat.category_id
NOT IN
(SELECT
fc.category_id AS fc_cat_is
FROM 
film_category AS fc
);
--both queries returned the empty set, which allows us to use
--INNER JOIN between these two tables on this category_id column

--------------i) query code------------------
CREATE TEMPORARY TABLE film_id_corr_category
SELECT 
f.film_id AS film_id,
cat.name AS category 
FROM 
film AS f 
INNER JOIN
film_category AS fc
ON 
f.film_id = fc.film_id
INNER JOIN
category AS cat
ON
fc.category_id = cat.category_id;

--ii) We join the temporary table created in i) above to a multi-table
--query spanning the payment, rental, and inventory tables

--ii_j) We must check to make sure the payment table and the 
--rental table contain an identical set of rental ids 
--We require two tables for this: k) and kk)
--------------ii_j) query code------------------
--k)
SELECT
pay.rental_id AS pay_rental_id
FROM
payment AS pay
WHERE
pay.rental_id
NOT IN
(SELECT
r.rental_id
FROM 
rental AS r
);
--kk)
SELECT
r.rental_id AS r_rental_id
FROM
rental AS r
WHERE
r.rental_id
NOT IN
(SELECT
pay.rental_id
FROM 
payment AS pay
);
--both queries returned the empty set, which allows us to use
--INNER JOIN between these two tables on this rental_id column

--ii_jj) We must check to make sure the rental table and the 
--inventory table contain an identical set of inventory ids 
--We require two tables for this: k) and kk)
--------------ii_jj) query code------------------
--k)
SELECT
r.inventory_id AS r_inventory_id
FROM
rental AS r
WHERE
r.inventory_id
NOT IN
(SELECT
i.inventory_id
FROM 
inventory AS i
);
--kk)
SELECT
i.inventory_id AS i_inventory_id
FROM
inventory AS i
WHERE
i.inventory_id
NOT IN
(SELECT
r.inventory_id
FROM 
rental AS r
);
--the results show that the inventory table has more rows than 
--the rental table, on the inventory_id column, which means
--it might be safer to use rental RIGHT JOIN inventory on the
--inventory_id column

--ii_jjj) We must check to make sure the inventory table and the 
--film_id_corr_category table contain an identical set of film ids 
--We require two tables for this: k) and kk)
--------------ii_jjj) query code------------------
--k)
SELECT
i.film_id AS i_film_id
FROM
inventory AS i
WHERE
i.film_id
NOT IN
(SELECT
fcc.film_id
FROM 
film_id_corr_category AS fcc
);
--kk)
SELECT
fcc.film_id AS fcc_film_id
FROM
film_id_corr_category AS fcc
WHERE
fcc.film_id
NOT IN
(SELECT
i.film_id
FROM 
inventory AS i
);
--the results show that the film_id_corr_category table has more rows
--than the inventory table, on the film_id column, which means
--it might be safer to use inventory RIGHT JOIN film_id_corr_category 
--on the film_id column

--------------ii) query code------------------
SELECT
SUM(pay.amount) AS the_sum,
fcc.category AS category
FROM 
payment AS pay
INNER JOIN
rental AS r
ON
pay.rental_id = r.rental_id
RIGHT JOIN
inventory AS i
ON
r.inventory_id = i.inventory_id
RIGHT JOIN
film_id_corr_category AS fcc
ON
i.film_id = fcc.film_id
GROUP BY 
category
ORDER BY
the_sum DESC;
--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^COMPLETE




--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--2) QUERY: Breakdown of the average rental amount, per customer, on
--a monthly basis

--i) We must check to make sure the customer table and the 
--payment table contain an identical set of customer ids 
--We require two tables for this: k) and kk)
--------------i) query code------------------
--k) 
SELECT 
c.customer_id AS c_customer_id
FROM 
customer AS c
WHERE
c.customer_id
NOT IN
(SELECT
p.customer_id
FROM 
payment AS p
); 

--kk) 
SELECT 
p.customer_id AS p_customer_id
FROM 
payment AS p
WHERE
p.customer_id
NOT IN
(SELECT
c.customer_id
FROM 
customer AS c
); 
--both queries returned the empty set, which allows us to use
--INNER JOIN between these two tables on this customer_id column

--------------2) query code------------------
SELECT 
concat(c.first_name, " ", c.last_name) AS customer_name,
p.customer_id AS customer_id,
SUM(p.amount)/COUNT(DISTINCT p.payment_id) AS average_rental_amount,
MIN(DATE(p.payment_date)) AS first_rental_of_month
FROM 
customer AS c
INNER JOIN
payment AS p
ON
c.customer_id = p.customer_id
GROUP BY
customer_id,
MONTH(payment_date)
ORDER BY
customer_id,
first_rental_of_month;
--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^COMPLETE




--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- 3) QUERY 
-- Pull all film titles priced between 2 and 4 dollars, belonging to
-- the documentary or horror categories, and having an actor named Bob

-- We first bridge the gap between rental and film tables. From there,
-- either rental or film can touch the other necessary tables:
-- payment, film_actor, film_category

-- Creating the film_rental_bridge table
CREATE TEMPORARY TABLE film_rental_bridge
SELECT
f.film_id AS film_id,
f.title AS film_title,
r.rental_id AS rental_id
FROM
inventory AS i
LEFT OUTER JOIN
rental AS r
ON 
i.inventory_id = r.inventory_id
RIGHT OUTER JOIN
film AS f
ON
i.film_id = f.film_id;

-- We have an inventory_id contained within the inventory table
-- that is not contained within the rental table
SELECT 
inventory_id 
FROM inventory 
WHERE inventory_id 
NOT IN (
SELECT inventory_id FROM rental
);

-- This inventory_id corresponds to film_id = 1;
SELECT film_id FROM inventory WHERE inventory_id = 5;

-- We have 42 rows in the film_id column of the film table
-- that are not contained in the inventory table
SELECT 
DISTINCT film_id, 
title 
FROM film 
WHERE film_id 
NOT IN (
SELECT film_id FROM inventory
);

-- We have 43 NULL rows in the film_rental_bridge. This makes sense,
-- as one row is expected to come from the one inventory row 
-- corresponding to none of the rows from the rental table and 42 rows
-- are expected to come from the 42 film rows corresponding to none of
-- the rows in the inventory table
SELECT * FROM film_rental_bridge WHERE rental_id IS NULL;

-- Additionally, there are 5 NULL entries in our payment_rental_id
-- column
SELECT 
payment_id,
rental_id
FROM 
payment
WHERE
rental_id IS NULL;

-- These entries cannot contribute to 3) QUERY, however
-- i)
SELECT * FROM payment WHERE rental_id IS NULL;

-- ii) The NULL values in the rental_id column of payment table 
-- correspond to none of the rows in the rental table. We use 
-- payment_id = 424 as an example.
 
-- j) This is a portion
-- of the row in the payment table in which payment_id = 424.
SELECT 
customer_id,
payment_id, 
rental_id
FROM 
payment
WHERE
payment_id = 424;

-- jj) This is every row in the rental table containing information
-- about customer_id = 16
SELECT
customer_id,
rental_id
FROM 
rental
WHERE 
customer_id = 16;

-- Thus, for all 5 rows in the payment table containing NULL values for
-- within the rental_id column, we are unable to connect inventory
-- data associated wth the rental table. This means we cannot obtain
-- film data for these 5 payment entries; 
SELECT 
* 
FROM 
information_schema.referential_constraints 
WHERE 
constraint_schema = 'sakila';

-- Now for 3) QUERY
SELECT
DISTINCT f.title AS film_title,
p.amount AS rental_amount,
cat.name AS category_name,
act.first_name AS actor_first_name
FROM
film AS f
INNER JOIN 
film_rental_bridge AS frb
ON
f.film_id = frb.film_id
INNER JOIN
payment AS p
ON
frb.rental_id = p.rental_id
INNER JOIN
rental AS r
ON
frb.rental_id = r.rental_id
INNER JOIN
inventory AS i
ON
r.inventory_id = i.inventory_id
INNER JOIN
film_category AS fc
ON
i.film_id = fc.film_id
INNER JOIN
category AS cat
ON
fc.category_id = cat.category_id
INNER JOIN
film_actor AS fa
ON
frb.film_id = fa.film_id
INNER JOIN
actor AS act
ON
fa.actor_id = act.actor_id 
WHERE
p.amount BETWEEN 2.00 AND 4.00
AND 
cat.name IN ('DOCUMENTARY', 'HORROR')
AND
act.first_name = 'BOB';
--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^COMPLETE
