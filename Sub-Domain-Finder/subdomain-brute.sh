#!/bin/bash

while getopts :d:w:h:v options; do
    case "$options" in
        d) domain=$OPTARG;;
        w) wordlist=$OPTARG;;
        h) help=$OPTARG;;
        v) echo "subdomain-brute version 1.0.0" && exit 0;;
        *) echo "Invalid option $options";;
    esac
done

if [[ -z "$domain" && -z "$wordlist" ]]; then
    echo -e "\n USAGE: subdomain-brute.sh -d <DOMAIN> -w <WORDLIST> \n"
    echo  "-d --domain  Domain Name. Eg. <google.com>"
    echo  "-w  --wordlist Wordlist Path. Eg. </home/user/wordlists/subdomain.txt>"
    echo -e  "-h  --help view help \n"
    exit 1
fi


if [[ -z "$domain" ]]; then
    echo -e "\n-------------  PLEASE PROVIDE DOMAIN NAME------------- \n";
    echo -e "USAGE: subdomain-brute.sh -d <DOMAIN> -w <WORDLIST> \n"
    echo  "-d --domain  Domain Name. Eg. <google.com>"
    echo  "-w  --wordlist Wordlist Path. Eg. </home/user/wordlists/subdomain.txt>"
    echo -e  "-h  --help view help \n"
    exit 1
fi

if [[ -z "$wordlist" ]]; then
    echo -e "\n -------------  PLEASE PROVIDE WORDLIST------------- \n";
    echo  -e "USAGE: subdomain-brute.sh -d <DOMAIN> -w <WORDLIST> \n"
    echo  "-d --domain  Domain Name. Eg. <google.com>"
    echo  "-w  --wordlist Wordlist Path. Eg. </home/user/wordlists/subdomain.txt>"
    echo -e "-h  --help view help \n"

    exit 1
fi

if [[ ! -e "$wordlist" ]]; then
    echo -e "\n--------- WORDLIST PATH IS INCORRECT ------------ \n";
    exit 1;
fi

echo -e "\n"
while read subdomain; do
    host "$subdomain"."$domain" &>/dev/null
    
    if [ $? -eq 0 ]; then
        echo -e "$subdomain"."$domain"
    fi

done <  "$wordlist" 
echo -e "\n"

