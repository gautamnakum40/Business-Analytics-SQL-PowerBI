/* copy data from all csv files into the tables created in the create table sql file
using 'for path'
*/


--1
copy public.olist_geolocation
from 'C:\Users\nakum\OneDrive\Desktop\PROJECTS\Ecommerce\Olist_Dataset\olist_geolocation_dataset.csv'
WITH (FORMAT csv, HEADER true, delimiter ',', encoding 'UTF8');

--2
copy public.Olist_seller
from 'C:\Users\nakum\OneDrive\Desktop\PROJECTS\Ecommerce\Olist_Dataset\olist_sellers_dataset.csv'
WITH (FORMAT csv, HEADER true, delimiter ',', encoding 'UTF8');

--3
copy public.olist_Customers
from 'C:\Users\nakum\OneDrive\Desktop\PROJECTS\Ecommerce\Olist_Dataset\olist_customers_dataset.csv'
WITH (FORMAT csv, HEADER true, delimiter ',', encoding 'UTF8');

--4
copy public.olist_orders
from 'C:\Users\nakum\OneDrive\Desktop\PROJECTS\Ecommerce\Olist_Dataset\olist_orders_dataset.csv'
WITH (FORMAT csv, HEADER true, delimiter ',', encoding 'UTF8');

--5
copy public.olist_order_reviews
from 'C:\Users\nakum\OneDrive\Desktop\PROJECTS\Ecommerce\Olist_Dataset\olist_order_reviews_dataset.csv'
WITH (FORMAT csv, HEADER true, delimiter ',', encoding 'UTF8');

--6
copy public.olist_order_payments
from 'C:\Users\nakum\OneDrive\Desktop\PROJECTS\Ecommerce\Olist_Dataset\olist_order_payments_dataset.csv'
WITH (FORMAT csv, HEADER true, delimiter ',', encoding 'UTF8');

--7 
copy public.olist_product_name_translation
from 'C:\Users\nakum\OneDrive\Desktop\PROJECTS\Ecommerce\Olist_Dataset\product_category_name_translation.csv'
WITH (FORMAT csv, HEADER true, delimiter ',', encoding 'UTF8');

--8
copy public.olist_products
from 'C:\Users\nakum\OneDrive\Desktop\PROJECTS\Ecommerce\Olist_Dataset\olist_products_dataset.csv'
WITH (FORMAT csv, HEADER true, delimiter ',', encoding 'UTF8');

--9
copy public.olist_order_items
from 'C:\Users\nakum\OneDrive\Desktop\PROJECTS\Ecommerce\Olist_Dataset\olist_order_items_dataset.csv'
WITH (FORMAT csv, HEADER true, delimiter ',', encoding 'UTF8');