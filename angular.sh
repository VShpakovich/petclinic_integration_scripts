#!/bin/bash

# Defining environment variables moved as parameters
BACKEND_IP=$1
BACKEND_PORT=$2
VM_PORT=$3

# Installing necessary packages
echo "Installing necessary packages..."
sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y
sudo apt install -y curl npm nginx

cd ~/

# Install package manager for Node.js (nvm)
echo "Installing nvm..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

nvm install 12.11.1

# Cloning the Spring PetClinic repository
git clone https://github.com/spring-petclinic/spring-petclinic-angular.git
npm install --save-dev @angular/cli@latest
cd spring-petclinic-angular

# Modifying environment.prod.ts to use the backend IP and port
sed -i "s/localhost/${BACKEND_IP}/g" src/environments/environment.ts src/environments/environment.prod.ts
sed -i "s/8080/${BACKEND_PORT}/g" src/environments/environment.ts src/environments/environment.prod.ts

# Building and running the Angular application
echo "Building and running the Angular application..."
echo N | npm install -g @angular/cli@latest
echo N | npm install
echo N | ng analytics off

npm install angular-http-server
npm run build -- --prod

# Start server
npx angular-http-server --path ./dist -p $VM_PORT &

###

echo "Frontend server started successfully."
