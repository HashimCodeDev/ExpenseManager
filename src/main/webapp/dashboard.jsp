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
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>
    <div class="container">
        <header>
            <h1>Expense Manager Dashboard</h1>
            <div class="user-info">
                Welcome, <%= user.getUsername() %>! 
                <a href="logout.jsp" class="logout-btn">Logout</a>
            </div>
        </header>
        
        <nav class="nav-menu">
            <a href="dashboard.jsp" class="active">Dashboard</a>
            <a href="expenses.jsp">Expenses</a>
            <a href="income.jsp">Income</a>
            <a href="reports.jsp">Reports</a>
        </nav>
        
        <div class="dashboard-summary">
            <%
            ExpenseDAO expenseDAO = new ExpenseDAO();
            IncomeDAO incomeDAO = new IncomeDAO();
            double totalExpenses = expenseDAO.getTotalExpenses(user.getId());
            double totalIncome = incomeDAO.getTotalIncome(user.getId());
            double netBalance = totalIncome - totalExpenses;
            %>
            
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
        
        <div class="quick-actions">
            <h2>Quick Actions</h2>
            <div class="action-buttons">
                <a href="expenses.jsp?action=add" class="btn btn-primary">Add Expense</a>
                <a href="income.jsp?action=add" class="btn btn-success">Add Income</a>
                <a href="reports.jsp" class="btn btn-info">View Reports</a>
            </div>
        </div>
        
        <div class="recent-transactions">
            <h2>Recent Transactions</h2>
            <table>
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
                    // Get recent expenses and income combined
                    List<Map<String, Object>> recentTransactions = new ArrayList<>();
                    
                    // Add expenses
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
                    
                    // Add income
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
                    
                    // Sort by date (most recent first)
                    recentTransactions.sort((a, b) -> ((java.sql.Date)b.get("date")).compareTo((java.sql.Date)a.get("date")));
                    
                    for (int i = 0; i < Math.min(10, recentTransactions.size()); i++) {
                        Map<String, Object> transaction = recentTransactions.get(i);
                        double amount = (Double) transaction.get("amount");
                    %>
                    <tr>
                        <td><%= transaction.get("date") %></td>
                        <td><%= transaction.get("description") %></td>
                        <td><%= transaction.get("category") %></td>
                        <td class="<%= transaction.get("type").toString().toLowerCase() %>"><%= transaction.get("type") %></td>
                        <td class="<%= amount >= 0 ? "positive" : "negative" %>">$<%= String.format("%.2f", Math.abs(amount)) %></td>
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