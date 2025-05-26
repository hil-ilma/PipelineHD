CREATE DATABASE IF NOT EXISTS companydb;

USE companydb;

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

INSERT INTO users (name, email) VALUES
('Hilma', 'hilma@example.com'),
('Admin', 'admin@example.com');
