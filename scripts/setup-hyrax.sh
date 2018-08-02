#! /bin/bash

##
# This is stuff that mostly really belongs elsewhere (?)
##

createDotEnv() {
  ENV_FILE="/opt/${1}/shared/.env.${2}"

  touch "$ENV_FILE"

  echo "PROJECT_NAME=${1}" >> "$ENV_FILE"
  echo "DATABASE_NAME=${3}" >> "$ENV_FILE"
  echo "DATABASE_USERNAME=${4}" >> "$ENV_FILE"
  echo "DATABASE_PASSWORD=${5}" >> "$ENV_FILE"
  echo "DATABASE_POOL_SIZE=25" >> "$ENV_FILE"
  echo "GEONAMES_USERNAME=${6}" >> "$ENV_FILE"
  echo "RAILS_SERVE_STATIC_FILES=true" >> "$ENV_FILE"
  echo "SIDEKIQ_WORKERS=7" >> "$ENV_FILE"
  echo "ADMIN_PASSWORD=${7}" >> "$ENV_FILE"
}

# Ubuntu ISO doesn't have this by default
gem install nokogiri -v '1.8.2'

# https://stackoverflow.com/questions/24470520/capistrano-mkdir-permission-denied
chown deploy:deploy /var/www/

# We can use the system env instead of dotenv since our box has a specific purpose
echo "export SECRET_KEY_BASE=$SECRET_KEY_BASE" >> /etc/environment
echo "export BRANCH=$GITHUB_BRANCH" >> /etc/environment
echo "export PROJECT_NAME=$PROJECT_NAME" >> /etc/environment
echo "export PROJECT_OWNER=$PROJECT_OWNER" >> /etc/environment
echo "export GEONAMES_USERNAME=$GEONAMES_USERNAME" >> /etc/environment

mkdir -p "/opt/${PROJECT_NAME}/shared"

createDotEnv "$PROJECT_NAME" "production" "$DB_NAME" "$DB_USERNAME" "$DB_PASSWORD" "$GEONAMES_USERNAME" "$ADMIN_PASSWORD"
createDotEnv "$PROJECT_NAME" "test" "${DB_NAME}_test" "$DB_USERNAME" "$DB_PASSWORD" "$GEONAMES_USERNAME" "$ADMIN_PASSWORD"
createDotEnv "$PROJECT_NAME" "development" "$DB_NAME" "$DB_USERNAME" "$DB_PASSWORD" "$GEONAMES_USERNAME" "$ADMIN_PASSWORD"

# Trying making the development the same as production since we don't have production on our dev box
#createDotEnv "$PROJECT_NAME" "development" "${DB_NAME}_development" "$DB_USERNAME" "$DB_PASSWORD" "$GEONAMES_USERNAME" "$ADMIN_PASSWORD"

chown -R deploy:deploy "/opt/${PROJECT_NAME}/"
