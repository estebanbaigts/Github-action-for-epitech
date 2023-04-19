#!/bin/bash

# This script is used to check the coding style of the source code.
# It is based on the coding style of the Linux kernel.

function my_readlink() {
    cd $1
    pwd
    cd - > /dev/null
}

function cat_readme() {
    echo ""
    echo "Usage: ./coding-style.sh DELIVERY_DIR REPORTS_DIR"
    echo "       DELIVERY_DIR      Should be the directory where your project files are"
    echo "       REPORTS_DIR       Should be the directory where we output the reports"
    echo "                         Take note that existing reports will be overriden"
    echo ""  
}

if [ $# == 1 ] && [ $1 == "--help" ]; then
    cat_readme
elif [ $# = 2 ];
then
    DELIVERY_DIR=$(my_readlink "$1")
    REPORTS_DIR=$(my_readlink "$2")
    EXPORT_FILE="$REPORTS_DIR"/coding-style-reports.log
    ### delete existing report file
    rm -f "$EXPORT_FILE"

    ### Pull new version of docker image and clean olds
    sudo docker pull ghcr.io/epitech/coding-style-checker:latest && sudo docker image prune -f

    ### generate reports
    sudo docker run --rm -i -v "$DELIVERY_DIR":"/mnt/delivery" -v "$REPORTS_DIR":"/mnt/reports" ghcr.io/epitech/coding-style-checker:latest "/mnt/delivery" "/mnt/reports"
    [[ -f "$EXPORT_FILE" ]] && echo "$(wc -l < "$EXPORT_FILE") coding style error(s) reported in "$EXPORT_FILE", $(grep -c ": MAJOR:" "$EXPORT_FILE") major, $(grep -c ": MINOR:" "$EXPORT_FILE") minor, $(grep -c ": INFO:" "$EXPORT_FILE") info"
    
    major=$(grep -c ": MAJOR:" "$EXPORT_FILE")
    minor=$(grep -c ": MINOR:" "$EXPORT_FILE")
    info=$(grep -c ": INFO:" "$EXPORT_FILE")
    note=$(((-3 * $major) + (-1 * $minor)))

    echo -e "\n\033[0m-------------------------------------------------------------------------------"
    echo -e "\033[0;34m                          \033[93mEpitech Coding Style Report\n"
    echo -e "\033[0mPath: \033[93m$DELIVERY_DIR"
    echo -e "\033[0m-------------------------------------------------------------------------------"
    echo -e "\033[0;34mFile                 Line     Error     Severity"
    echo -e "\033[0m-------------------------------------------------------------------------------\033[1;34;00m"
    awk -F: '{
        split($1, a, "/")
        if ($3 == " MAJOR")
            printf "\033[0;31m%-20s %-8s %-8s %-10s %s\033[0m\n", a[length(a)], $2, $4, $3, $5
        if ($3 == " MINOR")
            printf "\033[0;33m%-20s %-8s %-8s %-10s %s\033[0m\n", a[length(a)], $2, $4, $3, $5
        if ($3 == " INFO")
            printf "\033[0;32m%-20s %-8s %-8s %-10s %s\033[0m\n", a[length(a)], $2, $4, $3, $5
    }' $EXPORT_FILE
    echo -e "\033[0m-------------------------------------------------------------------------------"
    echo -e "\033[0;34mTOTAL\033[0m          MAJOR: \033[0;31m$major\033[0m       MINOR: \033[0;33m$minor\033[0m      INFO: \033[0;32m$info\033[0m      NOTE: \033[0;34m$note\033[0m"
    echo -e "\033[0m-------------------------------------------------------------------------------"
    if [[ $(grep -c ": MAJOR:" "$EXPORT_FILE") > 0 || $(grep -c ": MINOR:" "$EXPORT_FILE") > 0 ]]; then
        exit 1;
    fi
    exit 0;
else
    cat_readme
    exit 1;
fi