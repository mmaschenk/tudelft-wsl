# tudelft-wsl

This repository helps you install a TU Delft specific ubuntu image for wsl. It downloads and registers the image, allowing you to run wsl with a number of pre-installed tools available. Among these tools are:
- irods command line clients

## quick install

Make sure you have the "Windows Subsystem for Linux" system component installed.

Open a powershell window and copy-and-paste the following line into it:

```
 (New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/mmaschenk/tudelft-wsl/releases/latest/download/tudinstaller.ps1') | iex
```

Wait for the image to be downloaded and registered. After this you can start `wsl -d tudelft` to run the image (or find it in the profiles of your Windows Terminal app)

In case you do not trust me (you probably shouldn't), first download the [tudinstaller.ps1 script](https://raw.githubusercontent.com/mmaschenk/tudelft-wsl/releases/latest/download/tudinstaller.ps1) to your local machine and inspect what it does before running it!