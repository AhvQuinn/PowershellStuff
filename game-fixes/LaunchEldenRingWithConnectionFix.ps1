# PLEASE READ THE DOCUMENTATION IN FULL BEFORE ATTEMPTING TO USE THIS.

# Issue: It seems that Elden Ring (And some other games) doesn't respect the default MTU (Maximum Transmission Unit) for Windows. Reaffirming this setting before launching the game
#   appears to clear the issue. It could be there's some other issue, and updating this merely alleviates a symptom, and isn't the actual cure.
# Descriptions of MTU, for the curious: https://www.lifewire.com/definition-of-mtu-817948

# To change this script from Debug Mode to Run Mode, change the $debugMode variable from 1 to 0. THIS IS ESSENTIALLY IS A SAFETY TO ENSURE YOU'VE READ THIS.

# Before you run this out of debug mode, run this command in Powershell "netsh interface ipv4 show subinterface"
# Make sure the Interface with the largest Bytes In/ Bytes Out is "Ethernet"
# If it isn't, it's likely because you're running your internet over WiFi, or your connector has been renamed. If that isn't the case, I have no idea what's going on. Proceed at your own risk.
# If the largest interface is not "Ethernet", change the $defaultInterface variable to whichever is largest.
# Finally, make sure the $gamePathway variable is the location of the launch .exe for Elden Ring.
#   You can find this in Steam by right-clicking on the game in your library => "Manage" => "Browse Local Files". It's in the "Game" directory.


$debugMode = 1
$defaultInterface = "Ethernet"
$gamePathway = "D:\SteamLibrary\steamapps\common\ELDEN RING\Game\launch_elden_ring_seamlesscoop.exe"
$gameName = "Elden Ring";

#========================================================== End Of User-Configurable Fields ==========================================================#

Write-Host "Thanks for using Ahv Quinn's Multiplayer Fix for $gameName! Your game will start momentarily."

Start-Sleep -Seconds 2

$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if($debugMode){
    Write-Host "

You need to configure this PowerShell Script properly before using it.
Please consult the documentation in the header of the file."
    Start-Sleep -Seconds 7
}

if (!$debugMode){
    if(!$isAdmin){
        Write-Host "
This script must be run as an Administrator. Exiting shell..."
        Start-Sleep -Seconds 3
        exit
    }
    Write-Host "Setting new MTU Threshold...."
    netsh interface ipv4 set subinterface $defaultInterface mtu=1500 store=persistent
    Start-Sleep -Seconds 1
    Write-Host "Done! Starting $gameName...."
    Start-Sleep -Seconds 1
    Start-Process -FilePath $gamePathway
}
