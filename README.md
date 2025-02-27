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



