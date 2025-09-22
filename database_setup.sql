-- Create database
CREATE DATABASE IF NOT EXISTS expense_db;
USE expense_db;

-- Create users table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create expenses table
CREATE TABLE IF NOT EXISTS expenses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    description VARCHAR(255) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    category VARCHAR(50) NOT NULL,
    date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create income table
CREATE TABLE IF NOT EXISTS income (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    description VARCHAR(255) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    category VARCHAR(50) NOT NULL,
    date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Insert sample user (password is 'password123' hashed)
INSERT INTO users (username, email, password_hash) VALUES
('demo', 'demo@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMye1VdLSnqq3vyPfB0D9/FxeA2YfQdlHSe');

-- Insert sample data
INSERT INTO expenses (user_id, description, amount, category, date) VALUES
(1, 'Lunch at restaurant', 25.50, 'Food', '2024-01-15'),
(1, 'Bus fare', 3.00, 'Transport', '2024-01-15'),
(1, 'Movie ticket', 12.00, 'Entertainment', '2024-01-14'),
(1, 'Electricity bill', 85.00, 'Bills', '2024-01-13');

INSERT INTO income (user_id, description, amount, category, date) VALUES
(1, 'Salary', 3000.00, 'Job', '2024-01-01'),
(1, 'Freelance work', 500.00, 'Freelance', '2024-01-10'),
(1, 'Investment return', 150.00, 'Investment', '2024-01-12');