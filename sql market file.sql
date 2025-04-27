create database market;
use market;
select * from aisle;
select * from product;
-- 1.	What are the top 10 aisles with the highest number of products?
alter table `order` rename to orders;
select a.aisle , max(p.product_id) as products from aisle as a 
join
product as p on p.aisle_id = a.aisle_id 
group by a.aisle 
order by products desc limit 10;


-- 2.	How many unique departments are there in the dataset?
select distinct(count((department))) as departments from department;

-- 3	What is the distribution of products across departments?
 
 select d.department, count(p.product_name) as products from product as p
 join
 department as d on d.department_id = p.department_id
 group by d.department
 order by products desc limit 10;
 
 -- 4.	What are the top 10 products with the highest reorder rates?
 select * from orders;

 select p.product_name as products , max(t.reordered) as highest_order from train as t
 join
 product as p on p.product_id = t.product_id
 group by products 
 order by highest_order desc limit 10;
 
 
 
 
 SELECT 
    p.product_id,
    p.product_name,
    COUNT(CASE WHEN t.reordered = 1 THEN 1 END) * 1.0 / COUNT(*) AS reorder_rate
FROM train t
JOIN product p ON t.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY reorder_rate DESC
LIMIT 10;
 
 
  -- 5 How many unique users have placed orders in the dataset?
  
  select  count(distinct(user_id)) as users from orders ;
  
  -- What is the average number of days between orders for each user?
  select user_id,round(avg(days_since_prior_order),1) as avg_orders from orders
  group by user_id limit 10;
  
  -- What are the peak hours of order placement during the day?
  select order_hour_of_day,count(order_hour_of_day) as peak from orders
  group by order_hour_of_day
  order by peak desc limit 10;
  
 --  How does order volume vary by day of the week?
 select order_dow,count(order_dow) as volume_orders from orders
 group by order_dow
 order by volume_orders;
 
--  What are the top 10 most ordered products?
select
p. product_name as products,count(t.product_id) as  total_order from product as p
join train as t on p.product_id = t.product_id
group by products 
order by total_order desc ;

use market;
-- 10.	How many users have placed orders in each department?
select * from department;
select d.department,count(distinct o.user_id) as user_count from department as d
join product as p on p.department_id = d.department_id
join train as t on t.product_id = p.product_id
join orders as o on t.order_id = o.order_id
group by d.department
;

 -- 11.	What is the average number of products per order?
 select avg(product_count) as avg_product_per_order from (select order_id,count(product_id)  as product_count from train
 group by order_id) as tabl
;
 
-- 12.	What are the most reordered products in each department?

select d.department, p.product_name ,reordered_count 
from 
   (select d.department,p.product_name, sum(t.reordered) as reorder_count,
        rank() over (partition by d.department_id order by sum(t.reordered)) as rnk 
        from department as d
		join product as p on p.department_id = d.department_id 
        join train as t on t.product_id = p.product_id
        group by d.department,p.product_name,d.department_id) as ranked_product
        
        where rnk = 1
     order by d.department;
     
     SELECT 
    department, 
    product_name, 
    reorder_count
FROM (
    SELECT 
        d.department, 
        p.product_name,
        SUM(t.reordered) AS reorder_count,
        RANK() OVER (PARTITION BY d.department_id ORDER BY SUM(t.reordered) DESC) AS rnk
    FROM train t
    JOIN product p ON t.product_id = p.product_id
    JOIN department d ON p.department_id = d.department_id
    GROUP BY d.department_id, d.department, p.product_name
) AS ranked_products
WHERE rnk = 1
ORDER BY department;  

-- 13.	How many products have been reordered more than once?


select count(*) as no_of_products_reoreder_more_than_once
from (select product_id,sum(reordered) as total_reordered from train
group by product_id
having sum(reordered) > 1
order by total_reordered desc) as sub;


use market;
-- 14.	What is the average number of products added to the cart per order?

select * from orders ;
select avg(cart_count) as avg_no_of_pro_add_cart_per_order from
 (
select product_id,count(add_to_cart_order) as cart_count from train
group by product_id) as sub ;

-- 15.	How does the number of orders vary by hour of the day?
select * from orders;
select order_count as orders_vary_by_hour from 
(select hour(order_hour_of_day),count(order_hour_of_day) as order_count
 from orders group by order_hour_of_day) as sub limit 10;
 
 -- 16.	What is the distribution of order sizes (number of products per order)?
 select (no_of_products) as order_size,count(order_id) as frequnecy from 
 (select distinct order_id,count(product_id)
 as no_of_products from train
 group by order_id
) as sub
group by no_of_products
order by no_of_products;

-- 17.	What is the average reorder rate for products in each aisle?alter

use market ;
select products,aisle,avg(reorder_rate) as avg_rate from
(
select 
sum(case when t.reordered = 1 then 1 else 0 end) * 1.0 /count(*) as reorder_rate,
p.product_name as products,
a.aisle 
from product as p
join train as t on t.product_id = p.product_id 
join aisle as a on a.aisle_id = p.aisle_id 
group by p.product_name,a.aisle) as sub
group by products,aisle;

-- 18.	How does the average order size vary by day of the week?
select * from orders ;
select 
case  order_dow
when 0 then 'Sunday'
when 1 then 'Monday'
when 2 then 'Tuesday'
when 3 then 'Wednesday'
when 4 then 'Thursday'
when 5 then 'Friday'
when 6 then 'Saturday' end order_dow,
avg(order_number) as order_size from orders
group by order_dow
order by order_dow ;


-- 19.	What are top 10 users with the highest number of orders? 
select user_id ,
count(order_id) as highest_no_order 
from  orders
group by user_id
order by highest_no_order desc limit 10;

-- 20.	How many products belong to each aisle and department?
select  count(p.product_name) no_of_products, d.department,a.aisle from department as d 
join
product as p on p.department_id = d. department_id 
join 
aisle as a on a.aisle_id = p.aisle_id 
group by d.department,a.aisle
order by no_of_products desc ;