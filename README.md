# Complete Expense Manager

A comprehensive expense and income tracking web application built with JSP, JDBC, and MySQL.

## Features

### 🔐 User Authentication
- User registration with email validation
- Secure login with SHA-256 password hashing
- Session management for logged-in users
- Multi-user support with data isolation

### 💰 Expense & Income Management
- Add, edit, and delete expense entries
- Add, edit, and delete income entries
- Categorized transactions (Food, Transport, Job, Freelance, etc.)
- Date-based transaction tracking

### 📊 Dashboard & Reports
- Real-time dashboard with financial summary
- Total income, expenses, and net balance calculation
- Recent transactions overview
- Comprehensive transaction reports with filtering
- Running balance calculation
- Date range and category filtering
- CSV export functionality

### 🎨 Modern UI
- Responsive design with mobile support
- Clean and intuitive interface
- Color-coded transaction types
- Professional styling with CSS Grid and Flexbox

## Setup Instructions

### 1. Prerequisites
- Java 11 or higher
- Maven 3.6+
- MySQL 8.0+
- Apache Tomcat 9.0+

### 2. Database Setup
1. Install MySQL server
2. Create the database and tables:
   ```bash
   mysql -u root -p < database_setup.sql
   ```
3. Update database credentials in `src/main/java/com/expense/util/DatabaseConnection.java`:
   ```java
   private static final String URL = "jdbc:mysql://localhost:3306/expense_db";
   private static final String USERNAME = "your_username";
   private static final String PASSWORD = "your_password";
   ```

### 3. Build and Deploy
1. Clone or download the project
2. Build the project:
   ```bash
   mvn clean package
   ```
3. Deploy the generated WAR file:
   ```bash
   cp target/expense-manager-1.0.0.war $TOMCAT_HOME/webapps/
   ```
4. Start Tomcat server
5. Access the application at: `http://localhost:8080/expense-manager-1.0.0`

### 4. Default Login
- Username: `demo`
- Password: `password123`

## Project Structure
```
src/
├── main/
│   ├── java/
│   │   └── com/expense/
│   │       ├── dao/
│   │       │   ├── UserDAO.java
│   │       │   ├── ExpenseDAO.java
│   │       │   └── IncomeDAO.java
│   │       ├── model/
│   │       │   ├── User.java
│   │       │   ├── Expense.java
│   │       │   └── Income.java
│   │       └── util/
│   │           └── DatabaseConnection.java
│   └── webapp/
│       ├── css/
│       │   └── style.css
│       ├── WEB-INF/
│       │   └── web.xml
│       ├── dashboard.jsp
│       ├── expenses.jsp
│       ├── income.jsp
│       ├── reports.jsp
│       ├── login.jsp
│       ├── register.jsp
│       ├── export.jsp
│       ├── logout.jsp
│       └── index.jsp
├── database_setup.sql
└── pom.xml
```

## Database Schema

### Users Table
- `id` (Primary Key)
- `username` (Unique)
- `email` (Unique)
- `password_hash`
- `created_at`

### Expenses Table
- `id` (Primary Key)
- `user_id` (Foreign Key)
- `description`
- `amount`
- `category`
- `date`
- `created_at`

### Income Table
- `id` (Primary Key)
- `user_id` (Foreign Key)
- `description`
- `amount`
- `category`
- `date`
- `created_at`

## Usage Guide

1. **Registration**: Create a new account with username, email, and password
2. **Login**: Access your personal dashboard
3. **Dashboard**: View financial summary and recent transactions
4. **Add Transactions**: Use Expenses or Income pages to add new entries
5. **Edit/Delete**: Modify or remove existing transactions
6. **Reports**: View detailed reports with filtering options
7. **Export**: Download transaction data as CSV

## Security Features
- Password hashing using SHA-256
- SQL injection prevention with PreparedStatements
- Session-based authentication
- User data isolation
- Input validation and sanitization

## Technologies Used
- **Backend**: Java, JSP, JDBC
- **Database**: MySQL
- **Frontend**: HTML5, CSS3, JavaScript
- **Build Tool**: Maven
- **Server**: Apache Tomcat

## Contributing
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License
This project is open source and available under the MIT License.