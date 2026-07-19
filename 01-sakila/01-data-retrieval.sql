/*
Topics Covered:

- Retrieving rows
- Filtering data
- Sorting results
- Pattern matching
- NULL handling
- Aliases
- String functions
- Basic date functions
- Pagination (LIMIT / OFFSET)
*/


-- Display the full name of every actor.
select concat_ws(' ', first_name, last_name) as `Actor Name`
from actor;

-- Find all actors whose first name is NICK.
select concat_ws(' ', first_name, last_name) as 'Actor Name'
from actor
where first_name = "nick";

-- Display the first 15 actors ordered alphabetically by last name.
select lower(concat_ws(' ', first_name, last_name)) as `Actor Name`
from actor
order by last_name
limit 15;

-- Display 20 films starting from the 51st film.
select * 
from film
limit 20 offset 50;

-- Find all films rated PG-13.
select *
from film
where rating = "PG-13";

-- Find films with a rating of PG or PG-13.
select title, rating 
from film
where rating in ("PG", "PG-13");

-- Find films whose rental rate is between 2 and 4.
select *
from film
where rental_rate between 2 and 4;

-- Find films that are not rated R.
select *
from film
where rating <> "R";

-- Display all unique film ratings.
select distinct rating
from film;

-- Find customers whose first name starts with M.
select *
from customer
where first_name like "M%";

-- Find customers whose last name ends with SON.
select *
from customer
where last_name like "%son";

-- Find film titles containing the word LOVE.
select * 
from film
where title like "%love%";

-- Display customers whose email contains org.
select *
from customer
where email like "%org%";

-- Find actors whose first name contains exactly four characters.
select first_name
from actor
where first_name like "____";

-- Find all addresses where address2 is NULL.
select * 
from address
where address2 is null;

-- Display films released in 2006.
select *
from film
where release_year = "2006";

-- Display actors whose first name is either NICK, ED, or JOE.
select *
from actor
where first_name in ("nick", "ed", "joe");

-- Display films whose replacement cost is greater than 20.
select *
from film
where replacement_cost > 20;

-- Display customers ordered by last name, then first name.
select *
from customer
order by last_name, first_name;

-- Display the five longest film titles.
select *
from film
order by length(title) desc
limit 5;

-- Display films sorted by rental rate (highest first) and then title.
select *
from film
order by rental_rate desc, title asc;

-- Find customers living in district California.
select *
from customer
where address_id in (
    select address_id
    from address
    where district = "California"
);