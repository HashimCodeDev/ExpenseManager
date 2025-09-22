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

// Handle form submissions
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
<html>
<head>
    <title>Expenses - Expense Manager</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>
    <div class="container">
        <header>
            <h1>Expense Management</h1>
            <div class="user-info">
                Welcome, <%= user.getUsername() %>! 
                <a href="logout.jsp" class="logout-btn">Logout</a>
            </div>
        </header>
        
        <nav class="nav-menu">
            <a href="dashboard.jsp">Dashboard</a>
            <a href="expenses.jsp" class="active">Expenses</a>
            <a href="income.jsp">Income</a>
            <a href="reports.jsp">Reports</a>
        </nav>
        
        <% if (!message.isEmpty()) { %>
            <div class="<%= message.contains("successfully") ? "success" : "error" %>"><%= message %></div>
        <% } %>
        
        <div class="form-section">
            <h2><%= "edit".equals(action) ? "Edit Expense" : "Add New Expense" %></h2>
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
            
            <form method="post" action="expenses.jsp">
                <input type="hidden" name="action" value="<%= "edit".equals(action) ? "edit" : "add" %>">
                <% if (editExpense != null) { %>
                    <input type="hidden" name="id" value="<%= editExpense.getId() %>">
                <% } %>
                
                <input type="text" name="description" placeholder="Description" 
                       value="<%= editExpense != null ? editExpense.getDescription() : "" %>" required>
                <input type="number" name="amount" step="0.01" placeholder="Amount" 
                       value="<%= editExpense != null ? editExpense.getAmount() : "" %>" required>
                <select name="category" required>
                    <option value="">Select Category</option>
                    <option value="Food" <%= editExpense != null && "Food".equals(editExpense.getCategory()) ? "selected" : "" %>>Food</option>
                    <option value="Transport" <%= editExpense != null && "Transport".equals(editExpense.getCategory()) ? "selected" : "" %>>Transport</option>
                    <option value="Entertainment" <%= editExpense != null && "Entertainment".equals(editExpense.getCategory()) ? "selected" : "" %>>Entertainment</option>
                    <option value="Bills" <%= editExpense != null && "Bills".equals(editExpense.getCategory()) ? "selected" : "" %>>Bills</option>
                    <option value="Healthcare" <%= editExpense != null && "Healthcare".equals(editExpense.getCategory()) ? "selected" : "" %>>Healthcare</option>
                    <option value="Shopping" <%= editExpense != null && "Shopping".equals(editExpense.getCategory()) ? "selected" : "" %>>Shopping</option>
                    <option value="Other" <%= editExpense != null && "Other".equals(editExpense.getCategory()) ? "selected" : "" %>>Other</option>
                </select>
                <input type="date" name="date" 
                       value="<%= editExpense != null ? editExpense.getDate() : "" %>" required>
                <button type="submit"><%= "edit".equals(action) ? "Update Expense" : "Add Expense" %></button>
                <% if ("edit".equals(action)) { %>
                    <a href="expenses.jsp" class="btn btn-secondary">Cancel</a>
                <% } %>
            </form>
        </div>
        
        <div class="expenses-section">
            <h2>Your Expenses</h2>
            <table>
                <thead>
                    <tr>
                        <th>Date</th>
                        <th>Description</th>
                        <th>Category</th>
                        <th>Amount</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    double total = 0;
                    for (Expense expense : expenses) {
                        total += expense.getAmount();
                    %>
                    <tr>
                        <td><%= expense.getDate() %></td>
                        <td><%= expense.getDescription() %></td>
                        <td><%= expense.getCategory() %></td>
                        <td>$<%= String.format("%.2f", expense.getAmount()) %></td>
                        <td>
                            <a href="expenses.jsp?action=edit&id=<%= expense.getId() %>" class="btn btn-sm">Edit</a>
                            <a href="expenses.jsp?action=delete&id=<%= expense.getId() %>" 
                               onclick="return confirm('Are you sure you want to delete this expense?')" 
                               class="btn btn-sm btn-danger">Delete</a>
                        </td>
                    </tr>
                    <%
                    }
                    %>
                </tbody>
                <tfoot>
                    <tr>
                        <td colspan="3"><strong>Total:</strong></td>
                        <td><strong>$<%= String.format("%.2f", total) %></strong></td>
                        <td></td>
                    </tr>
                </tfoot>
            </table>
        </div>
    </div>
</body>
</html>