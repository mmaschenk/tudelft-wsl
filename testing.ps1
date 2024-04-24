. .\helpers.ps1

function Update-MyImageFile {
    param (
        [Parameter(Position=0)] $imagename,
        $cachepath,
        $base
    )
    Write-Host "Base is", $base
}

Update-ImageCacheFile "https://github.com/mmaschenk/actiontester/releases/latest/download/tudelft.tgz"