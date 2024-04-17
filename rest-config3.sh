#!/bin/bash

# Creating directory for backend
mkdir -p "${HOME}/backend"
cd "${HOME}/backend"

APP_PROP="src/main/resources/application.properties"
MYSQL_PROP="src/main/resources/application-mysql.properties"

DATABASE_MASTER_ADDRESS="$1"
DATABASE_MASTER_PORT="$2"
DATABASE_SLAVE_ADDRESS="$3"
DATABASE_SLAVE_PORT="$4"
DATABASE_USER="$5"
DATABASE_PASSWORD="$6"
VM_PORT="$7"

# Installing necessary packages
echo "Installing necessary packages..."
sudo apt-get update -y
sudo apt-get install openjdk-17-jdk -y
sudo apt-get install mysql-server -y

# Cloning the Spring PetClinic repository
echo "Cloning Spring PetClinic repository..."
git clone https://github.com/spring-petclinic/spring-petclinic-rest.git
cd spring-petclinic-rest

# Update configuration
ORIGINAL="jdbc:hsqldb://localhost:3306/petclinic?useUnicode=true"
REPLACEMENT="jdbc:mysql:replication://$DATABASE_MASTER_ADDRESS:$DATABASE_MASTER_PORT,$DATABASE_SLAVE_ADDRESS:$DATABASE_SLAVE_PORT/petclinic?useUnicode=true&allowSourceDownConnections=true"

sed -i "s/=hsqldb/=mysql/g" ${APP_PROP}
sed -i "s/9966/${VM_PORT}/g" ${APP_PROP}
jdbc:mysql:

sed -i "s/$ORIGINAL/$REPLACEMENT/g" ${MYSQL_PROP}
sed -i "s/username=pc/username=${DATABASE_USER}/g" ${MYSQL_PROP}
sed -i "s/password=petclinic/password=${DATABASE_PASSWORD}/g" ${MYSQL_PROP}

# Building and running the Spring Boot application
echo "Building and running the Spring Boot application..."
./mvnw spring-boot:run &

echo "Backend server started successfully."
