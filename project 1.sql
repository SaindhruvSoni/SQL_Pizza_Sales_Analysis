
/* Q1--Retrieve the total number of orders placed */

select count(order_id) as count_of_orders from orders
	

/* Q2--Calculate total revenue generated generated from pizza sales */

select round(sum(p1.price*od.quantity),2)
	as Revenue from
	pizzas as p1
	join order_details as od
on p1.pizza_id=od.pizza_id
	

/* Q3--Idetify the highest priced pizza */

select pt.name,p1.price
	from pizza_types as pt 
	join pizzas as p1 
	on p1.pizza_type_id=pt.pizza_type_id 
where price=(select max(price) from pizzas) 
	

/* Q4--Identify the most common pizza size ordered */

select p1.size,count(quantity) as pizza_count
	from pizzas as p1
	join order_details as od
	on p1.pizza_id=od.pizza_id
group by p1.size


/* Q5--List top 5 most ordered pizza types along with their quantities */

select top 5 pt.name,Sum(od.quantity) as pizza_count
	from pizza_types as pt
	join pizzas as p1
	on pt.pizza_type_id=p1.pizza_type_id
	join order_details as od 
    on od.pizza_id=p1.pizza_id
group by name
order by pizza_count desc


/* Q6--Join the necessary tables to find the total quantities of each pizza ordered */

select pt.category,sum(quantity) as Quantity
	from pizza_types as pt
	join pizzas as p1
	on pt.pizza_type_id=p1.pizza_type_id
	join order_details as od
	on od.pizza_id=p1.pizza_id
 group by pt.category
 order by Quantity desc


/* Q7--Determine the distribution of orders by hours of the day */

select datepart(hour,time) as Daily_Hour,count(order_id) as Order_Count from orders group by datepart(hour,time)


/* Q8--Join relevant tables to find the category wise distribution of pizzas */

select category,count(name) as pizza_count from pizza_types group by category


/* Q9--Group the orders by the date and calculate the average number of pizzas ordered per day */

with Pizza_avg as (
select date,sum(od.quantity) as total
from orders as o1 
join order_details as od
on o1.order_id=od.order_id 
group by date
)
select avg(total) as Average from Pizza_avg


/* Q10--Determine the top 3 most ordered pizza types based on reveue */

select top 3 pt.name,round(sum(p1.price*od.quantity),2) as Revenue
	from pizza_types as pt
	join pizzas as p1 
	on pt.pizza_type_id=p1.pizza_type_id
	join order_details as od 
	on od.pizza_id=p1.pizza_id
	group by name 
order by Revenue desc


/* Q11--Calculate the percentage contribution of each pizza type to total revenue */

with auto as (
select pt.category,round(sum(p1.price*od.quantity),0) as Revenue
from pizza_types as pt
join pizzas as p1 
on pt.pizza_type_id=p1.pizza_type_id
join order_details as od
on od.pizza_id=p1.pizza_id
group by pt.category
)
select *,round(revenue/817863*100,2) as total_percent from auto order by total_percent desc


/* Q12--Analyze the cumulative revenue generated over time */

select date,Revenue,sum(revenue)
over(order by date) as Revenue from
(select o1.date,round(sum(p1.price*od.quantity),2) as Revenue
from orders as o1
join order_details as od
on o1.order_id=od.order_id
join pizzas as p1
on p1.pizza_id=od.pizza_id
group by o1.date
) as orders


/* Q13--Determine the top 3 most ordered pizza type based on revenue for each pizza category */

select name,category,Revenue,rank() over (partition by category order by revenue) as Ranking from
(select pt.name,pt.category,round(sum(p1.price*od.quantity),2) as Revenue 
from pizza_types as pt
join pizzas as p1
on pt.pizza_type_id=p1.pizza_type_id
join order_details as od
on od.pizza_id=p1.pizza_id
group by pt.category,pt.name
) pizzas
