# This is a repository holding MySQL queries and their solutions for the sakila database. 

 - I provide detailed solutions that involve separate queries used for the purposes of double-checking that main queries are accurate. 

<b>sakila_queries_solutions_1.sql</b>
 - 1. QUERY: For all customers, retrive the customer_id and the number of rentals for that customer such that 'ACTION' is the category type for the rental. Also, retrieve a third column listing the category type'ACTION' for each row produced by the above queries.
 - 2. QUERY: For each film, retrieve the film title and category name to which that film corresponds. Also, create a column such that, for each row containing category name i, this additional column contains the number of films in category i.
 - 3. QUERY: For each customer, retrieve the average payment amount, as well as their full name.
 - 4. QUERY: For each customer, we retrieve the amount paid at each transaction. We retrieve two additional columns, one containing the customer's id, the other containing the average amount paid by the customer over the life of their account. In these two additional columns, the customer_id and the avgerage payment must correspond to every row containing a transaction from that customer.
 - 5. QUERY: From each customer, we retrieve all payment amount rows that exceed their average payment. We retrieve two additional columns, one containing the customer's id, the other containing the average amount paid by the customer over the life of their account. In these two additional columns, the customer_id and the avgerage payment must correspond to every row containing a transaction from that customer.
 - 6. QUERY: For each customer, we retrieve all transaction amounts in one column, transaction classification (low vs. high) in a second column, and the customer id corresponding to each transaction in a third column. 
 - 7. QUERY: We retrieve the number of films contained within the category, among all categories, holding the maximum number of films. Additionally, we retrieve a column listing that category name, such that the category name appears along the same row containing that category's number of films.
 - 8. QUERY: We retrieve the title, full name of the actors, and the category name for each film.
 - 9. QUERY: Retrieve all the film titles that are in the title column of the film table but not in the title column of the film_list table.
 - 10. QUERY: We retrieve the number of distinct last names of actors from the actor table.
 - 11. QUERY: We retrieve the categories for those three movies that exist within the title column of the film table and not in the title column of the film_list table. However, we must not assume that we have the names of these films prior to our query.
 - 12. QUERY: Use two different approaches to find the total number of films in the union of all films from both the 'Documentary' and 'Horror' categories.
 - 13. QUERY: We retrieve the first and last name of each actor whose name appears no more than once in the concatenated column. Additionally, we retrieve a column displaying in each row the number of times the first and last name appear together within the concatenated column. 
 - 14. QUERY: We retrieve the maximum number of apearances for the last name, among all of those last names appearing more than once, and we retrieve the last name appearing the maximum number of times.
 - 15. QUERY: We retrieve the maximum, among all numbers corresponding to the qauntity of films in which an actor has appeared, and we retrieve the name of the actor with the maximum number of film appearances. 

<b>sakila_queries_solutions_2.sql</b>
 - 1. QUERY: We find rental payment amount totals for each category
 - 2. QUERY: Breakdown of the average rental amount, per customer, on a monthly basis
 - 3. QUERY: Pull all film titles priced between 2 and 4 dollars, belonging to the documentary or horror categories, and having an actor named Bob
