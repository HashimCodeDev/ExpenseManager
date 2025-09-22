# Stage 1: Build WAR using Maven
FROM maven:3.9.6-eclipse-temurin-21 AS builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Tomcat runtime
FROM openjdk:21-jdk-slim

# Install Tomcat
RUN apt-get update && apt-get install -y wget && \
    wget https://archive.apache.org/dist/tomcat/tomcat-10/v10.1.28/bin/apache-tomcat-10.1.28.tar.gz && \
    tar -xzf apache-tomcat-10.1.28.tar.gz && \
    mv apache-tomcat-10.1.28 /opt/tomcat && \
    rm apache-tomcat-10.1.28.tar.gz && \
    apt-get purge -y wget && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

# Copy built WAR from builder stage
COPY --from=builder /app/target/expense-manager-1.0.0.war /opt/tomcat/webapps/expense-manager.war

EXPOSE 8080
CMD ["/opt/tomcat/bin/catalina.sh", "run"]
