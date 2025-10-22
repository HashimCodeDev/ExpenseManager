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

String startDateStr = request.getParameter("startDate");
String endDateStr = request.getParameter("endDate");
String categoryFilter = request.getParameter("category");

List<Expense> expenses = expenseDAO.getExpensesByUser(user.getId());
List<Income> incomes = incomeDAO.getIncomeByUser(user.getId());

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

allTransactions.sort((a, b) -> ((Date)a.get("date")).compareTo((Date)b.get("date")));

double runningBalance = 0;
for (Map<String, Object> transaction : allTransactions) {
    runningBalance += (Double) transaction.get("amount");
    transaction.put("balance", runningBalance);
}

double totalIncome = incomes.stream().mapToDouble(Income::getAmount).sum();
double totalExpenses = expenses.stream().mapToDouble(Expense::getAmount).sum();
double netBalance = totalIncome - totalExpenses;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports - ExpenseFlow</title>
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

        .grid-cols-3 {
            grid-template-columns: repeat(3, 1fr);
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

        /* Stats Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 24px;
            margin-bottom: 32px;
        }

        .stat-card {
            background: rgba(30, 41, 59, 0.8);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 20px;
            padding: 24px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
            animation: fadeInUp 0.8s ease-out;
            animation-fill-mode: both;
        }

        .stat-income {
            background: linear-gradient(135deg, rgba(16, 185, 129, 0.1), rgba(5, 150, 105, 0.1));
            border-color: rgba(16, 185, 129, 0.3);
        }

        .stat-expense {
            background: linear-gradient(135deg, rgba(239, 68, 68, 0.1), rgba(220, 38, 38, 0.1));
            border-color: rgba(239, 68, 68, 0.3);
        }

        .stat-balance {
            background: linear-gradient(135deg, rgba(99, 102, 241, 0.1), rgba(139, 92, 246, 0.1));
            border-color: rgba(99, 102, 241, 0.3);
        }

        .stat-info h3 {
            font-size: 14px;
            font-weight: 500;
            color: var(--gray);
            margin-bottom: 8px;
        }

        .stat-info p {
            font-size: 24px;
            font-weight: 700;
        }

        .stat-icon {
            width: 60px;
            height: 60px;
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
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

        .badge-danger {
            background: rgba(239, 68, 68, 0.1);
            color: #fca5a5;
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

            .grid-cols-3 {
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
        
    <div class="card">
        <h2 style="font-size: 24px; font-weight: 600; color: var(--light); margin-bottom: 24px;">Filter Transactions</h2>
        
        <form method="get" action="reports.jsp">
            <div class="grid grid-cols-3">
                <div class="form-group">
                    <label class="form-label" for="startDate">Start Date</label>
                    <input type="date" id="startDate" name="startDate" class="form-input"
                           value="<%= startDateStr != null ? startDateStr : "" %>">
                </div>
                <div class="form-group">
                    <label class="form-label" for="endDate">End Date</label>
                    <input type="date" id="endDate" name="endDate" class="form-input"
                           value="<%= endDateStr != null ? endDateStr : "" %>">
                </div>
                <div class="form-group">
                    <label class="form-label" for="category">Category</label>
                    <select id="category" name="category" class="form-input">
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
            </div>
            <div style="display: flex; gap: 16px; margin-top: 24px;">
                <button type="submit" class="btn btn-primary">Filter</button>
                <a href="reports.jsp" class="btn" style="background: var(--gray); color: white;">Clear</a>
            </div>
        </form>
    </div>
        
        <div class="stats-grid">
            <div class="stat-card stat-income animate-fade-in">
                <div class="stat-info">
                    <h3>Total Income</h3>
                    <p style="color: white;">$<%= String.format("%.2f", totalIncome) %></p>
                </div>
                <div class="stat-icon" style="background: rgba(255, 255, 255, 0.2);">💰</div>
            </div>

            <div class="stat-card stat-expense animate-fade-in">
                <div class="stat-info">
                    <h3>Total Expenses</h3>
                    <p style="color: white;">$<%= String.format("%.2f", totalExpenses) %></p>
                </div>
                <div class="stat-icon" style="background: rgba(255, 255, 255, 0.2);">💸</div>
            </div>

            <div class="stat-card <%= netBalance >= 0 ? "stat-balance" : "stat-expense" %> animate-fade-in">
                <div class="stat-info">
                    <h3>Net Balance</h3>
                    <p style="color: white;">$<%= String.format("%.2f", netBalance) %></p>
                </div>
                <div class="stat-icon" style="background: rgba(255, 255, 255, 0.2);"><%= netBalance >= 0 ? "📈" : "📉" %></div>
            </div>
        </div>
        
    <div style="text-align: center; margin-bottom: 32px;">
        <a href="export.jsp?<%= request.getQueryString() != null ? request.getQueryString() : "" %>" 
           class="btn btn-primary">
            📄 Export to CSV
        </a>
    </div>
        
    <div class="card">
        <h2 style="font-size: 24px; font-weight: 600; color: var(--light); margin-bottom: 20px;">All Transactions</h2>
        
        <% if (allTransactions.isEmpty()) { %>
        <div class="empty-state">
            <div style="font-size: 64px; margin-bottom: 16px;">📊</div>
            <h3>No transactions found</h3>
            <p>Try adjusting your filters or add some transactions to see data here.</p>
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
                    <th style="text-align: right;">Amount</th>
                    <th style="text-align: right;">Running Balance</th>
                </tr>
                </thead>
                <tbody>
                <%
                for (Map<String, Object> transaction : allTransactions) {
                    double amount = (Double) transaction.get("amount");
                    double balance = (Double) transaction.get("balance");
                    boolean isIncome = transaction.get("type").toString().equals("Income");
                %>
                <tr>
                    <td><%= transaction.get("date") %></td>
                    <td><%= transaction.get("description") %></td>
                    <td>
                        <span class="badge <%= isIncome ? "badge-success" : "badge-danger" %>">
                            <%= transaction.get("category") %>
                        </span>
                    </td>
                    <td>
                        <span class="badge <%= isIncome ? "badge-success" : "badge-danger" %>">
                            <%= transaction.get("type") %>
                        </span>
                    </td>
                    <td style="text-align: right; font-weight: 600; color: <%= amount >= 0 ? "#6ee7b7" : "#fca5a5" %>;">
                        <%= amount >= 0 ? "+" : "" %>$<%= String.format("%.2f", Math.abs(amount)) %>
                    </td>
                    <td style="text-align: right; font-weight: 700; color: <%= balance >= 0 ? "#6ee7b7" : "#fca5a5" %>;">
                        $<%= String.format("%.2f", balance) %>
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