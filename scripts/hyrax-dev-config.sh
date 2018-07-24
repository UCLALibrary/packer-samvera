#! /bin/bash

# Create a database user for the system user (in our case 'vagrant')
sudo -u postgres PGPASSWORD="$ROOT_DB_PASSWORD" psql -c "CREATE USER vagrant WITH LOGIN CREATEDB PASSWORD 'vagrant';"

# Install databases specific to a developer's workstation
cd "/home/vagrant/${PROJECT_NAME}"
sudo -u vagrant bundle exec rake db:setup
