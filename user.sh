# The following commands run under the vagrant user.
# We need to do this since we execute rails under that
# user

cd /vagrant

# Make sure we're using rvm, with the proper config
source /usr/local/rvm/scripts/rvm

# We're changing ruby versions
rvm install 2.1.3
rvm --default use 2.1.3

# Install all the dependencies for the rails project
bundle install

# Create the database
rake db:setup

# Add some data to the database
rake db:migrate
