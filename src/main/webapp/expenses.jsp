<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.expense.model.*, com.expense.dao.*, java.util.*, java.sql.Date" %>
<%
User user = (User) session.getAttribute("user");
if (user == null) {
    response.sendRedirect("login.jsp");
    return;
}

ExpenseDAO expenseDAO = new ExpenseDAO();
String action = request.getParameter("action");
String message = "";

if ("POST".equals(request.getMethod())) {
    if ("add".equals(action)) {
        String description = request.getParameter("description");
        String amountStr = request.getParameter("amount");
        String category = request.getParameter("category");
        String dateStr = request.getParameter("date");
        
        if (description != null && amountStr != null && category != null && dateStr != null) {
            try {
                double amount = Double.parseDouble(amountStr);
                Date date = Date.valueOf(dateStr);
                Expense expense = new Expense(user.getId(), description, amount, category, date);
                
                if (expenseDAO.addExpense(expense)) {
                    message = "Expense added successfully!";
                } else {
                    message = "Failed to add expense.";
                }
            } catch (Exception e) {
                message = "Error: " + e.getMessage();
            }
        }
    } else if ("edit".equals(action)) {
        String idStr = request.getParameter("id");
        String description = request.getParameter("description");
        String amountStr = request.getParameter("amount");
        String category = request.getParameter("category");
        String dateStr = request.getParameter("date");
        
        if (idStr != null && description != null && amountStr != null && category != null && dateStr != null) {
            try {
                int id = Integer.parseInt(idStr);
                double amount = Double.parseDouble(amountStr);
                Date date = Date.valueOf(dateStr);
                Expense expense = new Expense(user.getId(), description, amount, category, date);
                expense.setId(id);
                
                if (expenseDAO.updateExpense(expense)) {
                    message = "Expense updated successfully!";
                } else {
                    message = "Failed to update expense.";
                }
            } catch (Exception e) {
                message = "Error: " + e.getMessage();
            }
        }
    }
} else if ("delete".equals(action)) {
    String idStr = request.getParameter("id");
    if (idStr != null) {
        try {
            int id = Integer.parseInt(idStr);
            if (expenseDAO.deleteExpense(id, user.getId())) {
                message = "Expense deleted successfully!";
            } else {
                message = "Failed to delete expense.";
            }
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
        }
    }
}

List<Expense> expenses = expenseDAO.getExpensesByUser(user.getId());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Expenses - ExpenseManager</title>
    <%@ include file="components/modern-head.jsp" %>
</head>
<body class="bg-gray-50 min-h-screen">
    <%@ include file="components/modern-nav.jsp" %>
    
    <main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <% if (!message.isEmpty()) { %>
            <div class="mb-6 <%= message.contains("successfully") ? "bg-green-50 border-green-200 text-green-800" : "bg-red-50 border-red-200 text-red-800" %> border px-4 py-3 rounded-lg flex items-center space-x-3 animate-fade-in-up">
                <svg class="w-5 h-5 <%= message.contains("successfully") ? "text-green-400" : "text-red-400" %>" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <% if (message.contains("successfully")) { %>
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
                    <% } else { %>
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                    <% } %>
                </svg>
                <span><%= message %></span>
            </div>
        <% } %>
        
        <div class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden mb-8">
            <div class="px-6 py-4 border-b border-gray-200 bg-gray-50">
                <h2 class="text-lg font-semibold text-gray-900"><%= "edit".equals(action) ? "Edit Expense" : "Add New Expense" %></h2>
            </div>
            <div class="p-6">
                <%
                Expense editExpense = null;
                if ("edit".equals(action)) {
                    String editIdStr = request.getParameter("id");
                    if (editIdStr != null) {
                        int editId = Integer.parseInt(editIdStr);
                        for (Expense exp : expenses) {
                            if (exp.getId() == editId) {
                                editExpense = exp;
                                break;
                            }
                        }
                    }
                }
                %>
                
                <form method="post" action="expenses.jsp" class="space-y-6">
                    <input type="hidden" name="action" value="<%= "edit".equals(action) ? "edit" : "add" %>">
                    <% if (editExpense != null) { %>
                        <input type="hidden" name="id" value="<%= editExpense.getId() %>">
                    <% } %>
                    
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div class="space-y-2">
                            <label for="description" class="block text-sm font-medium text-gray-700">Description <span class="text-red-500">*</span></label>
                            <input type="text" id="description" name="description" required
                                   class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-red-500 focus:border-red-500 transition-colors duration-200"
                                   placeholder="Enter expense description" 
                                   value="<%= editExpense != null ? editExpense.getDescription() : "" %>">
                        </div>
                        
                        <div class="space-y-2">
                            <label for="amount" class="block text-sm font-medium text-gray-700">Amount <span class="text-red-500">*</span></label>
                            <div class="relative">
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <span class="text-gray-500 text-sm">$</span>
                                </div>
                                <input type="number" id="amount" name="amount" step="0.01" required
                                       class="w-full pl-8 pr-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-red-500 focus:border-red-500 transition-colors duration-200"
                                       placeholder="0.00" 
                                       value="<%= editExpense != null ? editExpense.getAmount() : "" %>">
                            </div>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div class="space-y-2">
                            <label for="category" class="block text-sm font-medium text-gray-700">Category <span class="text-red-500">*</span></label>
                            <select id="category" name="category" required
                                    class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-red-500 focus:border-red-500 transition-colors duration-200 bg-white">
                                <option value="">Select Category</option>
                                <option value="Food" <%= editExpense != null && "Food".equals(editExpense.getCategory()) ? "selected" : "" %>>🍕 Food</option>
                                <option value="Transport" <%= editExpense != null && "Transport".equals(editExpense.getCategory()) ? "selected" : "" %>>🚗 Transport</option>
                                <option value="Entertainment" <%= editExpense != null && "Entertainment".equals(editExpense.getCategory()) ? "selected" : "" %>>🎬 Entertainment</option>
                                <option value="Bills" <%= editExpense != null && "Bills".equals(editExpense.getCategory()) ? "selected" : "" %>>📱 Bills</option>
                                <option value="Healthcare" <%= editExpense != null && "Healthcare".equals(editExpense.getCategory()) ? "selected" : "" %>>🏥 Healthcare</option>
                                <option value="Shopping" <%= editExpense != null && "Shopping".equals(editExpense.getCategory()) ? "selected" : "" %>>🛍️ Shopping</option>
                                <option value="Other" <%= editExpense != null && "Other".equals(editExpense.getCategory()) ? "selected" : "" %>>📦 Other</option>
                            </select>
                        </div>
                        
                        <div class="space-y-2">
                            <label for="date" class="block text-sm font-medium text-gray-700">Date <span class="text-red-500">*</span></label>
                            <input type="date" id="date" name="date" required
                                   class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-red-500 focus:border-red-500 transition-colors duration-200"
                                   value="<%= editExpense != null ? editExpense.getDate() : "" %>">
                        </div>
                    </div>
                    
                    <div class="flex space-x-4">
                        <button type="submit" class="bg-red-600 hover:bg-red-700 text-white font-medium py-3 px-6 rounded-lg transition-colors duration-200 focus:outline-none focus:ring-2 focus:ring-red-500 focus:ring-offset-2">
                            <%= "edit".equals(action) ? "Update Expense" : "Add Expense" %>
                        </button>
                        <% if ("edit".equals(action)) { %>
                            <a href="expenses.jsp" class="bg-gray-600 hover:bg-gray-700 text-white font-medium py-3 px-6 rounded-lg transition-colors duration-200">Cancel</a>
                        <% } else { %>
                            <button type="reset" class="bg-gray-600 hover:bg-gray-700 text-white font-medium py-3 px-6 rounded-lg transition-colors duration-200">Clear Form</button>
                        <% } %>
                    </div>
                </form>
            </div>
        </div>
        
        <div class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
            <div class="px-6 py-4 border-b border-gray-200 bg-gray-50">
                <h2 class="text-lg font-semibold text-gray-900">Your Expenses</h2>
            </div>
            <div class="p-6">
                <% if (expenses.isEmpty()) { %>
                    <div class="text-center py-12">
                        <svg class="w-16 h-16 text-gray-300 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 9V7a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2m2 4h10a2 2 0 002-2v-6a2 2 0 00-2-2H9a2 2 0 00-2 2v6a2 2 0 002 2zm7-5a2 2 0 11-4 0 2 2 0 014 0z"/>
                        </svg>
                        <h3 class="text-lg font-medium text-gray-900 mb-2">No expenses yet</h3>
                        <p class="text-gray-500">Start tracking your expenses by adding your first entry above.</p>
                    </div>
                <% } else { %>
                    <div class="overflow-x-auto">
                        <table class="w-full">
                            <thead>
                                <tr class="border-b border-gray-200">
                                    <th class="text-left py-3 px-4 font-medium text-gray-700">Date</th>
                                    <th class="text-left py-3 px-4 font-medium text-gray-700">Description</th>
                                    <th class="text-left py-3 px-4 font-medium text-gray-700">Category</th>
                                    <th class="text-right py-3 px-4 font-medium text-gray-700">Amount</th>
                                    <th class="text-center py-3 px-4 font-medium text-gray-700">Actions</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-gray-200">
                                <%
                                double total = 0;
                                for (Expense expense : expenses) {
                                    total += expense.getAmount();
                                %>
                                <tr class="hover:bg-gray-50 transition-colors duration-200">
                                    <td class="py-3 px-4 text-sm text-gray-900"><%= expense.getDate() %></td>
                                    <td class="py-3 px-4 text-sm text-gray-900"><%= expense.getDescription() %></td>
                                    <td class="py-3 px-4">
                                        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800">
                                            <%= expense.getCategory() %>
                                        </span>
                                    </td>
                                    <td class="py-3 px-4 text-sm font-medium text-right text-red-600">$<%= String.format("%.2f", expense.getAmount()) %></td>
                                    <td class="py-3 px-4 text-center">
                                        <div class="flex justify-center space-x-2">
                                            <a href="expenses.jsp?action=edit&id=<%= expense.getId() %>" 
                                               class="bg-blue-600 hover:bg-blue-700 text-white px-3 py-1 rounded text-xs font-medium transition-colors duration-200">
                                                Edit
                                            </a>
                                            <a href="expenses.jsp?action=delete&id=<%= expense.getId() %>" 
                                               class="bg-red-600 hover:bg-red-700 text-white px-3 py-1 rounded text-xs font-medium transition-colors duration-200"
                                               onclick="return confirm('Are you sure you want to delete this expense?')">
                                                Delete
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                            <tfoot>
                                <tr class="bg-gray-50 font-semibold">
                                    <td colspan="3" class="py-3 px-4 text-sm text-gray-900">Total Expenses:</td>
                                    <td class="py-3 px-4 text-sm font-bold text-right text-red-600">$<%= String.format("%.2f", total) %></td>
                                    <td></td>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                <% } %>
            </div>
        </div>
    </main>

    <script>
        <% if (!"edit".equals(action)) { %>
            document.getElementById('date').valueAsDate = new Date();
        <% } %>
        
        setTimeout(() => {
            document.querySelectorAll('[class*="bg-green-50"], [class*="bg-red-50"]').forEach(alert => {
                if (alert.textContent.includes('successfully') || alert.textContent.includes('Error')) {
                    alert.style.opacity = '0';
                    alert.style.transform = 'translateY(-20px)';
                    setTimeout(() => alert.remove(), 300);
                }
            });
        }, 5000);
    </script>
</body>
</html>