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
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>
    <div class="background-pattern"></div>
    <div class="auth-container animate-fade-in">
        <div class="hero-icon" style="background: var(--gradient-success);">✨</div>
        <h1 class="mb-2" style="background: var(--gradient-success); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; font-weight: 700; font-size: 2rem;">Create Account</h1>
        <p class="text-muted mb-8">Join us to manage your finances</p>
        
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
            <div class="alert <%= message.contains("successful") ? "alert-success" : "alert-danger" %>">
                <%= message.contains("successful") ? "✅" : "❌" %> <%= message %>
            </div>
        <% } %>
        
        <form method="post">
            <div class="form-group">
                <input type="text" name="username" class="form-control" placeholder="👤 Choose a username" required minlength="3">
            </div>
            <div class="form-group">
                <input type="email" name="email" class="form-control" placeholder="📧 Enter your email" required>
            </div>
            <div class="form-group">
                <input type="password" name="password" class="form-control" placeholder="🔒 Create a password" required minlength="6">
            </div>
            <div class="form-group">
                <input type="password" name="confirmPassword" class="form-control" placeholder="🔐 Confirm your password" required minlength="6">
            </div>
            <button type="submit" class="btn btn-success w-full btn-lg">✨ Create Account</button>
        </form>
        
        <p class="mt-6">Already have an account? <a href="login.jsp" class="text-primary" style="text-decoration: none; font-weight: 500;">Sign in here</a></p>
    </div>

    <script>
        // Auto-hide alerts after 5 seconds
        setTimeout(() => {
            document.querySelectorAll('.alert').forEach(alert => {
                alert.style.opacity = '0';
                alert.style.transform = 'translateY(-20px)';
                setTimeout(() => alert.remove(), 300);
            });
        }, 5000);
        
        // Password confirmation validation
        document.querySelector('form').addEventListener('submit', function(e) {
            const password = document.querySelector('input[name="password"]').value;
            const confirmPassword = document.querySelector('input[name="confirmPassword"]').value;
            
            if (password !== confirmPassword) {
                e.preventDefault();
                alert('Passwords do not match!');
            }
        });
    </script>
</body>
</html>