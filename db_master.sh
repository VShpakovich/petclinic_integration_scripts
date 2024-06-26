PORT=$1
CONFIG_FILE="/etc/mysql/mysql.conf.d/mysqld.cnf"
INIT_DB="https://raw.githubusercontent.com/spring-petclinic/spring-petclinic-rest/master/src/main/resources/db/mysql/initDB.sql"
POPULATE_DB="https://raw.githubusercontent.com/spring-petclinic/spring-petclinic-rest/master/src/main/resources/db/mysql/populateDB.sql"

sudo apt-get update
sudo apt-get upgrade -y

sudo apt-get install mysql-server -y
sudo apt-get install wget -y

wget $INIT_DB
wget $POPULATE_DB

sed -i "s/127.0.0.1/0.0.0.0/g" $CONFIG_FILE
echo "port = $PORT" >> $CONFIG_FILE
echo "server-id = 1" >> $CONFIG_FILE
echo "log_bin = /var/log/mysql/mysql-bin.log" >> $CONFIG_FILE


sudo mysql -e "CREATE USER IF NOT EXISTS 'pc'@'%' IDENTIFIED BY 'pc';"
sudo mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'pc'@'%' WITH GRANT OPTION;"
sudo mysql -e "GRANT REPLICATION SLAVE ON *.* TO 'pc'@'%';"
sudo mysql -e "FLUSH PRIVILEGES;"

cat initDB.sql | sudo mysql -f

sed -i '1 i\USE petclinic;' populateDB.sql
cat populateDB.sql | sudo mysql -f

sudo service mysql restart