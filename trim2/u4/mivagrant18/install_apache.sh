#!/usr/bin/env bash

apt-get update
apt-get install -y apache2
apt-get install geany
rm -rf /var/www
ln -fs /vagrant /var/www
echo "<h1>Actividad de Vagrant</h1>" > /var/www/index.html
echo "<p>Curso201516</p>" >> /var/www/index.html
echo "<p>Aitor Machado</p>" >> /var/www/index.html
