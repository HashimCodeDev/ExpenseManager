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

// Get filter parameters
String startDateStr = request.getParameter("startDate");
String endDateStr = request.getParameter("endDate");
String categoryFilter = request.getParameter("category");

List<Expense> expenses = expenseDAO.getExpensesByUser(user.getId());
List<Income> incomes = incomeDAO.getIncomeByUser(user.getId());

// Apply filters
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

// Combine and sort transactions
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

// Sort by date
allTransactions.sort((a, b) -> ((Date)a.get("date")).compareTo((Date)b.get("date")));

// Calculate running balance
double runningBalance = 0;
for (Map<String, Object> transaction : allTransactions) {
    runningBalance += (Double) transaction.get("amount");
    transaction.put("balance", runningBalance);
}

// Calculate totals
double totalIncome = incomes.stream().mapToDouble(Income::getAmount).sum();
double totalExpenses = expenses.stream().mapToDouble(Expense::getAmount).sum();
double netBalance = totalIncome - totalExpenses;
%>
<!DOCTYPE html>
<html>
<head>
    <title>Reports - Expense Manager</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>
    <div class="container">
        <header>
            <h1>Transaction Reports</h1>
            <div class="user-info">
                Welcome, <%= user.getUsername() %>! 
                <a href="logout.jsp" class="logout-btn">Logout</a>
            </div>
        </header>
        
        <nav class="nav-menu">
            <a href="dashboard.jsp">Dashboard</a>
            <a href="expenses.jsp">Expenses</a>
            <a href="income.jsp">Income</a>
            <a href="reports.jsp" class="active">Reports</a>
        </nav>
        
        <div class="filter-section">
            <h2>Filter Transactions</h2>
            <form method="get" action="reports.jsp">
                <input type="date" name="startDate" placeholder="Start Date" value="<%= startDateStr != null ? startDateStr : "" %>">
                <input type="date" name="endDate" placeholder="End Date" value="<%= endDateStr != null ? endDateStr : "" %>">
                <select name="category">
                    <option value="">All Categories</option>
                    <option value="Food" <%= "Food".equals(categoryFilter) ? "selected" : "" %>>Food</option>
                    <option value="Transport" <%= "Transport".equals(categoryFilter) ? "selected" : "" %>>Transport</option>
                    <option value="Entertainment" <%= "Entertainment".equals(categoryFilter) ? "selected" : "" %>>Entertainment</option>
                    <option value="Bills" <%= "Bills".equals(categoryFilter) ? "selected" : "" %>>Bills</option>
                    <option value="Healthcare" <%= "Healthcare".equals(categoryFilter) ? "selected" : "" %>>Healthcare</option>
                    <option value="Shopping" <%= "Shopping".equals(categoryFilter) ? "selected" : "" %>>Shopping</option>
                    <option value="Job" <%= "Job".equals(categoryFilter) ? "selected" : "" %>>Job</option>
                    <option value="Freelance" <%= "Freelance".equals(categoryFilter) ? "selected" : "" %>>Freelance</option>
                    <option value="Investment" <%= "Investment".equals(categoryFilter) ? "selected" : "" %>>Investment</option>
                    <option value="Business" <%= "Business".equals(categoryFilter) ? "selected" : "" %>>Business</option>
                    <option value="Gift" <%= "Gift".equals(categoryFilter) ? "selected" : "" %>>Gift</option>
                    <option value="Other" <%= "Other".equals(categoryFilter) ? "selected" : "" %>>Other</option>
                </select>
                <button type="submit">Filter</button>
                <a href="reports.jsp" class="btn btn-secondary">Clear</a>
            </form>
        </div>
        
        <div class="report-summary">
            <div class="summary-card income">
                <h3>Total Income</h3>
                <p class="amount">$<%= String.format("%.2f", totalIncome) %></p>
            </div>
            
            <div class="summary-card expense">
                <h3>Total Expenses</h3>
                <p class="amount">$<%= String.format("%.2f", totalExpenses) %></p>
            </div>
            
            <div class="summary-card balance <%= netBalance >= 0 ? "positive" : "negative" %>">
                <h3>Net Balance</h3>
                <p class="amount">$<%= String.format("%.2f", netBalance) %></p>
            </div>
        </div>
        
        <div class="export-section">
            <a href="export.jsp?<%= request.getQueryString() != null ? request.getQueryString() : "" %>" 
               class="btn btn-info">Export to CSV</a>
        </div>
        
        <div class="transactions-section">
            <h2>All Transactions</h2>
            <table>
                <thead>
                    <tr>
                        <th>Date</th>
                        <th>Description</th>
                        <th>Category</th>
                        <th>Type</th>
                        <th>Amount</th>
                        <th>Running Balance</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    for (Map<String, Object> transaction : allTransactions) {
                        double amount = (Double) transaction.get("amount");
                        double balance = (Double) transaction.get("balance");
                    %>
                    <tr>
                        <td><%= transaction.get("date") %></td>
                        <td><%= transaction.get("description") %></td>
                        <td><%= transaction.get("category") %></td>
                        <td class="<%= transaction.get("type").toString().toLowerCase() %>"><%= transaction.get("type") %></td>
                        <td class="<%= amount >= 0 ? "positive" : "negative" %>">$<%= String.format("%.2f", Math.abs(amount)) %></td>
                        <td class="<%= balance >= 0 ? "positive" : "negative" %>">$<%= String.format("%.2f", balance) %></td>
                    </tr>
                    <%
                    }
                    %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>