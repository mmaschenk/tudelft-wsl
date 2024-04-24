function Update-ImageCacheFile {
    param (
        [Parameter(Position=0, Mandatory=$true)] $downloadurl,
        $storename = 'wsl',
        $cachepath = '.cache',
        $base = $env:UserProfile
    )
    
    if (-not [System.IO.Path]::IsPathRooted($storename)) {
        $storename = Join-Path -Path $base -ChildPath $storename
    }
    if (-not [System.IO.Path]::IsPathRooted($cachepath)) {
        $cachepath = Join-Path -Path $storename -ChildPath $cachepath
    }
    $basename = $downloadurl.Substring($downloadurl.LastIndexOf("/") + 1)
    $imagefile = Join-Path -Path $cachepath -ChildPath $basename
    $hashurl = "${downloadurl}.hash"

    

    Write-Host "Downloadurl", $downloadurl
    Write-Host "Base is", $base
    Write-Host "Storename", $storename
    Write-Host "Cache path", $cachepath
    Write-Host "Imagefile", $imagefile
    Write-Host "Hashurl", $hashurl

    if (Test-Path -Path $imagefile -PathType leaf) {
        Write-Host "Image file already present"
        $localhashvalue = (Get-FileHash $imagefile).Hash
    } else {
        Write-Host "Image file not yet present"
        $localhashvalue = "NOTPRESENT"
    }

    $remotehash = Invoke-WebRequest -URI $hashurl

    $remotehashvalue = [System.Text.Encoding]::ASCII.GetString($remotehash.Content)
    Write-Host "Local hash value", $localhashvalue
    Write-Host "Remotehashvalue", $remotehashvalue

    if ($remotehash -ne $localhashvalue) {
        Write-Host "Need to download"
        $webclient = New-Object System.Net.WebClient
        Write-Host "Downloading image"
        $webclient.DownloadFile($downloadurl, $imagefile.ToString())
        Write-Host "Image downloaded"
    }
}