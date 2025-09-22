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

        .logout-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s;
        }

        .logout-btn:hover::before {
            left: 100%;
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

        .dashboard-summary {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: 24px;
            margin-bottom: 48px;
        }

        .summary-card {
            backdrop-filter: blur(20px);
            padding: 32px;
            border-radius: var(--border-radius);
            text-align: center;
            position: relative;
            overflow: hidden;
            transition: var(--transition);
            border: 1px solid var(--glass-border);
        }

        .summary-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--primary), var(--info));
        }

        .summary-card:hover {
            transform: translateY(-8px) scale(1.02);
            box-shadow: var(--shadow-xl);
        }

        .summary-card.income {
            background: linear-gradient(135deg, rgba(16, 185, 129, 0.1), rgba(52, 211, 153, 0.05));
            border-color: rgba(16, 185, 129, 0.2);
        }

        .summary-card.income::before {
            background: linear-gradient(90deg, var(--success), var(--success-light));
        }

        .summary-card.expense {
            background: linear-gradient(135deg, rgba(239, 68, 68, 0.1), rgba(248, 113, 113, 0.05));
            border-color: rgba(239, 68, 68, 0.2);
        }

        .summary-card.expense::before {
            background: linear-gradient(90deg, var(--danger), var(--danger-light));
        }

        .summary-card.balance.positive {
            background: linear-gradient(135deg, rgba(6, 182, 212, 0.1), rgba(34, 211, 238, 0.05));
            border-color: rgba(6, 182, 212, 0.2);
        }

        .summary-card.balance.positive::before {
            background: linear-gradient(90deg, var(--info), var(--info-light));
        }

        .summary-card.balance.negative {
            background: linear-gradient(135deg, rgba(245, 158, 11, 0.1), rgba(251, 191, 36, 0.05));
            border-color: rgba(245, 158, 11, 0.2);
        }

        .summary-card.balance.negative::before {
            background: linear-gradient(90deg, var(--warning), var(--warning-light));
        }

        .card-icon {
            font-size: 2.5rem;
            margin-bottom: 16px;
            filter: drop-shadow(0 4px 8px rgba(0,0,0,0.1));
        }

        .summary-card h3 {
            font-size: 0.875rem;
            font-weight: 600;
            margin-bottom: 16px;
            color: var(--gray-dark);
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .summary-card .amount {
            font-size: 2.75rem;
            font-weight: 700;
            margin: 0;
            background: linear-gradient(135deg, var(--dark), var(--gray-dark));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            letter-spacing: -0.025em;
        }

        .quick-actions {
            margin-bottom: 48px;
            text-align: center;
        }

        .quick-actions h2 {
            color: var(--dark);
            margin-bottom: 32px;
            font-weight: 600;
            font-size: 1.75rem;
        }

        .action-buttons {
            display: flex;
            gap: 20px;
            justify-content: center;
            flex-wrap: wrap;
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
            padding: 16px 32px;
            border-radius: var(--border-radius-sm);
            font-size: 0.95rem;
            position: relative;
            overflow: hidden;
            min-width: 160px;
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
            transform: translateY(-3px);
            box-shadow: var(--shadow-lg);
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: var(--white);
        }

        .btn-success {
            background: linear-gradient(135deg, var(--success), var(--success-light));
            color: var(--white);
        }

        .btn-info {
            background: linear-gradient(135deg, var(--info), var(--info-light));
            color: var(--white);
        }

        .recent-transactions {
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(20px);
            border-radius: var(--border-radius);
            padding: 32px;
            border: 1px solid var(--glass-border);
            box-shadow: var(--shadow-lg);
        }

        .recent-transactions h2 {
            color: var(--dark);
            margin-bottom: 32px;
            font-weight: 600;
            font-size: 1.5rem;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .recent-transactions h2::before {
            content: '📊';
            font-size: 1.25rem;
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
            transform: scale(1.01);
        }

        .positive {
            color: var(--success);
            font-weight: 600;
        }

        .negative {
            color: var(--danger);
            font-weight: 600;
        }

        .income {
            background: linear-gradient(135deg, rgba(16, 185, 129, 0.1), transparent);
            color: var(--success);
            padding: 4px 12px;
            border-radius: 20px;
            font-weight: 500;
            font-size: 0.8rem;
        }

        .expense {
            background: linear-gradient(135deg, rgba(239, 68, 68, 0.1), transparent);
            color: var(--danger);
            padding: 4px 12px;
            border-radius: 20px;
            font-weight: 500;
            font-size: 0.8rem;
        }

        /* Animations */
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

        .summary-card {
            animation: fadeInUp 0.6s ease-out;
        }

        .summary-card:nth-child(1) { animation-delay: 0.1s; }
        .summary-card:nth-child(2) { animation-delay: 0.2s; }
        .summary-card:nth-child(3) { animation-delay: 0.3s; }

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
            
            .dashboard-summary {
                grid-template-columns: 1fr;
                gap: 16px;
            }
            
            .action-buttons {
                flex-direction: column;
                align-items: center;
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
            
            table {
                font-size: 0.85rem;
            }
            
            th, td {
                padding: 12px 8px;
            }
            
            .summary-card .amount {
                font-size: 2rem;
            }

            .recent-transactions {
                padding: 20px;
            }
        }

        @media (max-width: 480px) {
            .summary-card {
                padding: 24px 16px;
            }
            
            .summary-card .amount {
                font-size: 1.75rem;
            }

            header h1 {
                font-size: 1.75rem;
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
                <div class="card-icon">💰</div>
                <h3>Total Income</h3>
                <p class="amount">$<%= String.format("%.2f", totalIncome) %></p>
            </div>
            
            <div class="summary-card expense">
                <div class="card-icon">💳</div>
                <h3>Total Expenses</h3>
                <p class="amount">$<%= String.format("%.2f", totalExpenses) %></p>
            </div>
            
            <div class="summary-card balance <%= netBalance >= 0 ? "positive" : "negative" %>">
                <div class="card-icon"><%= netBalance >= 0 ? "📈" : "📉" %></div>
                <h3>Net Balance</h3>
                <p class="amount">$<%= String.format("%.2f", netBalance) %></p>
            </div>
        </div>
        
        <div class="quick-actions">
            <h2>Quick Actions</h2>
            <div class="action-buttons">
                <a href="expenses.jsp?action=add" class="btn btn-primary">
                    <span style="margin-right: 8px;">➖</span>Add Expense
                </a>
                <a href="income.jsp?action=add" class="btn btn-success">
                    <span style="margin-right: 8px;">➕</span>Add Income
                </a>
                <a href="reports.jsp" class="btn btn-info">
                    <span style="margin-right: 8px;">📈</span>View Reports
                </a>
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
                    
                    for (int i = 0; i < Math.min(10, recentTransactions.size()); i++) {
                        Map<String, Object> transaction = recentTransactions.get(i);
                        double amount = (Double) transaction.get("amount");
                    %>
                    <tr>
                        <td><%= transaction.get("date") %></td>
                        <td><%= transaction.get("description") %></td>
                        <td><%= transaction.get("category") %></td>
                        <td><span class="<%= transaction.get("type").toString().toLowerCase() %>"><%= transaction.get("type") %></span></td>
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