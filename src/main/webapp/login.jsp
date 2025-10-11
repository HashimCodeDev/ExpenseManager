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
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>
    <div class="background-pattern"></div>
    <div class="auth-container animate-fade-in">
        <div class="hero-icon">💰</div>
        <h1 class="mb-2" style="background: var(--gradient-primary); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; font-weight: 700; font-size: 2rem;">Welcome Back</h1>
        <p class="text-muted mb-8">Sign in to your account</p>
        
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
            <div class="alert alert-danger">❌ <%= message %></div>
        <% } %>
        
        <form method="post">
            <div class="form-group">
                <input type="text" name="username" class="form-control" placeholder="👤 Enter your username" required>
            </div>
            <div class="form-group">
                <input type="password" name="password" class="form-control" placeholder="🔒 Enter your password" required>
            </div>
            <button type="submit" class="btn btn-primary w-full btn-lg">🚀 Sign In</button>
        </form>
        
        <p class="mt-6">Don't have an account? <a href="register.jsp" class="text-primary" style="text-decoration: none; font-weight: 500;">Create one here</a></p>
        
        <div class="demo-info">
            <strong>🎯 Demo Account:</strong><br>
            Username: <code>demo</code><br>
            Password: <code>password123</code>
        </div>
    </div>
</body>
</html>