#!/bin/bash

echo y | rm -r ${HOME}/backend # Remove the backend directory if it exists

# Defining environment variables moved as parameters
DATABASE_IP=$1
DATABASE_PORT=$2
DATABASE_USER=$3
DATABASE_PASSWORD=$4
VM_PORT=$5

# Creating directory for backend
mkdir -p "${HOME}/backend"
cd "${HOME}/backend"

APP_PROP="src/main/resources/application.properties"
MYSQL_PROP="src/main/resources/application-mysql.properties"

# Installing necessary packages
echo "Installing necessary packages..."
sudo apt-get update -y
sudo apt-get install openjdk-17-jdk -y
sudo apt-get install mysql-server -y

# Cloning the Spring PetClinic repository
echo "Cloning Spring PetClinic repository..."
git clone https://github.com/spring-petclinic/spring-petclinic-rest.git
cd spring-petclinic-rest

# Modifying application.properties to use MySQL instead of HSQLDB
echo "Configuring application.properties..."
sed -i "s/=hsqldb/=mysql/g" ${APP_PROP}
sed -i "s/9966/${VM_PORT}/g" ${APP_PROP}

sed -i "s/jdbc:hsqldb/jdbc:mysql/g" ${MYSQL_PROP}
sed -i "s/localhost/${DATABASE_IP}/g" ${MYSQL_PROP}
sed -i "s/3306/${DATABASE_PORT}/g" ${MYSQL_PROP}
sed -i "s/username=pc/username=${DATABASE_USER}/g" ${MYSQL_PROP}
sed -i "s/password=petclinic/password=${DATABASE_PASSWORD}/g" ${MYSQL_PROP}

# Building and running the Spring Boot application
echo "Building and running the Spring Boot application..."
./mvnw spring-boot:run &

echo "Backend server started successfully."
