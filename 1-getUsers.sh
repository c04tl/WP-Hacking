#!/bin/bash

if [[ -z $@ ]]; then
    echo "Modo de uso: $0 HOST"
    exit 1
fi

host="$1"
usuario="A"
i=0
while [[ -n $usuario ]]; do
    usuario=$(curl -s $host/wp-json/wp/v2/users | jq ".[$i][\"slug\"]" | tr -d '"')
    if [[ $usuario == "null" ]]; then
        exit 0  

    elif [[ -z usuario ]]; then
        if [[ -z usuario=$(curl -s "$host/?rest_route=/wp/v2/users" | jq .[$i][\"slug\"] | tr -d '"') ]]; then
            echo "[x] No se encontraron usuarios :c"
            exit 1
        fi
    fi

    echo "[+] Usuario: $usuario"
    echo $usuario >> usuarios-wp.txt
    i=$i+1
done

