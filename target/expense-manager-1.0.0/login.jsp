<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.expense.dao.UserDAO, com.expense.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Login - ExpenseManager</title>
    <%@ include file="components/modern-head.jsp" %>
</head>
<body class="min-h-screen bg-gradient-to-br from-indigo-50 via-white to-cyan-50">
<div class="min-h-screen flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
    <div class="max-w-md w-full space-y-8" x-data="{ showPassword: false, isLoading: false }">
        <!-- Logo and Header -->
        <div class="text-center animate-fade-in-up">
            <div class="mx-auto h-16 w-16 bg-gradient-to-r from-indigo-500 to-purple-600 rounded-2xl flex items-center justify-center mb-6 shadow-lg">
                <span class="text-white text-2xl font-bold">💰</span>
            </div>
            <h2 class="text-3xl font-bold text-gray-900 mb-2">Welcome back</h2>
            <p class="text-gray-600">Sign in to your ExpenseManager account</p>
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

        <!-- Alert Message -->
        <% if (!message.isEmpty()) { %>
        <div class="bg-red-50 border border-red-200 text-red-800 px-4 py-3 rounded-lg flex items-center space-x-3 animate-fade-in-up">
            <svg class="w-5 h-5 text-red-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
            </svg>
            <span><%= message %></span>
        </div>
        <% } %>

        <!-- Login Form -->
        <div class="bg-white rounded-2xl shadow-xl border border-gray-200 p-8 animate-fade-in-up" style="animation-delay: 0.1s">
            <form method="post" @submit="isLoading = true" class="space-y-6">
                <!-- Username Field -->
                <div class="space-y-2">
                    <label for="username" class="block text-sm font-medium text-gray-700">
                        Username <span class="text-red-500">*</span>
                    </label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                            <svg class="w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                            </svg>
                        </div>
                        <input type="text"
                               id="username"
                               name="username"
                               required
                               class="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition-colors duration-200 bg-white"
                               placeholder="Enter your username">
                    </div>
                </div>

                <!-- Password Field -->
                <div class="space-y-2">
                    <label for="password" class="block text-sm font-medium text-gray-700">
                        Password <span class="text-red-500">*</span>
                    </label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                            <svg class="w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/>
                            </svg>
                        </div>
                        <input :type="showPassword ? 'text' : 'password'"
                               id="password"
                               name="password"
                               required
                               class="w-full pl-10 pr-12 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition-colors duration-200 bg-white"
                               placeholder="Enter your password">
                        <button type="button"
                                @click="showPassword = !showPassword"
                                class="absolute inset-y-0 right-0 pr-3 flex items-center">
                            <svg x-show="!showPassword" class="w-5 h-5 text-gray-400 hover:text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
                            </svg>
                            <svg x-show="showPassword" class="w-5 h-5 text-gray-400 hover:text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.878 9.878L3 3m6.878 6.878L21 21"/>
                            </svg>
                        </button>
                    </div>
                </div>

                <!-- Submit Button -->
                <button type="submit"
                        :disabled="isLoading"
                        class="w-full bg-gradient-to-r from-indigo-600 to-purple-600 hover:from-indigo-700 hover:to-purple-700 text-white font-medium py-3 px-4 rounded-lg transition-all duration-200 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2 shadow-lg hover:shadow-xl transform hover:-translate-y-0.5 disabled:opacity-50 disabled:cursor-not-allowed disabled:transform-none">
                        <span x-show="!isLoading" class="flex items-center justify-center">
                            <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 16l-4-4m0 0l4-4m-4 4h14m-5 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h7a3 3 0 013 3v1"/>
                            </svg>
                            Sign In
                        </span>
                    <span x-show="isLoading" class="flex items-center justify-center">
                            <svg class="animate-spin -ml-1 mr-3 h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                            </svg>
                            Signing in...
                        </span>
                </button>
            </form>

            <!-- Register Link -->
            <div class="mt-6 text-center">
                <p class="text-sm text-gray-600">
                    Don't have an account?
                    <a href="register.jsp" class="font-medium text-indigo-600 hover:text-indigo-500 transition-colors duration-200">
                        Create one here
                    </a>
                </p>
            </div>
        </div>

        <!-- Demo Account Info -->
        <div class="bg-blue-50 border border-blue-200 rounded-xl p-4 animate-fade-in-up" style="animation-delay: 0.2s">
            <div class="flex items-start space-x-3">
                <svg class="w-5 h-5 text-blue-400 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
                <div>
                    <h4 class="text-sm font-medium text-blue-800 mb-1">Demo Account</h4>
                    <div class="text-sm text-blue-700 space-y-1">
                        <p><strong>Username:</strong> <code class="bg-blue-100 px-2 py-0.5 rounded">demo</code></p>
                        <p><strong>Password:</strong> <code class="bg-blue-100 px-2 py-0.5 rounded">password123</code></p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Background Pattern -->
<div class="fixed inset-0 -z-10 overflow-hidden">
    <div class="absolute -top-40 -right-32 w-80 h-80 bg-gradient-to-br from-purple-400 to-indigo-600 rounded-full opacity-10 blur-3xl"></div>
    <div class="absolute -bottom-40 -left-32 w-80 h-80 bg-gradient-to-tr from-cyan-400 to-blue-600 rounded-full opacity-10 blur-3xl"></div>
</div>

<script>
    // Auto-fill demo credentials on demo button click
    function fillDemo() {
        document.getElementById('username').value = 'demo';
        document.getElementById('password').value = 'password123';
    }

    // Add demo button click handler
    document.addEventListener('DOMContentLoaded', function() {
        const demoSection = document.querySelector('.bg-blue-50');
        if (demoSection) {
            demoSection.style.cursor = 'pointer';
            demoSection.addEventListener('click', fillDemo);
            demoSection.title = 'Click to auto-fill demo credentials';
        }
    });
</script>
</body>
</html>