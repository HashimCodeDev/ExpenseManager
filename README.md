# Simple Expense Manager

A basic expense tracking application built with JSP and JDBC.

## Features
- Add new expenses with description, amount, category, and date
- View recent expenses in a table format
- Calculate total expenses
- Simple and clean interface

## Setup Instructions

### 1. Database Setup
1. Install MySQL server
2. Run the SQL script: `mysql -u root -p < database_setup.sql`
3. Update database credentials in `DatabaseConnection.java` if needed

### 2. Build and Deploy
1. Ensure you have Maven and Java 11+ installed
2. Build the project: `mvn clean package`
3. Deploy the generated WAR file to Tomcat server
4. Access the application at: `http://localhost:8080/expense-manager`

### 3. Configuration
- Update database URL, username, and password in `DatabaseConnection.java`
- Default credentials: root/password for localhost MySQL

## Project Structure
```
src/
├── main/
│   ├── java/
│   │   └── com/expense/
│   │       ├── model/Expense.java
│   │       └── util/DatabaseConnection.java
│   └── webapp/
│       ├── WEB-INF/web.xml
│       ├── css/style.css
│       └── index.jsp
├── database_setup.sql
└── pom.xml
```