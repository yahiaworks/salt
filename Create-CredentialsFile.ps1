param (
)

$script:MASTER_HOST = "devwltvipssm002.vistaprint.net"

$script:PRIVATE_PILLAR_ID = 18010

$script:VIPSADMIN_ID = 18148

$script:SALTCLOUD_ID = 18300

$script:SALTAPI_ID = 18596

$script:CERT_ID = 8789

$script:LDAPSALT_ID = 18713

$script:outfilename = "secrets.txt"

function Main()
{   
    Get-SSModule
    Import-SSModule

    Remove-Item -ErrorAction SilentlyContinue $outfilename

    Write-SecretInFile $PRIVATE_PILLAR_ID "PRIVATE_PILLAR_USER" $True
    Write-SecretInFile $PRIVATE_PILLAR_ID "PRIVATE_PILLAR_PASSWORD"
    
    Write-SecretInFile $SALTCLOUD_ID "VCENTER_PASSWORD"

    Write-SecretInFile $VIPSADMIN_ID "VIPSADMIN_PASSWORD"

    Write-SecretInFile $SALTAPI_ID "SALTAPI_USERNAME" $True
    Write-SecretInFile $SALTAPI_ID "SALTAPI_PASSWORD"

    Write-SecretInFile $CERT_ID "PEM_PASSPHRASE" -UserField "Notes"

    Write-SecretInFile $LDAPSALT_ID "LDAPBIND_USERNAME" $True
    Write-SecretInFile $LDAPSALT_ID "LDAPBIND_PASSWORD"

    $hostname = (hostname) + ".vistaprint.net"
    Write-InFile "MASTER_HOSTNAME" $hostname
}

function Write-SecretInFile([int] $private:secretId, [string] $private:key, [boolean] $private:isUsername = $False,
                            [string] $userField="Username", [string] $passwordField="Password")
{
    $creds = Get-Credential $secretId $userField $passwordField
    $value = if ($isUsername) {$creds.User} else {$creds.Password}

    Write-InFile $key $value
}

function Write-InFile($private:key, $private:value)
{
    Add-Content $script:outfilename "$key=$value`n" -NoNewLine 
}

function Get-Credential([int] $private:secretId, [string] $userField, [string] $passwordField)
{
    getSecretServerCredentialsById -UsernameField $userField -PasswordField $passwordField $secretId
}

function Get-SSModule() {
    Invoke-WebRequest -Outfile .\SecretServer-1.2.0.psm1 https://vbuartifactory.vips.vpsvc.com/artifactory/libs-release-local/com.vistaprint/PowershellModules/SecretServer/1.2.0/SecretServer-1.2.0.psm1
}

function Import-SSModule {
    Import-Module .\SecretServer-1.2.0.psm1 -DisableNameChecking -Force
}

Main