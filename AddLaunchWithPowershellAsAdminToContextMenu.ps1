#Before using, set the $debugMode variable to 0.
#You may update the $contextMenuTitle vaiable to be whatever you want, but DO NOT use ANY special characters.

$debugMode = 0
$contextMenuTitle = "Run with PowerShell as Administrator"

#========================================================== End Of User-Configurable Fields ==========================================================#

Write-Host "Thanks for using Ahv Quinn's Context-Menu Addition Tool!"
Start-Sleep -Seconds 2

$regPath = "Registry::HKEY_CLASSES_ROOT\Microsoft.PowerShellScript.1\Shell\$contextMenuTitle\Command"
$regCommand = "$([char]0x0022)C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe$([char]0x0022) $([char]0x0022)-Command$([char]0x0022) $([char]0x0022)$([char]0x0022)& {Start-Process PowerShell.exe -ArgumentList $([char]0x0027)-ExecutionPolicy RemoteSigned -File \$([char]0x0022)%1\$([char]0x0022)$([char]0x0027) -Verb RunAs}$([char]0x0022)"

$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if(!$debugMode){
    if(!$isAdmin){
        Write-Host "
This script must be run as an Administrator. Exiting shell..."
        Start-Sleep -Seconds 3
        exit
    }    
    $key = try{
        Get-Item -Path $regPath -ErrorAction Stop
    } catch {
        New-Item -Path $regPath -Force
    }

    Set-ItemProperty -Path $key.PSPath -Name '(Default)' -Value $regCommand
    Write-Host "Command Added!"
} else {
    Write-Host "

You need to configure this PowerShell Script properly before using it.
Please consult the documentation in the header of the file."
    Start-Sleep -Seconds 5
}