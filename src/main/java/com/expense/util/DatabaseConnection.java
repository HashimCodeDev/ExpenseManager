package com.expense.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {
    private static final String URL = System.getenv("DATABASE_URL") != null ? 
        System.getenv("DATABASE_URL") : "jdbc:mysql://localhost:3306/expense_db";
    private static final String USERNAME = System.getenv("DB_USERNAME") != null ? 
        System.getenv("DB_USERNAME") : "root";
    private static final String PASSWORD = System.getenv("DB_PASSWORD") != null ? 
        System.getenv("DB_PASSWORD") : "1234";
    
    public static Connection getConnection() throws SQLException {
        try {
            if (URL.startsWith("jdbc:postgresql")) {
                Class.forName("org.postgresql.Driver");
            } else {
                Class.forName("com.mysql.cj.jdbc.Driver");
            }
            return DriverManager.getConnection(URL, USERNAME, PASSWORD);
        } catch (ClassNotFoundException e) {
            throw new SQLException("Database Driver not found", e);
        }
    }
}