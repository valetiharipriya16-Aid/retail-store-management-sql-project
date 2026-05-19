CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) CHECK (category IN ('Electronics', 'Clothing', 'Grocery', 'Furniture')),
    price REAL NOT NULL CHECK (price > 0),
    stock_quantity INT CHECK (stock_quantity >=0)
);

CREATE TABLE Customers (
    customer_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    phone TEXT UNIQUE NOT NULL,
    address TEXT DEFAULT 'Not Provided'
);

CREATE TABLE Orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    order_date DATE DEFAULT CURRENT_DATE,
    total_amount REAL CHECK (total_amount > 0),
    Remarks_if_any TEXT DEFAULT 'No Remarks'
);
INSERT INTO Customers (customer_id, name, email, phone, address) 
VALUES
(1, 'John Doe', 'john.doe@email.com', '9876543210', '123 Main St'),
(2, 'Jane Smith', 'jane.smith@email.com', '9823456789', '45 Elm St'),
(3, 'Alice Brown', 'alice.b@email.com', '9988776655', '78 Pine Ave'),
(4, 'Bob Johnson', 'bob.j@email.com', '9765432109', '90 Oak Lane'),
(5, 'Charlie Lee', 'charlie.l@email.com', '9234567890', 'Not Provided'),
(6, 'David White', 'david.w@email.com', '9678991234', '12 Maple St'),
(7, 'Emily Clark', 'emily.c@email.com', '9345678901', 'Not Provided'),
(8, 'Frank Harris', 'frank.h@email.com', '9763214785', '56 Birch Road'),
(9,'Grace Kelly', 'grace.k@email.com', '9456123870','32 Cedar Ave'),
(10, 'Henry Adams', 'henry.a@email.com', '9312465789', '22 Walnut Lane');

INSERT INTO Products (product_id, name, category, price, stock_quantity) 
VALUES
(101, 'Apple iPhone 15', 'Electronics', 999.99, 10),
(102, 'Samsung Galaxy S23', 'Electronics', 899.99, 15),
(103, 'Leather Jacket', 'Clothing', 149.99, 25),
(104, 'HP Laptop', 'Electronics', 799.99, 8),
(105, 'Wooden Dining Table', 'Furniture', 499.99, 5),
(106, 'Nike Running Shoes', 'Clothing', 129.99, 20),
(107, 'LED TV 55"', 'Electronics', 699.99, 12),
(108, 'Rice 10kg', 'Grocery', 25.99, 50),
(109, 'Sofa Set (3+1+1)', 'Furniture', 999.99, 4),
(110, 'Organic Honey 500ml', 'Grocery', 15.99, 30);

INSERT INTO Orders (order_id, customer_id, order_date, total_amount, Remarks_if_any) 
VALUES
(1001, 1, '2024-01-15', 999.99, 'No Remarks'),
(1002, 2, '2024-01-16', 299.98, 'Delivered'),
(1003, 3, '2024-01-17', 129.99, 'Payment Pending'),
(1004, 4, '2024-01-18', 899.99, 'No Remarks'),
(1005, 5, '2024-01-19', 799.99, 'Cancelled'),
(1006, 6, '2024-01-20', 499.99, 'Delivered'),
(1007, 7, '2024-01-21', 129.99, 'No Remarks'),
(1008, 8, '2024-01-22', 699.99, 'Refund Issued'),
(1009, 9, '2024-01-23', 25.99, 'No Remarks'),
(1010, 10, '2024-01-24', 15.99, 'Delivered');

--Queries for retrieving the first 3 records from the three tables
SELECT * FROM Customers Limit 3;
SELECT * FROM Products Limit 3;
SELECT * FROM Orders Limit 3;

-- fetch all distinct product categories
select
DISTINCT category
FROM Products;

-- get orders of customers who have spent more than 900
SELECT *
FROM orders
WHERE total_amount>900;

-- Find the 2 most expensive products from the Products table
SELECT *
FROM Products
ORDER BY price DESC
limit 2;

-- Find customers who have not provided their address
SELECT *
FROM customers
WHERE address ='Not Provided';

-- Increase the prices of all products in the 'Electronics' category by 10%
-- Then, retrieve the name, price, and stock quantity of the first Electronics product from the Products table
UPDATE Products
SET price=price+(price*0.1)
WHERE category='Electronics';
SELECT name,price,stock_quantity FROM Products
where category='Electronics'
limit 1;

-- Add a new column "discount" to the Orders table.
-- Set its default value to 0.
-- Then, retrieve the order_id, total_amount and discount of the first order from the Orders table.
ALTER TABLE Orders 
ADD COLUMN discount INT DEFAULT 0;
SELECT order_id, total_amount, discount 
FROM Orders 
LIMIT 1;

-- Remove all products that are out of stock.Then, retrieve the product_id, name and stock_quantity of all products from the Product table.
BEGIN TRANSACTION;
SAVEPOINT S1;
DELETE FROM Products where stock_quantity=0;
SELECT product_id,name,stock_quantity FROM Products;

-- Delete all orders that were placed before 2024-01-20.
-- Then, retrieve the order_id, customer_id, order_date, total_amount of all orders from the Orders table.
BEGIN TRANSACTION;
SAVEPOINT S1;
DELETE FROM Orders WHERE order_date< '2024-01-20';
SELECT order_id,customer_id,order_date,total_amount from Orders;

-- Find the total revenue generated and display it with the header total_revenue.
SELECT SUM(total_amount) AS total_revenue
from Orders;

-- Find the average spending per customer and display it with the header avg_spending_per_customer.
SELECT AVG(total_amount) AS avg_spending_per_customer
FROM orders
GROUP BY customer_id
limit 1;

-- Find the number of orders placed per month and display them with the headers order_month and total_orders.
SELECT strftime('%Y-%m', order_date) AS order_month, 
       COUNT(order_id) AS total_orders
FROM Orders
GROUP BY order_month;

-- Update the Customers table to replace all occurrences of "Unknown" in the new_address column with NULL.
-- Ensure that no records are deleted, only modified.
-- Then, retrieve the customer_id, name and new_address of the first 3 customers from the Customer table.
UPDATE Customers
SET address=NULL
WHERE address='Unknown';
SELECT customer_id,name,address from Customers limit 3;

-- Find the order_id, customer_id, and order_date of all orders placed in January 2024.
SELECT order_id, customer_id, order_date 
FROM Orders 
WHERE strftime('%Y-%m', order_date) = '2024-01';

-- Query 2: Most recent order date
SELECT MAX(order_date) AS most_recent_order 
FROM Orders;

-- Query 3: Order count per day between 2024-01-15 and 2024-01-17
SELECT order_date, COUNT(order_id) AS order_count 
FROM Orders 
WHERE order_date BETWEEN '2024-01-15' AND '2024-01-17' 
GROUP BY order_date;

-- Number of days between earliest and latest orders
SELECT CAST(JULIANDAY(MAX(order_date)) - JULIANDAY(MIN(order_date)) AS INT) AS days_between 
FROM Orders;

-- Orders placed in the 5 days before 2024-01-24
SELECT order_id, customer_id, order_date, total_amount 
FROM Orders 
WHERE order_date BETWEEN DATE('2024-01-24', '-5 days') AND DATE('2024-01-24', '-1 day');
