


-- EXERCISE 1
/*Fred’s database, which contains a single table named store, has been loaded for you. Write a query to select the first 10 rows and all columns (using SELECT *) from the store table and inspect the results. In order to normalize the database, which columns do you think should be moved to separate tables?*/
SELECT *
FROM store
LIMIT 10;


-- EXERCISE 2
/*Have any customers made more than one order?Then, write another query using similar syntax to calculate the number of distinct customer_id values. You should see fewer customers than orders, suggesting that some customers have made more than one order!*/
SELECT COUNT(DISTINCT(order_id)) 
FROM store;

SELECT COUNT(DISTINCT(customer_id))
FROM store;

-- EXERCISE 3
/*Let’s inspect some of the repeated data in this table. Write a query to return the customer_id, customer_email, and customer_phone where customer_id = 1. How many orders did this customer make?*/
SELECT customer_id, customer_email, customer_phone
FROM store
WHERE customer_id = '1';

-- EXERCISE 4
/*There’s probably even more repeated data in the item-related columns! Write a query to return the item_1_id, item_1_name, and item_1_price where item_1_id = 4. How many orders include this item as item_1?*/
SELECT item_1_id, item_1_name, item_1_price
FROM store
WHERE item_1_id = '4';
-- includes four orders

-- EXERCISE 5
/*Use CREATE TABLE customers AS to create the customers table described in the schema by querying the original store table for the relevant columns. Make sure to only include one row per distinct customer_id.*/
CREATE TABLE customers AS
SELECT DISTINCT customer_id, customer_phone, customer_email
FROM store;

-- EXERCISE 6
/*Use the following syntax to designate the customer_id column as the primary key of your new customers table:*/
ALTER TABLE customers
ADD PRIMARY KEY (customer_id);

-- EXERCISE 7
/*Use CREATE TABLE items AS to create the items table described in the normalized schema (diagram below) by querying the original store table for the relevant columns. Make sure to only include one row per distinct item_id.*/
CREATE TABLE items AS 
SELECT DISTINCT item_1_id AS item_id, item_1_name AS name, item_1_price AS price
FROM store
UNION
SELECT DISTINCT item_2_id AS item_id, item_2_name AS name, item_2_price AS price
FROM store
WHERE item_2_id IS NOT NULL
UNION
SELECT DISTINCT item_3_id AS item_id,
item_3_name AS name, item_3_price AS price
FROM store
WHERE item_3_id IS NOT NULL;

-- EXERCISE 8
/*Designate the item_id column of your new items table as the primary key.*/
ALTER TAble items
ADD PRIMARY KEY (item_id);

-- EXERCISE 9
/*Use CREATE TABLE orders_items AS to create the orders_items table described in the normalized schema (diagram below) by querying the original store table for the relevant columns. Each row should correspond to a unique instance of a particular item in a particular order.*/
CREATE TABLE orders_items AS
SELECT order_id, item_1_id AS item_id
FROM store
UNION ALL
SELECT order_id, item_2_id AS item_id
FROM store
WHERE item_2_id IS NOT NULL
UNION ALL
SELECT order_id, item_3_id AS item_id
FROM store
WHERE item_3_id IS NOT NULL;

-- EXERCISE 10
/*Use CREATE TABLE orders AS to create the orders table described in the normalized schema (diagram below) by querying the original store table for the relevant columns. Note that you will want to include customer_id in the orders table so that you can still link orders and customers back together.*/
CREATE TABLE orders AS 
SELECT order_id, order_date, customer_id
FROM store;

-- EXERCISE 11
/*Designate the order_id column of the orders table as the primary key.*/
ALTER TABLE orders
ADD PRIMARY KEY (order_id);

-- EXERCISE 12
/*Use similar syntax to designate the item_id column of the orders_items table as a foreign key referencing the item_id column of the items table.*/
ALTER TABLE orders
ADD FOREIGN KEY (customer_id) 
REFERENCES customers(customer_id);

ALTER TABLE orders_items
ADD FOREIGN KEY (item_id)
REFERENCES items(item_id);

-- EXERCISE 13
/*Designate the order_id column of the orders_items table as a foreign key referencing the order_id column of the orders table.*/
ALTER TABLE orders_items
ADD FOREIGN KEY (order_id)
REFERENCES orders(order_id);

-- EXERCISE 14
/*Query the original store table to return the emails of all customers who made an order after July 25, 2019 (hint: use WHERE order_date > '2019-07-25').*/
SELECT customer_email
FROM store
WHERE order_date > '2019-07-25';


-- EXERCISE 15
/*Now, query your normalized database tables to return the emails of all customers who made an order after July 25, 2019 (the normalized database tables are: orders, orders_items, customers, and items). Is this easier or more difficult to do with the normalized database tables?*/
SELECT customer_email
FROM customers, orders
WHERE customers.customer_id = orders.customer_id
AND
orders.order_date > '2019-07-25';


-- EXERCISE 16
/*Query the original store table to return the number of orders containing each unique item (for example, two orders contain item 1, two orders contain item 2, four orders contain item 3, etc.)*/
WITH all_items AS (
SELECT item_1_id as item_id 
FROM store
UNION ALL
SELECT item_2_id as item_id
FROM store
WHERE item_2_id IS NOT NULL
UNION ALL
SELECT item_3_id as item_id
FROM store
WHERE item_3_id IS NOT NULL
)
SELECT item_id, COUNT(*)
FROM all_items
GROUP BY item_id;


-- EXERCISE 17
/*Query your normalized database tables to return the number of orders containing each unique item. Is this easier or more difficult to do with the normalized database tables?*/
SELECT item_id, COUNT(order_id)
FROM orders_items
GROUP BY item_id;
















