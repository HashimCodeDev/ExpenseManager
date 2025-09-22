<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.expense.model.*, com.expense.dao.*, java.util.*, java.sql.Date" %>
<%
User user = (User) session.getAttribute("user");
if (user == null) {
    response.sendRedirect("login.jsp");
    return;
}

IncomeDAO incomeDAO = new IncomeDAO();
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
                Income income = new Income(user.getId(), description, amount, category, date);
                
                if (incomeDAO.addIncome(income)) {
                    message = "Income added successfully!";
                } else {
                    message = "Failed to add income.";
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
                Income income = new Income(user.getId(), description, amount, category, date);
                income.setId(id);
                
                if (incomeDAO.updateIncome(income)) {
                    message = "Income updated successfully!";
                } else {
                    message = "Failed to update income.";
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
            if (incomeDAO.deleteIncome(id, user.getId())) {
                message = "Income deleted successfully!";
            } else {
                message = "Failed to delete income.";
            }
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
        }
    }
}

List<Income> incomes = incomeDAO.getIncomeByUser(user.getId());
%>
<!DOCTYPE html>
<html>
<head>
    <title>Income - Expense Manager</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>
    <div class="container">
        <header>
            <h1>Income Management</h1>
            <div class="user-info">
                Welcome, <%= user.getUsername() %>! 
                <a href="logout.jsp" class="logout-btn">Logout</a>
            </div>
        </header>
        
        <nav class="nav-menu">
            <a href="dashboard.jsp">Dashboard</a>
            <a href="expenses.jsp">Expenses</a>
            <a href="income.jsp" class="active">Income</a>
            <a href="reports.jsp">Reports</a>
        </nav>
        
        <% if (!message.isEmpty()) { %>
            <div class="<%= message.contains("successfully") ? "success" : "error" %>"><%= message %></div>
        <% } %>
        
        <div class="form-section">
            <h2><%= "edit".equals(action) ? "Edit Income" : "Add New Income" %></h2>
            <%
            Income editIncome = null;
            if ("edit".equals(action)) {
                String editIdStr = request.getParameter("id");
                if (editIdStr != null) {
                    int editId = Integer.parseInt(editIdStr);
                    for (Income inc : incomes) {
                        if (inc.getId() == editId) {
                            editIncome = inc;
                            break;
                        }
                    }
                }
            }
            %>
            
            <form method="post" action="income.jsp">
                <input type="hidden" name="action" value="<%= "edit".equals(action) ? "edit" : "add" %>">
                <% if (editIncome != null) { %>
                    <input type="hidden" name="id" value="<%= editIncome.getId() %>">
                <% } %>
                
                <input type="text" name="description" placeholder="Description" 
                       value="<%= editIncome != null ? editIncome.getDescription() : "" %>" required>
                <input type="number" name="amount" step="0.01" placeholder="Amount" 
                       value="<%= editIncome != null ? editIncome.getAmount() : "" %>" required>
                <select name="category" required>
                    <option value="">Select Category</option>
                    <option value="Job" <%= editIncome != null && "Job".equals(editIncome.getCategory()) ? "selected" : "" %>>Job</option>
                    <option value="Freelance" <%= editIncome != null && "Freelance".equals(editIncome.getCategory()) ? "selected" : "" %>>Freelance</option>
                    <option value="Investment" <%= editIncome != null && "Investment".equals(editIncome.getCategory()) ? "selected" : "" %>>Investment</option>
                    <option value="Business" <%= editIncome != null && "Business".equals(editIncome.getCategory()) ? "selected" : "" %>>Business</option>
                    <option value="Gift" <%= editIncome != null && "Gift".equals(editIncome.getCategory()) ? "selected" : "" %>>Gift</option>
                    <option value="Other" <%= editIncome != null && "Other".equals(editIncome.getCategory()) ? "selected" : "" %>>Other</option>
                </select>
                <input type="date" name="date" 
                       value="<%= editIncome != null ? editIncome.getDate() : "" %>" required>
                <button type="submit"><%= "edit".equals(action) ? "Update Income" : "Add Income" %></button>
                <% if ("edit".equals(action)) { %>
                    <a href="income.jsp" class="btn btn-secondary">Cancel</a>
                <% } %>
            </form>
        </div>
        
        <div class="income-section">
            <h2>Your Income</h2>
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
                    for (Income income : incomes) {
                        total += income.getAmount();
                    %>
                    <tr>
                        <td><%= income.getDate() %></td>
                        <td><%= income.getDescription() %></td>
                        <td><%= income.getCategory() %></td>
                        <td>$<%= String.format("%.2f", income.getAmount()) %></td>
                        <td>
                            <a href="income.jsp?action=edit&id=<%= income.getId() %>" class="btn btn-sm">Edit</a>
                            <a href="income.jsp?action=delete&id=<%= income.getId() %>" 
                               onclick="return confirm('Are you sure you want to delete this income?')" 
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