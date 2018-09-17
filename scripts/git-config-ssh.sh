#! /bin/bash

# Allow git to use host's ssh key
if [ -f "/home/vagrant/${PROJECT_NAME}/.git/config" ]; then
  sed -i 's/url = https\:\/\/github.com\//url = git@github.com:/' /home/vagrant/${PROJECT_NAME}/.git/config
fi
