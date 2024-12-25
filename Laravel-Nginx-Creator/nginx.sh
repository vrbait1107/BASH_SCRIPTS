#! /bin/bash

# Color definitions
BLACK='\033[30m'
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[34m'
MAGENTA='\033[35m'
CYAN='\033[36m'
WHITE='\033[37m'

BLACK_BG='\033[41m'
RED_BG='\033[41m'
GREEN_BG='\033[42m'
YELLOW_BG='\033[43m'
BLUE_BG='\033[44m'
MAGENTA_BG='\033[45m'
CYAN_BG='\033[46m'
WHITE_BG='\033[47m'

BOLD='\033[1m'
RESET='\033[0m'

template_file="/etc/nginx/nginx.stub"

if [[ ! -f "$template_file" ]]; then
    echo "Template File Does Not Exist"
    exit 1
fi

template_text=$(cat $template_file)

echo -e "${BLUE_BG}${BOLD} INFO ${RESET} Welcome To Nginx Configuration Creator\n"

echo "Please Enter Server Name"
read server_name

echo "Please Enter Directory Path"
read folder_path

if [[ ! -d /var/www/${folder_path} ]]; then
    echo -e "${RED_BG}${BOLD} ERROR ${RESET} Directory Does Not Exists\n"
    exit 1
fi

echo "Please Enter PHP Version"
read php_version

# Replace placeholders in the template content
final_text="$template_text"
final_text="${final_text//\{\{#SERVER_NAME#\}\}/$server_name}"
final_text="${final_text//\{\{#FOLDER_PATH#\}\}/$folder_path}"
final_text="${final_text//\{\{#PHP_VERSION#\}\}/$php_version}"

# Appending host name
echo -e "${YELLOW_BG}${BOLD}${BLACK} WARNING ${RESET} Adding Host Entry in /etc/hosts\n"
sudo echo "127.0.0.1	$server_name" >>/etc/hosts
echo -e "${GREEN_BG}${BOLD}${BLACK} SUCCESS ${RESET} Host Entry Successful /etc/hosts\n"

if [[ -e /etc/nginx/sites-available/${server_name}.conf ]]; then
    echo -e "${RED_BG}${BOLD}Nginx File Already Exists...${RESET}\n"
    exit 1
fi

# Creating Nginx Conf
echo -e "${YELLOW_BG}${BOLD}${BLACK} WARNING ${RESET} Creating Nginx file in Sites Available\n"
sudo touch /etc/nginx/sites-available/${server_name}.conf
echo -e "${GREEN_BG}${BOLD}${BLACK} SUCCESS ${RESET} Created Nginx file in Sites Available\n"

# Append Configurations to Nginx Conf
echo -e "${YELLOW_BG}${BOLD}${BLACK} WARNING ${RESET} Appending Nginx Configurations\n"
sudo echo "$final_text" >/etc/nginx/sites-available/${server_name}.conf
echo -e "${GREEN_BG}${BOLD}${BLACK} SUCCESS ${RESET} Appended Nginx Configurations\n"

# Create Symlink
echo -e "${YELLOW_BG}${BOLD}${BLACK} WARNING ${RESET} Creating Symlink in Sites Enabled\n"
sudo ln -s /etc/nginx/sites-available/${server_name}.conf /etc/nginx/sites-enabled/
echo -e "${GREEN_BG}${BOLD}${BLACK} SUCCESS ${RESET} Created Symlink\n"

# Reload Nginx
echo -e "${YELLOW_BG}${BOLD}${BLACK} WARNING ${RESET} Restarting Nginx\n"
sudo service nginx restart
echo -e "${GREEN_BG}${BOLD}${BLACK} SUCCESS ${RESET} Restarted Nginx\n"

echo -e "${GREEN_BG}${BOLD}${BLACK} SUCCESS ${RESET} Nginx Configuration Successful\n"
