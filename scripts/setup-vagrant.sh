#! /bin/bash

# Install necessary libraries for guest additions and Vagrant NFS Share
sudo apt-get -y -q install linux-headers-$(uname -r) build-essential dkms nfs-common

# Install the Guest Additions CD
mkdir /tmp/vboxguest
mount -t iso9660 -o loop /home/vagrant/VBoxGuestAdditions*.iso /tmp/vboxguest
cd /tmp/vboxguest
./VBoxLinuxAdditions.run
cd ~
sudo umount /tmp/vboxguest
rm VBoxGuestAdditions_*.iso

# Setup SSH key environment
mkdir ~/.ssh
chmod 700 ~/.ssh
cd ~/.ssh
wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -O authorized_keys
chmod 600 ~/.ssh/authorized_keys
chown -R vagrant ~/.ssh

# Add vagrant user (through admin group) to sudoers
groupadd -r admin
usermod -a -G admin vagrant
cp /etc/sudoers /etc/sudoers.orig
sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=admin' /etc/sudoers
sed -i -e 's/%admin ALL=(ALL) ALL/%admin ALL=NOPASSWD:ALL/g' /etc/sudoers
