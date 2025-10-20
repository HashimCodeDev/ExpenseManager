<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.expense.model.User, com.expense.dao.*, java.util.*" %>
<%
User user = (User) session.getAttribute("user");
if (user == null) {
    response.sendRedirect("login.jsp");
    return;
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Dashboard - ExpenseManager</title>
    <%@ include file="components/modern-head.jsp" %>
</head>
<body class="bg-gray-50 min-h-screen">
    <%@ include file="components/modern-nav.jsp" %>
    
    <main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div class="mb-8 animate-fade-in-up">
            <h1 class="text-3xl font-bold text-gray-900 mb-2">Welcome back, <%= user.getUsername() %>! 👋</h1>
            <p class="text-gray-600">Here's your financial overview for today.</p>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8" x-data="{ animateCards: false }" x-init="setTimeout(() => animateCards = true, 100)">
            <%
            ExpenseDAO expenseDAO = new ExpenseDAO();
            IncomeDAO incomeDAO = new IncomeDAO();
            double totalExpenses = expenseDAO.getTotalExpenses(user.getId());
            double totalIncome = incomeDAO.getTotalIncome(user.getId());
            double netBalance = totalIncome - totalExpenses;
            %>
            
            <div class="bg-gradient-to-r from-green-500 to-green-600 rounded-xl p-6 text-white shadow-lg hover:shadow-xl transition-all duration-300 transform hover:-translate-y-1"
                 :class="animateCards ? 'animate-fade-in-up' : 'opacity-0'">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-green-100 text-sm font-medium">Total Income</p>
                        <p class="text-3xl font-bold">$<%= String.format("%.2f", totalIncome) %></p>
                    </div>
                    <div class="bg-white/20 p-3 rounded-lg">
                        <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1"/>
                        </svg>
                    </div>
                </div>
            </div>

            <div class="bg-gradient-to-r from-red-500 to-red-600 rounded-xl p-6 text-white shadow-lg hover:shadow-xl transition-all duration-300 transform hover:-translate-y-1"
                 :class="animateCards ? 'animate-fade-in-up' : 'opacity-0'" style="animation-delay: 0.1s">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-red-100 text-sm font-medium">Total Expenses</p>
                        <p class="text-3xl font-bold">$<%= String.format("%.2f", totalExpenses) %></p>
                    </div>
                    <div class="bg-white/20 p-3 rounded-lg">
                        <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 9V7a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2m2 4h10a2 2 0 002-2v-6a2 2 0 00-2-2H9a2 2 0 00-2 2v6a2 2 0 002 2zm7-5a2 2 0 11-4 0 2 2 0 014 0z"/>
                        </svg>
                    </div>
                </div>
            </div>

            <div class="bg-gradient-to-r from-<%= netBalance >= 0 ? "blue-500 to-blue-600" : "orange-500 to-orange-600" %> rounded-xl p-6 text-white shadow-lg hover:shadow-xl transition-all duration-300 transform hover:-translate-y-1"
                 :class="animateCards ? 'animate-fade-in-up' : 'opacity-0'" style="animation-delay: 0.2s">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-white/80 text-sm font-medium">Net Balance</p>
                        <p class="text-3xl font-bold">$<%= String.format("%.2f", netBalance) %></p>
                    </div>
                    <div class="bg-white/20 p-3 rounded-lg">
                        <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="<%= netBalance >= 0 ? "M13 7h8m0 0v8m0-8l-8 8-4-4-6 6" : "M13 17h8m0 0V9m0 8l-8-8-4 4-6-6" %>"/>
                        </svg>
                    </div>
                </div>
            </div>
        </div>

        <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6 mb-8 animate-fade-in-up" style="animation-delay: 0.3s">
            <h2 class="text-xl font-semibold text-gray-900 mb-4">Quick Actions</h2>
            <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
                <a href="expenses.jsp?action=add" 
                   class="flex items-center justify-center p-4 bg-red-50 hover:bg-red-100 border border-red-200 rounded-lg transition-colors duration-200 group">
                    <svg class="w-5 h-5 text-red-600 mr-3 group-hover:scale-110 transition-transform duration-200" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"/>
                    </svg>
                    <span class="text-red-700 font-medium">Add Expense</span>
                </a>
                <a href="income.jsp?action=add" 
                   class="flex items-center justify-center p-4 bg-green-50 hover:bg-green-100 border border-green-200 rounded-lg transition-colors duration-200 group">
                    <svg class="w-5 h-5 text-green-600 mr-3 group-hover:scale-110 transition-transform duration-200" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"/>
                    </svg>
                    <span class="text-green-700 font-medium">Add Income</span>
                </a>
                <a href="reports.jsp" 
                   class="flex items-center justify-center p-4 bg-blue-50 hover:bg-blue-100 border border-blue-200 rounded-lg transition-colors duration-200 group">
                    <svg class="w-5 h-5 text-blue-600 mr-3 group-hover:scale-110 transition-transform duration-200" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"/>
                    </svg>
                    <span class="text-blue-700 font-medium">View Reports</span>
                </a>
            </div>
        </div>

        <div class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden animate-fade-in-up" style="animation-delay: 0.4s">
            <div class="px-6 py-4 border-b border-gray-200 bg-gray-50">
                <div class="flex items-center justify-between">
                    <h3 class="text-lg font-semibold text-gray-900">Recent Transactions</h3>
                    <a href="reports.jsp" class="text-indigo-600 hover:text-indigo-700 text-sm font-medium">View All</a>
                </div>
            </div>
            <div class="p-6">
                <% 
                List<Map<String, Object>> recentTransactions = new ArrayList<>();
                
                List<com.expense.model.Expense> expenses = expenseDAO.getExpensesByUser(user.getId());
                for (int i = 0; i < Math.min(5, expenses.size()); i++) {
                    com.expense.model.Expense exp = expenses.get(i);
                    Map<String, Object> transaction = new HashMap<>();
                    transaction.put("date", exp.getDate());
                    transaction.put("description", exp.getDescription());
                    transaction.put("category", exp.getCategory());
                    transaction.put("type", "Expense");
                    transaction.put("amount", -exp.getAmount());
                    recentTransactions.add(transaction);
                }
                
                List<com.expense.model.Income> incomes = incomeDAO.getIncomeByUser(user.getId());
                for (int i = 0; i < Math.min(5, incomes.size()); i++) {
                    com.expense.model.Income inc = incomes.get(i);
                    Map<String, Object> transaction = new HashMap<>();
                    transaction.put("date", inc.getDate());
                    transaction.put("description", inc.getDescription());
                    transaction.put("category", inc.getCategory());
                    transaction.put("type", "Income");
                    transaction.put("amount", inc.getAmount());
                    recentTransactions.add(transaction);
                }
                
                recentTransactions.sort((a, b) -> ((java.sql.Date)b.get("date")).compareTo((java.sql.Date)a.get("date")));
                
                if (recentTransactions.isEmpty()) {
                %>
                    <div class="text-center py-12">
                        <svg class="w-16 h-16 text-gray-300 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"/>
                        </svg>
                        <h3 class="text-lg font-medium text-gray-900 mb-2">No transactions yet</h3>
                        <p class="text-gray-500 mb-6">Start by adding your first income or expense entry.</p>
                        <div class="flex justify-center space-x-4">
                            <a href="expenses.jsp?action=add" class="bg-red-600 hover:bg-red-700 text-white px-4 py-2 rounded-lg font-medium transition-colors duration-200">
                                Add Expense
                            </a>
                            <a href="income.jsp?action=add" class="bg-green-600 hover:bg-green-700 text-white px-4 py-2 rounded-lg font-medium transition-colors duration-200">
                                Add Income
                            </a>
                        </div>
                    </div>
                <% } else { %>
                    <div class="overflow-x-auto">
                        <table class="w-full">
                            <thead>
                                <tr class="border-b border-gray-200">
                                    <th class="text-left py-3 px-4 font-medium text-gray-700">Date</th>
                                    <th class="text-left py-3 px-4 font-medium text-gray-700">Description</th>
                                    <th class="text-left py-3 px-4 font-medium text-gray-700">Category</th>
                                    <th class="text-left py-3 px-4 font-medium text-gray-700">Type</th>
                                    <th class="text-right py-3 px-4 font-medium text-gray-700">Amount</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-gray-200">
                                <%
                                for (int i = 0; i < Math.min(10, recentTransactions.size()); i++) {
                                    Map<String, Object> transaction = recentTransactions.get(i);
                                    double amount = (Double) transaction.get("amount");
                                    boolean isIncome = transaction.get("type").toString().equals("Income");
                                %>
                                <tr class="hover:bg-gray-50 transition-colors duration-200">
                                    <td class="py-3 px-4 text-sm text-gray-900"><%= transaction.get("date") %></td>
                                    <td class="py-3 px-4 text-sm text-gray-900"><%= transaction.get("description") %></td>
                                    <td class="py-3 px-4">
                                        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium <%= isIncome ? "bg-green-100 text-green-800" : "bg-red-100 text-red-800" %>">
                                            <%= transaction.get("category") %>
                                        </span>
                                    </td>
                                    <td class="py-3 px-4">
                                        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium <%= isIncome ? "bg-green-100 text-green-800" : "bg-red-100 text-red-800" %>">
                                            <%= transaction.get("type") %>
                                        </span>
                                    </td>
                                    <td class="py-3 px-4 text-sm font-medium text-right <%= amount >= 0 ? "text-green-600" : "text-red-600" %>">
                                        <%= amount >= 0 ? "+" : "" %>$<%= String.format("%.2f", Math.abs(amount)) %>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } %>
            </div>
        </div>
    </main>
</body>
</html>