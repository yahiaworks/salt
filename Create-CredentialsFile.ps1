param (
)

$script:AWS_KEY_ID = 19235
$script:outfilename = "secrets.txt"

function Main()
{   
    Get-SSModule
    Import-SSModule

    Remove-Item -ErrorAction SilentlyContinue $outfilename

    Write-SecretInFile $AWS_KEY_ID "AWS_ACCESS_KEY_ID" $True -UserField "Access Key ID" -passwordField "Secret Access Key"
    Write-SecretInFile $AWS_KEY_ID "AWS_SECRET_ACCESS_KEY" $False -UserField "Access Key ID" -passwordField "Secret Access Key"
    Write-InFile "AWS_DEFAULT_REGION" "us-east-1"

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