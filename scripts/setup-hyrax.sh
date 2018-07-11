#! /bin/bash

##
# This is stuff that mostly really belongs elsewhere (?)
##

# Ubuntu ISO doesn't have this by default
gem install nokogiri -v '1.8.2'

# https://stackoverflow.com/questions/24470520/capistrano-mkdir-permission-denied
chown deploy:deploy /var/www/

# We can use the system env instead of dotenv since our box has a specific purpose
echo "export SECRET_KEY_BASE=$SECRET_KEY_BASE" >> /etc/environment
echo "export DB_USERNAME=$DB_USERNAME" >> /etc/environment
echo "export DB_PASSWORD=$DB_PASSWORD" >> /etc/environment
echo "export DB_NAME=$DB_NAME" >> /etc/environment
echo "export BRANCH=$GITHUB_BRANCH" >> /etc/environment
echo "export PROJECT_NAME=$PROJECT_NAME" >> /etc/environment
echo "export PROJECT_OWNER=$PROJECT_OWNER" >> /etc/environment
echo "export GEONAMES_USERNAME=$GEONAMES_USERNAME" >> /etc/environment

# I'm not using dotenv but something in the build expects this so we fake it...
mkdir -p /opt/${PROJECT_NAME}/shared
touch /opt/${PROJECT_NAME}/shared/.env.production
chown -R deploy:deploy /opt/${PROJECT_NAME}/
