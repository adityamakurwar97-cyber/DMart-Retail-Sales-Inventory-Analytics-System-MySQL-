-- D-Mart Retail Sales Data Warehouse (MySQL)
-- Safe script: drops and recreates schema. Use with caution on production.
DROP DATABASE IF EXISTS dmart;
CREATE DATABASE dmart;
USE dmart;

-- disable FK checks while recreating tables
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS sales_fact;
DROP TABLE IF EXISTS payment_dim;
DROP TABLE IF EXISTS date_dim;
DROP TABLE IF EXISTS store_dim;
DROP TABLE IF EXISTS customer_dim;
DROP TABLE IF EXISTS product_dim;

SET FOREIGN_KEY_CHECKS = 1;

-- 1) PRODUCT DIMENSION
CREATE TABLE IF NOT EXISTS product_dim (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    product_category VARCHAR(40) NOT NULL,
    mrp DECIMAL(10,2),
    selling_price DECIMAL(10,2),
    cost_price DECIMAL(10,2),
    brand VARCHAR(50)
);

-- 2) CUSTOMER DIMENSION
CREATE TABLE IF NOT EXISTS customer_dim (
    customer_id INT PRIMARY KEY,
    customer_fullname VARCHAR(100) NOT NULL,
    gender VARCHAR(10),
    age_group VARCHAR(20),
    city VARCHAR(40),
    membership_type VARCHAR(30)
);

-- 3) STORE DIMENSION
CREATE TABLE IF NOT EXISTS store_dim (
    store_id INT PRIMARY KEY,
    store_name VARCHAR(100) NOT NULL,
    city VARCHAR(40),
    state VARCHAR(40),
    store_size VARCHAR(20)
);

-- 4) DATE DIMENSION
CREATE TABLE IF NOT EXISTS date_dim (
    date_id INT PRIMARY KEY,
    full_date DATE NOT NULL,
    day INT,
    month INT,
    year INT,
    quarter VARCHAR(10),
    day_name VARCHAR(15),
    is_weekend VARCHAR(5)
);

-- 5) PAYMENT DIMENSION
CREATE TABLE IF NOT EXISTS payment_dim (
    payment_id INT PRIMARY KEY,
    payment_method VARCHAR(20) NOT NULL,
    provider VARCHAR(40)
);

-- 6) SALES FACT TABLE
CREATE TABLE IF NOT EXISTS sales_fact (
    sale_id INT PRIMARY KEY,
    date_id INT NOT NULL,
    product_id INT NOT NULL,
    customer_id INT NOT NULL,
    store_id INT NOT NULL,
    payment_id INT NOT NULL,
    quantity_sold INT,
    discount_amount DECIMAL(10,2),
    total_amount DECIMAL(10,2),
    profit DECIMAL(10,2),
    FOREIGN KEY (date_id) REFERENCES date_dim(date_id),
    FOREIGN KEY (product_id) REFERENCES product_dim(product_id),
    FOREIGN KEY (customer_id) REFERENCES customer_dim(customer_id),
    FOREIGN KEY (store_id) REFERENCES store_dim(store_id),
    FOREIGN KEY (payment_id) REFERENCES payment_dim(payment_id)
);

-- INSERTS: product_dim (50 rows)
INSERT INTO product_dim (product_id, product_name, product_category, mrp, selling_price, cost_price, brand) VALUES
(101, 'Basmati Rice 5kg', 'Grocery', 650.00, 620.00, 560.00, 'India Gate'),
(102, 'Wheat Flour 10kg', 'Grocery', 420.00, 399.00, 350.00, 'Aashirvaad'),
(103, 'Sugar 5kg', 'Grocery', 240.00, 230.00, 200.00, 'Dhampure'),
(104, 'Salt 1kg', 'Grocery', 25.00, 22.00, 18.00, 'Tata'),
(105, 'Tea Powder 500g', 'Grocery', 280.00, 260.00, 230.00, 'Tata Tea'),
(106, 'Coffee 200g', 'Grocery', 180.00, 170.00, 150.00, 'Nescafe'),
(107, 'Sunflower Oil 1L', 'Grocery', 170.00, 160.00, 140.00, 'Fortune'),
(108, 'Ghee 1L', 'Grocery', 650.00, 630.00, 580.00, 'Amul'),
(109, 'Toor Dal 1kg', 'Grocery', 180.00, 170.00, 150.00, 'Tata Sampann'),
(110, 'Moong Dal 1kg', 'Grocery', 160.00, 150.00, 135.00, 'Tata Sampann'),
(111, 'Besan 1kg', 'Grocery', 120.00, 110.00, 95.00, 'Rajdhani'),
(112, 'Poha 1kg', 'Grocery', 80.00, 75.00, 60.00, '24 Mantra'),
(113, 'Cornflakes 500g', 'Grocery', 210.00, 199.00, 175.00, 'Kelloggs'),
(114, 'Biscuits Pack', 'Grocery', 50.00, 45.00, 35.00, 'Parle'),
(115, 'Maggi Noodles Pack', 'Grocery', 60.00, 55.00, 45.00, 'Maggi'),
(201, 'Detergent Powder 2kg', 'Household', 320.00, 299.00, 250.00, 'Surf Excel'),
(202, 'Dishwash Liquid 500ml', 'Household', 120.00, 110.00, 90.00, 'Vim'),
(203, 'Toilet Cleaner 500ml', 'Household', 110.00, 99.00, 80.00, 'Harpic'),
(204, 'Floor Cleaner 1L', 'Household', 210.00, 199.00, 170.00, 'Lizol'),
(205, 'Shampoo 340ml', 'Household', 240.00, 220.00, 190.00, 'Dove'),
(206, 'Soap Bar Pack', 'Household', 160.00, 150.00, 120.00, 'Lux'),
(207, 'Toothpaste 200g', 'Household', 110.00, 99.00, 80.00, 'Colgate'),
(208, 'Toothbrush Pack', 'Household', 90.00, 85.00, 70.00, 'Oral-B'),
(209, 'Handwash 750ml', 'Household', 170.00, 160.00, 130.00, 'Dettol'),
(210, 'Tissue Paper Pack', 'Household', 80.00, 75.00, 55.00, 'Origami'),
(211, 'Garbage Bags Pack', 'Household', 120.00, 110.00, 90.00, 'CleanWrap'),
(212, 'Phenyl 1L', 'Household', 130.00, 120.00, 95.00, 'Domex'),
(213, 'Mosquito Repellent', 'Household', 95.00, 90.00, 70.00, 'Goodknight'),
(214, 'Scrub Pad Pack', 'Household', 40.00, 35.00, 25.00, 'Scotch-Brite'),
(215, 'Bathing Towel', 'Household', 300.00, 280.00, 240.00, 'Raymond'),
(301, 'Men T-Shirt', 'Fashion', 499.00, 450.00, 350.00, 'Puma'),
(302, 'Men Jeans', 'Fashion', 1499.00, 1399.00, 1100.00, 'Levis'),
(303, 'Women Kurti', 'Fashion', 799.00, 750.00, 600.00, 'Biba'),
(304, 'Women Leggings', 'Fashion', 399.00, 350.00, 250.00, 'Jockey'),
(305, 'Kids Dress', 'Fashion', 699.00, 650.00, 500.00, 'Max'),
(306, 'Socks Pack', 'Fashion', 199.00, 180.00, 120.00, 'Adidas'),
(307, 'Innerwear Pack', 'Fashion', 599.00, 550.00, 450.00, 'Jockey'),
(308, 'Cap', 'Fashion', 299.00, 250.00, 180.00, 'Nike'),
(309, 'Women Saree', 'Fashion', 1999.00, 1850.00, 1500.00, 'Manyavar'),
(310, 'Sports Shoes', 'Fashion', 2499.00, 2300.00, 1800.00, 'Reebok'),
(401, 'Bluetooth Earphones', 'Electronics', 1299.00, 1199.00, 900.00, 'boAt'),
(402, 'Power Bank 10000mAh', 'Electronics', 1499.00, 1399.00, 1100.00, 'Mi'),
(403, 'USB Cable', 'Electronics', 299.00, 250.00, 180.00, 'Samsung'),
(404, 'LED Bulb 9W', 'Electronics', 150.00, 130.00, 100.00, 'Philips'),
(405, 'Extension Board', 'Electronics', 499.00, 450.00, 350.00, 'Havells'),
(406, 'Electric Kettle', 'Electronics', 999.00, 950.00, 750.00, 'Prestige'),
(407, 'Mixer Grinder', 'Electronics', 2499.00, 2399.00, 2000.00, 'Bajaj'),
(408, 'Iron Box', 'Electronics', 1599.00, 1499.00, 1200.00, 'Philips'),
(409, 'Mobile Charger', 'Electronics', 799.00, 750.00, 600.00, 'Realme'),
(410, 'Smart Watch', 'Electronics', 2999.00, 2799.00, 2200.00, 'Noise');

-- INSERTS: customer_dim (30 rows)
INSERT INTO customer_dim (customer_id, customer_fullname, gender, age_group, city, membership_type) VALUES
(1, 'Aditya Patil', 'Male', '18-25', 'Nanded', 'D-Mart Ready'),
(2, 'Rohit Deshmukh', 'Male', '18-25', 'Pune', 'Normal'),
(3, 'Sneha Kulkarni', 'Female', '18-25', 'Mumbai', 'D-Mart Ready'),
(4, 'Amit Jadhav', 'Male', '26-35', 'Nagpur', 'Normal'),
(5, 'Priya Sharma', 'Female', '26-35', 'Pune', 'Premium'),
(6, 'Neha Patil', 'Female', '18-25', 'Nashik', 'Normal'),
(7, 'Saurabh More', 'Male', '26-35', 'Aurangabad', 'D-Mart Ready'),
(8, 'Kunal Joshi', 'Male', '18-25', 'Mumbai', 'Normal'),
(9, 'Riya Singh', 'Female', '18-25', 'Thane', 'Premium'),
(10, 'Vikas Pawar', 'Male', '36-45', 'Nanded', 'Normal'),
(11, 'Anjali Deshpande', 'Female', '26-35', 'Nagpur', 'D-Mart Ready'),
(12, 'Rahul Mehta', 'Male', '26-35', 'Mumbai', 'Premium'),
(13, 'Pooja Chavan', 'Female', '18-25', 'Pune', 'Normal'),
(14, 'Siddharth Kale', 'Male', '18-25', 'Nashik', 'Normal'),
(15, 'Komal Patil', 'Female', '26-35', 'Aurangabad', 'D-Mart Ready'),
(16, 'Yash Shinde', 'Male', '18-25', 'Thane', 'Normal'),
(17, 'Shubham Koli', 'Male', '26-35', 'Mumbai', 'Normal'),
(18, 'Mansi Deshmukh', 'Female', '18-25', 'Pune', 'D-Mart Ready'),
(19, 'Akash Patil', 'Male', '26-35', 'Nagpur', 'Premium'),
(20, 'Isha Kulkarni', 'Female', '18-25', 'Nanded', 'Normal'),
(21, 'Tejas Jadhav', 'Male', '36-45', 'Mumbai', 'D-Mart Ready'),
(22, 'Meera Joshi', 'Female', '26-35', 'Pune', 'Premium'),
(23, 'Nikhil Pawar', 'Male', '18-25', 'Aurangabad', 'Normal'),
(24, 'Rashmi Patil', 'Female', '36-45', 'Nashik', 'Normal'),
(25, 'Swapnil More', 'Male', '26-35', 'Thane', 'D-Mart Ready'),
(26, 'Ayesha Khan', 'Female', '18-25', 'Mumbai', 'Normal'),
(27, 'Harsh Sharma', 'Male', '18-25', 'Pune', 'Normal'),
(28, 'Tanvi Singh', 'Female', '26-35', 'Nagpur', 'Premium'),
(29, 'Ramesh Chavan', 'Male', '46-60', 'Nanded', 'Normal'),
(30, 'Kavya Mehta', 'Female', '18-25', 'Mumbai', 'D-Mart Ready');

-- INSERTS: store_dim (7 rows)
INSERT INTO store_dim (store_id, store_name, city, state, store_size) VALUES
(1, 'D-Mart Nanded', 'Nanded', 'Maharashtra', 'Medium'),
(2, 'D-Mart Pune', 'Pune', 'Maharashtra', 'Large'),
(3, 'D-Mart Mumbai', 'Mumbai', 'Maharashtra', 'Large'),
(4, 'D-Mart Nagpur', 'Nagpur', 'Maharashtra', 'Medium'),
(5, 'D-Mart Nashik', 'Nashik', 'Maharashtra', 'Medium'),
(6, 'D-Mart Aurangabad', 'Aurangabad', 'Maharashtra', 'Small'),
(7, 'D-Mart Thane', 'Thane', 'Maharashtra', 'Large');

-- INSERTS: date_dim (18 rows)
INSERT INTO date_dim (date_id, full_date, day, month, year, quarter, day_name, is_weekend) VALUES
(1, '2026-01-01', 1, 1, 2026, 'Q1', 'Thursday', 'No'),
(2, '2026-01-05', 5, 1, 2026, 'Q1', 'Monday', 'No'),
(3, '2026-01-10', 10, 1, 2026, 'Q1', 'Saturday', 'Yes'),
(4, '2026-01-15', 15, 1, 2026, 'Q1', 'Thursday', 'No'),
(5, '2026-01-20', 20, 1, 2026, 'Q1', 'Tuesday', 'No'),
(6, '2026-01-25', 25, 1, 2026, 'Q1', 'Sunday', 'Yes'),
(7, '2026-02-01', 1, 2, 2026, 'Q1', 'Sunday', 'Yes'),
(8, '2026-02-05', 5, 2, 2026, 'Q1', 'Thursday', 'No'),
(9, '2026-02-10', 10, 2, 2026, 'Q1', 'Tuesday', 'No'),
(10, '2026-02-14', 14, 2, 2026, 'Q1', 'Saturday', 'Yes'),
(11, '2026-02-18', 18, 2, 2026, 'Q1', 'Wednesday', 'No'),
(12, '2026-02-25', 25, 2, 2026, 'Q1', 'Wednesday', 'No'),
(13, '2026-03-01', 1, 3, 2026, 'Q1', 'Sunday', 'Yes'),
(14, '2026-03-05', 5, 3, 2026, 'Q1', 'Thursday', 'No'),
(15, '2026-03-10', 10, 3, 2026, 'Q1', 'Tuesday', 'No'),
(16, '2026-03-15', 15, 3, 2026, 'Q1', 'Sunday', 'Yes'),
(17, '2026-03-20', 20, 3, 2026, 'Q1', 'Friday', 'No'),
(18, '2026-03-25', 25, 3, 2026, 'Q1', 'Wednesday', 'No');

-- INSERTS: payment_dim (7 rows)
INSERT INTO payment_dim (payment_id, payment_method, provider) VALUES
(1, 'Cash', 'NA'),
(2, 'UPI', 'PhonePe'),
(3, 'UPI', 'Google Pay'),
(4, 'UPI', 'Paytm'),
(5, 'Card', 'HDFC Bank'),
(6, 'Card', 'SBI Bank'),
(7, 'Card', 'ICICI Bank');

-- INSERTS: sales_fact (50 sample transactions)
INSERT INTO sales_fact 
(sale_id, date_id, product_id, customer_id, store_id, payment_id, quantity_sold, discount_amount, total_amount, profit) 
VALUES
(1, 1, 101, 1, 2, 2, 2, 40, 1200, 80),
(2, 1, 201, 2, 2, 3, 1, 10, 289, 39),
(3, 2, 107, 3, 3, 4, 3, 20, 460, 40),
(4, 2, 303, 4, 3, 5, 1, 50, 700, 50),
(5, 3, 404, 5, 1, 2, 4, 20, 500, 100),
(6, 3, 115, 6, 1, 1, 5, 10, 265, 40),
(7, 4, 205, 7, 4, 6, 2, 30, 410, 30),
(8, 4, 310, 8, 4, 7, 1, 100, 2200, 400),
(9, 5, 109, 9, 5, 3, 2, 20, 320, 20),
(10, 5, 402, 10, 5, 5, 1, 50, 1349, 249),
(11, 6, 210, 11, 6, 4, 3, 15, 210, 45),
(12, 6, 304, 12, 6, 2, 2, 30, 670, 170),
(13, 7, 108, 13, 7, 3, 1, 20, 610, 30),
(14, 7, 401, 14, 7, 5, 2, 100, 2298, 498),
(15, 8, 202, 15, 2, 1, 2, 20, 200, 20),
(16, 8, 114, 16, 2, 2, 6, 15, 255, 45),
(17, 9, 309, 17, 3, 7, 1, 200, 1650, 150),
(18, 9, 111, 18, 3, 3, 3, 30, 300, 15),
(19, 10, 405, 19, 4, 6, 1, 50, 400, 50),
(20, 10, 215, 20, 4, 1, 2, 40, 520, 80),
(21, 11, 105, 21, 5, 4, 2, 20, 500, 40),
(22, 11, 212, 22, 5, 2, 1, 10, 110, 15),
(23, 12, 403, 23, 6, 5, 3, 30, 720, 180),
(24, 12, 302, 24, 6, 6, 1, 100, 1299, 199),
(25, 13, 102, 25, 7, 3, 1, 20, 379, 29),
(26, 13, 204, 26, 7, 4, 2, 30, 368, 28),
(27, 14, 406, 27, 2, 5, 1, 50, 900, 150),
(28, 14, 301, 28, 2, 1, 2, 40, 860, 160),
(29, 15, 110, 29, 3, 2, 4, 40, 560, 20),
(30, 15, 409, 30, 3, 7, 2, 100, 1400, 200),
(31, 16, 203, 1, 4, 4, 2, 20, 178, 18),
(32, 16, 307, 2, 4, 6, 1, 50, 500, 0),
(33, 17, 113, 3, 5, 3, 2, 20, 378, 40),
(34, 17, 410, 4, 5, 5, 1, 200, 2599, 399),
(35, 18, 208, 5, 6, 2, 3, 15, 240, 30),
(36, 18, 308, 6, 6, 1, 2, 20, 480, 120),
(37, 2, 104, 7, 7, 3, 5, 5, 105, 15),
(38, 3, 106, 8, 2, 4, 2, 10, 330, 30),
(39, 4, 214, 9, 3, 2, 4, 20, 120, 20),
(40, 5, 407, 10, 4, 7, 1, 100, 2299, 299),
(41, 6, 103, 11, 5, 1, 2, 10, 450, 50),
(42, 7, 112, 12, 6, 2, 3, 15, 210, 15),
(43, 8, 213, 13, 7, 4, 2, 10, 170, 30),
(44, 9, 305, 14, 2, 5, 1, 50, 600, 100),
(45, 10, 408, 15, 3, 6, 1, 100, 1399, 199),
(46, 11, 209, 16, 4, 3, 2, 20, 300, 40),
(47, 12, 306, 17, 5, 2, 3, 30, 510, 150),
(48, 13, 211, 18, 6, 4, 1, 10, 100, 10),
(49, 14, 202, 19, 7, 1, 4, 40, 400, 40),
(50, 15, 114, 20, 2, 3, 5, 10, 215, 40);
-- END OF DATA

-- QUICK CHECKS
SELECT COUNT(*) AS product_count FROM product_dim;
SELECT COUNT(*) AS customer_count FROM customer_dim;
SELECT COUNT(*) AS store_count FROM store_dim;
SELECT COUNT(*) AS date_count FROM date_dim;
SELECT COUNT(*) AS payment_count FROM payment_dim;
SELECT COUNT(*) AS sales_count FROM sales_fact;

-- SAMPLE ANALYTICS QUERIES (run these after inserts)
-- Total Revenue
SELECT SUM(total_amount) AS total_revenue FROM sales_fact;

-- Total Profit
SELECT SUM(profit) AS total_profit FROM sales_fact;

-- Monthly Revenue
SELECT d.month, d.year, SUM(f.total_amount) AS monthly_revenue
FROM sales_fact f
JOIN date_dim d ON f.date_id = d.date_id
GROUP BY d.year, d.month
ORDER BY d.year, d.month;

-- Top 5 Products by revenue
SELECT p.product_name, SUM(f.total_amount) AS revenue
FROM sales_fact f
JOIN product_dim p ON f.product_id = p.product_id
GROUP BY p.product_name
ORDER BY revenue DESC
LIMIT 5;

-- Category-wise Revenue
SELECT p.product_category, SUM(f.total_amount) AS revenue
FROM sales_fact f
JOIN product_dim p ON f.product_id = p.product_id
GROUP BY p.product_category
ORDER BY revenue DESC;

-- Store-wise Revenue
SELECT s.store_name, SUM(f.total_amount) AS revenue
FROM sales_fact f
JOIN store_dim s ON f.store_id = s.store_id
GROUP BY s.store_name
ORDER BY revenue DESC;

-- Membership Type Revenue
SELECT c.membership_type, SUM(f.total_amount) AS revenue
FROM sales_fact f
JOIN customer_dim c ON f.customer_id = c.customer_id
GROUP BY c.membership_type
ORDER BY revenue DESC;

-- Payment method usage
SELECT p.payment_method, COUNT(*) AS total_transactions
FROM sales_fact f
JOIN payment_dim p ON f.payment_id = p.payment_id
GROUP BY p.payment_method
ORDER BY total_transactions DESC;

-- Full joined report (use for screenshots)
SELECT 
    f.sale_id,
    d.full_date,
    p.product_name,
    p.product_category,
    c.customer_fullname,
    c.city AS customer_city,
    s.store_name,
    pay.payment_method,
    pay.provider,
    f.quantity_sold,
    f.discount_amount,
    f.total_amount,
    f.profit
FROM sales_fact f
JOIN date_dim d ON f.date_id = d.date_id
JOIN product_dim p ON f.product_id = p.product_id
JOIN customer_dim c ON f.customer_id = c.customer_id
JOIN store_dim s ON f.store_id = s.store_id
JOIN payment_dim pay ON f.payment_id = pay.payment_id
ORDER BY f.sale_id;

-- End of script
