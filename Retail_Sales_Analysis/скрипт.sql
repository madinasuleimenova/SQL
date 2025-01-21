-- retail_sales-- SQL Retail Sales Analysis
create database retail_project;
use retail_project;
-- cretaing table
drop table if exists retail_sales;
create table retail_sales
	(
			transactions_id int primary key,
			sale_date date null,
			sale_time time null,
			customer_id int null,
			gender varchar(15) null,
			age int null,
			category varchar(15) null,
			quantity int null,
			price_per_unit float null, 
			cogs float null,
			total_sale float null
	);
    
select * from retail_sales;

select * from retail_sales
limit 10;

select count(*) from retail_sales;

-- clean
select * from retail_sales
where quantity is null;

select * from retail_sales
where transactions_id is null;

select * from retail_sales
where 
	transactions_id is null
    or
    quantity is null
    or
    sale_date is null
    or
    sale_time is null
    or
    gender is null
    or 
    age is null
    or
	category is null
    or
	customer_id is null
    or
	price_per_unit is null
    or
	cogs is null
    or
	total_sale is null;

-- clean data
delete from retail_sales
where 
		quantity is null
		or
		sale_date is null
		or
		sale_time is null
		or
		gender is null
		or 
		age is null
		or
		category is null
		or
		price_per_unit is null
		or
		cogs is null
		or
		total_sale is null;

-- Data exploration

-- How many sales do we have?
select count(*) as total_sale from retail_sales; -- 1987

-- How many customers do we have?
select count(distinct customer_id) as total_customers from retail_sales;

-- How many categories do we have?
select count(distinct category) as num_of_cat from retail_sales;
select distinct category from retail_sales;

-- Data Analysis & Business key problems & Answers

-- My Analysis $ Findings
-- Q1.Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
-- Q3.Write a SQL query to calculate the total sales (total_sale) for each category.:
-- Q4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
-- Q5.Write a SQL query to find all transactions where the total_sale is greater than 1000.:
-- Q6.Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
-- Q7.Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
-- Q8.Write a SQL query to find the top 5 customers based on the highest total sales **:
-- Q9.Write a SQL query to find the number of unique customers who purchased items from each category.:
-- Q10.Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

    
-- Q1.Write a SQL query to retrieve all columns for sales made on '2022-11-05
select * from retail_sales
where sale_date = '2022-11-05';
    
select count(*) from retail_sales
where sale_date = '2022-11-05';
    
-- Q2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:   
select * from retail_sales
where 
	category = 'Clothing'
    and 
    quantity >= 4
    and
    sale_date like '2022-11-%';
    
select transactions_id from retail_sales
where 
	category = 'Clothing'
    and
    quantity > 4
    and 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11' ;
    
-- Q2. Write an SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is mor ethan 10 in
-- the month of Nov-2022
 
 select category, 
		sum(quantity)
        from retail_sales
        where category = 'Clothing'
        group by 1;
    
-- Q3.Write a SQL query to calculate the total sales (total_sale) for each category.
select 
	category, 
    sum(total_sale) as net_sale,
    count(total_sale) as total_orders
from retail_sales
group by category;

-- Q4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
select 
	category, 
    round(avg(age), 2) as average_age_of_customers
from retail_sales
where category = 'Beauty'
group by category;

-- Q5.Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from retail_sales
where total_sale > 1000;

-- Q6.Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select category, gender, count(*) as total_trans from retail_sales
group by category, gender
order by category;

-- Q7.Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
select 
	year1,
    avg_sale,
    rank_of_sellings
from 
(
	select 
		extract(year from sale_date) as year1, 
		-- year(sale_date),
	--     month(sale_date), 
		extract(month from sale_date) as month1,
		round(avg(total_sale),2) as avg_sale,
		rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc) as rank_of_sellings
	from retail_sales
	group by month1, year1
	-- order by year1, month1;
) as t1
where rank_of_sellings = 1;

-- Q8.Write a SQL query to find the top 5 customers based on the highest total sales.
select 
	customer_id,
    sum(total_sale) as total_sales_of_cust
from retail_sales
group by customer_id
order by total_sales_of_cust desc
limit 5;

-- Q9.Write a SQL query to find the number of unique customers who purchased items from each category.:
select 
    category,
    count(distinct customer_id) as unique_customers
from retail_sales
group by category;
-- Q10.Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
with hourly_sale
as
(
	select *,
		case 
			when extract(hour from sale_time) < 12 then 'Morning'
			when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
			else 'Evening'
		end as shift
	from retail_sales
)
select 
	shift,
    count(transactions_id) as total_orders 
from hourly_sale
group by shift
order by shift;