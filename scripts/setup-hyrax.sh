#! /bin/bash

##
# This is stuff that mostly really belongs elsewhere (?)
##

createDotEnv() {
  touch "/opt/${1}/shared/.env.${2}"
  chown -R deploy:deploy "/opt/${1}/"

  echo "PROJECT_NAME=${1}" >> "/opt/${1}/shared/.env.${2}"
  echo "DATABASE_NAME=${3}" >> "/opt/${1}/shared/.env.${2}"
  echo "DATABASE_USERNAME=${4}" >> "/opt/${1}/shared/.env.{2}"
  echo "DATABASE_PASSWORD=${5}" >> "/opt/${1}/shared/.env.{2}"
  echo "DATABASE_POOL_SIZE=25" >> "/opt/${1}/shared/.env.${2}"
  echo "GEONAMES_USERNAME=${6}" >> "/opt/${1}/shared/.env.${2}"
  echo "RAILS_SERVE_STATIC_FILES=true" >> "/opt/${1}/shared/.env.${2}"
  echo "SIDEKIQ_WORKERS=7" >> "/opt/${1}/shared/.env.${2}"
}

# Ubuntu ISO doesn't have this by default
gem install nokogiri -v '1.8.2'

# https://stackoverflow.com/questions/24470520/capistrano-mkdir-permission-denied
chown deploy:deploy /var/www/

# We can use the system env instead of dotenv since our box has a specific purpose
echo "export SECRET_KEY_BASE=$SECRET_KEY_BASE" >> /etc/environment
echo "export DB_USERNAME=$DB_USERNAME" >> /etc/environment
echo "export DB_PASSWORD=$DB_PASSWORD" >> /etc/environment
echo "export DB_NAME=$DB_NAME" >> /etc/environment
echo "export DATABASE_USERNAME=$DB_USERNAME" >> /etc/environment
echo "export DATABASE_PASSWORD=$DB_PASSWORD" >> /etc/environment
echo "export DATABASE_NAME=$DB_NAME" >> /etc/environment
echo "export BRANCH=$GITHUB_BRANCH" >> /etc/environment
echo "export PROJECT_NAME=$PROJECT_NAME" >> /etc/environment
echo "export PROJECT_OWNER=$PROJECT_OWNER" >> /etc/environment
echo "export GEONAMES_USERNAME=$GEONAMES_USERNAME" >> /etc/environment

mkdir -p "/opt/${PROJECT_NAME}/shared"

createDotEnv "$PROJECT_NAME" "production" "$DB_NAME" "$DB_USERNAME" "$DB_PASSWORD" "$GEONAMES_USERNAME"
createDotEnv "$PROJECT_NAME" "test" "$DB_NAME" "$DB_USERNAME" "$DB_PASSWORD" "$GEONAMES_USERNAME"
createDotEnv "$PROJECT_NAME" "development" "$DB_NAME" "$DB_USERNAME" "$DB_PASSWORD" "$GEONAMES_USERNAME"
