#!/bin/sh

#SWAPFILE
echo "downloding swapfile script from github ..."
sudo curl -o ubuntu-swapfile.sh https://raw.githubusercontent.com/wjcarey/ubuntu-swapfile/master/ubuntu-swapfile.sh && sudo chmod 777 ubuntu-swapfile.sh && sudo ./ubuntu-swapfile.sh

#SOFTWARE INSTALL
echo "downlaoding webserver software install script from github ..."
sudo curl -o ubuntu-apache-maria-php.sh https://raw.githubusercontent.com/wjcarey/ubuntu-apache-maria-php/master/ubuntu-apache-maria-php.sh && sudo chmod 777 ubuntu-apache-maria-php.sh && sudo ./ubuntu-apache-maria-php.sh

#MODIFY APACHE AND PHP CONFIGURATION
echo "downlaoding webserver config script from github ..."
sudo curl -o apache2-modify-conf.sh https://raw.githubusercontent.com/wjcarey/apache2-modify-conf/master/apache2-modify-conf.sh && sudo chmod 777 apache2-modify-conf.sh && sudo ./apache2-modify-conf.sh

#WORDPRESS INSTALL
echo "downlaoding wordpress install script from github ..."
sudo curl -o wordpress-install.sh https://raw.githubusercontent.com/wjcarey/wordpress-install/master/wordpress-install.sh && sudo chmod 777 wordpress-install.sh && sudo ./wordpress-install.sh

echo "success: installation complete ..."
rm -- "$0"
exit