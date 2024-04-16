#!/bin/bash

# Defining environment variables moved as parameters
BACKEND_IP=$1
BACKEND_PORT=$2
VM_PORT=$3

# Creating directory for frontend
mkdir -p "${HOME}/frontend"
cd "${HOME}/frontend"

ENV="src/environments/environment.ts"
ENV_PROD="src/environments/environment.prod.ts"

# Installing necessary packages
echo "Installing necessary packages..."
sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y
sudo apt install -y curl

# Install package manager for Node.js (nvm)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm install v18.13.0

# Cloning the Spring PetClinic repository
git clone https://github.com/spring-petclinic/spring-petclinic-angular.git
cd spring-petclinic-angular

# Modifying environment.prod.ts to use the backend IP and port
sed -i "s/localhost/${BACKEND_IP}/g" ${ENV} ${ENV_PROD}
sed -i "s/9966/${BACKEND_PORT}/g" ${ENV} ${ENV_PROD}

# Building and running the Angular application
echo "Building and running the Angular application..."
echo N | npm install -g @angular/cli@latest
echo N | npm install
echo N | ng analytics off

npm install angular-http-server
npm run build --prod

# Start server
npx angular-http-server --path ./dist -p $VM_PORT &

###

echo "Frontend server started successfully."
