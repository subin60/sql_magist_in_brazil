
-- 1. How many orders are there in the dataset? 

select count(order_id) 
from orders;

-- 2.1  How many orders are delivered - 96478

select count(order_status)
from orders
where order_status = 'delivered';

-- 2.2 How many are canceled - 625

select count(order_status)
from orders
where order_status = 'canceled';
  

-- 3. Is Magist having user growth? 


SELECT DATE_FORMAT(order_purchase_timestamp, "%Y-%m") AS order_month, count(customer_id)
FROM orders
group by 
	order_month
order by 
	order_month;

SELECT DATE_FORMAT(order_purchase_timestamp, "%Y") AS order_year, count(customer_id)
FROM orders
group by 
	order_year
order by 
	order_year;
    

-- 4. How many products are there on the products table? 
select count(distinct product_id) 
from products;


-- 5. Which are the categories with the most products? 


select product_category_name , count(distinct product_id) as order_count
from products
group by product_category_name
order by order_count desc;

-- 6. How many of those products were present in actual transactions? 

select count(distinct product_id) 
from order_items;




-- 7. What’s the price for the most expensive and cheapest products?

select max(price) as max_product_price , min(price) as min_product_price
from order_items;


-- 8. What are the highest and lowest payment values? 
select max(payment_value) as max_order_payments , min(payment_value) as min_order_payments
from order_payments;



select *
from product_category_name_translation:

-- What categories of tech products does Magist have?

select DISTINCT product_category_name
from products;



-- 'audio','cds_dvds_musicals', 'cine_photo', 'consoles_games', 'dvds_blu_ray', 'electronics', 'small_appliances', 'computers_accessories','books_technical', 'pc_gamer', 'tablets_printing_image', 'telephony', 'fixed_telephony'


-- How many products of these tech categories have been sold (within the time window of the database snapshot)? What percentage does that represent from the overall number of products sold?


select count(o_i.product_id)
from order_items as o_i
left join products as p on o_i.product_id = p.product_id 
right join product_category_name_translation as p_c_n_t on p.product_category_name = p_c_n_t.product_category_name
where product_category_name_english in ('audio', 'electronics','computers', 'computers_accessories', 'pc_gamer', 'telephony');




-- What’s the average price of the products being sold?

select min(price), avg(price), max(price)
from order_items as o_i
left join products as p on o_i.product_id = p.product_id 
right join product_category_name_translation as p_c_n_t on p.product_category_name = p_c_n_t.product_category_name
where product_category_name_english in ('audio', 'electronics','computers', 'computers_accessories', 'pc_gamer', 'telephony');

-- Expensive products are not popular
-- Are expensive tech products popular? 
select count(o_i.order_id),
CASE 
when o_i.price <= 500 then 'Cheap product'
when o_i.price > 500 then 'Expensive product'
End as price_category
from order_items as o_i
left join products as p on o_i.product_id = p.product_id 
right join product_category_name_translation as p_c_n_t on p.product_category_name = p_c_n_t.product_category_name
where product_category_name_english in ('audio', 'electronics','computers', 'computers_accessories', 'pc_gamer', 'telephony')
group by price_category;

-- How many months of data are included in the magist database?


SELECT count(Distinct DATE_FORMAT(order_purchase_timestamp, "%Y-%m"))
FROM orders;

-- How many sellers are there? 

select count(distinct seller_id)
from sellers;


-- How many Tech sellers are there? 

select count(DISTINCT s.seller_id)
from order_items as o_i
left join products as p on o_i.product_id = p.product_id 
right join product_category_name_translation as p_c_n_t on p.product_category_name = p_c_n_t.product_category_name
left join sellers as s on o_i.seller_id = s.seller_id
where product_category_name_english in ('audio', 'electronics','computers', 'computers_accessories', 'pc_gamer', 'telephony');




-- What percentage of overall sellers are Tech sellers?

-- (481 / 3095) * 100 
-- 15,54%

-- What is the total amount earned by all sellers? 



select sum(payment_value)
from order_items as o_i
left join products as p on o_i.product_id = p.product_id 
right join product_category_name_translation as p_c_n_t on p.product_category_name = p_c_n_t.product_category_name
left join sellers as s on o_i.seller_id = s.seller_id
right join orders o on o.order_id = o_i.order_id
right join order_payments as o_p on o.order_id = o_p.order_id;



-- What is the total amount earned by all Tech sellers?

select sum(payment_value)
from order_items as o_i
left join products as p on o_i.product_id = p.product_id 
right join product_category_name_translation as p_c_n_t on p.product_category_name = p_c_n_t.product_category_name
left join sellers as s on o_i.seller_id = s.seller_id
right join orders o on o.order_id = o_i.order_id
right join order_payments as o_p on o.order_id = o_p.order_id
where product_category_name_english in ('audio', 'electronics','computers', 'computers_accessories', 'pc_gamer', 'telephony');



-- Can you work out the average monthly income of all sellers? 



SELECT avg(o_p.payment_value)
from order_items as o_i
left join products as p on o_i.product_id = p.product_id 
right join product_category_name_translation as p_c_n_t on p.product_category_name = p_c_n_t.product_category_name
left join sellers as s on o_i.seller_id = s.seller_id
right join orders o on o.order_id = o_i.order_id
right join order_payments as o_p on o.order_id = o_p.order_id;
-- group by (DATE_FORMAT(o.order_purchase_timestamp, "%Y-%m"));



-- Can you work out the average monthly income of Tech sellers?



SELECT avg(o_p.payment_value) as average_per_month
from order_items as o_i
left join products as p on o_i.product_id = p.product_id 
right join product_category_name_translation as p_c_n_t on p.product_category_name = p_c_n_t.product_category_name
left join sellers as s on o_i.seller_id = s.seller_id
right join orders o on o.order_id = o_i.order_id
right join order_payments as o_p on o.order_id = o_p.order_id
where product_category_name_english in ('audio', 'electronics','computers', 'computers_accessories', 'pc_gamer', 'telephony');
-- group by (DATE_FORMAT(o.order_purchase_timestamp, "%Y-%m"));


-- What’s the average time between the order being placed and the product being delivered?

select avg((TIMESTAMPDIFF(SECOND, order_purchase_timestamp, order_delivered_customer_date))/3600) AS hrs, avg((TIMESTAMPDIFF(SECOND, order_purchase_timestamp, order_delivered_customer_date))/ 24 / 3600) as days
from orders;



-- How many orders are delivered on time vs orders delivered with a delay?


select count(order_id) as delayed_order_number
from orders
where (TIMESTAMPDIFF(SECOND, order_estimated_delivery_date, order_delivered_customer_date)/3600/24) > 0;

select count(order_id) as ontime_order_number
from orders
where (TIMESTAMPDIFF(SECOND, order_estimated_delivery_date, order_delivered_customer_date)/3600/24) <= 0;


-- Is there any pattern for delayed orders, e.g. big products being delayed more often?

select product_name_length, product_description_length,  product_weight_g, product_length_cm, product_height_cm, product_width_cm
from orders as o
right join order_items as o_i on o.order_id = o_i.order_id
right join products as p on o_i.product_id = p.product_id;



select avg(product_name_length), avg(product_description_length),  avg(product_weight_g), avg(product_length_cm), avg(product_height_cm), avg(product_width_cm)
from orders as o
right join order_items as o_i on o.order_id = o_i.order_id
right join products as p on o_i.product_id = p.product_id
where (TIMESTAMPDIFF(SECOND, order_estimated_delivery_date, order_delivered_customer_date)/3600/24) <= 0;



