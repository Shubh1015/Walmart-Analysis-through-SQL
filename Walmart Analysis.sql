create database if not exists walmartsalesdata;

create table if not exists sales(
     invoice_id varchar(30) not null primary key,
     branch varchar(5) not null,
     city varchar(30) not null,
     customer_type varchar(30) not null,
     gender varchar(10) not null,
     product_line varchar(100) not null,
     unit_price decimal (10, 2) not null,
     quantity int not null,
     VAT float (6,4) not null,
     total decimal (12,4) not null,
     date datetime not null,
     time time not null,
     payment_method  varchar(15) not null,
     cogs decimal (10,2) not null,
     gross_margin_pct float(11,9),
     gross_income decimal(12,4) not null,
     rating float (2,1)
);
     
     


-- -------------------------------------------------------------------------------------------------------
-- --------------------------- Feature Engineering -------------------------------------------------------



select
	time,
    (Case
        when `time` between "00:00:00" and "12:00:00" then "Morning"
		when `time` between "12:01:00" and "16:00:00" then "Afternoon"
        Else "Evening"
	end
	) As time_of_date
From sales;

Alter table sales add column time_of_day varchar(20);

Update sales
set time_of_day = (
	Case
		when `time` between "00:00:00" and "12:00:00" then "Morning"
		when `time` between "12:01:00" and "16:00:00" then "Afternoon"
        Else "Evening"
	end
);


-- day_name----
select
    date,
    dayname(date) as day_name 
from sales;

alter table sales add column day_name varchar(10);

update sales
set day_name = dayname(date);

-- ---- month_name----

select
    date,
    monthname(date) as month_name
from sales;

Alter table sales add column month_name varchar(10);

update sales
set month_name = monthname(date);

-- ----------------------------------------------------------------------------------------------------------------

-- ------------------------------------------------------- Generic Questions----------------------------------------------
-- ------------------------- how many unique cities does the data have?------------------------------------------------------

select
   distinct city
from sales;

-- ------- in which city is each branch?----

select
   distinct city,
   branch
from sales;


-- ----------------------------- product questions---------------------------------
-- ----------------------- how many unique product lines does the data have?------------------------------

select
    distinct product_line
from sales;


select
    count(distinct product_line)
from sales;

-- -------------------------------------- what is the most common payment method----------

select
     payment_method,
     count(payment_method) as cnt
from sales
group by payment_method
order by cnt desc;

-- ------------------what is the most selling product line?---------------------

select
      product_line,
      count(product_line) cnt
from sales
group by product_line
order by cnt desc;
    
-- ------- what is the total revenue by month-------

select 
     month_name as month,
     sum(total) as total_revenue
from sales
group by month_name
order by total_revenue desc;

-- ------------------ what month had the largest cogs?-------------------------

select
   month_name as month,
   sum(cogs) as cogs
from sales
group by month_name
order by cogs desc;

-- ------------------- what product line had the largest revenue------------------------

select
    product_line,
	sum(total) as total_revenue
from sales
group by product_line
order by total_revenue desc;

-- --------------------- what is the city with the largest revenue-----------------

select 
     branch,
     city,
     sum(total) as total_revenue
from sales 
group by city, branch
order by total_revenue desc;

-- --------------  what product line had the largest VAT?------------------------

select
    product_line,
    avg(VAT) as avg_tax
from sales
group by product_line
order by avg_tax desc;

-- ------------------ which branch sold more products than average product sold?-------

select
     branch,
     sum(quantity) as qty
from sales
group by branch
having sum(quantity) > (select avg(quantity)  from sales);

-- ----------------------- what is the most common product line by gender-------------

select
     gender,
     product_line,
     count(gender) as total_cnt
from sales
group by gender, product_line 
order by total_cnt desc;

-- -------------------------------  what is the average rating of each product line---------------
select
     avg(rating) as avg_rating,
     product_line
from sales
group by product_line
order by avg_rating desc;

-- ----------------------- sales questions -------------------------------------------------
-- -------------------------- number of sales made in each time of the day per weekday------------------------

select 
	time_of_day,
    count(*) as total_sales
from sales
where day_name = "Monday"
group by time_of_day
order by total_sales desc;

-- ---------------------- which of the customer types brings the most revenue ------------------

select 
    customer_type,
    sum(total) as total_rev
from sales
group by customer_type
order by total_rev desc;

-- ------------------ ---  which city has the largest tax percent/ VAT (Value added tax)?----------------

select
     city,
     avg(VAT) as VAT
from sales
group by city
order by VAT desc;

-- --------------------- which customer type pays the most in VAT -------------------

select 
     customer_type,
     avg(VAT) as VAT
from sales
group by customer_type
order by VAT desc;


-- --------------------------customer------------------------------
-- -------------- how many unique customer types does the data have-------------------------

select
    distinct customer_type
from sales;

-- ----------------- how many unique payment methods does the data have---------------------

select 
     distinct payment_method
from sales;


-- ----------------- what is the most common customer type-----------------------------

select
     distinct customer_type
from sales;


-- -------------------which customer type buys the most-------------------------

select
     customer_type,
     count(*) as cstm_cnt
from sales
group by customer_type;


-- -------------------what is the gender of most of the customers-------------------

select
     gender,
     count(*) as gender_cnt
from sales
group by gender
order by gender_cnt desc;

-- ----------------------what is the gender distribution per branch-------------------------

select
     gender,
     count(*) as gender_cnt
from sales
where branch = "c"
group by gender
order by gender_cnt desc;

-- -------------------which time of the day do customer give most ratings---------------

select 
     time_of_day,
     avg(rating) as avg_rating
from sales
group by time_of_day
order by avg_rating;

-- ---------------------------- which time of the day customers give most ratings per branch--------------

select 
     time_of_day,
     avg(rating) as avg_rating
from sales
where branch = "c"
group by time_of_day
order by avg_rating desc;

-- -------------------------- which day of the week has the best avg ra6ings-------------------------

select
     day_name,
     avg (rating) as avg_rating
from sales
group by day_name
order by avg_rating desc;

-- - ------- per branch---------------------------------
select
     day_name,
     avg (rating) as avg_rating
from sales
where branch = "c"
group by day_name
order by avg_rating desc;








-- ---------------------- fetch each product line and add a column to those product line showing "good", "bad". good if its greater than avergae sales------



