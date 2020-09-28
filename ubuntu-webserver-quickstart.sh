#!/bin/sh

#SWAPFILE
echo "Would you like to create a 2G swapfile? [Y/n]"
read SWAP_CONFIRM
if [ "$SWAP_CONFIRM" != "${SWAP_CONFIRM#[Yy]}" ] ;then
    fallocate -l 2G /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    echo "# Linux Swapfile use sudo free -h to view available space" >> /etc/fstab
    echo "/swapfile swap swap defaults 0 0" >> /etc/fstab
    echo "Success: swapfile created ..."
else
    echo "Error: swapfile skipped by user ..."
fi

#SOFTWARE INSTALL
echo "software install starting ..."
apt update -qq && apt upgrade -qq && apt install -qq git unzip php php-cli php-fpm php-json php-pdo php-mysql php-zip php-gd php-mbstring php-curl php-xml php-pear php-bcmath php-tokenizer php-imagick mariadb-server

#WORDPRESS INSTALL
INSTALL_PATH="/var/www/html"
echo "Confirm  wordpress installation in ${INSTALL_PATH}, Do you want to continue? [Y/n]"
read CONFIRM_INSTALL_LOCATION
if [ "$CONFIRM_INSTALL_LOCATION" != "${CONFIRM_INSTALL_LOCATION#[Yy]}" ] ;then
    rm ${INSTALL_PATH}/index.html
    wget "https://wordpress.org/latest.zip" -P ${INSTALL_PATH}
    unzip ${INSTALL_PATH}/latest.zip -d ${INSTALL_PATH}
    mv ${INSTALL_PATH}/wordpress/* ${INSTALL_PATH}
    rm -R ${INSTALL_PATH}/wordpress
    chmod 775 -R ${INSTALL_PATH}
    chown -R  www-data:www-data ${INSTALL_PATH}
    echo "Success: Wordpress installed ..."
else
    echo "Error: the WordPress installer was skipped ..."
fi

#DATABASE CONFIGURE
echo "Would you like to configure the database now? [Y/n]"
read CONFIRM_DATABASE_CONFIGURE
if [ "$CONFIRM_DATABASE_CONFIGURE" != "${CONFIRM_DATABASE_CONFIGURE#[Yy]}" ] ;then
    echo "Create your username ..."
    read DATABASE_USER
    echo "create your password for ${DATABASE_USER} ..."
    read DATABASE_PASS
    echo "create your database Name ..."
    read DATBASE_NAME
    echo "User: ${DATABASE_USER}, Password: ${DATABASE_PASS}, Database: ${DATBASE_NAME}, Do you want to continue? [Y/n]"
    read CONFIRM_DATABASE_INSTALL
    if [ "$CONFIRM_DATABASE_INSTALL" != "${CONFIRM_DATABASE_INSTALL#[Yy]}" ] ;then
        mysql -e "DROP USER 'root'@'localhost'; CREATE USER 'root'@'%' IDENTIFIED BY ''; GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION; CREATE USER '${DATABASE_USER}'@'%' IDENTIFIED BY '${DATABASE_PASS}'; GRANT ALL PRIVILEGES ON *.* TO '${DATABASE_USER}'@'%' WITH GRANT OPTION; FLUSH PRIVILEGES;"
        mysql -e "CREATE DATABASE ${DATBASE_NAME}; FLUSH PRIVILEGES;"
        echo "Success: database complete ..."
    else
        echo "Error: database configuration skipped"
    fi
else
    echo "Warning: database configuration incomplete"
fi

#APACHE-PHP MODIFY CONFIG
a2enmod rewrite expires headers
sed -i '0,/AllowOverride None/s//AllowOverride All/; 0,/Require all denied/s//Require all granted/' /etc/apache2/apache2.conf
echo -e "\n#Remove Server Tokens\nServerTokens Prod\n#Remove server signature\nServerSignature Off" >> /etc/apache2/apache2.conf
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 1G/g;s/post_max_size = 8M/post_max_size = 1G/g;s/memory_limit = 128M/memory_limit = 512M/g;s/max_execution_time = 30/max_execution_time = 300/g;s/max_input_time = 60/max_input_time = 300/g;' /etc/php/7.4/apache2/php.ini
systemctl restart apache2

echo "Success: installation complete ..."
rm -- "$0"
exit