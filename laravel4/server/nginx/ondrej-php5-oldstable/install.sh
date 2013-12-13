#!/usr/bin/env bash

echo "--- Updating packages list ---"
sudo apt-get update

echo "--- Setting nginx ---"
sudo add-apt-repository -y ppa:nginx/stable
sudo apt-get update
sudo apt-get install -y nginx

echo "--- Setting document root ---"
sudo rm -rf /var/www
sudo ln -fs /vagrant/www/public /var/www

sudo rm /etc/nginx/sites-available/default
sudo ln -fs /vagrant/server/nginx/default /etc/nginx/sites-available/default

echo "--- Restarting nginx ---"

echo "--- MySQL ---"
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'

echo "--- Installing base packages ---"
sudo apt-get install -y vim curl python-software-properties

echo "--- Updating packages list ---"
sudo apt-get update

echo "--- php old-stable ---"
sudo apt-add-repository -y ppa:ondrej/php5-oldstable

echo "--- Updating packages list ---"
sudo apt-get update

echo "--- Installing PHP-specific packages ---"
sudo apt-get install -y php5 php5-curl php5-gd php5-mcrypt mysql-server-5.5 php5-mysql git-core

# echo "--- Stop Apache ---"
sudo service apache2 stop

sudo apt-get install -y php5-fpm
sudo service nginx start

echo "--- Installing and configuring Xdebug ---"
sudo apt-get install -y php5-xdebug

cat << EOF | sudo tee -a /etc/php5/mods-available/xdebug.ini
xdebug.scream=1
xdebug.cli_color=1
xdebug.show_local_vars=1
EOF

echo "--- installing Composer ---"
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

echo "--- fin ---"
