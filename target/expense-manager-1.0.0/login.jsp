<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.expense.dao.UserDAO, com.expense.model.User" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login - Expense Manager</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>
    <div class="auth-container">
        <h1>Login</h1>
        
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
            <div class="error"><%= message %></div>
        <% } %>
        
        <form method="post">
            <input type="text" name="username" placeholder="Username" required>
            <input type="password" name="password" placeholder="Password" required>
            <button type="submit">Login</button>
        </form>
        
        <p><a href="register.jsp">Don't have an account? Register here</a></p>
    </div>
</body>
</html>