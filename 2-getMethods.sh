#!/bin/bash

if [[ -z $@ ]]; then
	echo "Modo de uso: $0 HOST"
	exit 1
fi

host=$1

echo "
<methodCall>
	<methodName>system.listMethods</methodName>
</methodCall>
" > datos.xml

curl -s "$host/xmlrpc.php" -d @$datos_xml
rm datos.xml
