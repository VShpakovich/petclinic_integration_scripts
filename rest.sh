#!/bin/bash

echo y | rm -r ${HOME}/backend # Remove the backend directory if it exists

# Defining environment variables moved as parameters
DATABASE_IP=$1
DATABASE_PORT=$2
DATABASE_USER=$3
DATABASE_PASSWORD=$4
VM_PORT=$5

APP_PROP="src/main/resources/application.properties"
MYSQL_PROP="${HOME}/backend/spring-petclinic-rest/src/main/resources/application-mysql.properties"

# Creating directory for backend
mkdir -p "${HOME}/backend"
cd "${HOME}/backend"

# Installing necessary packages
echo "Installing necessary packages..."
sudo apt-get update -y
sudo apt-get install -y default-jdk mysql-server

# Cloning the Spring PetClinic repository
echo "Cloning Spring PetClinic repository..."
git clone https://github.com/spring-petclinic/spring-petclinic-rest.git
cd spring-petclinic-rest

# Modifying application.properties to use MySQL instead of HSQLDB
echo "Configuring application.properties..."
sed -i -n "s/=hsqldb/=mysql/g" ${APP_PROP}
sed -i -n "s/9966/${VM_PORT}/g" ${APP_PROP}

sed -i -n "s/jdbc:hsqldb/jdbc:mysql/g" ${MYSQL_PROP}
sed -i -n "s/localhost/${DATABASE_IP}/g" ${MYSQL_PROP}
sed -i -n "s/3306/${DATABASE_PORT}/g" ${MYSQL_PROP}
sed -i -n "s/pc/${DATABASE_USER}/g" ${MYSQL_PROP}
sed -i -n "s/pc/${DATABASE_PASSWORD}/g" ${MYSQL_PROP}

# Building and running the Spring Boot application
echo "Building and running the Spring Boot application..."
./mvnw spring-boot:run &

echo "Backend server started successfully."
