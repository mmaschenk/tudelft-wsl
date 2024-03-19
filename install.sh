#!/bin/bash

echo "Doing installation"

wget -qO - https://packages.irods.org/irods-signing-key.asc > /etc/apt/trusted.gpg.d/irods-signing-key.asc

echo "deb [arch=amd64] https://packages.irods.org/apt/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/renci-irods.list

apt-get update -y

# Basic tools
apt install -y irods-icommands irods-gridftp-client python3-irodsclient dos2unix ipython3 jupyter-core jupyterhub python-is-python3 python3-pip