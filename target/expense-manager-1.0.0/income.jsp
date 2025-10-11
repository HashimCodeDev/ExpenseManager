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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="css/ultra-modern.css">
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
            <a href="income.jsp" class="nav-link active">💰 Income</a>
            <a href="reports.jsp" class="nav-link">📊 Reports</a>
        </nav>
        
        <% if (!message.isEmpty()) { %>
            <div class="alert <%= message.contains("successfully") ? "alert-success" : "alert-danger" %>">
                <%= message.contains("successfully") ? "✅" : "❌" %> <%= message %>
            </div>
        <% } %>
        
        <div class="card">
            <div class="card-header">
                <h2 class="card-title">💰 <%= "edit".equals(action) ? "Edit Income" : "Add New Income" %></h2>
            </div>
            <div class="card-body">
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
                    
                    <div class="form-grid">
                        <div class="form-group">
                            <label class="form-label" for="description">Description</label>
                            <input type="text" id="description" name="description" class="form-control" 
                                   placeholder="💵 Enter income description" 
                                   value="<%= editIncome != null ? editIncome.getDescription() : "" %>" required>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label" for="amount">Amount</label>
                            <input type="number" id="amount" name="amount" step="0.01" class="form-control" 
                                   placeholder="💰 0.00" 
                                   value="<%= editIncome != null ? editIncome.getAmount() : "" %>" required>
                        </div>
                    </div>

                    <div class="form-grid">
                        <div class="form-group">
                            <label class="form-label" for="category">Category</label>
                            <select id="category" name="category" class="form-control" required>
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
                            <label class="form-label" for="date">Date</label>
                            <input type="date" id="date" name="date" class="form-control"
                                   value="<%= editIncome != null ? editIncome.getDate() : "" %>" required>
                        </div>
                    </div>
                    
                    <div class="d-flex gap-3">
                        <button type="submit" class="btn btn-success">
                            <%= "edit".equals(action) ? "✏️ Update Income" : "➕ Add Income" %>
                        </button>
                        <% if ("edit".equals(action)) { %>
                            <a href="income.jsp" class="btn btn-secondary">🔄 Cancel</a>
                        <% } else { %>
                            <button type="reset" class="btn btn-secondary">🔄 Clear Form</button>
                        <% } %>
                    </div>
                </form>
            </div>
        </div>
        
        <div class="card">
            <div class="card-header">
                <h2 class="card-title">📊 Your Income</h2>
            </div>
            <div class="card-body">
                <% if (incomes.isEmpty()) { %>
                    <div class="empty-state">
                        <div class="empty-state-icon">💰</div>
                        <h3>No income entries yet</h3>
                        <p>Start tracking your income by adding your first entry above.</p>
                    </div>
                <% } else { %>
                    <table class="table">
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
                                String categoryIcon = "📦";
                                switch(income.getCategory()) {
                                    case "Job": categoryIcon = "💼"; break;
                                    case "Freelance": categoryIcon = "💻"; break;
                                    case "Investment": categoryIcon = "📈"; break;
                                    case "Business": categoryIcon = "🏢"; break;
                                    case "Gift": categoryIcon = "🎁"; break;
                                }
                            %>
                            <tr>
                                <td><%= income.getDate() %></td>
                                <td><%= income.getDescription() %></td>
                                <td><span class="badge badge-success"><%= categoryIcon %> <%= income.getCategory() %></span></td>
                                <td class="text-success">$<%= String.format("%.2f", income.getAmount()) %></td>
                                <td>
                                    <div class="actions-cell">
                                        <a href="income.jsp?action=edit&id=<%= income.getId() %>" class="btn btn-info btn-sm">✏️ Edit</a>
                                        <a href="income.jsp?action=delete&id=<%= income.getId() %>" class="btn btn-danger btn-sm" 
                                           onclick="return confirm('Are you sure you want to delete this income?')">🗑️ Delete</a>
                                    </div>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                        <tfoot>
                            <tr style="background: var(--light); font-weight: 600;">
                                <td colspan="3"><strong>Total Income:</strong></td>
                                <td class="text-success"><strong>$<%= String.format("%.2f", total) %></strong></td>
                                <td></td>
                            </tr>
                        </tfoot>
                    </table>
                <% } %>
            </div>
        </div>
    </div>

    <script>
        // Auto-set today's date for new income
        <% if (!"edit".equals(action)) { %>
            document.getElementById('date').valueAsDate = new Date();
        <% } %>
        
        // Auto-hide alerts after 5 seconds
        setTimeout(() => {
            document.querySelectorAll('.alert').forEach(alert => {
                alert.style.opacity = '0';
                alert.style.transform = 'translateY(-20px)';
                setTimeout(() => alert.remove(), 300);
            });
        }, 5000);
    </script>
</body>
</html>