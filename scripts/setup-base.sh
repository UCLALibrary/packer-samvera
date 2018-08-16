#! /bin/bash

# Set the system language
update-locale LANG="en_US.UTF-8" LANGUAGE="en_US"

# Upgrade the system
apt-get -y update
apt-get -y upgrade

# Setup Ansible
apt-get -y install software-properties-common python-software-properties
apt-add-repository -y ppa:ansible/ansible
apt-get -y autoclean
apt-get -y update
apt-get -y install -f ansible

# Setup some basics
apt-get -y install nano htop git nmap curl wget tmux tmuxinator lynx nodejs
