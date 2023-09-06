#!/bin/bash

$1 2>/dev/null

clear

sleep 1
echo ""
echo "========================================"
sleep 0.1
echo "╦ ╦╔═╗   ╔═╗╔═╗╔╗╔╔═╗╦╔═╗   ╔═╗╔═╗╔═╗╔╗╔"
sleep 0.1
echo "║║║╠═╝───║  ║ ║║║║╠╣ ║║ ╦───╚═╗║  ╠═╣║║║"
sleep 0.1
echo "╚╩╝╩     ╚═╝╚═╝╝╚╝╚  ╩╚═╝   ╚═╝╚═╝╩ ╩╝╚╝"
sleep 0.1
echo "========================================"
sleep 0.1
echo "Joan Moya (Aka. MicroJoan)"

#Se comprueba que se ha insertado la web desde el terminal
if [[ ! -n $1 ]];
then 
    echo -e "\nPease insert the URL to scan, example: (./wp-config-scan.sh http://wordpress_site.com)"
	echo ""
	exit
fi

#se comprueba si la url contiene un "/" al final, y en caso de tenerlo lo quitamos
if [[ "${1: -1}" == "/" ]]; then
  url="${1%/*}"
else 
  url=$1
fi

sleep 2

echo ""
echo -e "\e[38;5;208m Scanning $url... \e[0m"
echo ""

sleep 1


#comprobamos si existe la url /wp-json/wp/v2/users
wp_users=`curl -s $url/wp-json/wp/v2/users` >&/dev/null

if echo "$wp_users" | grep -q "401"; then

    echo "[!]Searching system users"
    sleep 1
    echo ""
    echo -e "\e[31m No users found \e[0m"
    sleep 1
else

    echo "[!]Searching system users"
    sleep 1
    echo -e "\e[32m "
    echo -e "$wp_users" | jq -r '.[].slug'
    echo -e "\e[0m"
    sleep 1
fi

echo ""
echo -e "\e[38;5;208m Looking for vulnerable routes... \e[0m"
echo ""

#comprobamos si existe la url /wp-admin
response=$(curl -s -o /dev/null -w "%{http_code}" "$url/wp-login.php/")

if [ $response -eq 200 ]; then
    
    echo ""
    echo -e "\e[32m /wp-login is up! \e[0m"

else
    echo ""
    echo -e "\033[31m /wp-login is KO \033[0m"
fi


sleep 1

#comprobamos si existe la url /xmlrpc.php
if curl -I "$url/xmlrpc.php" >/dev/null 2>&1; then

    echo ""
    echo -e "\e[32m /xmlrpc.php is up! \e[0m"
else
    echo -e "\033[31m /xmlrpc.php is KO \033[0m"
fi

sleep 1

#comprobamos si existe la url /feed
if curl -I "$url/feed" >/dev/null 2>&1; then

    echo ""
    echo -e "\e[32m /feed is up! \e[0m"

else
    echo -e "\033[31m /feed is KO \033[0m"
fi

sleep 1

#comprobamos si existe la url /cron.php
if curl -I "$url/cron.php" >/dev/null 2>&1; then

    echo ""
    echo -e "\e[32m /cron.php is up! \e[0m"
else
    echo -e "\033[31m /cron.php is KO \033[0m"
fi

sleep 1

#comprobamos si existe la url /wp-sitemap.xml
if curl -I "$url/wp-sitemap.xml" >/dev/null 2>&1; then

    echo ""
    echo -e "\e[32m /wp-sitemap.xml is up! \e[0m"
else
    echo -e "\033[31m /wp-sitemap.xml is KO \033[0m"
fi

sleep 1

#comprobamos si existen archivos interesantes en la raiz del sitio
echo -e "\e[38;5;208m Checking interesting files... \e[0m"

if curl -I "$url/htaccess_old" >/dev/null 2>&1; then

    echo ""
    echo -e "\e[32m /htaccess_old is up! \e[0m"
else
    echo -e "\033[31m /htaccess_old is KO \033[0m"
fi

sleep 1

if curl -I "$url/htaccess_bk" >/dev/null 2>&1; then

    echo ""
    echo -e "\e[32m /htaccess_bk is up! \e[0m"
else
    echo -e "\033[31m /htaccess_bk is KO \033[0m"
fi

sleep 1

if curl -I "$url/htaccess.txt" >/dev/null 2>&1; then

    echo ""
    echo -e "\e[32m /htaccess.txt is up! \e[0m"
else
    echo -e "\033[31m /htaccess.txt is KO \033[0m"
fi

sleep 1

if curl -I "$url/bbdd.sql" >/dev/null 2>&1; then

    echo ""
    echo -e "\e[32m /bbdd.sql is up! \e[0m"
else
    echo -e "\033[31m /bbdd.sql is KO \033[0m"
fi

sleep 1

if curl -I "$url/mysql.sql" >/dev/null 2>&1; then

    echo ""
    echo -e "\e[32m /mysql.sql is up! \e[0m"
else
    echo -e "\033[31m /mysql.sql is KO \033[0m"
fi

sleep 1

if curl -I "$url/basededatos.sql" >/dev/null 2>&1; then

    echo ""
    echo -e "\e[32m /basededatos.sql is up! \e[0m"
else
    echo -e "\033[31m /basededatos.sql is KO \033[0m"
fi

sleep 1

if curl -I "$url/database.sql" >/dev/null 2>&1; then

    echo ""
    echo -e "\e[32m /database.sql is up! \e[0m"
else
    echo -e "\033[31m /database.sql is KO \033[0m"
fi

sleep 1

if curl -I "$url/wp-config.php_old" >/dev/null 2>&1; then

    echo ""
    echo -e "\e[32m /wp-config.php_old is up! \e[0m"
else
    echo -e "\033[31m /wp-config.php_old is KO \033[0m"
fi

sleep 1

if curl -I "$url/wp-config.php_bk" >/dev/null 2>&1; then

    echo ""
    echo -e "\e[32m /wp-config.php_bk is up! \e[0m"
else
    echo -e "\033[31m /wp-config.php_bk is KO \033[0m"
fi

sleep 1

echo ""
echo "Finish"
