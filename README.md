# Olist E-commerce Analysis Using SQL and PowerBI

## Overview

This project delves into the comprehensive dataset provided by Olist, a leading Brazilian e-commerce platform. By analyzing customer orders, product details, seller performance, reviews, geolocation, and sales metrics, we extract valuable insights into **customer behavior, product performance, and overall business trends** in the e-commerce industry. This analysis is aimed at supporting data-driven decision-making for enhanced business strategies.

## Objectives

### 1. Database Design and Data Import

The first phase involves designing and structuring the database in PostgreSQL to establish relationships among the datasets. The key tasks include

  - Creating all tables in a structured order to maintain relational integrity.
  - Selecting appropriate data types for optimized storage and performance.
  - Establishing Primary Keys and Foreign Keys to define relationships between tables.
  - Importing data in a structured sequence to maintain referential integrity.
  - Developing an Entity Relationship Diagram (ERD) to visualize table relationships

### 2. Exploratory Data Analysis (EDA) using SQL

After successful data ingestion, SQL queries are used to conduct in-depth Exploratory Data Analysis (EDA), uncovering key business insights. The major analyses include:
  - Customer and Seller Analysis
  - Delivery and Review Analysis
  - Sales and Revenue Analysis

### 3. Power BI Dashboard

The Power BI Dashboard aims to provide an interactive and visually compelling analysis of the Olist e-commerce dataset, enabling data-driven decision-making.

![overview](https://github.com/gautamnakum40/Business-Analytics-SQL-PowerBI/blob/master/Img/Overview%20dashboard.png)

![order](https://github.com/gautamnakum40/Business-Analytics-SQL-PowerBI/blob/master/Img/Order%20dashboard.png)


## Dataset

This dataset, provided by Olist, is available for download on [Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) and consists of 9 CSV files stored in the [Dataset folder](https://github.com/gautamnakum40/Business-Analytics-SQL-PowerBI/tree/master/Dataset).

The dataset contains **100K E-commerce orders** from **2016 to 2018**, spanning multiple Brazilian marketplaces. It provides a **comprehensive view of each order, covering order status, pricing, payments, freight details, customer demographics, product attributes, and customer reviews.** Additionally, a **geolocation dataset** maps Brazilian zip codes to latitude and longitude coordinates.

This dataset represents **real commercial transactions** but has been anonymized for privacy. Any references to companies and partners in the review text have been replaced with the names of **Game of Thrones great houses.**

## Tools I Used

  - **SQL**: The core of this project, used for data import, transformation, and exploratory data analysis (EDA).
    
  - **Postgresql**: The database management system ideal for handling the Olist dataset.
    
  - **Visual Studio Code (VS Code)**: The preferred Integrated Development Environment (IDE) for managing databases and executing SQL queries.
    
  - **Git & GitHub**: Used for version control, project tracking, and sharing SQL queries. Git LFS is implemented to handle large CSV files in the dataset.
    
  - **Power BI**: All data visualizations, including interactive dashboards and analytical reports, are built in Power BI to present insights effectively.

## Skills Demonstrated

  - **SQL**: Used Joins, CTEs, Subqueries, Group By, and Aggregate Functions for data analysis.
    
  - **PostgreSQL**: Designed a relational database with primary and foreign keys for data integrity.
    
  - **ETL**: Extracted data, transformed it using SQL, and loaded results into Power BI for visualization.
    
  - **Power BI**: Created interactive dashboards with area charts, bar charts, waterfall charts, heatmaps, and matrix tables.
    
  - **DAX & Time Intelligence**: Used DAX functions and calendar tables for advanced analytics.
    
  - **Git & GitHub**: Managed SQL scripts and Power BI files, using Git LFS for large datasets.
    
  - **Business Intelligence**: Analyzed customer behavior, sales trends, and seller performance for data-driven insights.
 
## Database Design and Importing Data

### Data Schema

A Star Data Schema is provided by Olist.

![Data schema](https://github.com/gautamnakum40/Business-Analytics-SQL-PowerBI/blob/master/Img/Data%20Schema.png)

I used this Data Schema to understand the dataset structure and determine the sequence for creating tables and importing data. Based on this analysis, the following sequence ensures proper relational integrity:

Geolocation → Customers/Sellers → Orders → Payments/Reviews → Product Name Translation → Products → Order Items 

'→' : indicate the sequence
'/' : indicate that either table can be created first

You can check out the SQL files for creating tables and importing Olist data in sequence from : [Setup Folder](https://github.com/gautamnakum40/Business-Analytics-SQL-PowerBI/tree/master/Setup)

### Table Creation & Data load :

#### 1. Table Olist_geolocation

This table cannot have ```zip_code_prefix``` as the primary key because there are duplicate values. A particular zip code can have multiple coordinates where orders could have been delivered. Due to this, the table cannot connect to other tables until this issue is resolved. Since it lacks a connection, I can create this table first.

```Sql

drop table if exists public.olist_geolocation;

/* create table olist_geolocation table with no primary key
 because zip code prefix has duplicate values.
Also this table cannot be joined with olist_seller or olist_customers table 
through zip code prefix because it has duplicate values */

create table public.olist_geolocation
(
    geolocation_zip_code_prefix int,
    geoloacation_lat float,
    geolocation_lng float,
    geolocation_city varchar(100),
    geolocation_state char(2)
    
);

-- import data from csv files to table :

copy public.olist_geolocation
from 'C:\Users\nakum\OneDrive\Desktop\PROJECTS\Ecommerce\Olist_Dataset\olist_geolocation_dataset.csv'
WITH (FORMAT csv, HEADER true, delimiter ',', encoding 'UTF8');
```

#### 2. Table Olist_sellers

This table has seller_id as the primary key and has 3095 values.

```sql

--drop table if already exist to ensure multiple runs and clean slate

drop table if exists public.olist_seller;

--create table Olist_seller table with primary key 

create table public.olist_seller 
(
    seller_id varchar(100) primary key,
    seller_zip_code_prefix int,
    seller_city varchar(100),
    seller_state char(2)
);

-- import data from csv files to table :

copy public.Olist_seller
from 'C:\Users\nakum\OneDrive\Desktop\PROJECTS\Ecommerce\Olist_Dataset\olist_sellers_dataset.csv'
WITH (FORMAT csv, HEADER true, delimiter ',', encoding 'UTF8');
```

#### 3. Table Olist_Customers

The primary key for this table is Customer_ID and it has 99441 values.

```sql

--drop table if already exist to ensure multiple runs and clean slate

drop table if exists public.olist_customers;

--create table olist_Customers with primary key 

create table public.olist_Customers
(
    customer_id varchar(100) primary key,
    customer_unique_id varchar(100),
    customer_zip_code_prefix int,
    customer_city varchar(100),
    customer_state char(2)
);

-- import data from csv files to table :

copy public.olist_Customers
from 'C:\Users\nakum\OneDrive\Desktop\PROJECTS\Ecommerce\Olist_Dataset\olist_customers_dataset.csv'
WITH (FORMAT csv, HEADER true, delimiter ',', encoding 'UTF8');
```

#### 4. Table Olist_Order

This table has order_id as primary key and customer_id as foreign key.

```sql
--drop table if already exist to ensure multiple runs and clean slate

drop table if EXISTS public.olist_orders;

--create table olist_orders table with primary key and foreign key

create table public.olist_orders  
(
    order_id varchar(100) primary key,
    customer_id varchar(100),
    order_status varchar(100), 
    order_purchase_timestamp TIMESTAMP without time zone,
    order_approved_at TIMESTAMP without time zone,
    order_delivered_carrier_date TIMESTAMP without time zone,
    order_delivered_customer_date TIMESTAMP without time zone,
    order_estimated_delivery_date TIMESTAMP without time zone,
    foreign key(customer_id) references olist_Customers(customer_id)
);

-- import data from csv files to table :

copy public.olist_orders
from 'C:\Users\nakum\OneDrive\Desktop\PROJECTS\Ecommerce\Olist_Dataset\olist_orders_dataset.csv'
WITH (FORMAT csv, HEADER true, delimiter ',', encoding 'UTF8');
```

#### 5. Table Olist_Order_reviews

This table has order_id as foreign key.

```sql

--drop table if already exist to ensure multiple runs and clean slate

drop table if EXISTS public.olist_order_reviews;

/* create table olist_order_review with foreign key
review_id and order_id has duplicate values so it cannot be primary key
*/

create table public.olist_order_reviews
(
    review_id VARCHAR(100),
    order_id varchar(100),
    review_score int,
    review_comment_title varchar(255),
    review_comment_message text,
    review_creation_date TIMESTAMP without time zone,
    review_answer_timestamp TIMESTAMP without time zone,
    foreign key (order_id) references olist_orders(order_id)
);

-- import data from csv files to table :

  copy public.olist_order_reviews
from 'C:\Users\nakum\OneDrive\Desktop\PROJECTS\Ecommerce\Olist_Dataset\olist_order_reviews_dataset.csv'
WITH (FORMAT csv, HEADER true, delimiter ',', encoding 'UTF8');
```

#### 6. Table Olist_Order_payments

This table has order_id as foreign key.

```sql

--drop table if already exist to ensure multiple runs and clean slate

drop table if EXISTS public.olist_order_payments;

--create table olist_order_payments with foreign key

create table public.olist_order_payments 
(
    order_id varchar(100),
    payment_sequential int,
    payment_type varchar(100),
    payment_installments int,
    payment_value numeric(10,2),
    foreign key(order_id) references olist_orders(order_id)
);

-- import data from csv files to table :

copy public.olist_order_payments
from 'C:\Users\nakum\OneDrive\Desktop\PROJECTS\Ecommerce\Olist_Dataset\olist_order_payments_dataset.csv'
WITH (FORMAT csv, HEADER true, delimiter ',', encoding 'UTF8');
```

#### 7. Table Olist_product_name_translation

This table has Product_category_name as the primary key which has 73 values.

```sql

--drop table if already exist to ensure multiple runs and clean slate

drop table if exists public.olist_product_name_translation;

--create table olist_product_name_translation with primary key

create table public.olist_product_name_translation
(
    product_category_name varchar(100) primary key,
    product_category_name_english varchar(100)
);

-- I Manually Translate columns names into English in .csv file.
-- import data from csv files to table :

copy public.olist_product_name_translation
from 'C:\Users\nakum\OneDrive\Desktop\PROJECTS\Ecommerce\Olist_Dataset\product_category_name_translation.csv'
WITH (FORMAT csv, HEADER true, delimiter ',', encoding 'UTF8');
```

#### 8. Table Olist_products

This table has product_id as primary key with values 32951 and product_category_name as foreign key.

```sql

--drop table if already exist to ensure multiple runs and clean slate

drop table if EXISTS public.olist_products;

-- create table olist_products with pimary key and foreign key

create table public.olist_products
(
    product_id varchar(100) primary key,
    product_category_name varchar(100),
    product_name_lenght int,
    product_description_lenght int,
    product_photos_qty int,
    product_weight_g int,
    product_length_cm int,
    product_height_cm int,
    product_width_cm int,
    foreign key (product_category_name) references olist_product_name_translation(product_category_name)
);

-- import data from csv files to table :

copy public.olist_products
from 'C:\Users\nakum\OneDrive\Desktop\PROJECTS\Ecommerce\Olist_Dataset\olist_products_dataset.csv'
WITH (FORMAT csv, HEADER true, delimiter ',', encoding 'UTF8');
```

#### 9. Table Olist_order_items

This is the last table to be creted as it has relations with three tables with order_id, seller_id and Product_id as its foreign keys

```sql

drop table if exists public.olist_order_items;

-- create table olist_order_items with primary key and foreign keys

create table public.olist_order_items
(
    order_id VARCHAR(100),
    order_item_id int,
    product_id VARCHAR(100),
    seller_id VARCHAR(100),
    shipping_limit_date TIMESTAMP without time zone,
    price numeric(10,2),
    freight_value numeric(10,2),
    foreign key (order_id) references olist_orders(order_id),
    foreign key (product_id) references olist_products(product_id),
    foreign key (seller_id) references olist_seller(seller_id)
);

-- import data from csv files to table :

copy public.olist_order_items
from 'C:\Users\nakum\OneDrive\Desktop\PROJECTS\Ecommerce\Olist_Dataset\olist_order_items_dataset.csv'
WITH (FORMAT csv, HEADER true, delimiter ',', encoding 'UTF8');
```


## Entity Relationship Diagram (ERD)

This diagram illustrates the relationships between all the tables I have created.

![ERD Diagram](https://github.com/gautamnakum40/Business-Analytics-SQL-PowerBI/blob/master/Img/ERD.png)

## Exploratory Data Analysis (EDA)

The second objective is to perform Exploratory Data Analysis (EDA) to uncover valuable insights. The analysis is divided into three different approaches based on the data, providing a comprehensive understanding of the overall e-commerce business.

   - Customer and Seller Analysis [SQL File](https://github.com/gautamnakum40/Business-Analytics-SQL-PowerBI/blob/master/EDA_SQL/Customer%26Seller_analysis.sql)
   - Delivery and Review Analysis [SQL File](https://github.com/gautamnakum40/Business-Analytics-SQL-PowerBI/blob/master/EDA_SQL/Delivery%26Review_analysis.sql)
   - Sales and Revenue Analysis [SQL File](https://github.com/gautamnakum40/Business-Analytics-SQL-PowerBI/blob/master/EDA_SQL/Sales%26Revenue_analysis.sql)

### **Customer and Seller Analysis**

Questions to be answer for this analysis are as follows:

  1. What are the top 10 cities with most customers?
  2. What are the top 10 states with most customers?
  3. Find what top 10 cities come under what states?
  4. What are the top 10 cities with most selles?
  5. What are the top 10 states with most selles?
  6. Find what top 10 cities come under what states?
  7. Is there any relation between the geography of customers and sellers?

#### 1. What are the top 10 cities with most customers?

```sql
--we will use customer unique id because we want to get total unique customers

select customer_city, count(customer_unique_id) as number_customers
from olist_customers
group by customer_city
order by number_customers DESC
limit 10;
```

Visualization [Link](https://github.com/gautamnakum40/Business-Analytics-SQL-PowerBI/blob/master/Img/top%2010%20cities%20with%20most%20customers.png)

![img](https://github.com/gautamnakum40/Business-Analytics-SQL-PowerBI/blob/master/Img/top%2010%20cities%20with%20most%20customers.png)

Insights

Sao Paulo has the largert customer base for Olist.

#### 2. What are the top 10 states with most customers?

```sql
select customer_state, count(customer_unique_id) as number_customers
from olist_customers
group by customer_state
order by number_customers DESC
limit 10;
```

Visualization [Link](https://github.com/gautamnakum40/Business-Analytics-SQL-PowerBI/blob/master/Img/top%2010%20states%20with%20most%20customers.png)

![img](https://github.com/gautamnakum40/Business-Analytics-SQL-PowerBI/blob/master/Img/top%2010%20states%20with%20most%20customers.png)

Insights

State of São Paulo has the largert customer base for Olist.

#### 3. Find what top 10 cities come under what states?

```sql
with topcities_cust AS
(SELECT customer_state, customer_city, count(customer_unique_id) as number_customers,
row_number() over (ORDER BY count(customer_unique_id) desc) as row_num
from olist_customers
group by customer_city,customer_state
)
select customer_state, customer_city, number_customers
from topcities_cust
where row_num<=10
ORDER BY customer_state, number_customers desc;
```

Visualization [Link](https://github.com/gautamnakum40/Business-Analytics-SQL-PowerBI/blob/master/Img/Customer%20distribution%20bt%20state%20and%20city.png)

![img](https://github.com/gautamnakum40/Business-Analytics-SQL-PowerBI/blob/master/Img/Customer%20distribution%20bt%20state%20and%20city.png)

Insights

State of São Paulo has the 4 cities which have largest customer base for Olist.

#### 4. What are the top 10 cities with most selles?

```sql
select seller_city, count(seller_id) as number_sellers
from olist_seller
group by seller_city
order by number_sellers DESC
limit 10;
```

Visualization [Link](https://github.com/gautamnakum40/Business-Analytics-SQL-PowerBI/blob/master/Img/top%2010%20cities%20with%20most%20selles.png)

![img](https://github.com/gautamnakum40/Business-Analytics-SQL-PowerBI/blob/master/Img/top%2010%20cities%20with%20most%20selles.png)

Insights

São Paulo has the most number of sellers for Olist.

#### 5. What are the top 10 states with most selles?

```sql
select seller_state, count(seller_id) as number_sellers
from olist_seller
group by seller_state
order by number_sellers DESC
limit 10;
```

Visualization [Link](https://github.com/gautamnakum40/Business-Analytics-SQL-PowerBI/blob/master/Img/top%2010%20states%20with%20most%20selles.png)

![img](https://github.com/gautamnakum40/Business-Analytics-SQL-PowerBI/blob/master/Img/top%2010%20states%20with%20most%20selles.png)

Insights

São Paulo has the most number of sellers for Olist.

#### 6. Find what top 10 cities come under what states?

```sql
with topcities_seller AS
(SELECT seller_state, seller_city, count(seller_id) as number_sellers,
row_number() over (ORDER BY count(seller_id) desc) as row_num
from olist_seller
group by seller_city,seller_state
)
select seller_state, seller_city, number_sellers
from topcities_seller
where row_num<=10
ORDER BY seller_state, number_sellers desc;

```

Visualization [Link](https://github.com/gautamnakum40/Business-Analytics-SQL-PowerBI/blob/master/Img/Seller%20distisbution%20by%20states.png)

![img](https://github.com/gautamnakum40/Business-Analytics-SQL-PowerBI/blob/master/Img/Seller%20distisbution%20by%20states.png)

Insights

60% of the top 10 sellers are from the State of Sao Paulo.

Also from the visualizations it is clear that State of Sao Paulo and city of Sao Pualo has the largest customer and seller base. For further analysis I could use the geolocation table but due to prefix zip code dupliaction avoiding it.

### **Delivery and Review Analysis**

Questions to be answer for this analysis are as follows:

   1. Find the avergare time it takes for the after the puchase for the payment to be approved?
   2. Find out the fastest and the slowest delivery days or time?
   3. Find out the average devlivery time or days ?
   4. Find the average, max, min difference between the actual delivery and estimated delivery?
   5. Find out count of all reviews scores and the avergae review score per delivery?
   6. Find the relation between delivery time and review score?

#### 1. Find the avergare time it takes for the after the puchase for the payment to be approved?

```sql

select MAX(order_approved_at - order_purchase_timestamp) as maxtime_approval FROM olist_orders
where order_status='delivered'
;

select MIN(order_approved_at - order_purchase_timestamp) as mintime_approval FROM olist_orders
where order_status='delivered'
;

-- we see 0 as result because there are orders when the purchase was approved at the same time

select * from olist_orders
where order_approved_at = order_purchase_timestamp;

select AVG(order_approved_at - order_purchase_timestamp) as avgtime_approval FROM olist_orders
where order_status='delivered'
;
```

Output

For Max

```{ "days": 30, "hours": 21, "minutes": 26, "seconds": 37}```

For Min

``` {} ```

> Insight : The MIN value is 0 because purchase time and order time is same for some orders.

For Avg

``` { "hours": 10, "minutes": 16, "seconds": 36, "milliseconds": 361.244} ```

> Insight : On average it took 10hrs and 16 minutes for the payment bee approved after the purchase was made by the customer.

#### 2. FInd out the fastest and the slowest delivery days or time?

```sql
-- For Slowest

select max(order_delivered_customer_date - order_purchase_timestamp) as slowest_delivery from olist_orders
where order_status= 'delivered'
;

-- For fastest

select min(order_delivered_customer_date - order_purchase_timestamp) as fastest_delivery from olist_orders
where order_status= 'delivered'
;

-- For Avg

select avg(order_delivered_customer_date - order_purchase_timestamp) as average_delivery from olist_orders
where order_status= 'delivered'
;
```

Output 

For Slowest

``` {"days": 209,"hours": 15,"minutes": 5,"seconds": 12}```

> Insight : the slowest delivery took 209 days to deliver

For Fastest

``` {"hours": 12, "minutes": 48,"seconds": 7} ```

> Insight : observation fastest delivery time is 12 hours

#### 3.  Find out the average devlivery time or days ?

```sql
-- For Avg
select avg(order_delivered_customer_date - order_purchase_timestamp) as average_delivery from olist_orders
where order_status= 'delivered'
;
```

Output 

``` {"days": 12, "hours": 13, "minutes": 23, "seconds": 49, "milliseconds": 957.272 }```

> Insight : average delivery time is 12 days and 13 hours

#### 4. Find the average, max, min difference between the actual delivery and estimated delivery?

``` sql
-- For AVG

select avg(order_estimated_delivery_date - order_delivered_customer_date) as average_discrepency from olist_orders
where order_status= 'delivered'
;

-- For Max

select max(order_estimated_delivery_date - order_delivered_customer_date) as max_discrepency from olist_orders
where order_status= 'delivered'
;

- For MIN

select min(order_estimated_delivery_date - order_delivered_customer_date) as min_discrepency from olist_orders
where order_status= 'delivered'
```

Output 

For AVG

```{"days": 10,"hours": 28, "minutes": 16, "seconds": 30, "milliseconds": 62.973}```

> Insight : On average product is delivered 10 days before the estimated delivery date.

For Max

```{"max_discrepency": { "days": 146,  "minutes": 23, "seconds": 13}}```

> Insight : A product was delivered 146 days prior to the estimated delivery time.

For MIN

```{ "days": -188,"hours": -23, "minutes": -24,"seconds": -7}```

> Insight : A product was delivered 6 months after the estimated delivery time. Negative days means the product was delivered after the estimated date of delivery.

#### 5. Find out count of all reviews scores and the percentage of review score?

```sql
with starrating AS
(
select review_score, count(order_id) star_ratings from olist_order_reviews
group by review_score
order by star_ratings DESC
)
,
total as 
(
select count(order_id) as total from olist_order_reviews
)

select review_score, star_ratings, (star_ratings::float / total) * 100 as percentage_stars
from starrating, total;
```

Visualization [Link](https://github.com/gautamnakum40/Business-Analytics-SQL-PowerBI/blob/master/Img/Rating%20Analysis.png)

![img](https://github.com/gautamnakum40/Business-Analytics-SQL-PowerBI/blob/master/Img/Rating%20Analysis.png)

#### 6. Find the relation between delivery time and review score?

-- Checking the Avg score if delivered within first two weeks

```sql
--find avg_rating we use cte inside cte


with avgrating as
(with relation as
(select ord.order_id, (ord.order_delivered_customer_date - ord.order_purchase_timestamp) as deliverytime,
orr.review_score
from olist_orders ord join olist_order_reviews orr on ord.order_id = orr.order_id
where ord.order_status = 'delivered' and order_delivered_customer_date is not NULL)

select * from relation
where deliverytime < INTERVAL '14 days'
)
select avg(review_score) from avgrating
```
Output 

```{ "avg": "4.3533371570018414"}```

> Insight : f the product is delivered with in 2 weeks the avg rating is 4.35.

-- Checking the Avg score if delivered between 2 and 3 weeks

```sql
with avgrating as
(
with relation as
(select ord.order_id, (ord.order_delivered_customer_date - ord.order_purchase_timestamp) as deliverytime,
orr.review_score
from olist_orders ord join olist_order_reviews orr on ord.order_id = orr.order_id
where ord.order_status = 'delivered' and order_delivered_customer_date is not NULL)

select * from relation
where deliverytime between INTERVAL '14 days' and INTERVAL '21 days'
)
select avg(review_score) from avgrating
```

Output 

```{ "avg": "4.1396386222473179"}```

> Insight : if the product is delivered with in 2 weeks to 3 weeks the avg rating drops to 4.13.

-- Checking the Avg score if delivered between 3 and 4 weeks

```sql
with avgrating as
(
with relation as
(select ord.order_id, (ord.order_delivered_customer_date - ord.order_purchase_timestamp) as deliverytime,
orr.review_score
from olist_orders ord join olist_order_reviews orr on ord.order_id = orr.order_id
where ord.order_status = 'delivered' and order_delivered_customer_date is not NULL)

select * from relation
where deliverytime between INTERVAL '21 days' and INTERVAL '28 days'
)

select avg(review_score) from avgrating
```

Output 

```{ "avg": "3.6899055918663762"}```

> Insight : if the product is delivered with in 3 weeks to 4 weeks the avg rating drops to 3.6.

-- Checking the Avg score if delivered between 4 and 5 weeks

```sql
with avgrating as
(
with relation as
(select ord.order_id, (ord.order_delivered_customer_date - ord.order_purchase_timestamp) as deliverytime,
orr.review_score
from olist_orders ord join olist_order_reviews orr on ord.order_id = orr.order_id
where ord.order_status = 'delivered' and order_delivered_customer_date is not NULL)

select * from relation
where deliverytime  between INTERVAL '28 days' and INTERVAL '35 days'
)

select avg(review_score) from avgrating
```

Output 

```{ "avg": "2.8450144508670520"}```

> Insight : if the product is delivered with in 4 weeks to 5 weeks the avg rating drops to 2.8.

-- Checking the Avg score if delivered after 5 weeks

```sql
with avgrating as
(
with relation as
(select ord.order_id, (ord.order_delivered_customer_date - ord.order_purchase_timestamp) as deliverytime,
orr.review_score
from olist_orders ord join olist_order_reviews orr on ord.order_id = orr.order_id
where ord.order_status = 'delivered' and order_delivered_customer_date is not NULL)

select * from relation
where deliverytime > INTERVAL '35 days'

)

select avg(review_score) from avgrating
```

Output 

```{"avg": "1.9714912280701754"}```

> Insight : if the product is delivered after 5 weeks the avg rating drops to 1.9

### **Sales and Revenue Analysis**

Questions to be answer for this analysis are as follows:

  1. Find the top 10 categories whose avg products price is expensive? Also do find cheapest 10 ?
  2. Find the top 10 most ordered product categories?
  3. Find out the distribution of payment installments ?
  4. Find the total orders yearly and monthly?
  4. Find out the total sales revenue yearly and monthly?
  6. Find out the average frieght paid by customers?

#### 1. Find the top 10 categories whose avg products price is expensive? Also do find cheapest 10 ?

-- Most Expensive Categories by average product price.

```sql
with exppd AS
(
select  pt.product_category_name, avg(oi.price) avg_price
from olist_order_items oi join olist_products pt 
on oi.product_id = pt.product_id
group by pt.product_category_name
order by avg_price DESC
limit 10
)
select exppd.product_category_name, nt.product_category_name_english, exppd.avg_price avg_price
from exppd join olist_product_name_translation nt 
on exppd.product_category_name = nt.product_category_name
order by avg_price desc;
```

Visualization [Link](https://github.com/gautamnakum40/Business-Analytics-SQL-PowerBI/blob/master/Img/Most%20Expensive%20Categories.png)

![img](https://github.com/gautamnakum40/Business-Analytics-SQL-PowerBI/blob/master/Img/Most%20Expensive%20Categories.png)

-- Least Expensive Categories by average product price.

```sql
with chpd AS
(
select pt.product_category_name, avg(oi.price) as avg_price
from olist_order_items oi join olist_products pt 
on oi.product_id = pt.product_id
group by pt.product_category_name
order by avg_price asc
limit 10
)
select chpd.product_category_name, nt.product_category_name_english, chpd.avg_price avg_price
from chpd join olist_product_name_translation nt 
on chpd.product_category_name = nt.product_category_name
order by avg_price asc;
```

Visualization [Link](https://github.com/gautamnakum40/Business-Analytics-SQL-PowerBI/blob/master/Img/Least%20Expensive%20Category.png)

![img](https://github.com/gautamnakum40/Business-Analytics-SQL-PowerBI/blob/master/Img/Least%20Expensive%20Category.png)

#### 2. Find the top 10 most ordered product categories?

```sql
with products_ordered as
(
select p.product_category_name, count(oi.product_id) productord
from olist_order_items oi join olist_products p
on oi.product_id = p.product_id
group by p.product_category_name
order by productord desc
limit 10
)

select po.product_category_name, nt.product_category_name_english, po.productord
from products_ordered po join olist_product_name_translation nt
on po.product_category_name = nt.product_category_name
order by po.productord desc
```

Visualization [Link](https://github.com/gautamnakum40/Business-Analytics-SQL-PowerBI/blob/master/Img/TOP%2010%20PRODUCTS%20ORDERED.png)

![img](https://github.com/gautamnakum40/Business-Analytics-SQL-PowerBI/blob/master/Img/TOP%2010%20PRODUCTS%20ORDERED.png)

#### 3. Find out the distribution of payment installments ?

```sql
with num_count as
(
select payment_installments, count(order_id) num
from olist_order_payments
group by payment_installments
order by payment_installments asc
)
,
total as
(
select count(order_id) tot
from olist_order_payments
)
select payment_installments, num, (num :: float / tot) * 100 as percentage
from num_count, total
```

Visualization [Link](https://github.com/gautamnakum40/Business-Analytics-SQL-PowerBI/blob/master/Img/PAYMENT%20INSTALLMENTS%20DISTRIBUTION.png)

![img](https://github.com/gautamnakum40/Business-Analytics-SQL-PowerBI/blob/master/Img/PAYMENT%20INSTALLMENTS%20DISTRIBUTION.png)

#### 4. Find the total orders yearly and monthly?

```sql
select  extract(month from order_purchase_timestamp) as month, extract(year from order_purchase_timestamp) as year, count(order_id) as total_orders
from olist_orders
group by  year, month
```

Visualization [Link](https://github.com/gautamnakum40/Business-Analytics-SQL-PowerBI/blob/master/Img/Yearly%20and%20Monthly%20Order%20Sales.png)

![img](https://github.com/gautamnakum40/Business-Analytics-SQL-PowerBI/blob/master/Img/Yearly%20and%20Monthly%20Order%20Sales.png)

#### 5. Find out the total sales revenue yearly and monthly?

```sql
select sum(op.payment_value) as sales_revenue, extract(year from o.order_purchase_timestamp) as year, extract(month from o.order_purchase_timestamp) as month
from olist_order_payments op join olist_orders o
on op.order_id = o.order_id
group by year, month
```

Visualization [Link](https://github.com/gautamnakum40/Business-Analytics-SQL-PowerBI/blob/master/Img/Yearly%20and%20Monthly%20Revenue.png)

![img](https://github.com/gautamnakum40/Business-Analytics-SQL-PowerBI/blob/master/Img/Yearly%20and%20Monthly%20Revenue.png)

#### 6. Find out the average frieght paid by customers?

```sql
select avg(freight_value)
from olist_order_items
```

Output

```{"avg": "19.9903199289835775"}```

> Insight : On average $19.9 frieght charges are there per order.

###  Power BI Dashboard

The Power BI Dashboard aims to provide an interactive and visually compelling analysis of the Olist e-commerce dataset, enabling data-driven decision-making.



## Executive Summary

### Database design and importing data

This part of the project includes using the schema provide by the Olist dataset to establish the follwing tasks:

  - Using the data in different csv files to import into seperate tables using the given schema.
  - Creating tables in order so that these relationships can be established and data can be imported in a logical order.
  - Asigning adequate data types such as int, numeeric, varchar, timestamp etc to the tables so that it is easies to perform functions usch as joins to the tables.
  - Creating a Entity relationship diagram and then comparing it to the schema provided.

After this part the data is available a form that can be used for exploratory data analysis.

### Exploaratory Data Analysis(EDA)

**This part of the project includes exploring the data using postgre and then visualizing it in PowerBI**.

  - Gaining insights using questions for each segment of this analysis.
  - Finding the different geographical distribution of customers and sellers.
  - Analysing sales and revenue as well as product distribution. 
  - Understanding the delivery timings and its effect on reviews.

**Various SQL techniques are used in order to perform these analysis such as:**

  - Joins are used for different tables to get required results.
  - CTE common tabke expression is used for table manuplation.
  - Aggregate functions used such as avg, max, min for analysis.
  - Subqueries and Group By clauses used with other basic operations like to extract order and filter data.  

**[PowerBI for Visualization & Dashboard](https://github.com/gautamnakum40/Business-Analytics-SQL-PowerBI/blob/master/PowerBI/Olist_Ecommerce_Dashboard.pbix)**
   
   - Results from sql queries are stores as csv files and used for visualization.
   - Diffferet charts such as area chart, bar chart, waterfall chart, heatmaps, Stacked area chart and table matrix  are used for interactive visualization.
   - hese visualizations are integrated into a dynamic Power BI dashboard, providing an intuitive and interactive way to analyze key metrics and trends.

## Key Insights from the Olist E-commerce Analysis

**1. Top-Performing Product Categories Drive Revenue**
  - Certain product categories contribute significantly to total sales, indicating **high customer demand and profitability.**

**2. Delivery Speed Directly Impacts Customer Satisfaction**
  - Orders with faster delivery times tend to receive higher customer ratings, emphasizing the importance of logistics optimization.

**3. Seller Performance Influences Repeat Purchases**
  - **High-rated sellers** tend to have better sales consistency and repeat customers, highlighting the impact of **customer trust and service quality.**

**4. Review Sentiment Correlates with Product Quality & Service**
  - Negative reviews often highlight issues in **product quality, delayed deliveries, or poor customer support**, serving as key areas for business improvement.
