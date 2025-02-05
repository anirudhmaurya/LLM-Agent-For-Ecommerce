CREATE DATABASE ecommerce;

USE ecommerce;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    description TEXT,
    price DECIMAL(10, 2),
    stock_quantity INT,
    category_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2),
    status VARCHAR(20),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

CREATE TABLE payments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(10, 2),
    payment_method VARCHAR(50),
    status VARCHAR(20),
    FOREIGN KEY (order_id) REFERENCES orders(id)
);

INSERT INTO users (name, email, phone, address) 
VALUES 
('John Doe', 'john@example.com', '1234567890', '123 Main St, City, Country'),
('Jane Smith', 'jane@example.com', '9876543210', '456 Elm St, City, Country'),
('Tom Harris', 'tom@example.com', '5555555555', '789 Pine St, City, Country'),
('Alice Brown', 'alice@example.com', '6666666666', '101 Maple St, City, Country'),
('Robert Green', 'robert@example.com', '7777777777', '202 Oak St, City, Country');

INSERT INTO categories (name, description) 
VALUES 
('Electronics', 'Mobile phones, computers, gadgets, etc.'),
('Clothing', 'Men and women apparel, accessories.'),
('Home & Kitchen', 'Furniture, kitchenware, decor, etc.'),
('Books', 'Fiction, non-fiction, educational books.'),
('Beauty', 'Skincare, cosmetics, perfumes.');

INSERT INTO products (name, description, price, stock_quantity, category_id) 
VALUES 
('iPhone 13', 'Latest Apple iPhone 13', 999.99, 50, 1),
('Nike Running Shoes', 'Comfortable Nike running shoes', 79.99, 100, 2),
('Coffee Maker', 'Automatic coffee machine', 129.99, 30, 3),
('The Great Gatsby', 'Classic novel by F. Scott Fitzgerald', 10.99, 200, 4),
('Sunscreen Lotion', 'SPF 50 sunscreen for all skin types', 19.99, 150, 5);

INSERT INTO orders (user_id, total_amount, status) 
VALUES 
(1, 999.99, 'Completed'),
(2, 79.99, 'Pending'),
(3, 129.99, 'Shipped'),
(4, 10.99, 'Completed'),
(5, 19.99, 'Pending');

INSERT INTO order_items (order_id, product_id, quantity, price) 
VALUES 
(1, 1, 1, 999.99),
(2, 2, 1, 79.99),
(3, 3, 1, 129.99),
(4, 4, 1, 10.99),
(5, 5, 1, 19.99);

INSERT INTO payments (order_id, amount, payment_method, status) 
VALUES 
(1, 999.99, 'Credit Card', 'Completed'),
(2, 79.99, 'PayPal', 'Pending'),
(3, 129.99, 'Debit Card', 'Completed'),
(4, 10.99, 'Credit Card', 'Completed'),
(5, 19.99, 'PayPal', 'Pending');

SELECT * FROM users;