#! /bin/bash

# Alter our system database user so that it can create databases
sudo -u postgres PGPASSWORD="$ROOT_DB_PASSWORD" psql -c "ALTER USER vagrant WITH CREATEDB;"

# Link to .env file for the system user's code base
sudo ln -s /opt/${PROJECT_NAME}/shared/.env.development /home/vagrant/${PROJECT_NAME}/.env.development
sudo ln -s /opt/${PROJECT_NAME}/shared/.env.production /home/vagrant/${PROJECT_NAME}/.env.production
sudo ln -s /opt/${PROJECT_NAME}/shared/.env.test /home/vagrant/${PROJECT_NAME}/.env.test

# Install test database; Ansible has installed the other database
cd "/home/vagrant/${PROJECT_NAME}"
RAILS_ENV=test bundle exec rake db:setup

# Setup an alias for `bundle exec`
echo -e "alias be=\"bundle exec\"\n" >> /home/vagrant/.bash_aliases

# This is a temporary workaround... log files should go to /var/log
sudo chown -R vagrant:vagrant /home/vagrant/${PROJECT_NAME}/log
