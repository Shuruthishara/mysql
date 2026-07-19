/*
Topics Covered:

- Aggregate functions:
    COUNT
    SUM
    AVG
    MIN
    MAX
    GROUP BY
    HAVING
*/


-- Find the cheapest film rental rate.
select min(rental_rate) as "cheap_rental_rate"
from film;

-- Find the number of customers in each store.
select count(store_id)
from customer
group by store_id;

-- Find the number of actors sharing each first name.
SELECT first_name, count(*) as `no_of_actors`
from actor
group by first_name;

-- Find first names that are shared by more than one actor.
SELECT first_name, count(*) as `no_of_actors`
from actor
group by first_name
having `no_of_actors` > 1
order by `no_of_actors` DESC;

-- Find the maximum replacement cost for each rating.
select max(replacement_cost) as `max_replacement_cost`, rating
from film
group by rating;

-- Find the average film length.
select avg(length) as `average_film_length`
from film;

-- Find the total amount collected in payments.
select sum(amount)
from payment;

-- Find the total payment received by each staff member.
select sum(amount) as `total_payment_received`, staff_id
from payment
group by staff_id;

-- Find the total number of rentals made by each customer.
select count(rental_id) as `no_of_rentals`, customer_id
from rental
group by customer_id;

-- Find customers who rented more than 30 films.
select count(rental_id) as `no_of_rentals`, customer_id
from rental
group by customer_id
having no_of_rentals > 30;

-- Find the maximum film title length for each rating.
select max(length(title)) as `max_film_title_length`, rating
from film
group by rating;

-- Find categories containing more than 50 films.
select category_id, count(*) as `no_of_films`
from film_category
group by category_id
having count(*) > 50;

-- Find the five customers who spent the most money.
select customer_id, max(amount) as `max_amount_spent`
from payment
group by customer_id
order by max(amount) desc
limit 5;

-- Find the five most common actor first names.
select first_name, count(*) as `no_of_actors`
from actor
group by first_name
order by count(*) desc
limit 5;

-- Find the total revenue generated each month.
select monthname(payment_date) as `month`, sum(amount) as `total_revenue`
from payment
group by monthname(payment_date);