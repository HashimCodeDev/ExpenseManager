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
<html lang="en">
<head>
    <title>Income - ExpenseFlow</title>
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
        
        <% if (!message.isEmpty()) { %>
            <div class="alert <%= message.contains("successfully") ? "alert-success" : "alert-error" %> animate-fade-in">
                <span style="font-size: 18px;"><%= message.contains("successfully") ? "✓" : "✗" %></span>
                <span><%= message %></span>
            </div>
        <% } %>
        
        <div class="card animate-fade-in">
            <h2 style="font-size: 20px; font-weight: 600; color: var(--light); margin-bottom: 24px;"><%= "edit".equals(action) ? "Edit Income" : "Add New Income" %></h2>
            
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
                
                <div class="grid grid-cols-2">
                    <div class="form-group">
                        <label class="form-label" for="description">Description <span style="color: var(--success);">*</span></label>
                        <input type="text" id="description" name="description" required class="form-input"
                               placeholder="Enter income description" 
                               value="<%= editIncome != null ? editIncome.getDescription() : "" %>">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label" for="amount">Amount <span style="color: var(--success);">*</span></label>
                        <input type="number" id="amount" name="amount" step="0.01" required class="form-input"
                               placeholder="0.00" 
                               value="<%= editIncome != null ? editIncome.getAmount() : "" %>">
                    </div>
                </div>

                <div class="grid grid-cols-2">
                    <div class="form-group">
                        <label class="form-label" for="category">Category <span style="color: var(--success);">*</span></label>
                        <select id="category" name="category" required class="form-input">
                            <option value="">Select Category</option>
                            <option value="Job" <%= editIncome != null && "Job".equals(editIncome.getCategory()) ? "selected" : "" %>>💼 Job</option>
                            <option value="Freelance" <%= editIncome != null && "Freelance".equals(editIncome.getCategory()) ? "selected" : "" %>>💻 Freelance</option>
                            <option value="Investment" <%= editIncome != null && "Investment".equals(editIncome.getCategory()) ? "selected" : "" %>>📈 Investment</option>
                            <option value="Business" <%= editIncome != null && "Business".equals(editIncome.getCategory()) ? "selected" : "" %>>🏢 Business</option>
                            <option value="Gift" <%= editIncome != null && "Gift".equals(editIncome.getCategory()) ? "selected" : "" %>>🎁 Gift</option>
                            <option value="Other" <%= editIncome != null && "Other".equals(editIncome.getCategory()) ? "selected" : "" %>>📦 Other</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label" for="date">Date <span style="color: var(--success);">*</span></label>
                        <input type="date" id="date" name="date" required class="form-input"
                               value="<%= editIncome != null ? editIncome.getDate() : "" %>">
                    </div>
                </div>
                
                <div style="display: flex; gap: 16px; margin-top: 24px;">
                    <button type="submit" class="btn btn-success">
                        <%= "edit".equals(action) ? "Update Income" : "Add Income" %>
                    </button>
                    <% if ("edit".equals(action)) { %>
                        <a href="income.jsp" class="btn" style="background: var(--gray); color: white;">Cancel</a>
                    <% } else { %>
                        <button type="reset" class="btn" style="background: var(--gray); color: white;">Clear Form</button>
                    <% } %>
                </div>
            </form>
        </div>
        
        <div class="card animate-fade-in">
            <h2 style="font-size: 20px; font-weight: 600; color: var(--light); margin-bottom: 20px;">Your Income</h2>
            
            <% if (incomes.isEmpty()) { %>
                <div style="text-align: center; padding: 48px 0;">
                    <div style="font-size: 64px; margin-bottom: 16px;">💰</div>
                    <h3 style="font-size: 18px; font-weight: 500; color: var(--light); margin-bottom: 8px;">No income entries yet</h3>
                    <p style="color: var(--gray);">Start tracking your income by adding your first entry above.</p>
                </div>
            <% } else { %>
                <div style="overflow-x: auto;">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Date</th>
                                <th>Description</th>
                                <th>Category</th>
                                <th style="text-align: right;">Amount</th>
                                <th style="text-align: center;">Actions</th>
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
                                <td>
                                    <span class="badge badge-success">
                                        <%= income.getCategory() %>
                                    </span>
                                </td>
                                <td style="text-align: right; font-weight: 600; color: var(--success);">$<%= String.format("%.2f", income.getAmount()) %></td>
                                <td style="text-align: center;">
                                    <div style="display: flex; justify-content: center; gap: 8px;">
                                        <a href="income.jsp?action=edit&id=<%= income.getId() %>" class="btn btn-primary" style="padding: 4px 12px; font-size: 12px;">
                                            Edit
                                        </a>
                                        <a href="income.jsp?action=delete&id=<%= income.getId() %>" class="btn btn-danger" style="padding: 4px 12px; font-size: 12px;"
                                           onclick="return confirm('Are you sure you want to delete this income?')">
                                            Delete
                                        </a>
                                    </div>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                        <tfoot>
                            <tr style="background: rgba(15, 23, 42, 0.5); font-weight: 600;">
                                <td colspan="3">Total Income:</td>
                                <td style="text-align: right; font-weight: 700; color: var(--success);">$<%= String.format("%.2f", total) %></td>
                                <td></td>
                            </tr>
                        </tfoot>
                    </table>
                </div>
            <% } %>
        </div>
    </div>

    <script>
        <% if (!"edit".equals(action)) { %>
            document.getElementById('date').valueAsDate = new Date();
        <% } %>
    </script>
</body>
</html>