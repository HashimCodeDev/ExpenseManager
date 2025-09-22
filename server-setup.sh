#!/bin/bash
# VPS Setup Script for Ubuntu

# Update system
sudo apt update && sudo apt upgrade -y

# Install Java 11
sudo apt install openjdk-11-jdk -y

# Install MySQL
sudo apt install mysql-server -y

# Install Tomcat 9
sudo apt install tomcat9 -y

# Start services
sudo systemctl start mysql
sudo systemctl start tomcat9
sudo systemctl enable mysql
sudo systemctl enable tomcat9

# Configure firewall
sudo ufw allow 8080
sudo ufw allow 22
sudo ufw allow 3306

echo "Server setup complete!"
echo "Upload your WAR file to /var/lib/tomcat9/webapps/"
echo "Access at: http://YOUR_SERVER_IP:8080/expense-manager"