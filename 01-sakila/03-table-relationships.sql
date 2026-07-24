/*
Topics Covered:

- JOIN
- EXISTS
- Subqueries
- ANY
- ALL
- UNION
- Self Join
*/


-- Display each customer along with their address.
select 
    concat_ws(' ', first_name, last_name) as `customer_name`, 
    concat_ws(', ', address, district, city, postal_code) as `address`
from address
join customer
    on address.address_id = customer.address_id
join city
    on address.city_id = city.city_id;
    

-- Display each customer with their city and country.
select 
    concat_ws(' ', first_name, last_name) as `customer_name`, 
    concat_ws(', ', address, district, city, country, postal_code) as `address`
from address
join customer
    on address.address_id = customer.address_id
join city
    on address.city_id = city.city_id
join country
    on city.country_id = country.country_id;


-- Display every film with its language.
select title as `film`, name as `language`
from film
join language
    on film.language_id = language.language_id;


-- Display films along with their category.
select  f.title as `film`, c.name as `category`
from film as f
join film_category as fc
    on f.film_id = fc.film_id
join category as c
    on fc.category_id = c.category_id;


-- Display every actor and the films they appeared in.
select 
    concat_ws(' ', a.first_name, a.last_name) as `actor_name`, 
    f.title
from film_actor as fc
join actor as a
    on fc.actor_id = a.actor_id
join film as f
    on fc.film_id = f.film_id
order by `actor_name`, f.title;


-- Find every film featuring actor NICK WAHLBERG.
select 
    concat_ws(' ', a.first_name, a.last_name) as `actor_name`, 
    f.title
from film_actor as fc
join actor as a
    on fc.actor_id = a.actor_id
join film as f
    on fc.film_id = f.film_id
where a.first_name = "NICK" and a.last_name = "WAHLBERG"
order by f.title;


-- Find every actor appearing in ACADEMY DINOSAUR.
select 
    concat_ws(' ', a.first_name, a.last_name) as `actor_name`, 
    f.title
from film_actor as fc
join actor as a
    on fc.actor_id = a.actor_id
join film as f
    on fc.film_id = f.film_id
where f.title = "ACADEMY DINOSAUR"
order by `actor_name`;


-- Display customers along with every rental they made.
select 
    concat_ws(' ', c.first_name, c.last_name) as `customer_name`,
    f.title as `film`
from customer as c
join rental as r
    on c.customer_id = r.customer_id
join inventory as i
    on r.inventory_id = i.inventory_id
join film as f
    on i.film_id = f.film_id
order by `customer_name`;


-- Display payments together with customer names.
select 
    concat_ws(' ', c.first_name, c.last_name) as `customer_name`,
    sum(amount) as `total_payment`
from customer as c
join payment as p
    on p.customer_id = c.customer_id
group by p.customer_id
order by `customer_name`;


-- Display customers who never rented a film.
select 
    concat_ws(' ', first_name, last_name) as `customer_name`
from customer as c
where not exists (
    select customer_id
    from rental as r
    where r.customer_id = c.customer_id
);


-- Display films that have never been rented.
select 
    f.title as `film_not_rented`
from film as f
where not exists (
    select 1
    from rental as r
    join inventory as i
        on r.inventory_id = i.inventory_id
    where f.film_id = i.film_id
);


-- Display actors who have never appeared in any film.
select 
    concat_ws(' ', a.first_name, a.last_name) as `actor_name`
from actor as a
where not exists (
    select 1
    from film_actor as fa
    where a.actor_id = fa.actor_id
);


-- Find customers who have made at least one payment greater than $10.
select distinct
    concat_ws(' ', c.first_name, c.last_name) as `customer_name`
from customer as c
join payment as p
    on c.customer_id = p.customer_id
where p.amount > 10;

select
    concat_ws(' ', c.first_name, c.last_name) as `customer_name`
from customer as c
where customer_id = any (
    select p.customer_id
    from payment as p
    where p.amount > 10
);

select
    concat_ws(' ', c.first_name, c.last_name) as `customer_name`
from customer as c
where exists (
    select 1
    from payment as p
    where c.customer_id = p.customer_id and p.amount > 10
); 
/* All three queries produce same result */


-- Find films whose rental rate is greater than the average rental rate.
select title, rental_rate
from film
where rental_rate > (
    select avg(rental_rate)
    from film
);


-- Find films with the same rating as ACADEMY DINOSAUR.
select title, rating
from film
where rating = any (
    select rating
    from film
    where title = "ACADEMY DINOSAUR"
);


-- Find customers whose total spending is above the average customer spending.
select
    concat_ws(' ', c.first_name, c.last_name) as `customer_name`, 
    sum(p.amount) as `total_spending`
from customer as c
join payment as p
    on p.customer_id = c.customer_id
group by c.customer_id
having sum(p.amount) > (
    select avg(`total_spending`)
    from (
        select sum(amount) as `total_spending`
        from payment
        group by customer_id
    ) as `customer_spending` /* It is called derived table (subquery in the FROM clause) */
);


-- Find actors sharing the same last name.
select 
    concat_ws(' ', a1.first_name, a1.last_name) as `actor_name_01`,
    concat_ws(' ', a2.first_name, a2.last_name) as `actor_name_02`
from actor as a1
join actor as a2
    on a1.last_name = a2.last_name
where a1.first_name > a2.first_name
order by a1.first_name;


-- Find customers living in the same city.
select 
    concat_ws(' ', c1.first_name, c1.last_name) as `customer_name_01`,
    concat_ws(' ', c2.first_name, c2.last_name) as `customer_name_02`,
    ci.city as `city`
from customer as c1
join address as a1
    on c1.address_id = a1.address_id
join customer as c2
    on c1.customer_id <> c2.customer_id
join address as a2
    on c2.address_id = a2.address_id
join city as ci
    on a1.city_id = ci.city_id
where c1.customer_id < c2.customer_id and a1.city_id = a2.city_id
order by `city`;

/* Instead of giving the condition (c1.customer_id < c2.customer_id) in where clasue to avoid duplicate pairs,
you can give the condition directly in join...on as like below, which is efficient */
select 
    concat_ws(' ', c1.first_name, c1.last_name) as `customer_name_01`,
    concat_ws(' ', c2.first_name, c2.last_name) as `customer_name_02`,
    ci.city as `city`
from customer as c1
join address as a1
    on c1.address_id = a1.address_id
join customer as c2
    on c1.customer_id < c2.customer_id /*here*/
join address as a2
    on c2.address_id = a2.address_id
join city as ci
    on a1.city_id = a2.city_id
where a1.city_id = a2.city_id
order by `city`;


-- Find films whose replacement cost is greater than every film rated PG.
select title, replacement_cost
from film
where replacement_cost > (
    select max(replacement_cost)
    from film
    where rating = "PG"
);

select title, replacement_cost
from film
where replacement_cost > all (
    select replacement_cost
    from film
    where rating = "PG"
);


-- Display all films in the Action category together with every actor appearing in those films.
select 
    f.title as `film`, 
    concat_ws(' ', a.first_name, a.last_name) as `actor_name`
from film as f
join film_category as fc
    on f.film_id = fc.film_id
join category as c
    on c.category_id = fc.category_id
join film_actor as fa
    on f.film_id = fa.film_id
join actor as a
    on a.actor_id = fa.actor_id
where c.name = "action"
order by f.title;

/* Instead of returning one row per actor, grouping by the film and concatenating all actor names into a single row. 
That is, the same above result in a diff view. */
select 
    lower(f.title) as `film`, 
    group_concat(
        concat_ws(' ', lower(a.first_name), lower(a.last_name))
        order by a.first_name, a.last_name
        separator ', '
    ) as `actor_name`
from film as f
join film_category as fc
    on f.film_id = fc.film_id
join category as c
    on c.category_id = fc.category_id
join film_actor as fa
    on f.film_id = fa.film_id
join actor as a
    on a.actor_id = fa.actor_id
where c.name = "action"
group by f.film_id
order by f.title;


-- Create a single contact directory (name, mail, person-type) containing both customers and staff members.
select
    concat_ws(' ', c.first_name, c.last_name) as `name`, 
    c.email, 
    'customer' as `person_type`
from customer as c
union
select
    concat_ws(' ', s.first_name, s.last_name) as `name`, 
    s.email, 
    'staff' as `person_type`
from staff as s
order by `person_type`, `name`;


-- Display a list of film titles with no duplicates that satisfy either of the following conditions:
        -- The film belongs to the Action category.
        -- The film features the actor NICK WAHLBERG.
select f.title
from film as f
join film_category as fc
    on f.film_id = fc.film_id
join category as c
    on c.category_id = fc.category_id
where c.name = "action"
union
select f.title
from film as f
join film_actor as fa
    on fa.film_id = f.film_id
join actor as a
    on a.actor_id = fa.actor_id
where a.first_name = "NICK" and a.last_name = "WAHLBERG"
order by title;
