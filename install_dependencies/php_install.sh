#!/bin/bash

echo $(date '+%d/%m/%Y %H:%M:%S')

# Variables
PHP_VERSION=8.2
COMPOSE_VERSION=2.2.7

#Install PHP
echo 'Installing PHP "$PHP_VERSION"'
sudo apt update
sudo apt install lsb-release ca-certificates apt-transport-https software-properties-common -y
sudo add-apt-repository ppa:ondrej/php -y

sudo apt update
sudo apt install php"$PHP_VERSION" -y

#PHP extensions
echo 'Installing PHP extensions'
sudo apt install php"$PHP_VERSION"-curl php"$PHP_VERSION"-dom \
	php"$PHP_VERSION"-gd php"$PHP_VERSION"-igbinary php"$PHP_VERSION"-mbstring \
	php"$PHP_VERSION"-mysqli php"$PHP_VERSION"-mysqlnd php"$PHP_VERSION"-redis \
	php"$PHP_VERSION"-SimpleXML php"$PHP_VERSION"-xml php"$PHP_VERSION"-xmlreader \
	php"$PHP_VERSION"-xmlwriter php"$PHP_VERSION"-xsl php"$PHP_VERSION"-zip -y
#sudo apt install php"$PHP_VERSION"-newrelic php"$PHP_VERSION"-pdo_mysql -y


#Install Composer $COMPOSE_VERSION
echo 'Installing Composer $COMPOSE_VERSION'
sudo apt update
sudo apt-get install php-cli unzip zip -y
cd ~
curl -sS https://getcomposer.org/installer -o composer-setup.php
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer --version=$COMPOSE_VERSION

echo 'Successfully Installed the Dependencies'
php --version
composer --version -y