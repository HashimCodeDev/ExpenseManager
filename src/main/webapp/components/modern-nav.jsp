<%-- Modern navigation component with dark theme --%>
<%@ page import="com.expense.model.User" %>
<%
User navUser = (User) session.getAttribute("user");
String currentPage = request.getRequestURI();
%>

<nav style="position: fixed; top: 0; left: 0; right: 0; z-index: 50; background: rgba(30, 41, 59, 0.9); backdrop-filter: blur(20px); border-bottom: 1px solid rgba(255, 255, 255, 0.1);">
    <div style="max-width: 1200px; margin: 0 auto; padding: 0 20px;">
        <div style="display: flex; justify-content: space-between; align-items: center; height: 60px;">
            <!-- Logo -->
            <div style="display: flex; align-items: center; gap: 12px;">
                <div style="width: 40px; height: 40px; background: linear-gradient(135deg, var(--primary), var(--secondary)); border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 20px;">
                    💰
                </div>
                <h1 style="font-family: 'Space Grotesk', sans-serif; font-size: 20px; font-weight: 700; color: var(--light);">
                    ExpenseFlow
                </h1>
            </div>

            <!-- Navigation Links -->
            <div style="display: flex; align-items: center; gap: 8px;">
                <a href="dashboard.jsp" 
                   style="padding: 8px 16px; border-radius: 8px; font-size: 14px; font-weight: 500; transition: all 0.3s; text-decoration: none; <%= currentPage.contains("dashboard") ? "background: rgba(99, 102, 241, 0.2); color: #a5b4fc;" : "color: var(--gray); hover: color: var(--light);" %>">
                    Dashboard
                </a>
                <a href="expenses.jsp" 
                   style="padding: 8px 16px; border-radius: 8px; font-size: 14px; font-weight: 500; transition: all 0.3s; text-decoration: none; <%= currentPage.contains("expenses") ? "background: rgba(239, 68, 68, 0.2); color: #fca5a5;" : "color: var(--gray);" %>">
                    Expenses
                </a>
                <a href="income.jsp" 
                   style="padding: 8px 16px; border-radius: 8px; font-size: 14px; font-weight: 500; transition: all 0.3s; text-decoration: none; <%= currentPage.contains("income") ? "background: rgba(16, 185, 129, 0.2); color: #6ee7b7;" : "color: var(--gray);" %>">
                    Income
                </a>
                <a href="reports.jsp" 
                   style="padding: 8px 16px; border-radius: 8px; font-size: 14px; font-weight: 500; transition: all 0.3s; text-decoration: none; <%= currentPage.contains("reports") ? "background: rgba(6, 182, 212, 0.2); color: #67e8f9;" : "color: var(--gray);" %>">
                    Reports
                </a>
            </div>

            <!-- User Menu -->
            <div style="display: flex; align-items: center; gap: 16px;">
                <% if (navUser != null) { %>
                <div style="display: flex; align-items: center; gap: 12px;">
                    <div style="width: 32px; height: 32px; background: linear-gradient(135deg, var(--primary), var(--secondary)); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-size: 14px; font-weight: 600;">
                        <%= navUser.getUsername().substring(0, 1).toUpperCase() %>
                    </div>
                    <span style="font-size: 14px; color: var(--light);"><%= navUser.getUsername() %></span>
                    <a href="logout.jsp" class="btn btn-danger" style="padding: 8px 16px; font-size: 14px;">
                        Logout
                    </a>
                </div>
                <% } %>
            </div>
        </div>
    </div>
</nav>