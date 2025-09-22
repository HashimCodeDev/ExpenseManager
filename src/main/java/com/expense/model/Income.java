package com.expense.model;

import java.sql.Date;

public class Income {
    private int id;
    private int userId;
    private String description;
    private double amount;
    private String category;
    private Date date;
    
    public Income() {}
    
    public Income(int userId, String description, double amount, String category, Date date) {
        this.userId = userId;
        this.description = description;
        this.amount = amount;
        this.category = category;
        this.date = date;
    }
    
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }
    
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    
    public Date getDate() { return date; }
    public void setDate(Date date) { this.date = date; }
}