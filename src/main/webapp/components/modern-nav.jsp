<%-- Modern navigation component with mobile menu --%>
<%@ page import="com.expense.model.User" %>
<%
User navUser = (User) session.getAttribute("user");
String currentPage = request.getRequestURI();
%>

<nav class="bg-white/80 backdrop-blur-lg border-b border-gray-200 sticky top-0 z-50" x-data="{ mobileMenuOpen: false }">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center h-16">
            <!-- Logo -->
            <div class="flex items-center space-x-3">
                <div class="w-8 h-8 bg-gradient-to-r from-indigo-500 to-purple-600 rounded-lg flex items-center justify-center">
                    <span class="text-white font-bold text-sm">💰</span>
                </div>
                <h1 class="text-xl font-bold bg-gradient-to-r from-indigo-600 to-purple-600 bg-clip-text text-transparent">
                    ExpenseManager
                </h1>
            </div>

            <!-- Desktop Navigation -->
            <div class="hidden md:flex items-center space-x-1">
                <a href="dashboard.jsp" 
                   class="px-4 py-2 rounded-lg text-sm font-medium transition-all duration-200 <%= currentPage.contains("dashboard") ? "bg-indigo-100 text-indigo-700" : "text-gray-600 hover:text-indigo-600 hover:bg-gray-50" %>">
                    <span class="flex items-center space-x-2">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 7v10a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2H5a2 2 0 00-2-2z"/>
                        </svg>
                        <span>Dashboard</span>
                    </span>
                </a>
                <a href="expenses.jsp" 
                   class="px-4 py-2 rounded-lg text-sm font-medium transition-all duration-200 <%= currentPage.contains("expenses") ? "bg-red-100 text-red-700" : "text-gray-600 hover:text-red-600 hover:bg-gray-50" %>">
                    <span class="flex items-center space-x-2">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 9V7a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2m2 4h10a2 2 0 002-2v-6a2 2 0 00-2-2H9a2 2 0 00-2 2v6a2 2 0 002 2zm7-5a2 2 0 11-4 0 2 2 0 014 0z"/>
                        </svg>
                        <span>Expenses</span>
                    </span>
                </a>
                <a href="income.jsp" 
                   class="px-4 py-2 rounded-lg text-sm font-medium transition-all duration-200 <%= currentPage.contains("income") ? "bg-green-100 text-green-700" : "text-gray-600 hover:text-green-600 hover:bg-gray-50" %>">
                    <span class="flex items-center space-x-2">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1"/>
                        </svg>
                        <span>Income</span>
                    </span>
                </a>
                <a href="reports.jsp" 
                   class="px-4 py-2 rounded-lg text-sm font-medium transition-all duration-200 <%= currentPage.contains("reports") ? "bg-blue-100 text-blue-700" : "text-gray-600 hover:text-blue-600 hover:bg-gray-50" %>">
                    <span class="flex items-center space-x-2">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"/>
                        </svg>
                        <span>Reports</span>
                    </span>
                </a>
            </div>

            <!-- User Menu -->
            <div class="flex items-center space-x-4">
                <% if (navUser != null) { %>
                <div class="hidden md:flex items-center space-x-3">
                    <div class="w-8 h-8 bg-gradient-to-r from-indigo-500 to-purple-600 rounded-full flex items-center justify-center text-white text-sm font-medium">
                        <%= navUser.getUsername().substring(0, 1).toUpperCase() %>
                    </div>
                    <span class="text-sm text-gray-700">Welcome, <%= navUser.getUsername() %></span>
                    <a href="logout.jsp" 
                       class="px-3 py-1.5 bg-red-500 hover:bg-red-600 text-white text-sm font-medium rounded-lg transition-colors duration-200">
                        Logout
                    </a>
                </div>
                <% } %>

                <!-- Mobile menu button -->
                <button @click="mobileMenuOpen = !mobileMenuOpen" 
                        class="md:hidden p-2 rounded-lg text-gray-600 hover:text-gray-900 hover:bg-gray-100 transition-colors duration-200">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path x-show="!mobileMenuOpen" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"/>
                        <path x-show="mobileMenuOpen" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                    </svg>
                </button>
            </div>
        </div>

        <!-- Mobile Navigation -->
        <div x-show="mobileMenuOpen" 
             x-transition:enter="transition ease-out duration-200"
             x-transition:enter-start="opacity-0 transform -translate-y-2"
             x-transition:enter-end="opacity-100 transform translate-y-0"
             x-transition:leave="transition ease-in duration-150"
             x-transition:leave-start="opacity-100 transform translate-y-0"
             x-transition:leave-end="opacity-0 transform -translate-y-2"
             class="md:hidden border-t border-gray-200 bg-white">
            <div class="px-2 pt-2 pb-3 space-y-1">
                <a href="dashboard.jsp" class="block px-3 py-2 rounded-lg text-base font-medium <%= currentPage.contains("dashboard") ? "bg-indigo-100 text-indigo-700" : "text-gray-600 hover:text-indigo-600 hover:bg-gray-50" %>">
                    Dashboard
                </a>
                <a href="expenses.jsp" class="block px-3 py-2 rounded-lg text-base font-medium <%= currentPage.contains("expenses") ? "bg-red-100 text-red-700" : "text-gray-600 hover:text-red-600 hover:bg-gray-50" %>">
                    Expenses
                </a>
                <a href="income.jsp" class="block px-3 py-2 rounded-lg text-base font-medium <%= currentPage.contains("income") ? "bg-green-100 text-green-700" : "text-gray-600 hover:text-green-600 hover:bg-gray-50" %>">
                    Income
                </a>
                <a href="reports.jsp" class="block px-3 py-2 rounded-lg text-base font-medium <%= currentPage.contains("reports") ? "bg-blue-100 text-blue-700" : "text-gray-600 hover:text-blue-600 hover:bg-gray-50" %>">
                    Reports
                </a>
                <% if (navUser != null) { %>
                <div class="border-t border-gray-200 pt-3 mt-3">
                    <div class="flex items-center px-3 py-2">
                        <div class="w-8 h-8 bg-gradient-to-r from-indigo-500 to-purple-600 rounded-full flex items-center justify-center text-white text-sm font-medium">
                            <%= navUser.getUsername().substring(0, 1).toUpperCase() %>
                        </div>
                        <span class="ml-3 text-sm text-gray-700"><%= navUser.getUsername() %></span>
                    </div>
                    <a href="logout.jsp" class="block px-3 py-2 text-base font-medium text-red-600 hover:text-red-700 hover:bg-red-50 rounded-lg">
                        Logout
                    </a>
                </div>
                <% } %>
            </div>
        </div>
    </div>
</nav>