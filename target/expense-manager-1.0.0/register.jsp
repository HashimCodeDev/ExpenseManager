<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.expense.dao.UserDAO" %>
<!DOCTYPE html>
<html>
<head>
    <title>Register - Expense Manager</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="css/modern-style.css">
    <style>
        .auth-container {
            max-width: 400px;
            margin: 10vh auto;
            padding: 40px;
            backdrop-filter: blur(20px);
            background: var(--backdrop);
            border: 1px solid var(--glass-border);
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-xl);
            text-align: center;
        }
        .auth-container h1 {
            background: linear-gradient(135deg, var(--success), var(--success-light));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            font-weight: 700;
            font-size: 2rem;
            margin-bottom: 8px;
        }
        .auth-container p {
            color: var(--gray);
            margin-bottom: 32px;
        }
        .auth-container a {
            color: var(--primary);
            text-decoration: none;
            font-weight: 500;
        }
        .auth-container a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="background-pattern"></div>
    <div class="auth-container">
        <div style="margin-bottom: 32px;">
            <div style="width: 80px; height: 80px; background: linear-gradient(135deg, var(--success), var(--success-light)); border-radius: 50%; margin: 0 auto 20px; display: flex; align-items: center; justify-content: center; color: white; font-size: 2rem; font-weight: bold;">✨</div>
            <h1>Create Account</h1>
            <p>Join us to manage your finances</p>
        </div>
        
        <%
        String message = "";
        if ("POST".equals(request.getMethod())) {
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");
            
            if (username != null && email != null && password != null && confirmPassword != null) {
                if (!password.equals(confirmPassword)) {
                    message = "Passwords do not match";
                } else {
                    UserDAO userDAO = new UserDAO();
                    if (userDAO.registerUser(username, email, password)) {
                        message = "Registration successful! <a href='login.jsp'>Login here</a>";
                    } else {
                        message = "Registration failed. Username or email may already exist.";
                    }
                }
            }
        }
        %>
        
        <% if (!message.isEmpty()) { %>
            <div class="alert <%= message.contains("successful") ? "alert-success" : "alert-danger" %>"><%= message %></div>
        <% } %>
        
        <form method="post">
            <div class="form-group">
                <input type="text" name="username" class="form-control" placeholder="Choose a username" required>
            </div>
            <div class="form-group">
                <input type="email" name="email" class="form-control" placeholder="Enter your email" required>
            </div>
            <div class="form-group">
                <input type="password" name="password" class="form-control" placeholder="Create a password" required>
            </div>
            <div class="form-group">
                <input type="password" name="confirmPassword" class="form-control" placeholder="Confirm your password" required>
            </div>
            <button type="submit" class="btn btn-success" style="width: 100%; padding: 16px; font-weight: 600;">Create Account</button>
        </form>
        
        <p style="margin-top: 24px;">Already have an account? <a href="login.jsp">Sign in here</a></p>
    </div>
</body>
</html>