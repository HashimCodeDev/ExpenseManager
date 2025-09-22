package com.expense.dao;

import com.expense.model.Income;
import com.expense.util.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class IncomeDAO {
    
    public boolean addIncome(Income income) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            String sql = "INSERT INTO income (user_id, description, amount, category, date) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, income.getUserId());
            stmt.setString(2, income.getDescription());
            stmt.setDouble(3, income.getAmount());
            stmt.setString(4, income.getCategory());
            stmt.setDate(5, income.getDate());
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<Income> getIncomeByUser(int userId) {
        List<Income> incomes = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection()) {
            String sql = "SELECT * FROM income WHERE user_id = ? ORDER BY date DESC";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Income income = new Income();
                income.setId(rs.getInt("id"));
                income.setUserId(rs.getInt("user_id"));
                income.setDescription(rs.getString("description"));
                income.setAmount(rs.getDouble("amount"));
                income.setCategory(rs.getString("category"));
                income.setDate(rs.getDate("date"));
                incomes.add(income);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return incomes;
    }
    
    public boolean updateIncome(Income income) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            String sql = "UPDATE income SET description = ?, amount = ?, category = ?, date = ? WHERE id = ? AND user_id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, income.getDescription());
            stmt.setDouble(2, income.getAmount());
            stmt.setString(3, income.getCategory());
            stmt.setDate(4, income.getDate());
            stmt.setInt(5, income.getId());
            stmt.setInt(6, income.getUserId());
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean deleteIncome(int id, int userId) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            String sql = "DELETE FROM income WHERE id = ? AND user_id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            stmt.setInt(2, userId);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public double getTotalIncome(int userId) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            String sql = "SELECT SUM(amount) as total FROM income WHERE user_id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getDouble("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0.0;
    }
}