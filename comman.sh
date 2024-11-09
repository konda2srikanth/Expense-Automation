
# This file is used to host all the common patterns

ID=$(id -u)
COLOR() {
    echo -e "\e[35m $* \e[0m"
} 

stat() {
    if [ $1 -eq  0 ] ; then 
        echo -e "\e[32m - Success \e[0m" 
    else 
        echo -e "\e[31m - Failure \e[0m" 
        exit 1
    fi 
}

if [ "$ID" -ne 0 ]; then 
    echo -e "\e[31m Script is expected to be executed as a root user or with sudo scriptName.sh \e[0m"
    echo -e "\t  sudo bash $0"
    exit 1
fi 