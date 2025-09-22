FROM openjdk:21-jdk-slim

RUN apt-get update && apt-get install -y wget && \
    wget https://archive.apache.org/dist/tomcat/tomcat-10/v10.1.28/bin/apache-tomcat-10.1.28.tar.gz && \
    tar -xzf apache-tomcat-10.1.28.tar.gz && \
    mv apache-tomcat-10.1.28 /opt/tomcat && \
    rm apache-tomcat-10.1.28.tar.gz && \
    apt-get remove -y wget && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

COPY target/expense-manager-1.0.0.war /opt/tomcat/webapps/

EXPOSE 8080

CMD ["/opt/tomcat/bin/catalina.sh", "run"]