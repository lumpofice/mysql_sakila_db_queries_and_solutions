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
SELECT 
concat(c.first_name, " ", c.last_name) AS customer_name,
p.customer_id AS customer_id,
SUM(p.amount)/COUNT(DISTINCT p.payment_id) AS average_rental_amount,
MIN(DATE(p.payment_date)) AS first_rental_of_month
FROM 
customer AS c
LEFT JOIN
payment AS p
ON
c.customer_id = p.customer_id
GROUP BY
customer_id,
MONTH(payment_date)
ORDER BY
customer_id,
first_rental_of_month;
