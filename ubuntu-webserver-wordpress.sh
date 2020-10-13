#!/bin/sh

#preinstall arguments
echo -e "\e[32mwould you like to create a 2G swapfile? [Y/n]"
read SWAP_CONFIRM
echo -e "\e[32mcreate your database Name ..."
read DATABASE_NAME
echo -e "\e[32mcreate your username ..."
read DATABASE_USER
echo -e "\e[32mcreate your password..."
read DATABASE_PASS
echo -e "database: \e[32m${DATABASE_NAME}\e[39m, user: \e[32m${DATABASE_USER}\e[39m, password: \e[32m${DATABASE_PASS}"
echo -e "\e[32menter the full path for your wordpress installation ..."
read INSTALL_PATH
echo -e "\e[32mconfirm  wordpress installation in ${INSTALL_PATH}, Do you want to continue? [Y/n]"
read CONFIRM_INSTALL_LOCATION
echo -e "\e[32mwhat domain name will you use for this wordpress ..."
read DOMAIN_NAME

#SWAPFILE
echo "downloading swapfile script from github ..."
sudo curl -o ubuntu-swapfile.sh https://raw.githubusercontent.com/wjcarey/ubuntu-swapfile/master/ubuntu-swapfile.sh && sudo chmod 777 ubuntu-swapfile.sh && sudo ./ubuntu-swapfile.sh ${SWAP_CONFIRM}

#SOFTWARE INSTALL
echo "downloading webserver software install script from github ..."
sudo curl -o ubuntu-apache-maria-php.sh https://raw.githubusercontent.com/wjcarey/ubuntu-apache-maria-php/master/ubuntu-apache-maria-php.sh && sudo chmod 777 ubuntu-apache-maria-php.sh && sudo ./ubuntu-apache-maria-php.sh ${DATABASE_NAME} ${DATABASE_USER} ${DATABASE_PASS}

#MODIFY APACHE AND PHP CONFIGURATION
echo "downloading webserver config script from github ..."
sudo curl -o apache2-modify-conf.sh https://raw.githubusercontent.com/wjcarey/apache2-modify-conf/master/apache2-modify-conf.sh && sudo chmod 777 apache2-modify-conf.sh && sudo ./apache2-modify-conf.sh

#WORDPRESS INSTALL
echo "downloading wordpress install script from github ..."
sudo curl -o wordpress-install.sh https://raw.githubusercontent.com/wjcarey/wordpress-install/master/wordpress-install.sh && sudo chmod 777 wordpress-install.sh && sudo ./wordpress-install.sh ${INSTALL_PATH}

#CERTBOT INSTALL
echo "downloading certbot install script from github ..."
sudo curl -o apache2-certbot.sh https://raw.githubusercontent.com/wjcarey/apache2-certbot/main/apache2-certbot.sh && sudo chmod 777 apache2-certbot.sh && sudo ./apache2-certbot.sh ${INSTALL_PATH} ${DOMAIN_NAME}

echo "success: installation complete ..."
rm -- "$0"
exit