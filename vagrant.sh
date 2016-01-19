# Make sure we're using the latest version of the repos
sudo apt-get update

# First we install this missing packages (http://lifeonubuntu.com/ubuntu-missing-add-apt-repository-command/)
sudo apt-get install software-properties-common python-software-properties imagemagick libmagick++-dev libmagickwand-dev build-essential zlib1g-dev git-core curl -y

# Add latest node repo
add-apt-repository -y ppa:chris-lea/node.js

# Install node
apt-get install nodejs -y

# Make sure we're in the right folder
cd /vagrant

# Run additional commands as the vagrant user
su -c "source /vagrant/user.sh" vagrant