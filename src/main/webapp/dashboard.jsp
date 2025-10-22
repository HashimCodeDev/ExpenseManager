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
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - ExpenseFlow</title>
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

        /* Header */
        .header {
            margin-bottom: 32px;
            animation: fadeInUp 0.8s ease-out;
        }

        .header h1 {
            font-family: 'Space Grotesk', sans-serif;
            font-size: 36px;
            font-weight: 700;
            margin-bottom: 8px;
        }

        .header p {
            color: var(--gray);
            font-size: 16px;
        }

        /* Stats Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 24px;
            margin-bottom: 32px;
        }

        .stat-card {
            background: rgba(30, 41, 59, 0.8);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 20px;
            padding: 28px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
            animation: fadeInUp 0.8s ease-out;
            animation-fill-mode: both;
            position: relative;
            overflow: hidden;
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, transparent, rgba(255, 255, 255, 0.05));
            opacity: 0;
            transition: opacity 0.3s;
        }

        .stat-card:hover::before {
            opacity: 1;
        }

        .stat-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
        }

        .stat-card:nth-child(1) { animation-delay: 0.1s; }
        .stat-card:nth-child(2) { animation-delay: 0.2s; }
        .stat-card:nth-child(3) { animation-delay: 0.3s; }

        .stat-info h3 {
            color: var(--gray);
            font-size: 14px;
            font-weight: 500;
            margin-bottom: 8px;
        }

        .stat-info p {
            font-size: 32px;
            font-weight: 700;
        }

        .stat-icon {
            width: 64px;
            height: 64px;
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
        }

        .stat-income {
            background: linear-gradient(135deg, var(--success), #059669);
            box-shadow: 0 10px 30px rgba(16, 185, 129, 0.3);
        }

        .stat-expense {
            background: linear-gradient(135deg, var(--danger), #dc2626);
            box-shadow: 0 10px 30px rgba(239, 68, 68, 0.3);
        }

        .stat-balance {
            background: linear-gradient(135deg, var(--info), #2563eb);
            box-shadow: 0 10px 30px rgba(59, 130, 246, 0.3);
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

        .card:nth-child(4) { animation-delay: 0.4s; }
        .card:nth-child(5) { animation-delay: 0.5s; }

        .card-header {
            margin-bottom: 24px;
        }

        .card-header h2 {
            font-size: 24px;
            font-weight: 600;
            margin-bottom: 4px;
        }

        /* Quick Actions */
        .actions-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 16px;
        }

        .action-btn {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
            padding: 20px;
            border-radius: 12px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s;
            border: 2px solid transparent;
        }

        .action-btn svg {
            width: 24px;
            height: 24px;
            transition: transform 0.3s;
        }

        .action-btn:hover svg {
            transform: scale(1.1);
        }

        .action-expense {
            background: rgba(239, 68, 68, 0.1);
            color: #fca5a5;
            border-color: rgba(239, 68, 68, 0.3);
        }

        .action-expense:hover {
            background: rgba(239, 68, 68, 0.2);
            border-color: var(--danger);
        }

        .action-income {
            background: rgba(16, 185, 129, 0.1);
            color: #6ee7b7;
            border-color: rgba(16, 185, 129, 0.3);
        }

        .action-income:hover {
            background: rgba(16, 185, 129, 0.2);
            border-color: var(--success);
        }

        .action-reports {
            background: rgba(59, 130, 246, 0.1);
            color: #93c5fd;
            border-color: rgba(59, 130, 246, 0.3);
        }

        .action-reports:hover {
            background: rgba(59, 130, 246, 0.2);
            border-color: var(--info);
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

        th:last-child {
            text-align: right;
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

        td:last-child {
            text-align: right;
        }

        .badge {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 600;
        }

        .badge-income {
            background: rgba(16, 185, 129, 0.1);
            color: #6ee7b7;
        }

        .badge-expense {
            background: rgba(239, 68, 68, 0.1);
            color: #fca5a5;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
        }

        .empty-state svg {
            width: 80px;
            height: 80px;
            color: var(--gray);
            margin: 0 auto 24px;
            opacity: 0.5;
        }

        .empty-state h3 {
            font-size: 20px;
            margin-bottom: 12px;
        }

        .empty-state p {
            color: var(--gray);
            margin-bottom: 24px;
        }

        .empty-actions {
            display: flex;
            gap: 12px;
            justify-content: center;
        }

        .btn {
            padding: 12px 24px;
            border-radius: 10px;
            border: none;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s;
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

            .header h1 {
                font-size: 28px;
            }

            .stats-grid {
                grid-template-columns: 1fr;
            }

            .actions-grid {
                grid-template-columns: 1fr;
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

    <div class="header">
        <h1>Welcome back, <%= user.getUsername() %>! 👋</h1>
        <p>Here's your financial overview for today.</p>
    </div>

    <%
        ExpenseDAO expenseDAO = new ExpenseDAO();
        IncomeDAO incomeDAO = new IncomeDAO();
        double totalExpenses = expenseDAO.getTotalExpenses(user.getId());
        double totalIncome = incomeDAO.getTotalIncome(user.getId());
        double netBalance = totalIncome - totalExpenses;
    %>

    <div class="stats-grid">
        <div class="stat-card stat-income">
            <div class="stat-info">
                <h3>Total Income</h3>
                <p>$<%= String.format("%.2f", totalIncome) %></p>
            </div>
            <div class="stat-icon" style="background: rgba(255, 255, 255, 0.2);">
                <svg width="32" height="32" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1"/>
                </svg>
            </div>
        </div>

        <div class="stat-card stat-expense">
            <div class="stat-info">
                <h3>Total Expenses</h3>
                <p>$<%= String.format("%.2f", totalExpenses) %></p>
            </div>
            <div class="stat-icon" style="background: rgba(255, 255, 255, 0.2);">
                <svg width="32" height="32" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 9V7a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2m2 4h10a2 2 0 002-2v-6a2 2 0 00-2-2H9a2 2 0 00-2 2v6a2 2 0 002 2zm7-5a2 2 0 11-4 0 2 2 0 014 0z"/>
                </svg>
            </div>
        </div>

        <div class="stat-card stat-balance">
            <div class="stat-info">
                <h3>Net Balance</h3>
                <p>$<%= String.format("%.2f", netBalance) %></p>
            </div>
            <div class="stat-icon" style="background: rgba(255, 255, 255, 0.2);">
                <svg width="32" height="32" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6"/>
                </svg>
            </div>
        </div>
    </div>

    <div class="card">
        <div class="card-header">
            <h2>Quick Actions</h2>
        </div>
        <div class="actions-grid">
            <a href="expenses.jsp?action=add" class="action-btn action-expense">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"/>
                </svg>
                Add Expense
            </a>
            <a href="income.jsp?action=add" class="action-btn action-income">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"/>
                </svg>
                Add Income
            </a>
            <a href="reports.jsp" class="action-btn action-reports">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"/>
                </svg>
                View Reports
            </a>
        </div>
    </div>

    <div class="card">
        <div class="card-header" style="display: flex; justify-content: space-between; align-items: center;">
            <h2>Recent Transactions</h2>
            <a href="reports.jsp" class="btn btn-primary" style="padding: 8px 16px; font-size: 14px;">View All</a>
        </div>

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
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"/>
            </svg>
            <h3>No transactions yet</h3>
            <p>Start by adding your first income or expense entry.</p>
            <div class="empty-actions">
                <a href="expenses.jsp?action=add" class="btn btn-primary">Add Expense</a>
                <a href="income.jsp?action=add" class="btn btn-success">Add Income</a>
            </div>
        </div>
        <% } else { %>
        <div class="table-container">
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
                    for (int i = 0; i < Math.min(10, recentTransactions.size()); i++) {
                        Map<String, Object> transaction = recentTransactions.get(i);
                        double amount = (Double) transaction.get("amount");
                        boolean isIncome = transaction.get("type").toString().equals("Income");
                %>
                <tr>
                    <td><%= transaction.get("date") %></td>
                    <td><%= transaction.get("description") %></td>
                    <td>
                                    <span class="badge <%= isIncome ? "badge-income" : "badge-expense" %>">
                                        <%= transaction.get("category") %>
                                    </span>
                    </td>
                    <td>
                                    <span class="badge <%= isIncome ? "badge-income" : "badge-expense" %>">
                                        <%= transaction.get("type") %>
                                    </span>
                    </td>
                    <td style="font-weight: 600; color: <%= amount >= 0 ? "#6ee7b7" : "#fca5a5" %>">
                        <%= amount >= 0 ? "+" : "" %>$<%= String.format("%.2f", Math.abs(amount)) %>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } %>
    </div>
</div>
</body>
</html>