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
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Income - ExpenseFlow</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        :root {
            --primary: #6366f1;
            --secondary: #8b5cf6;
            --accent: #ec4899;
            --dark: #0f172a;
            --card-bg: #1e293b;
            --light: #f8fafc;
            --gray: #64748b;
            --success: #10b981;
            --danger: #ef4444;
            --warning: #f59e0b;
            --info: #3b82f6;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: var(--dark);
            color: var(--light);
            min-height: 100vh;
            position: relative;
        }

        .bg-animation {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: 0;
            background: linear-gradient(to bottom, #0f172a, #1e293b);
        }

        .orb {
            position: absolute;
            border-radius: 50%;
            filter: blur(80px);
            opacity: 0.4;
            animation: float 20s infinite ease-in-out;
        }

        .orb-1 {
            width: 400px;
            height: 400px;
            background: var(--primary);
            top: -200px;
            right: -100px;
            animation-delay: 0s;
        }

        .orb-2 {
            width: 350px;
            height: 350px;
            background: var(--accent);
            bottom: -150px;
            left: -100px;
            animation-delay: -10s;
        }

        .orb-3 {
            width: 300px;
            height: 300px;
            background: var(--secondary);
            top: 50%;
            left: 50%;
            animation-delay: -5s;
        }

        @keyframes float {
            0%, 100% {
                transform: translate(0, 0) scale(1);
            }
            33% {
                transform: translate(50px, -50px) scale(1.1);
            }
            66% {
                transform: translate(-30px, 30px) scale(0.9);
            }
        }

        .container {
            position: relative;
            z-index: 10;
            max-width: 1400px;
            margin: 0 auto;
            padding: 20px;
        }

        /* Navigation */
        .navbar {
            background: rgba(30, 41, 59, 0.8);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 16px;
            padding: 16px 24px;
            margin-bottom: 32px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
            animation: fadeInDown 0.6s ease-out;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 12px;
            font-family: 'Space Grotesk', sans-serif;
            font-size: 24px;
            font-weight: 700;
            color: var(--light);
        }

        .logo-icon {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
        }

        .nav-links {
            display: flex;
            gap: 8px;
            align-items: center;
        }

        .nav-link {
            padding: 10px 20px;
            color: var(--light);
            text-decoration: none;
            border-radius: 10px;
            transition: all 0.3s;
            font-weight: 500;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .nav-link:hover {
            background: rgba(99, 102, 241, 0.1);
            color: var(--primary);
        }

        .btn-logout {
            background: linear-gradient(135deg, var(--danger), #dc2626);
            color: white;
            padding: 10px 20px;
            border-radius: 10px;
            border: none;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s;
            box-shadow: 0 4px 15px rgba(239, 68, 68, 0.3);
        }

        .btn-logout:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(239, 68, 68, 0.4);
        }

        /* Alert */
        .alert {
            padding: 16px 20px;
            border-radius: 12px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 12px;
            border: 1px solid;
            animation: slideDown 0.4s ease-out;
        }

        .alert-success {
            background: rgba(16, 185, 129, 0.1);
            border-color: rgba(16, 185, 129, 0.3);
            color: #6ee7b7;
        }

        .alert-error {
            background: rgba(239, 68, 68, 0.1);
            border-color: rgba(239, 68, 68, 0.3);
            color: #fca5a5;
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Cards */
        .card {
            background: rgba(30, 41, 59, 0.8);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 20px;
            padding: 28px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
            margin-bottom: 24px;
            animation: fadeInUp 0.8s ease-out;
            animation-fill-mode: both;
        }

        .card:nth-child(2) { animation-delay: 0.1s; }
        .card:nth-child(3) { animation-delay: 0.2s; }

        /* Form Elements */
        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            display: block;
            font-size: 14px;
            font-weight: 500;
            margin-bottom: 8px;
            color: var(--light);
        }

        .form-input {
            width: 100%;
            padding: 12px 16px;
            background: rgba(15, 23, 42, 0.6);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 10px;
            color: var(--light);
            font-size: 15px;
            transition: all 0.3s;
            outline: none;
        }

        .form-input:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
            background: rgba(15, 23, 42, 0.8);
        }

        select.form-input {
            cursor: pointer;
        }

        .grid {
            display: grid;
            gap: 20px;
        }

        .grid-cols-2 {
            grid-template-columns: repeat(2, 1fr);
        }

        /* Buttons */
        .btn {
            padding: 12px 24px;
            border-radius: 10px;
            border: none;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s;
            font-size: 14px;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            box-shadow: 0 4px 15px rgba(99, 102, 241, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(99, 102, 241, 0.4);
        }

        .btn-success {
            background: linear-gradient(135deg, var(--success), #059669);
            color: white;
            box-shadow: 0 4px 15px rgba(16, 185, 129, 0.3);
        }

        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(16, 185, 129, 0.4);
        }

        .btn-danger {
            background: linear-gradient(135deg, var(--danger), #dc2626);
            color: white;
            box-shadow: 0 4px 15px rgba(239, 68, 68, 0.3);
        }

        .btn-danger:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(239, 68, 68, 0.4);
        }

        /* Table */
        .table-container {
            overflow-x: auto;
            border-radius: 12px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        thead tr {
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        th {
            text-align: left;
            padding: 16px;
            font-weight: 600;
            color: var(--gray);
            font-size: 14px;
        }

        tbody tr {
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
            transition: background 0.3s;
        }

        tbody tr:hover {
            background: rgba(255, 255, 255, 0.02);
        }

        td {
            padding: 16px;
            font-size: 14px;
        }

        tfoot tr {
            border-top: 2px solid rgba(255, 255, 255, 0.1);
        }

        tfoot td {
            font-weight: 700;
            font-size: 16px;
        }

        .badge {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 600;
        }

        .badge-success {
            background: rgba(16, 185, 129, 0.1);
            color: #6ee7b7;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
        }

        .empty-state h3 {
            font-size: 20px;
            margin-bottom: 12px;
            color: var(--light);
        }

        .empty-state p {
            color: var(--gray);
        }

        @keyframes fadeInDown {
            from {
                opacity: 0;
                transform: translateY(-30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @media (max-width: 768px) {
            .navbar {
                flex-direction: column;
                gap: 16px;
            }

            .nav-links {
                flex-wrap: wrap;
                justify-content: center;
            }

            .grid-cols-2 {
                grid-template-columns: 1fr;
            }

            .table-container {
                overflow-x: scroll;
            }
        }
    </style>
</head>
<body>
<div class="bg-animation">
    <div class="orb orb-1"></div>
    <div class="orb orb-2"></div>
    <div class="orb orb-3"></div>
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
    <div class="alert <%= message.contains("successfully") ? "alert-success" : "alert-error" %>">
        <span style="font-size: 18px;"><%= message.contains("successfully") ? "✓" : "✗" %></span>
        <span><%= message %></span>
    </div>
    <% } %>

    <div class="card">
        <h2 style="font-size: 24px; font-weight: 600; color: var(--light); margin-bottom: 24px;">
            <%= "edit".equals(action) ? "Edit Income" : "Add New Income" %>
        </h2>

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
                    <label class="form-label" for="description">Description <span style="color: var(--danger);">*</span></label>
                    <input type="text" id="description" name="description" required class="form-input"
                           placeholder="Enter income description"
                           value="<%= editIncome != null ? editIncome.getDescription() : "" %>">
                </div>

                <div class="form-group">
                    <label class="form-label" for="amount">Amount <span style="color: var(--danger);">*</span></label>
                    <input type="number" id="amount" name="amount" step="0.01" required class="form-input"
                           placeholder="0.00"
                           value="<%= editIncome != null ? editIncome.getAmount() : "" %>">
                </div>
            </div>

            <div class="grid grid-cols-2">
                <div class="form-group">
                    <label class="form-label" for="category">Category <span style="color: var(--danger);">*</span></label>
                    <select id="category" name="category" required class="form-input">
                        <option value="">Select Category</option>
                        <option value="Job" <%= editIncome != null && "Job".equals(editIncome.getCategory()) ? "selected" : "" %>>💼 Job</option>
                        <option value="Freelance" <%= editIncome != null && "Freelance".equals(editIncome.getCategory()) ? "selected" : "" %>>💻 Freelance</option>
                        <option value="Business" <%= editIncome != null && "Business".equals(editIncome.getCategory()) ? "selected" : "" %>>🏢 Business</option>
                        <option value="Investment" <%= editIncome != null && "Investment".equals(editIncome.getCategory()) ? "selected" : "" %>>📈 Investment</option>
                        <option value="Rental" <%= editIncome != null && "Rental".equals(editIncome.getCategory()) ? "selected" : "" %>>🏠 Rental</option>
                        <option value="Gift" <%= editIncome != null && "Gift".equals(editIncome.getCategory()) ? "selected" : "" %>>🎁 Gift</option>
                        <option value="Other" <%= editIncome != null && "Other".equals(editIncome.getCategory()) ? "selected" : "" %>>📦 Other</option>
                    </select>
                </div>

                <div class="form-group">
                    <label class="form-label" for="date">Date <span style="color: var(--danger);">*</span></label>
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

    <div class="card">
        <h2 style="font-size: 24px; font-weight: 600; color: var(--light); margin-bottom: 20px;">Your Income</h2>

        <% if (incomes.isEmpty()) { %>
        <div class="empty-state">
            <div style="font-size: 64px; margin-bottom: 16px;">💰</div>
            <h3>No income yet</h3>
            <p>Start tracking your income by adding your first entry above.</p>
        </div>
        <% } else { %>
        <div class="table-container">
            <table>
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
                    <td style="text-align: right; font-weight: 600; color: #6ee7b7;">$<%= String.format("%.2f", income.getAmount()) %></td>
                    <td style="text-align: center;">
                        <div style="display: flex; justify-content: center; gap: 8px;">
                            <a href="income.jsp?action=edit&id=<%= income.getId() %>" class="btn btn-primary" style="padding: 8px 16px; font-size: 13px;">
                                Edit
                            </a>
                            <a href="income.jsp?action=delete&id=<%= income.getId() %>" class="btn btn-danger" style="padding: 8px 16px; font-size: 13px;"
                               onclick="return confirm('Are you sure you want to delete this income?')">
                                Delete
                            </a>
                        </div>
                    </td>
                </tr>
                <% } %>
                </tbody>
                <tfoot>
                <tr style="background: rgba(15, 23, 42, 0.5);">
                    <td colspan="3" style="font-weight: 600;">Total Income:</td>
                    <td style="text-align: right; font-weight: 700; color: #6ee7b7;">$<%= String.format("%.2f", total) %></td>
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