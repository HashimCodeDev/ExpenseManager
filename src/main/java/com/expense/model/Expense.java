package com.expense.model;

import java.sql.Date;

public class Expense {
    private int id;
    private String description;
    private double amount;
    private String category;
    private Date date;
    
    public Expense() {}
    
    public Expense(String description, double amount, String category, Date date) {
        this.description = description;
        this.amount = amount;
        this.category = category;
        this.date = date;
    }
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }
    
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    
    public Date getDate() { return date; }
    public void setDate(Date date) { this.date = date; }
}