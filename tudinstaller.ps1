param (
    $downloadurl = "%baseurl%/tudelft.tgz",
    $RegistrationName = "tudelft"
)

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

    Write-Host("Downloadurl:           {0}" -f $downloadurl)
    Write-Host("Base is:               {0}" -f $base)
    Write-Host("Storename:             {0}" -f $storename)
    Write-Host("Cache path:            {0}" -f $cachepath)
    Write-Host("Imagefile:             {0}" -f $imagefile)
    Write-Host("Hashurl:               {0}" -f $hashurl)

    $ni = New-Item -ItemType Directory -Path $cachepath -ErrorAction SilentlyContinue

    if (Test-Path -Path $imagefile -PathType leaf) {
        Write-Host "* Image file already present"
        $localhashvalue = (Get-FileHash $imagefile).Hash.Trim()
    } else {
        Write-Host "* Image file not yet present"
        $localhashvalue = "NOTPRESENT"
    }
    $remotehash = Invoke-WebRequest -URI $hashurl
    $remotehashvalue = [System.Text.Encoding]::ASCII.GetString($remotehash.Content).Trim()
    Write-Host("Local hash:            {0}" -f $localhashvalue)
    Write-Host("Remote hash:           {0}" -f $remotehashvalue)

    if ($remotehashvalue -ne $localhashvalue) {
        Write-Host "* Need to download image file"
        $webclient = New-Object System.Net.WebClient
        Write-Host "* Downloading image file"
        $webclient.DownloadFile($downloadurl, $imagefile.ToString())
        Write-Host "* Imagefile downloaded"
    }
    return $imagefile
}

function Initialize-WSLStoreLocation {
    param(
        [Parameter(Position=0, Mandatory=$true)] $distribution,
        $storename = 'wsl',
        $base = $env:UserProfile
    )

    if (-not [System.IO.Path]::IsPathRooted($storename)) {
        $storename = Join-Path -Path $base -ChildPath $storename
    }

    $fullstorepath = Join-Path -Path $storename -ChildPath $distribution

    if (Test-Path $fullstorepath) {
        $dirinfo = Get-ChildItem $fullstorepath

        if ($dirinfo.count -ne 0) {
            throw ("Directory {0} already exists and is not empty." -f $fullstorepath)
        } else {
            $ni = New-Item -Path $fullstorepath -ItemType Directory 
            Write-Host("Created fullstorepath: {0}" -f $fullstorepath)
        }
    }
    return $fullstorepath.ToString()
}

function  Register-ImageFile {
    param (
        [Parameter(Position=0, Mandatory=$true)] $downloadurl,
        $registrationname = 'tudelft'
    )

    $cachefile = Update-ImageCacheFile($downloadurl)
    $fullstorepath = Initialize-WSLStoreLocation($registrationname)

    Write-Host("cachefile:             {0}" -f $cachefile)
    Write-Host("registration:          {0}" -f $registrationname)
    Write-Host("storepath:             {0}" -f $fullstorepath)
    
    Write-Host("going to run: wsl.exe --import {0} {1} {2}" -f $registrationname,"$fullstorepath","$cachefile")
    wsl.exe --import $registrationname "$fullstorepath" "$cachefile"
}

Write-Host("Installing:            {0}" -f $downloadurl)
Register-ImageFile -downloadurl $downloadurl -registrationname $RegistrationName