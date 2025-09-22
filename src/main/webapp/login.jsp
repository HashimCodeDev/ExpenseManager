<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.expense.dao.UserDAO, com.expense.model.User" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login - Expense Manager</title>
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
            background: linear-gradient(135deg, var(--primary), var(--info));
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
        .demo-info {
            margin-top: 30px;
            padding: 20px;
            background: linear-gradient(135deg, rgba(99, 102, 241, 0.05), rgba(6, 182, 212, 0.05));
            border: 1px solid rgba(99, 102, 241, 0.1);
            border-radius: var(--border-radius-sm);
            font-size: 0.9rem;
            color: var(--gray-dark);
        }
    </style>
</head>
<body>
    <div class="background-pattern"></div>
    <div class="auth-container">
        <div style="margin-bottom: 32px;">
            <div style="width: 80px; height: 80px; background: linear-gradient(135deg, var(--primary), var(--info)); border-radius: 50%; margin: 0 auto 20px; display: flex; align-items: center; justify-content: center; color: white; font-size: 2rem; font-weight: bold;">💰</div>
            <h1>Welcome Back</h1>
            <p>Sign in to your account</p>
        </div>
        
        <%
        String message = "";
        if ("POST".equals(request.getMethod())) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            
            if (username != null && password != null) {
                UserDAO userDAO = new UserDAO();
                User user = userDAO.loginUser(username, password);
                
                if (user != null) {
                    session.setAttribute("user", user);
                    response.sendRedirect("dashboard.jsp");
                    return;
                } else {
                    message = "Invalid username or password";
                }
            }
        }
        %>
        
        <% if (!message.isEmpty()) { %>
            <div class="alert alert-danger"><%= message %></div>
        <% } %>
        
        <form method="post">
            <div class="form-group">
                <input type="text" name="username" class="form-control" placeholder="Enter your username" required>
            </div>
            <div class="form-group">
                <input type="password" name="password" class="form-control" placeholder="Enter your password" required>
            </div>
            <button type="submit" class="btn btn-primary" style="width: 100%; padding: 16px; font-weight: 600;">Sign In</button>
        </form>
        
        <p style="margin-top: 24px;">Don't have an account? <a href="register.jsp">Create one here</a></p>
        
        <div class="demo-info">
            <strong>Demo Account:</strong><br>
            Username: demo<br>
            Password: password123
        </div>
    </div>
</body>
</html>