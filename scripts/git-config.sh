#! /bin/bash

#
# Some git configuration post git installation (which is done in a role)
#

# Have git remember user's https passwords
git config --global credential.helper cache

# Have git remember them for nine hours
git config --global credential.helper 'cache --timeout=32400'

# Avoid the initial warning message by choosing the newer merge strategy
git config --global push.default current
