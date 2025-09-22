<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.expense.util.DatabaseConnection, com.expense.model.Expense, java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Expense Manager</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>
    <div class="container">
        <h1>Expense Manager</h1>
        
        <!-- Add Expense Form -->
        <div class="form-section">
            <h2>Add New Expense</h2>
            <form method="post" action="index.jsp">
                <input type="text" name="description" placeholder="Description" required>
                <input type="number" name="amount" step="0.01" placeholder="Amount" required>
                <select name="category" required>
                    <option value="">Select Category</option>
                    <option value="Food">Food</option>
                    <option value="Transport">Transport</option>
                    <option value="Entertainment">Entertainment</option>
                    <option value="Bills">Bills</option>
                    <option value="Other">Other</option>
                </select>
                <input type="date" name="date" required>
                <button type="submit" name="action" value="add">Add Expense</button>
            </form>
        </div>

        <%
        // Handle form submission
        if ("add".equals(request.getParameter("action"))) {
            String description = request.getParameter("description");
            String amountStr = request.getParameter("amount");
            String category = request.getParameter("category");
            String dateStr = request.getParameter("date");
            
            if (description != null && amountStr != null && category != null && dateStr != null) {
                try {
                    double amount = Double.parseDouble(amountStr);
                    java.sql.Date date = java.sql.Date.valueOf(dateStr);
                    
                    Connection conn = DatabaseConnection.getConnection();
                    String sql = "INSERT INTO expenses (description, amount, category, date) VALUES (?, ?, ?, ?)";
                    PreparedStatement stmt = conn.prepareStatement(sql);
                    stmt.setString(1, description);
                    stmt.setDouble(2, amount);
                    stmt.setString(3, category);
                    stmt.setDate(4, date);
                    
                    int result = stmt.executeUpdate();
                    if (result > 0) {
                        out.println("<div class='success'>Expense added successfully!</div>");
                    }
                    
                    stmt.close();
                    conn.close();
                } catch (Exception e) {
                    out.println("<div class='error'>Error: " + e.getMessage() + "</div>");
                }
            }
        }
        %>

        <!-- Display Expenses -->
        <div class="expenses-section">
            <h2>Recent Expenses</h2>
            <table>
                <thead>
                    <tr>
                        <th>Date</th>
                        <th>Description</th>
                        <th>Category</th>
                        <th>Amount</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    try {
                        Connection conn = DatabaseConnection.getConnection();
                        String sql = "SELECT * FROM expenses ORDER BY date DESC LIMIT 10";
                        Statement stmt = conn.createStatement();
                        ResultSet rs = stmt.executeQuery(sql);
                        
                        double total = 0;
                        while (rs.next()) {
                            total += rs.getDouble("amount");
                    %>
                    <tr>
                        <td><%= rs.getDate("date") %></td>
                        <td><%= rs.getString("description") %></td>
                        <td><%= rs.getString("category") %></td>
                        <td>$<%= String.format("%.2f", rs.getDouble("amount")) %></td>
                    </tr>
                    <%
                        }
                        rs.close();
                        stmt.close();
                        conn.close();
                    %>
                </tbody>
                <tfoot>
                    <tr>
                        <td colspan="3"><strong>Total:</strong></td>
                        <td><strong>$<%= String.format("%.2f", total) %></strong></td>
                    </tr>
                </tfoot>
                <%
                    } catch (Exception e) {
                        out.println("<tr><td colspan='4'>Error loading expenses: " + e.getMessage() + "</td></tr>");
                    }
                %>
            </table>
        </div>
    </div>
</body>
</html>