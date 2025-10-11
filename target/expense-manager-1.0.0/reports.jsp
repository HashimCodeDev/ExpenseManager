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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>
    <div class="container animate-fade-in">
        <header class="header">
            <h1 class="header-title">💰 Expense Manager</h1>
            <div class="user-info">
                <div class="user-avatar"><%= user.getUsername().substring(0, 1).toUpperCase() %></div>
                <span>Welcome, <%= user.getUsername() %>!</span>
                <a href="logout.jsp" class="btn btn-danger btn-sm">🚪 Logout</a>
            </div>
        </header>
        
        <nav class="nav">
            <a href="dashboard.jsp" class="nav-link">🏠 Dashboard</a>
            <a href="expenses.jsp" class="nav-link">💳 Expenses</a>
            <a href="income.jsp" class="nav-link">💰 Income</a>
            <a href="reports.jsp" class="nav-link active">📊 Reports</a>
        </nav>
        
        <div class="card">
            <div class="card-header">
                <h2 class="card-title">🔍 Filter Transactions</h2>
            </div>
            <div class="card-body">
                <form method="get" action="reports.jsp" class="form-grid">
                    <div class="form-group">
                        <label class="form-label" for="startDate">Start Date</label>
                        <input type="date" id="startDate" name="startDate" class="form-control" value="<%= startDateStr != null ? startDateStr : "" %>">
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="endDate">End Date</label>
                        <input type="date" id="endDate" name="endDate" class="form-control" value="<%= endDateStr != null ? endDateStr : "" %>">
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="category">Category</label>
                        <select id="category" name="category" class="form-control">
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
                    <div class="form-group d-flex gap-3" style="align-items: end;">
                        <button type="submit" class="btn btn-primary">🔍 Filter</button>
                        <a href="reports.jsp" class="btn btn-secondary">🔄 Clear</a>
                    </div>
                </form>
            </div>
        </div>
        
        <div class="summary-grid">
            <div class="summary-card income">
                <div class="summary-icon">💰</div>
                <h3 class="summary-title">Total Income</h3>
                <p class="summary-amount text-success">$<%= String.format("%.2f", totalIncome) %></p>
            </div>
            
            <div class="summary-card expense">
                <div class="summary-icon">💳</div>
                <h3 class="summary-title">Total Expenses</h3>
                <p class="summary-amount text-danger">$<%= String.format("%.2f", totalExpenses) %></p>
            </div>
            
            <div class="summary-card balance">
                <div class="summary-icon"><%= netBalance >= 0 ? "📈" : "📉" %></div>
                <h3 class="summary-title">Net Balance</h3>
                <p class="summary-amount <%= netBalance >= 0 ? "text-success" : "text-danger" %>">$<%= String.format("%.2f", netBalance) %></p>
            </div>
        </div>
        
        <div class="text-center mb-8">
            <a href="export.jsp?<%= request.getQueryString() != null ? request.getQueryString() : "" %>" 
               class="btn btn-info btn-lg">
                📄 Export to CSV
            </a>
        </div>
        
        <div class="card">
            <div class="card-header">
                <h2 class="card-title">📊 All Transactions</h2>
            </div>
            <div class="card-body">
                <% if (allTransactions.isEmpty()) { %>
                    <div class="empty-state">
                        <div class="empty-state-icon">📊</div>
                        <h3>No transactions found</h3>
                        <p>Try adjusting your filters or add some transactions to see data here.</p>
                    </div>
                <% } else { %>
                    <table class="table">
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
                                <td><span class="badge <%= transaction.get("type").toString().toLowerCase().equals("income") ? "badge-success" : "badge-danger" %>"><%= transaction.get("type") %></span></td>
                                <td class="<%= amount >= 0 ? "text-success" : "text-danger" %>">$<%= String.format("%.2f", Math.abs(amount)) %></td>
                                <td class="<%= balance >= 0 ? "text-success" : "text-danger" %>" style="font-weight: 600;">$<%= String.format("%.2f", balance) %></td>
                            </tr>
                            <%
                            }
                            %>
                        </tbody>
                    </table>
                <% } %>
            </div>
        </div>
    </div>
</body>
</html>