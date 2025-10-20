<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.expense.model.*, com.expense.dao.*, java.util.*, java.sql.Date, java.text.SimpleDateFormat" %>
<%
User user = (User) session.getAttribute("user");
if (user == null) {
    response.sendRedirect("login.jsp");
    return;
}

ExpenseDAO expenseDAO = new ExpenseDAO();
IncomeDAO incomeDAO = new IncomeDAO();

String startDateStr = request.getParameter("startDate");
String endDateStr = request.getParameter("endDate");
String categoryFilter = request.getParameter("category");

List<Expense> expenses = expenseDAO.getExpensesByUser(user.getId());
List<Income> incomes = incomeDAO.getIncomeByUser(user.getId());

if (startDateStr != null && !startDateStr.isEmpty()) {
    Date startDate = Date.valueOf(startDateStr);
    expenses.removeIf(e -> e.getDate().before(startDate));
    incomes.removeIf(i -> i.getDate().before(startDate));
}

if (endDateStr != null && !endDateStr.isEmpty()) {
    Date endDate = Date.valueOf(endDateStr);
    expenses.removeIf(e -> e.getDate().after(endDate));
    incomes.removeIf(i -> i.getDate().after(endDate));
}

if (categoryFilter != null && !categoryFilter.isEmpty()) {
    expenses.removeIf(e -> !e.getCategory().equals(categoryFilter));
    incomes.removeIf(i -> !i.getCategory().equals(categoryFilter));
}

List<Map<String, Object>> allTransactions = new ArrayList<>();

for (Expense expense : expenses) {
    Map<String, Object> transaction = new HashMap<>();
    transaction.put("date", expense.getDate());
    transaction.put("description", expense.getDescription());
    transaction.put("category", expense.getCategory());
    transaction.put("type", "Expense");
    transaction.put("amount", -expense.getAmount());
    allTransactions.add(transaction);
}

for (Income income : incomes) {
    Map<String, Object> transaction = new HashMap<>();
    transaction.put("date", income.getDate());
    transaction.put("description", income.getDescription());
    transaction.put("category", income.getCategory());
    transaction.put("type", "Income");
    transaction.put("amount", income.getAmount());
    allTransactions.add(transaction);
}

allTransactions.sort((a, b) -> ((Date)a.get("date")).compareTo((Date)b.get("date")));

double runningBalance = 0;
for (Map<String, Object> transaction : allTransactions) {
    runningBalance += (Double) transaction.get("amount");
    transaction.put("balance", runningBalance);
}

double totalIncome = incomes.stream().mapToDouble(Income::getAmount).sum();
double totalExpenses = expenses.stream().mapToDouble(Expense::getAmount).sum();
double netBalance = totalIncome - totalExpenses;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Reports - ExpenseManager</title>
    <%@ include file="components/modern-head.jsp" %>
</head>
<body class="bg-gray-50 min-h-screen">
    <%@ include file="components/modern-nav.jsp" %>
    
    <main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden mb-8">
            <div class="px-6 py-4 border-b border-gray-200 bg-gray-50">
                <h2 class="text-lg font-semibold text-gray-900">Filter Transactions</h2>
            </div>
            <div class="p-6">
                <form method="get" action="reports.jsp" class="grid grid-cols-1 md:grid-cols-4 gap-6">
                    <div class="space-y-2">
                        <label for="startDate" class="block text-sm font-medium text-gray-700">Start Date</label>
                        <input type="date" id="startDate" name="startDate" 
                               class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition-colors duration-200"
                               value="<%= startDateStr != null ? startDateStr : "" %>">
                    </div>
                    <div class="space-y-2">
                        <label for="endDate" class="block text-sm font-medium text-gray-700">End Date</label>
                        <input type="date" id="endDate" name="endDate" 
                               class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition-colors duration-200"
                               value="<%= endDateStr != null ? endDateStr : "" %>">
                    </div>
                    <div class="space-y-2">
                        <label for="category" class="block text-sm font-medium text-gray-700">Category</label>
                        <select id="category" name="category" 
                                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition-colors duration-200 bg-white">
                            <option value="">All Categories</option>
                            <option value="Food" <%= "Food".equals(categoryFilter) ? "selected" : "" %>>🍕 Food</option>
                            <option value="Transport" <%= "Transport".equals(categoryFilter) ? "selected" : "" %>>🚗 Transport</option>
                            <option value="Entertainment" <%= "Entertainment".equals(categoryFilter) ? "selected" : "" %>>🎬 Entertainment</option>
                            <option value="Bills" <%= "Bills".equals(categoryFilter) ? "selected" : "" %>>📱 Bills</option>
                            <option value="Healthcare" <%= "Healthcare".equals(categoryFilter) ? "selected" : "" %>>🏥 Healthcare</option>
                            <option value="Shopping" <%= "Shopping".equals(categoryFilter) ? "selected" : "" %>>🛍️ Shopping</option>
                            <option value="Job" <%= "Job".equals(categoryFilter) ? "selected" : "" %>>💼 Job</option>
                            <option value="Freelance" <%= "Freelance".equals(categoryFilter) ? "selected" : "" %>>💻 Freelance</option>
                            <option value="Investment" <%= "Investment".equals(categoryFilter) ? "selected" : "" %>>📈 Investment</option>
                            <option value="Business" <%= "Business".equals(categoryFilter) ? "selected" : "" %>>🏢 Business</option>
                            <option value="Gift" <%= "Gift".equals(categoryFilter) ? "selected" : "" %>>🎁 Gift</option>
                            <option value="Other" <%= "Other".equals(categoryFilter) ? "selected" : "" %>>📦 Other</option>
                        </select>
                    </div>
                    <div class="flex items-end space-x-3">
                        <button type="submit" class="bg-indigo-600 hover:bg-indigo-700 text-white font-medium py-3 px-6 rounded-lg transition-colors duration-200 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2">
                            Filter
                        </button>
                        <a href="reports.jsp" class="bg-gray-600 hover:bg-gray-700 text-white font-medium py-3 px-6 rounded-lg transition-colors duration-200">
                            Clear
                        </a>
                    </div>
                </form>
            </div>
        </div>
        
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
            <div class="bg-gradient-to-r from-green-500 to-green-600 rounded-xl p-6 text-white shadow-lg">
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

            <div class="bg-gradient-to-r from-red-500 to-red-600 rounded-xl p-6 text-white shadow-lg">
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

            <div class="bg-gradient-to-r from-<%= netBalance >= 0 ? "blue-500 to-blue-600" : "orange-500 to-orange-600" %> rounded-xl p-6 text-white shadow-lg">
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
        
        <div class="text-center mb-8">
            <a href="export.jsp?<%= request.getQueryString() != null ? request.getQueryString() : "" %>" 
               class="bg-blue-600 hover:bg-blue-700 text-white font-medium py-3 px-6 rounded-lg transition-colors duration-200 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2">
                📄 Export to CSV
            </a>
        </div>
        
        <div class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
            <div class="px-6 py-4 border-b border-gray-200 bg-gray-50">
                <h2 class="text-lg font-semibold text-gray-900">All Transactions</h2>
            </div>
            <div class="p-6">
                <% if (allTransactions.isEmpty()) { %>
                    <div class="text-center py-12">
                        <svg class="w-16 h-16 text-gray-300 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"/>
                        </svg>
                        <h3 class="text-lg font-medium text-gray-900 mb-2">No transactions found</h3>
                        <p class="text-gray-500">Try adjusting your filters or add some transactions to see data here.</p>
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
                                    <th class="text-right py-3 px-4 font-medium text-gray-700">Running Balance</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-gray-200">
                                <%
                                for (Map<String, Object> transaction : allTransactions) {
                                    double amount = (Double) transaction.get("amount");
                                    double balance = (Double) transaction.get("balance");
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
                                    <td class="py-3 px-4 text-sm font-bold text-right <%= balance >= 0 ? "text-green-600" : "text-red-600" %>">
                                        $<%= String.format("%.2f", balance) %>
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