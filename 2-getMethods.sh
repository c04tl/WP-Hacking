#!/bin/bash
#Este Script lista los metodos permitidos por el sitio en wordpress

if [[ -z $@ ]]; then
	echo -e "\n\tUso: $0 <host>"
	exit 1
fi

host=$1

function ctrl_c(){
	echo -e "\n[!] Saliendo. . .\n"
	exit 1

}

trap ctrl_c INT

declare -r xmlrpc_url="http://$host/xmlrpc.php"
declare -r data_xml_file="data.xml"

cat << EOF > $data_xml_file
<methodCall>
	<methodName>system.listMethods</methodName>
</methodCall>
EOF


curl -s $xmlrpc_url -X POST -d @$data_xml_file

rm $data_xml_file
