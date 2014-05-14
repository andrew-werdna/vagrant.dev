#!/bin/bash

# Upgrade all packages
if [[ ! -f /provision-update-run ]]; then
	yum update -y && touch /provision-update-run
fi

# Install ansible and requirements
if [[ ! -f /provision-python-run ]]; then 
	yum -y install python-devel python-setuptools && easy_install pip && pip install ansible && touch /provision-python-run
fi

# Create private key for virtual machine and allow it to connect to iself, also add host to known hosts
# Note: This script is run as root, but ansible then uses the vagrant user when connecting
if [[ ! -f /provision-ssh-run ]]; then 
	ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa && cat ~/.ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys && ssh-keyscan -H 127.0.0.1 >> ~/.ssh/known_hosts && touch /provision-ssh-run
fi
