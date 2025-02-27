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






