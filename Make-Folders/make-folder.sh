#!/bin/bash

cd /home/vishal/Backups;

Date=$(date +"%d-%m-%Y")

if [ ! -d $Date ]; then
    
    mkdir $Date
    cd $Date

    folder=("models" "views" "controllers")
    
    for folderName in "${folder[@]}"; do
        mkdir "$folderName"
        cd "$folderName"
        mkdir "Folder1" "Folder2" "Folder3" "Folder4"
        cd ../
    done 
    
fi
