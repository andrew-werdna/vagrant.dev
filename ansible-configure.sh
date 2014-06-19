#!/bin/sh

# Connect to vagrant host and start ansible to run tasks tagged with "configure"
ssh vagrant@33.33.33.10 -i $HOME/.vagrant.d/insecure_private_key "sudo -s; export PYTHONUNBUFFERED=1; ansible-playbook /vagrant/ansible/main.yml --inventory-file=/vagrant/ansible/hosts-local --user=vagrant --tags=configure"