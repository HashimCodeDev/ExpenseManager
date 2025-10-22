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
    <title>Reports - ExpenseFlow</title>
    <%@ include file="components/modern-head.jsp" %>
</head>
<body>
    <div class="bg-animation">
        <div class="orb orb-1"></div>
        <div class="orb orb-2"></div>
    </div>
    
    <div class="container">
        <nav class="navbar">
            <div class="logo">
                <div class="logo-icon">💰</div>
                <span>ExpenseFlow</span>
            </div>
            <div class="nav-links">
                <a href="dashboard.jsp" class="nav-link">
                    <svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"/>
                    </svg>
                    Dashboard
                </a>
                <a href="expenses.jsp" class="nav-link">
                    <svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 9V7a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2m2 4h10a2 2 0 002-2v-6a2 2 0 00-2-2H9a2 2 0 00-2 2v6a2 2 0 002 2zm7-5a2 2 0 11-4 0 2 2 0 014 0z"/>
                    </svg>
                    Expenses
                </a>
                <a href="income.jsp" class="nav-link">
                    <svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1"/>
                    </svg>
                    Income
                </a>
                <a href="reports.jsp" class="nav-link">
                    <svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"/>
                    </svg>
                    Reports
                </a>
                <form action="logout" method="post" style="margin: 0;">
                    <button type="submit" class="btn-logout">Logout</button>
                </form>
            </div>
        </nav>
        
        <div class="card animate-fade-in">
            <h2 style="font-size: 20px; font-weight: 600; color: var(--light); margin-bottom: 24px;">Filter Transactions</h2>
            
            <form method="get" action="reports.jsp" class="grid grid-cols-2" style="gap: 24px;">
                <div class="form-group">
                    <label class="form-label" for="startDate">Start Date</label>
                    <input type="date" id="startDate" name="startDate" class="form-input"
                           value="<%= startDateStr != null ? startDateStr : "" %>">
                </div>
                <div class="form-group">
                    <label class="form-label" for="endDate">End Date</label>
                    <input type="date" id="endDate" name="endDate" class="form-input"
                           value="<%= endDateStr != null ? endDateStr : "" %>">
                </div>
                <div class="form-group">
                    <label class="form-label" for="category">Category</label>
                    <select id="category" name="category" class="form-input">
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
                <div style="display: flex; align-items: end; gap: 16px;">
                    <button type="submit" class="btn btn-primary">Filter</button>
                    <a href="reports.jsp" class="btn" style="background: var(--gray); color: white;">Clear</a>
                </div>
            </form>
        </div>
        
        <div class="stats-grid">
            <div class="stat-card stat-income animate-fade-in">
                <div class="stat-info">
                    <h3>Total Income</h3>
                    <p style="color: white;">$<%= String.format("%.2f", totalIncome) %></p>
                </div>
                <div class="stat-icon" style="background: rgba(255, 255, 255, 0.2);">💰</div>
            </div>

            <div class="stat-card stat-expense animate-fade-in">
                <div class="stat-info">
                    <h3>Total Expenses</h3>
                    <p style="color: white;">$<%= String.format("%.2f", totalExpenses) %></p>
                </div>
                <div class="stat-icon" style="background: rgba(255, 255, 255, 0.2);">💸</div>
            </div>

            <div class="stat-card <%= netBalance >= 0 ? "stat-balance" : "stat-expense" %> animate-fade-in">
                <div class="stat-info">
                    <h3>Net Balance</h3>
                    <p style="color: white;">$<%= String.format("%.2f", netBalance) %></p>
                </div>
                <div class="stat-icon" style="background: rgba(255, 255, 255, 0.2);"><%= netBalance >= 0 ? "📈" : "📉" %></div>
            </div>
        </div>
        
        <div style="text-align: center; margin-bottom: 32px;">
            <a href="export.jsp?<%= request.getQueryString() != null ? request.getQueryString() : "" %>" 
               class="btn btn-primary">
                📄 Export to CSV
            </a>
        </div>
        
        <div class="card animate-fade-in">
            <h2 style="font-size: 20px; font-weight: 600; color: var(--light); margin-bottom: 20px;">All Transactions</h2>
            
            <% if (allTransactions.isEmpty()) { %>
                <div style="text-align: center; padding: 48px 0;">
                    <div style="font-size: 64px; margin-bottom: 16px;">📊</div>
                    <h3 style="font-size: 18px; font-weight: 500; color: var(--light); margin-bottom: 8px;">No transactions found</h3>
                    <p style="color: var(--gray);">Try adjusting your filters or add some transactions to see data here.</p>
                </div>
            <% } else { %>
                <div style="overflow-x: auto;">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Date</th>
                                <th>Description</th>
                                <th>Category</th>
                                <th>Type</th>
                                <th style="text-align: right;">Amount</th>
                                <th style="text-align: right;">Running Balance</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                            for (Map<String, Object> transaction : allTransactions) {
                                double amount = (Double) transaction.get("amount");
                                double balance = (Double) transaction.get("balance");
                                boolean isIncome = transaction.get("type").toString().equals("Income");
                            %>
                            <tr>
                                <td><%= transaction.get("date") %></td>
                                <td><%= transaction.get("description") %></td>
                                <td>
                                    <span class="badge <%= isIncome ? "badge-success" : "badge-danger" %>">
                                        <%= transaction.get("category") %>
                                    </span>
                                </td>
                                <td>
                                    <span class="badge <%= isIncome ? "badge-success" : "badge-danger" %>">
                                        <%= transaction.get("type") %>
                                    </span>
                                </td>
                                <td style="text-align: right; font-weight: 600; color: <%= amount >= 0 ? "var(--success)" : "var(--error)" %>;">
                                    <%= amount >= 0 ? "+" : "" %>$<%= String.format("%.2f", Math.abs(amount)) %>
                                </td>
                                <td style="text-align: right; font-weight: 700; color: <%= balance >= 0 ? "var(--success)" : "var(--error)" %>;">
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
</body>
</html>