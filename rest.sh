#!/bin/bash

# Defining environment variables moved as parameters
DATABASE_IP=$1
DATABASE_PORT=$2
DATABASE_USER=$3
DATABASE_PASSWORD=$4
VM_PORT=$5

# Creating directory for backend
mkdir -p "${HOME}/backend"
cd "${HOME}/backend"

# Installing necessary packages
echo "Installing necessary packages..."
sudo apt update -y
sudo apt install -y default-jdk maven mysql-server

# Cloning the Spring PetClinic repository
echo "Cloning Spring PetClinic repository..."
git clone https://github.com/spring-petclinic/spring-petclinic-rest.git
cd spring-petclinic-rest

# Modifying application.properties to use MySQL instead of HSQLDB
echo "Configuring application.properties..."
sed -i "s/=hsqldb/=mysql/g" ./src/main/resources/application.properties
sed -i "s/9090/${VM_PORT}/g" ./src/main/resources/application.properties

sed -i "s/jdbc:hsqldb/jdbc:mysql/g" ./src/main/resources/application-mysql.properties
sed -i "s/localhost/${DATABASE_IP}/g" ./src/main/resources/application-mysql.properties
sed -i "s/3306/${DATABASE_PORT}/g" ./src/main/resources/application-mysql.properties
sed -i "s/spring.datasource.username=sa/spring.datasource.username=${DATABASE_USER}/g" ./src/main/resources/application-mysql.properties
sed -i "s/spring.datasource.password=/spring.datasource.password=${DATABASE_PASSWORD}/g" ./src/main/resources/application-mysql.properties

# Building and running the Spring Boot application
echo "Building and running the Spring Boot application..."
cd ./spring-petclinic-rest/
./mvnw spring-boot:run

echo "Backend server started successfully."
