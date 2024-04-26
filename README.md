# tudelft-wsl

This repository helps you install a TU Delft specific ubuntu image for wsl. It downloads and registers the image, allowing you to run wsl with a number of pre-installed tools available. Among these tools are:
- irods command line clients

#3 Quick install

Make sure you have the "Windows Subsystem for Linux" system component installed.

## git config

Always run `git config --global core.sshcommand "C:/Windows/System32/OpenSSH/ssh.exe"` to set the ssh executable for all invocations of git (also from within vs-code)