-- Connect to postgres database first
\c postgres

-- Drop the database if it exists
DROP DATABASE IF EXISTS bookstore;

-- Create the database
CREATE DATABASE bookstore;

-- Connect to the database
\c bookstore

-- Drop any existing views first
DROP VIEW IF EXISTS books_sales_view;
DROP VIEW IF EXISTS customers_sales_view;
DROP VIEW IF EXISTS customers_service_view;

-- Books table
CREATE TABLE IF NOT EXISTS books (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    cost_price DECIMAL(10, 2) NOT NULL,
    stock INTEGER NOT NULL
);

-- Customers table
CREATE TABLE IF NOT EXISTS customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    credit_card VARCHAR(255)
);

-- Orders table
CREATE TABLE IF NOT EXISTS orders (
    id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(id),
    date DATE NOT NULL,
    status VARCHAR(50) NOT NULL
);

-- Order items table
CREATE TABLE IF NOT EXISTS order_items (
    id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(id),
    book_id INTEGER REFERENCES books(id),
    quantity INTEGER NOT NULL,
    price_at_order DECIMAL(10, 2) NOT NULL
);

-- Drop existing roles if they exist
DROP ROLE IF EXISTS sales_rep;
DROP ROLE IF EXISTS customer_service;
DROP ROLE IF EXISTS inventory_manager;

-- Insert sample books
INSERT INTO books (title, author, price, cost_price, stock) VALUES 
('The Great Gatsby', 'F. Scott Fitzgerald', 12.99, 5.50, 100),
('To Kill a Mockingbird', 'Harper Lee', 14.99, 6.25, 85),
('1984', 'George Orwell', 11.99, 4.75, 120),
('Pride and Prejudice', 'Jane Austen', 9.99, 3.80, 75),
('The Hobbit', 'J.R.R. Tolkien', 19.99, 8.25, 60);

-- Insert sample customers
INSERT INTO customers (name, email, phone, credit_card) VALUES 
('John Smith', 'john@example.com', '555-123-4567', 'XXXX-XXXX-XXXX-1234'),
('Jane Doe', 'jane@example.com', '555-987-6543', 'XXXX-XXXX-XXXX-5678'),
('Bob Johnson', 'bob@example.com', '555-456-7890', 'XXXX-XXXX-XXXX-9012'),
('Alice Brown', 'alice@example.com', '555-789-0123', 'XXXX-XXXX-XXXX-3456');

-- Insert sample orders
INSERT INTO orders (customer_id, date, status) VALUES 
(1, '2023-10-01', 'Completed'),
(2, '2023-10-02', 'Processing'),
(3, '2023-10-03', 'Pending'),
(4, '2023-10-04', 'Cancelled'),
(1, '2023-10-05', 'Completed');

-- Insert sample order items
INSERT INTO order_items (order_id, book_id, quantity, price_at_order) VALUES 
(1, 1, 2, 12.99),
(1, 3, 1, 11.99),
(2, 2, 1, 14.99),
(3, 5, 1, 19.99),
(4, 4, 3, 9.99),
(5, 3, 2, 11.99);

-- Enable row-level security on tables
ALTER TABLE books ENABLE ROW LEVEL SECURITY;
ALTER TABLE customers ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;

-- Create roles
CREATE ROLE sales_rep WITH LOGIN PASSWORD 'sales123';
CREATE ROLE customer_service WITH LOGIN PASSWORD 'service123';
CREATE ROLE inventory_manager WITH LOGIN PASSWORD 'inventory123';

-- Grant basic connection permissions
GRANT CONNECT ON DATABASE bookstore TO sales_rep, customer_service, inventory_manager;
GRANT USAGE ON SCHEMA public TO sales_rep, customer_service, inventory_manager;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO sales_rep, customer_service, inventory_manager;

-- SALES_REP permissions
-- Can see all book details except cost_price
-- Can see all customer data except credit_card
-- Can update book stock
CREATE VIEW books_sales_view AS 
SELECT id, title, author, price, stock FROM books;

GRANT SELECT ON books_sales_view TO sales_rep;
GRANT UPDATE (stock) ON books TO sales_rep;

CREATE VIEW customers_sales_view AS
SELECT id, name, email, phone FROM customers;

GRANT SELECT ON customers_sales_view TO sales_rep;
GRANT SELECT ON orders TO sales_rep;
GRANT SELECT ON order_items TO sales_rep;

-- CUSTOMER_SERVICE permissions
-- Can read all book details except cost_price
-- Can read customer name and email only
-- Can read and update order status
CREATE VIEW customers_service_view AS
SELECT id, name, email FROM customers;

GRANT SELECT ON books_sales_view TO customer_service;
GRANT SELECT ON customers_service_view TO customer_service;
GRANT SELECT ON orders TO customer_service;
GRANT UPDATE (status) ON orders TO customer_service;
GRANT SELECT ON order_items TO customer_service;

-- INVENTORY_MANAGER permissions
-- Can read and write all book data including cost_price
-- Cannot access customer or order data
GRANT SELECT, INSERT, UPDATE ON books TO inventory_manager;

-- Drop existing policies
DROP POLICY IF EXISTS sales_books_policy ON books;
DROP POLICY IF EXISTS sales_customers_policy ON customers;
DROP POLICY IF EXISTS sales_orders_policy ON orders;
DROP POLICY IF EXISTS sales_order_items_policy ON order_items;
DROP POLICY IF EXISTS service_books_policy ON books;
DROP POLICY IF EXISTS service_customers_policy ON customers;
DROP POLICY IF EXISTS service_orders_policy ON orders;
DROP POLICY IF EXISTS service_order_items_policy ON order_items;
DROP POLICY IF EXISTS inventory_books_policy ON books;

-- Create and apply row-level security policies
-- For sales_rep
CREATE POLICY sales_books_policy ON books 
    FOR ALL
    TO sales_rep
    USING (true);

CREATE POLICY sales_customers_policy ON customers 
    FOR SELECT
    TO sales_rep
    USING (true);

CREATE POLICY sales_orders_policy ON orders 
    FOR SELECT
    TO sales_rep
    USING (true);

CREATE POLICY sales_order_items_policy ON order_items 
    FOR SELECT
    TO sales_rep
    USING (true);

-- For customer_service
CREATE POLICY service_books_policy ON books 
    FOR SELECT
    TO customer_service
    USING (true);

CREATE POLICY service_customers_policy ON customers 
    FOR SELECT
    TO customer_service
    USING (true);

CREATE POLICY service_orders_policy ON orders 
    FOR ALL
    TO customer_service
    USING (true);

CREATE POLICY service_order_items_policy ON order_items 
    FOR SELECT
    TO customer_service
    USING (true);

-- For inventory_manager
CREATE POLICY inventory_books_policy ON books 
    FOR ALL
    TO inventory_manager
    USING (true); 