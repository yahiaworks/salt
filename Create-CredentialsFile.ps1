param (
)

Import-Module c:\vp\devenv\ps\modules\SecretServer\SecretServer.psm1 -DisableNameChecking -Force

$script:MASTER_HOST = "devwltvipssm002.vistaprint.net"

$script:PRIVATE_PILLAR_ID = 18010

$script:VIPSADMIN_ID = 18148

$script:SALTCLOUD_ID = 18300

$script:outfilename = "secrets.txt"

function Main()
{   
    Remove-Item -ErrorAction SilentlyContinue $outfilename

    Write-SecretInFile $PRIVATE_PILLAR_ID "PRIVATE_PILLAR_USER" $True
    Write-SecretInFile $PRIVATE_PILLAR_ID "PRIVATE_PILLAR_PASSWORD"
    
    Write-SecretInFile $SALTCLOUD_ID "VCENTER_PASSWORD"

    Write-SecretInFile $VIPSADMIN_ID "VIPSADMIN_PASSWORD"

    $hostname = (hostname) + ".vistaprint.net"
    Write-InFile "MASTER_HOSTNAME" $hostname
}

function Write-SecretInFile([int] $private:secretId, [string] $private:key, [boolean] $private:isUsername = $False)
{
    $creds = Get-Credential $secretId
    $value = if ($isUsername) {$creds.User} else {$creds.Password}

    Write-InFile $key $value
}

function Write-InFile($private:key, $private:value)
{
    Add-Content $script:outfilename "$key=$value`n" -NoNewLine 
}

function Get-Credential([int] $private:secretId)
{
    getSecretServerCredentialsById $secretId
}

Main