-- Create database
CREATE DATABASE IF NOT EXISTS expense_db;
USE expense_db;

-- Create expenses table
CREATE TABLE IF NOT EXISTS expenses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    description VARCHAR(255) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    category VARCHAR(50) NOT NULL,
    date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data
INSERT INTO expenses (description, amount, category, date) VALUES
('Lunch at restaurant', 25.50, 'Food', '2024-01-15'),
('Bus fare', 3.00, 'Transport', '2024-01-15'),
('Movie ticket', 12.00, 'Entertainment', '2024-01-14'),
('Electricity bill', 85.00, 'Bills', '2024-01-13');