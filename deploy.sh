#!/bin/bash

# Build project
mvn clean package

# Deploy to Tomcat
sudo cp target/expense-manager.war /opt/tomcat/webapps/

# Restart Tomcat
sudo systemctl restart tomcat

echo "Deployment complete. Access at: http://localhost:8080/expense-manager"