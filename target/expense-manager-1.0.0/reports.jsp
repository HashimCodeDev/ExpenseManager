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

// Get filter parameters
String startDateStr = request.getParameter("startDate");
String endDateStr = request.getParameter("endDate");
String categoryFilter = request.getParameter("category");

List<Expense> expenses = expenseDAO.getExpensesByUser(user.getId());
List<Income> incomes = incomeDAO.getIncomeByUser(user.getId());

// Apply filters
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

// Combine and sort transactions
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

// Sort by date
allTransactions.sort((a, b) -> ((Date)a.get("date")).compareTo((Date)b.get("date")));

// Calculate running balance
double runningBalance = 0;
for (Map<String, Object> transaction : allTransactions) {
    runningBalance += (Double) transaction.get("amount");
    transaction.put("balance", runningBalance);
}

// Calculate totals
double totalIncome = incomes.stream().mapToDouble(Income::getAmount).sum();
double totalExpenses = expenses.stream().mapToDouble(Expense::getAmount).sum();
double netBalance = totalIncome - totalExpenses;
%>
<!DOCTYPE html>
<html>
<head>
    <title>Reports - Expense Manager</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="css/modern-style.css">
    <style>
        .filter-form {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 16px;
            align-items: end;
        }
        .export-section {
            text-align: center;
            margin: 24px 0;
        }
        .report-summary {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 32px;
        }
        .summary-card {
            backdrop-filter: blur(20px);
            padding: 24px;
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
        .summary-card h3 {
            font-size: 0.875rem;
            font-weight: 600;
            margin-bottom: 12px;
            color: var(--gray-dark);
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        .summary-card .amount {
            font-size: 1.75rem;
            font-weight: 700;
            margin: 0;
            background: linear-gradient(135deg, var(--dark), var(--gray-dark));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
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
            <a href="expenses.jsp">Expenses</a>
            <a href="income.jsp">Income</a>
            <a href="reports.jsp" class="active">Reports</a>
        </nav>
        
        <div class="content-section">
            <h2>🔍 Filter Transactions</h2>
            <form method="get" action="reports.jsp" class="filter-form">
                <div class="form-group">
                    <label>Start Date</label>
                    <input type="date" name="startDate" class="form-control" value="<%= startDateStr != null ? startDateStr : "" %>">
                </div>
                <div class="form-group">
                    <label>End Date</label>
                    <input type="date" name="endDate" class="form-control" value="<%= endDateStr != null ? endDateStr : "" %>">
                </div>
                <div class="form-group">
                    <label>Category</label>
                    <select name="category" class="form-control">
                        <option value="">All Categories</option>
                        <option value="Food" <%= "Food".equals(categoryFilter) ? "selected" : "" %>>Food</option>
                        <option value="Transport" <%= "Transport".equals(categoryFilter) ? "selected" : "" %>>Transport</option>
                        <option value="Entertainment" <%= "Entertainment".equals(categoryFilter) ? "selected" : "" %>>Entertainment</option>
                        <option value="Bills" <%= "Bills".equals(categoryFilter) ? "selected" : "" %>>Bills</option>
                        <option value="Healthcare" <%= "Healthcare".equals(categoryFilter) ? "selected" : "" %>>Healthcare</option>
                        <option value="Shopping" <%= "Shopping".equals(categoryFilter) ? "selected" : "" %>>Shopping</option>
                        <option value="Job" <%= "Job".equals(categoryFilter) ? "selected" : "" %>>Job</option>
                        <option value="Freelance" <%= "Freelance".equals(categoryFilter) ? "selected" : "" %>>Freelance</option>
                        <option value="Investment" <%= "Investment".equals(categoryFilter) ? "selected" : "" %>>Investment</option>
                        <option value="Business" <%= "Business".equals(categoryFilter) ? "selected" : "" %>>Business</option>
                        <option value="Gift" <%= "Gift".equals(categoryFilter) ? "selected" : "" %>>Gift</option>
                        <option value="Other" <%= "Other".equals(categoryFilter) ? "selected" : "" %>>Other</option>
                    </select>
                </div>
                <div class="form-group">
                    <button type="submit" class="btn btn-primary">Filter</button>
                    <a href="reports.jsp" class="btn btn-secondary" style="margin-left: 8px;">Clear</a>
                </div>
            </form>
        </div>
        
        <div class="report-summary">
            <div class="summary-card income">
                <h3>💰 Total Income</h3>
                <p class="amount">$<%= String.format("%.2f", totalIncome) %></p>
            </div>
            
            <div class="summary-card expense">
                <h3>💳 Total Expenses</h3>
                <p class="amount">$<%= String.format("%.2f", totalExpenses) %></p>
            </div>
            
            <div class="summary-card balance <%= netBalance >= 0 ? "positive" : "negative" %>">
                <h3><%= netBalance >= 0 ? "📈" : "📉" %> Net Balance</h3>
                <p class="amount">$<%= String.format("%.2f", netBalance) %></p>
            </div>
        </div>
        
        <div class="export-section">
            <a href="export.jsp?<%= request.getQueryString() != null ? request.getQueryString() : "" %>" 
               class="btn btn-info">
                📄 Export to CSV
            </a>
        </div>
        
        <div class="content-section">
            <h2>📊 All Transactions</h2>
            <table>
                <thead>
                    <tr>
                        <th>Date</th>
                        <th>Description</th>
                        <th>Category</th>
                        <th>Type</th>
                        <th>Amount</th>
                        <th>Running Balance</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    for (Map<String, Object> transaction : allTransactions) {
                        double amount = (Double) transaction.get("amount");
                        double balance = (Double) transaction.get("balance");
                    %>
                    <tr>
                        <td><%= transaction.get("date") %></td>
                        <td><%= transaction.get("description") %></td>
                        <td><%= transaction.get("category") %></td>
                        <td><span class="<%= transaction.get("type").toString().toLowerCase() %>"><%= transaction.get("type") %></span></td>
                        <td class="<%= amount >= 0 ? "positive" : "negative" %>">$<%= String.format("%.2f", Math.abs(amount)) %></td>
                        <td class="<%= balance >= 0 ? "positive" : "negative" %>">$<%= String.format("%.2f", balance) %></td>
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