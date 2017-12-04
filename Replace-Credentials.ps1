param (

)

Import-Module c:\vp\devenv\ps\modules\SecretServer\SecretServer.psm1 -DisableNameChecking -Force

$script:PROFILE_FILENAME = "config\cloud.profiles.d\vmware.conf"
$script:PROVIDER_FILENAME = "config\cloud.providers.d\vmware.conf"
$script:MASTER_FILENAME = "config\master"
$script:DOCKER_FILENAME = "Dockerfile"

$script:MASTER_NAME = "[MASTER NAME]"
$script:MASTER_HOST = "devwltvipssm002.vistaprint.net"

$script:PRIVATE_PILLAR_ID = 18010
$script:PRIVATE_PILLAR_USERNAME = "[USERNAME]"
$script:PRIVATE_PILLAR_PASSWORD = "[PASSWORD]"

$script:VIPSADMIN_ID = 18148
$script:VIPSADMIN_PASSWORD = "[VIPSADMIN PASSWORD]"

$script:SALTCLOUD_ID = 18300
$script:SALTCLOUD_PASSWORD = "[VCENTER_VIPS_PASSWORD]"

$script:SALTAPI_ID = 18596
$script:SALTAPI_USERNAME = "[SALTAPI_USERNAME]"
$script:SALTAPI_PASSWORD = "[SALTAPI_PASSWORD]"

function Main()
{
    Replace-SecretInFile $PRIVATE_PILLAR_ID $MASTER_FILENAME $PRIVATE_PILLAR_USERNAME $True
    Replace-SecretInFile $PRIVATE_PILLAR_ID $MASTER_FILENAME $PRIVATE_PILLAR_PASSWORD
    
    Replace-SecretInFile $SALTCLOUD_ID $PROVIDER_FILENAME $SALTCLOUD_PASSWORD

    Replace-SecretInFile $VIPSADMIN_ID $PROFILE_FILENAME $VIPSADMIN_PASSWORD

    Replace-SecretInFile $SALTAPI_ID $DOCKER_FILENAME $SALTAPI_USERNAME $True
    Replace-SecretInFile $SALTAPI_ID $DOCKER_FILENAME $SALTAPI_PASSWORD
}

function Replace-SecretInFile([int] $private:secretId, [string] $private:file, [string] $private:key, [boolean] $private:isUsername = $False)
{
    $creds = Get-Credential $secretId
    $value = if ($isUsername) {$creds.User} else {$creds.Password}

    Replace-InFile $file $key $value
}

function Replace-InFile($private:file, $private:key, $private:value)
{
    Write-Host "Replacing value $key in $file"
    (Get-Content $file | Out-String).Replace($key, $value) | Set-Content $file
}

function Get-Credential([int] $private:secretId)
{
    getSecretServerCredentialsById $secretId
}

Main