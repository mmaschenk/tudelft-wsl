param (
    $distname='tudelft', 
    $storename, 
    $downloadurl = "https://github.com/mmaschenk/tudelft-wsl/releases/download/v0.0.1/tud.tgz"
    )

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
$basename = $downloadurl.Substring($downloadurl.LastIndexOf("/") + 1)
$imagefile = Join-Path -Path $cachepath -ChildPath $basename

Write-Host $cachepath
Write-Host $distname
Write-Host $downloadurl
Write-Host $basename
Write-Host $imagefile

if (Test-Path $fullstorepath) {
    Write-Host ("Directory {0} already exists. Will not continue" -f $fullstorepath)
    exit
}

if (-not (Test-Path $imagefile)) {
    $webclient = New-Object System.Net.WebClient
    Write-Host "Downloading image"
    $webclient.DownloadFile($downloadurl, $imagefile.ToString())
    Write-Host "Image downloaded"
}

wsl.exe --import $distname $fullstorepath $imagefile