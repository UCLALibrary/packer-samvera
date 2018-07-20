#! /bin/bash

# Allow git to use host's ssh key
sed -i 's/url = https\:\/\/github.com\//url = git@github.com:/' ~/${PROJECT_NAME}/.git/config
