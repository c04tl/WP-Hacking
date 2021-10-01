#!/bin/bash

if [[ -z $@ ]]; then
	echo -e "\n\tUso: $0 <host> <diccionario>"
	exit 1
fi

function ctrl_c(){
	echo -e "\n[!] Saliendo. . .\n"
	exit 1

}

trap ctrl_c INT

host="$1"
usuario="None"
i=0

while [ ! -z $usuario ]
do
    usuario="$(curl -s "$host/wp-json/wp/v2/users/" | jq ".[$i][\"slug\"]" | tr -d '"')"
    if [ "$usuario" == "null" ]; then
        exit
    fi
    echo -e "[-] Usuario: $usuario"
    echo "$usuario" >> usuarios-wp.txt
    i=$i+1
done
