#use the sakila database
use sakila;

#1a: display first and last name of all actors
SELECT * FROM actor;

#1b: display first and last name in single column called Actor Name
SELECT concat(first_name, " ", last_name) AS `Actor Name`
FROM actor;

#2a: ID, first and last name of actor named "Joe"
SELECT * FROM actor WHERE first_name = "Joe";

#2b: all actors whose last name contains "GEN"
SELECT * FROM actor WHERE last_name LIKE '%gen%';

#2c: all actors whose last name contains "LI", ordered by last name, first name
SELECT last_name, first_name FROM actor WHERE last_name LIKE "%li%"
ORDER BY Last_name;

#2d: display country id and country for list of countries
SELECT * FROM sakila.country;
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan' , 'Bangladesh' , 'China');

##3a. You want to keep a description of each actor. 
SELECT * FROM actor;
ALTER TABLE Actor
ADD description BLOB;

##3b. Delete the description column.
ALTER TABLE Actor
DROP COLUMN description;

##4a. List the last names of actors, as well as how many actors have that last name.
SELECT COUNT(actor_id), last_name
FROM actor
GROUP BY last_name;

##4b. List last names of actors and the number of actors 
SELECT COUNT(actor_ID), last_name
FROM actor
GROUP BY last_name
HAVING COUNT(actor_ID) >= 2;

##4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS.
UPDATE actor 
SET first_name = 'HARPO'
WHERE actor_ID = 172;

##4d.the first name of the actor is currently HARPO, change it to GROUCHO.   
 UPDATE actor
 SET first_name = 'GROUCHO'
WHERE actor_ID = 172;

##5a. You cannot locate the schema of the address table
Show create table address; 

##6a. Use JOIN to display the first and last names, as well as the address, of each staff member. 
SELECT staff.first_name, staff.last_name, address.address
FROM staff
JOIN address ON staff.address_ID=address.address_ID;

##6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. 
SELECT staff.first_name, staff.last_name, SUM(payment.amount) as "Total Payment"
FROM staff
JOIN payment using (staff_ID)
WHERE payment_date BETWEEN "2005-08-01" AND "2005-08-31"
GROUP BY staff_ID;

##6c. List each film and the number of actors who are listed for that film
SELECT film.title, COUNT(*) actor_ID
FROM film
JOIN film_actor using (film_ID)
GROUP BY film_ID;

##6d. How many copies of the film Hunchback Impossible exis
SELECT title, COUNT(*) inventory_ID
FROM inventory
JOIN film using (film_ID)
WHERE title ='Hunchback Impossible';

##6e. Using the tables payment and customer and the JOIN
SELECT first_name, last_name, COUNT(amount) as 'Total Amount'
FROM customer
JOIN payment using (customer_ID)
GROUP BY customer_ID
ORDER BY last_name ASC;

##7a. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
SELECT title
FROM film 
WHERE language_ID IN (SELECT language_ID
FROM language WHERE name = 'English')
AND title LIKE "Q%" OR title LIKE "K%";

##7b. Use subqueries to display all actors who appear in the film Alone Trip
SELECT first_name, last_name
FROM actor
WHERE actor_id IN
(
 SELECT actor_id
FROM film_actor
WHERE film_id IN
(
 SELECT film_id
 FROM film
 WHERE title = 'Alone Trip'));
  
  ##7c.the names and email addresses of all Canadian customers.
  SELECT first_name, last_name, email, country
  FROM customer
  JOIN address using (address_ID)
  JOIN city using (city_ID)
  JOIN country using (country_ID)
  WHERE country = 'Canada';
  
##7d. Identify all movies categorized as family films.
  SELECT title, name
  FROM category
  JOIN film_category using (category_ID)
  JOIN film using (film_ID)
  WHERE name = 'family';

##7e. Display the most frequently rented movies in descending order.
SELECT title, COUNT(rental_date) as rentals
FROM film
JOIN inventory using (film_ID)
JOIN rental using (inventory_ID)
GROUP by title
ORDER BY rentals DESC;

##7f. Write a query to display how much business, in dollars, each store brought in.
SELECT store_ID, COUNT(amount) AS 'Dollar Amount'
FROM store
JOIN staff using (store_ID)
JOIN payment using (staff_ID)
GROUP BY store_ID
ORDER BY 'Dollar Amount';

##7g. Write a query to display for each store its store ID, city, and country
SELECT store_ID, city, country
FROM store
JOIN address using (address_ID)
JOIN city using (city_ID)
JOIN country using (country_ID)
GROUP BY store_ID
ORDER BY city AND country;

##7h. List the top five genres in gross revenue in descending order.
SELECT name AS 'Genre', SUM(amount) AS 'Gross Revenue'
FROM category
JOIN film_category using (category_ID)
JOIN inventory using (film_ID)
JOIN rental using (inventory_ID)
JOIN payment using (rental_ID)
GROUP BY name
ORDER BY amount DESC;

##8a.create a view.
CREATE VIEW top_five_genres (name, revenue) AS
SELECT name AS 'Genre', SUM(amount) AS 'Gross Revenue'
FROM category
JOIN film_category using (category_ID)
JOIN inventory using (film_ID)
JOIN rental using (inventory_ID)
JOIN payment using (rental_ID)
GROUP BY name
ORDER BY amount DESC;

##8b. Display the view
SHOW CREATE VIEW `top_five_genres`;

##8c.Write a query to delete it.
DROP VIEW `top_five_genres`;
