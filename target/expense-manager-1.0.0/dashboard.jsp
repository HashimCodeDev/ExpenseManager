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
<html>
<head>
    <title>Dashboard - Expense Manager</title>
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
            <a href="dashboard.jsp" class="nav-link active">🏠 Dashboard</a>
            <a href="expenses.jsp" class="nav-link">💳 Expenses</a>
            <a href="income.jsp" class="nav-link">💰 Income</a>
            <a href="reports.jsp" class="nav-link">📊 Reports</a>
        </nav>
        
        <div class="summary-grid">
            <%
            ExpenseDAO expenseDAO = new ExpenseDAO();
            IncomeDAO incomeDAO = new IncomeDAO();
            double totalExpenses = expenseDAO.getTotalExpenses(user.getId());
            double totalIncome = incomeDAO.getTotalIncome(user.getId());
            double netBalance = totalIncome - totalExpenses;
            %>
            
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
        
        <div class="text-center mb-12">
            <h2 class="mb-8">🚀 Quick Actions</h2>
            <div class="d-flex justify-center gap-4" style="flex-wrap: wrap;">
                <a href="expenses.jsp?action=add" class="btn btn-primary btn-lg">
                    ➖ Add Expense
                </a>
                <a href="income.jsp?action=add" class="btn btn-success btn-lg">
                    ➕ Add Income
                </a>
                <a href="reports.jsp" class="btn btn-info btn-lg">
                    📈 View Reports
                </a>
            </div>
        </div>
        
        <div class="card">
            <div class="card-header">
                <h2 class="card-title">📊 Recent Transactions</h2>
            </div>
            <div class="card-body">
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
                    <div class="empty-state">
                        <div class="empty-state-icon">📊</div>
                        <h3>No transactions yet</h3>
                        <p>Start by adding your first income or expense entry.</p>
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
                            </tr>
                        </thead>
                        <tbody>
                            <%
                            for (int i = 0; i < Math.min(10, recentTransactions.size()); i++) {
                                Map<String, Object> transaction = recentTransactions.get(i);
                                double amount = (Double) transaction.get("amount");
                            %>
                            <tr>
                                <td><%= transaction.get("date") %></td>
                                <td><%= transaction.get("description") %></td>
                                <td><%= transaction.get("category") %></td>
                                <td><span class="badge <%= transaction.get("type").toString().toLowerCase().equals("income") ? "badge-success" : "badge-danger" %>"><%= transaction.get("type") %></span></td>
                                <td class="<%= amount >= 0 ? "text-success" : "text-danger" %>">$<%= String.format("%.2f", Math.abs(amount)) %></td>
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