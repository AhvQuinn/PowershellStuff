Write-Host "Thanks for using my cache-cleaner! Your game will start momentarily."

$debugMode = 0

$userChipset =  Get-WmiObject Win32_VideoController

if($userChipset.description -like "NVIDIA*"){
    Write-Host "Clearing caches...."
} else {
    Write-Host "At the moment, AMD GPUs are not supported. This feature is coming soon!"
    Start-Sleep -Seconds 3
    exit
}

$scriptPath = Split-Path -parent $MyInvocation.MyCommand.Definition
$scriptPath = Join-Path -path $scriptPath -ChildPath "settings.txt"
$pathCheck = Test-Path $scriptPath

if (!$pathCheck){
    New-Item $scriptPath
    Write-Host "Settings Log created."
}

# Clear these =>
$cacheLocation = "C:\ProgramData\NVIDIA Corporation\NV_Cache"
$cacheLocation2 = Join-Path -path $env:LOCALAPPDATA -ChildPath "D3DSCache"
$cacheLocation3 = Join-Path -path $env:LOCALAPPDATA -ChildPath "NVIDIA\GLCache"
$cacheLocation4 = Join-Path -path $env:LOCALAPPDATA -ChildPath "Temp"

$pathCheck = Test-Path $cacheLocation
if ($pathCheck){
        Get-ChildItem -Path $cacheLocation -Include * | remove-Item -recurse -ErrorAction SilentlyContinue
        Write-Host "Cache: ""$cacheLocation"" cleared!"
} else {
    Write-Host "The ""$cacheLocation"" folder wasn't found. This cache wasn't deleted."
}

$pathCheck = Test-Path $cacheLocation2
if ($pathCheck){
        Get-ChildItem -Path $cacheLocation2 -Include * | remove-Item -recurse -ErrorAction SilentlyContinue 
        Write-Host "Cache: ""$cacheLocation2"" cleared!"
} else {
    Write-Host "The ""$cacheLocation2"" folder wasn't found. This cache wasn't deleted."
}

$pathCheck = Test-Path $cacheLocation3
if ($pathCheck){
        Get-ChildItem -Path $cacheLocation3 -Include * | remove-Item -recurse -ErrorAction SilentlyContinue
        Write-Host "Cache: ""$cacheLocation3"" cleared!"
} else {
    Write-Host "The ""$cacheLocation3"" folder wasn't found. This cache wasn't deleted."
}

$pathCheck = Test-Path $cacheLocation4
if ($pathCheck){
        Get-ChildItem -Path $cacheLocation4 -Include * | remove-Item -recurse -ErrorAction SilentlyContinue
        Write-Host "Cache: ""$cacheLocation4"" cleared!"
} else {
    Write-Host "The ""$cacheLocation4"" folder wasn't found. This cache wasn't deleted."
}

if (!$debugMode){
    Start-Process -FilePath "C:\Battlestate Games\BsgLauncher\BsgLauncher.exe"
}