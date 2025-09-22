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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #6366f1;
            --primary-dark: #4f46e5;
            --primary-light: #a5b4fc;
            --secondary: #0f172a;
            --secondary-light: #1e293b;
            --success: #10b981;
            --success-light: #34d399;
            --danger: #ef4444;
            --danger-light: #f87171;
            --warning: #f59e0b;
            --warning-light: #fbbf24;
            --info: #06b6d4;
            --info-light: #22d3ee;
            --dark: #0f172a;
            --light: #f8fafc;
            --gray: #64748b;
            --gray-light: #e2e8f0;
            --gray-dark: #334155;
            --white: #ffffff;
            --surface: #ffffff;
            --surface-dark: #1e293b;
            --border: rgba(148, 163, 184, 0.2);
            --shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06);
            --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
            --shadow-xl: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
            --border-radius: 16px;
            --border-radius-sm: 8px;
            --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            --backdrop: rgba(255, 255, 255, 0.8);
            --glass-border: rgba(255, 255, 255, 0.2);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 50%, #f093fb 100%);
            background-attachment: fixed;
            min-height: 100vh;
            color: var(--dark);
            line-height: 1.6;
            font-weight: 400;
            overflow-x: hidden;
        }

        .background-pattern {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            opacity: 0.03;
            z-index: -1;
            background-image: radial-gradient(circle at 25% 25%, #667eea 0%, transparent 50%),
                              radial-gradient(circle at 75% 75%, #764ba2 0%, transparent 50%);
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 24px;
            backdrop-filter: blur(20px);
            background: var(--backdrop);
            border: 1px solid var(--glass-border);
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-xl);
            margin-top: 24px;
            margin-bottom: 24px;
            position: relative;
        }

        header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 32px 0;
            border-bottom: 1px solid var(--border);
            margin-bottom: 40px;
            position: relative;
        }

        header::after {
            content: '';
            position: absolute;
            bottom: -1px;
            left: 0;
            width: 80px;
            height: 3px;
            background: linear-gradient(90deg, var(--primary), var(--info));
            border-radius: 2px;
        }

        header h1 {
            background: linear-gradient(135deg, var(--primary), var(--info));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            font-weight: 700;
            font-size: 2.5rem;
            letter-spacing: -0.025em;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 20px;
            color: var(--gray-dark);
            font-size: 0.95rem;
            font-weight: 500;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, var(--primary), var(--info));
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
            font-size: 1.1rem;
        }

        .logout-btn {
            background: linear-gradient(135deg, var(--danger), var(--danger-light));
            color: var(--white);
            padding: 12px 20px;
            border-radius: var(--border-radius-sm);
            text-decoration: none;
            font-size: 0.875rem;
            font-weight: 500;
            transition: var(--transition);
            position: relative;
            overflow: hidden;
        }

        .logout-btn:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-lg);
        }

        .nav-menu {
            display: flex;
            gap: 4px;
            margin-bottom: 40px;
            background: rgba(255, 255, 255, 0.6);
            backdrop-filter: blur(10px);
            padding: 6px;
            border-radius: var(--border-radius);
            border: 1px solid var(--glass-border);
        }

        .nav-menu a {
            text-decoration: none;
            color: var(--gray-dark);
            padding: 16px 24px;
            border-radius: var(--border-radius-sm);
            font-weight: 500;
            transition: var(--transition);
            flex: 1;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .nav-menu a:hover {
            background: rgba(99, 102, 241, 0.1);
            color: var(--primary);
            transform: translateY(-1px);
        }

        .nav-menu a.active {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: var(--white);
            box-shadow: var(--shadow);
        }

        .alert {
            padding: 16px 20px;
            border-radius: var(--border-radius-sm);
            margin-bottom: 24px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 12px;
            backdrop-filter: blur(10px);
            border: 1px solid;
            animation: slideInDown 0.5s ease-out;
        }

        .alert-success {
            background: rgba(16, 185, 129, 0.1);
            color: var(--success);
            border-color: rgba(16, 185, 129, 0.3);
        }

        .alert-success::before {
            content: '✅';
            font-size: 1.2rem;
        }

        .alert-danger {
            background: rgba(239, 68, 68, 0.1);
            color: var(--danger);
            border-color: rgba(239, 68, 68, 0.3);
        }

        .alert-danger::before {
            content: '❌';
            font-size: 1.2rem;
        }

        .content-section {
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(20px);
            border-radius: var(--border-radius);
            padding: 32px;
            margin-bottom: 32px;
            border: 1px solid var(--glass-border);
            box-shadow: var(--shadow-lg);
            position: relative;
        }

        .content-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--primary), var(--info));
            border-radius: var(--border-radius) var(--border-radius) 0 0;
        }

        .content-section h2 {
            color: var(--dark);
            margin-bottom: 32px;
            font-weight: 600;
            font-size: 1.75rem;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .form-group {
            margin-bottom: 24px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: var(--gray-dark);
            font-size: 0.95rem;
        }

        .form-control {
            width: 100%;
            padding: 16px 20px;
            border: 2px solid var(--border);
            border-radius: var(--border-radius-sm);
            font-size: 1rem;
            font-family: inherit;
            transition: var(--transition);
            outline: none;
            background: rgba(255, 255, 255, 0.8);
            backdrop-filter: blur(10px);
        }

        .form-control:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.1);
            background: var(--white);
        }

        .form-control::placeholder {
            color: var(--gray);
        }

        .btn {
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            cursor: pointer;
            border: none;
            font-weight: 500;
            transition: var(--transition);
            padding: 16px 24px;
            border-radius: var(--border-radius-sm);
            font-size: 0.95rem;
            position: relative;
            overflow: hidden;
            font-family: inherit;
        }

        .btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s;
        }

        .btn:hover::before {
            left: 100%;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-lg);
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: var(--white);
        }

        .btn-secondary {
            background: linear-gradient(135deg, var(--gray), var(--gray-dark));
            color: var(--white);
        }

        .btn-info {
            background: linear-gradient(135deg, var(--info), var(--info-light));
            color: var(--white);
            font-size: 0.85rem;
            padding: 8px 16px;
        }

        .btn-danger {
            background: linear-gradient(135deg, var(--danger), var(--danger-light));
            color: var(--white);
            font-size: 0.85rem;
            padding: 8px 16px;
        }

        .form-actions {
            display: flex;
            gap: 16px;
            flex-wrap: wrap;
        }

        form {
            display: grid;
            gap: 24px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            background: var(--white);
            border-radius: var(--border-radius);
            overflow: hidden;
            box-shadow: var(--shadow);
        }

        th, td {
            padding: 20px 16px;
            text-align: left;
            border-bottom: 1px solid var(--border);
        }

        th {
            background: linear-gradient(135deg, var(--light), #f1f5f9);
            font-weight: 600;
            color: var(--gray-dark);
            font-size: 0.875rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            position: relative;
        }

        tbody tr {
            transition: var(--transition);
        }

        tbody tr:hover {
            background: linear-gradient(135deg, rgba(99, 102, 241, 0.02), rgba(6, 182, 212, 0.02));
            transform: scale(1.005);
        }

        tbody tr:last-child td {
            border-bottom: none;
        }

        tfoot td {
            background: linear-gradient(135deg, var(--light), #f1f5f9);
            font-weight: 600;
            color: var(--dark);
            border-top: 2px solid var(--primary);
        }

        .negative {
            color: var(--danger);
            font-weight: 600;
        }

        .actions-cell {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        .category-badge {
            background: linear-gradient(135deg, rgba(99, 102, 241, 0.1), rgba(6, 182, 212, 0.1));
            color: var(--primary);
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 500;
            border: 1px solid rgba(99, 102, 241, 0.2);
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: var(--gray);
        }

        .empty-state-icon {
            font-size: 4rem;
            margin-bottom: 16px;
            opacity: 0.5;
        }

        .empty-state h3 {
            font-size: 1.5rem;
            margin-bottom: 8px;
            color: var(--gray-dark);
        }

        .empty-state p {
            font-size: 1rem;
            margin-bottom: 24px;
        }

        /* Animations */
        @keyframes slideInDown {
            from {
                transform: translateY(-20px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }



        /* Responsive Design */
        @media (max-width: 768px) {
            .container {
                margin: 12px;
                padding: 20px;
            }
            
            header {
                flex-direction: column;
                gap: 20px;
                text-align: center;
                padding: 24px 0;
            }

            header h1 {
                font-size: 2rem;
            }

            .content-section {
                padding: 24px 20px;
            }
            
            .nav-menu {
                flex-wrap: wrap;
                gap: 4px;
            }
            
            .nav-menu a {
                flex: none;
                min-width: 120px;
                padding: 12px 16px;
            }

            .form-grid {
                grid-template-columns: 1fr;
                gap: 16px;
            }

            .form-actions {
                flex-direction: column;
            }
            
            table {
                font-size: 0.85rem;
            }
            
            th, td {
                padding: 12px 8px;
            }

            .actions-cell {
                flex-direction: column;
            }

            .btn-info, .btn-danger {
                font-size: 0.8rem;
                padding: 6px 12px;
            }
        }

        @media (max-width: 480px) {
            header h1 {
                font-size: 1.75rem;
            }

            .content-section h2 {
                font-size: 1.5rem;
            }

            th, td {
                padding: 8px 6px;
                font-size: 0.8rem;
            }
        }
    </style>
</head>
<body>
    <div class="background-pattern"></div>
    <div class="container">
        <header>
            <h1>Expense Manager</h1>
            <div class="user-info">
                <div class="user-avatar"><%= user.getUsername().substring(0, 1).toUpperCase() %></div>
                <span>Welcome, <%= user.getUsername() %>!</span>
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
            <div class="alert <%= message.contains("successfully") ? "alert-success" : "alert-danger" %>"><%= message %></div>
        <% } %>
        
        <div class="content-section">
            <h2>💳 <%= "edit".equals(action) ? "Edit Expense" : "Add New Expense" %></h2>
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
                
                <div class="form-grid">
                    <div class="form-group">
                        <label for="description">Description</label>
                        <input type="text" id="description" name="description" class="form-control" 
                               placeholder="Enter expense description" 
                               value="<%= editExpense != null ? editExpense.getDescription() : "" %>" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="amount">Amount</label>
                        <input type="number" id="amount" name="amount" step="0.01" class="form-control" 
                               placeholder="0.00" 
                               value="<%= editExpense != null ? editExpense.getAmount() : "" %>" required>
                    </div>
                </div>

                <div class="form-grid">
                    <div class="form-group">
                        <label for="category">Category</label>
                        <select id="category" name="category" class="form-control" required>
                            <option value="">Select Category</option>
                            <option value="Food" <%= editExpense != null && "Food".equals(editExpense.getCategory()) ? "selected" : "" %>>🍕 Food</option>
                            <option value="Transport" <%= editExpense != null && "Transport".equals(editExpense.getCategory()) ? "selected" : "" %>>🚗 Transport</option>
                            <option value="Entertainment" <%= editExpense != null && "Entertainment".equals(editExpense.getCategory()) ? "selected" : "" %>>🎬 Entertainment</option>
                            <option value="Bills" <%= editExpense != null && "Bills".equals(editExpense.getCategory()) ? "selected" : "" %>>📱 Bills</option>
                            <option value="Healthcare" <%= editExpense != null && "Healthcare".equals(editExpense.getCategory()) ? "selected" : "" %>>🏥 Healthcare</option>
                            <option value="Shopping" <%= editExpense != null && "Shopping".equals(editExpense.getCategory()) ? "selected" : "" %>>🛍️ Shopping</option>
                            <option value="Other" <%= editExpense != null && "Other".equals(editExpense.getCategory()) ? "selected" : "" %>>📦 Other</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="date">Date</label>
                        <input type="date" id="date" name="date" class="form-control"
                               value="<%= editExpense != null ? editExpense.getDate() : "" %>" required>
                    </div>
                </div>
                
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">
                        <%= "edit".equals(action) ? "✏️ Update Expense" : "➕ Add Expense" %>
                    </button>
                    <% if ("edit".equals(action)) { %>
                        <a href="expenses.jsp" class="btn btn-secondary">🔄 Cancel</a>
                    <% } else { %>
                        <button type="reset" class="btn btn-secondary">🔄 Clear Form</button>
                    <% } %>
                </div>
            </form>
        </div>
        
        <div class="content-section">
            <h2>📊 Your Expenses</h2>
            
            <% if (expenses.isEmpty()) { %>
                <div class="empty-state">
                    <div class="empty-state-icon">💳</div>
                    <h3>No expenses yet</h3>
                    <p>Start tracking your expenses by adding your first entry above.</p>
                </div>
            <% } else { %>
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
                            String categoryIcon = "📦";
                            switch(expense.getCategory()) {
                                case "Food": categoryIcon = "🍕"; break;
                                case "Transport": categoryIcon = "🚗"; break;
                                case "Entertainment": categoryIcon = "🎬"; break;
                                case "Bills": categoryIcon = "📱"; break;
                                case "Healthcare": categoryIcon = "🏥"; break;
                                case "Shopping": categoryIcon = "🛍️"; break;
                            }
                        %>
                        <tr>
                            <td><%= expense.getDate() %></td>
                            <td><%= expense.getDescription() %></td>
                            <td><span class="category-badge"><%= categoryIcon %> <%= expense.getCategory() %></span></td>
                            <td class="negative">$<%= String.format("%.2f", expense.getAmount()) %></td>
                            <td>
                                <div class="actions-cell">
                                    <a href="expenses.jsp?action=edit&id=<%= expense.getId() %>" class="btn btn-info">✏️ Edit</a>
                                    <a href="expenses.jsp?action=delete&id=<%= expense.getId() %>" class="btn btn-danger" 
                                       onclick="return confirm('Are you sure you want to delete this expense?')">🗑️ Delete</a>
                                </div>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                    <tfoot>
                        <tr>
                            <td colspan="3"><strong>Total Expenses:</strong></td>
                            <td class="negative"><strong>$<%= String.format("%.2f", total) %></strong></td>
                            <td></td>
                        </tr>
                    </tfoot>
                </table>
            <% } %>
        </div>
    </div>

    <script>
        // Auto-set today's date for new expenses
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