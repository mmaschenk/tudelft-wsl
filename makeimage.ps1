param ($distname, $storename)

#$base = $env:Home
$base = $env:UserProfile

if ([System.String]::IsNullOrWhiteSpace($storename)) {
    $storepath = Join-Path -Path $base -ChildPath "wsl"
} else {
    if (-not [System.IO.Path]::IsPathRooted($storename)) {
        $storename = Join-Path -Path $env:Home -ChildPath $storename
    }
    if (Test-Path $storename) {
        $storepath = Resolve-Path -Path $storename
    } else {
        throw "Directory {0} not found" -f $storename
    }
}
$fullstorepath = Join-Path -Path $storepath -ChildPath $distname
$cachepath = Join-Path -Path $storepath -ChildPath '.cache'

New-Item -ItemType Directory -Path $cachepath -ErrorAction SilentlyContinue

Write-Host "DIST", $distname
Write-Host "HOME", $env:Home
Write-Host "SN", $storename
Write-Host "SP", $storepath
Write-Host "FSP", $fullstorepath

if (Test-Path $fullstorepath) {
    throw "Directory {0} already exists. Will not continue" -f $fullstorepath
}


$imagefile = Join-Path -Path $cachepath -ChildPath "ubuntu.tar.gz"

Write-Host "IMAGE", $imagefile

#Invoke-WebRequest -Uri https://cloud-images.ubuntu.com/wsl/jammy/current/ubuntu-jammy-wsl-amd64-wsl.rootfs.tar.gz | wsl.exe --import $distname $fullstorepath -

New-Item -Path $fullstorepath -ItemType Directory > $null
$webclient = New-Object System.Net.WebClient
Write-Host "Downloading image"
#$webclient.DownloadFile("https://cloud-images.ubuntu.com/wsl/jammy/current/ubuntu-jammy-wsl-amd64-wsl.rootfs.tar.gz", $imagefile.ToString())
Write-Host "Image downloaded"

wsl.exe --import $distname $fullstorepath $imagefile

$config = @"
[user]
default=tud

[network]
hostname=tudelft
"@

$installscript = Get-Content .\install.sh -Raw

Push-Location $env:Home

wsl.exe -d $distname 'sed' '-i.bak' 's/^%sudo\s*ALL\=(ALL:ALL)\s*ALL/%sudo  ALL=(ALL)       NOPASSWD: ALL/' '/etc/sudoers'
wsl.exe -d $distname useradd -m -G sudo tud -s /bin/bash

#wsl.exe -d $distname apt install -y dos2unix
Write-Output $installscript  | wsl.exe -d $distname 'cat' '|' 'sed' '$ s/.$//' '>' '/tmp/install.sh' # Bloody powershell...
wsl.exe -d $distname chmod 755 /tmp/install.sh

Write-Output $config | wsl.exe -d $distname 'cat' '>' '/etc/wsl.conf'
wsl.exe -d $distname /tmp/install.sh

Pop-Location