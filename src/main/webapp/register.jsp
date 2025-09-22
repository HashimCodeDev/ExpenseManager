<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.expense.dao.UserDAO" %>
<!DOCTYPE html>
<html>
<head>
    <title>Register - Expense Manager</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>
    <div class="auth-container">
        <h1>Register</h1>
        
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
            <div class="<%= message.contains("successful") ? "success" : "error" %>"><%= message %></div>
        <% } %>
        
        <form method="post">
            <input type="text" name="username" placeholder="Username" required>
            <input type="email" name="email" placeholder="Email" required>
            <input type="password" name="password" placeholder="Password" required>
            <input type="password" name="confirmPassword" placeholder="Confirm Password" required>
            <button type="submit">Register</button>
        </form>
        
        <p><a href="login.jsp">Already have an account? Login here</a></p>
    </div>
</body>
</html>