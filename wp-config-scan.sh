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

echo ""
echo "Finish"