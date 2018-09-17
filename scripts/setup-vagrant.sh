#! /bin/bash

# Install necessary libraries for guest additions and Vagrant NFS Share
if hash apt-get 2>/dev/null; then
  sudo apt-get -y -q install linux-headers-$(uname -r) build-essential dkms nfs-common
elif hash yum 2>/dev/null; then
  sudo yum -y install perl gcc dkms kernel-devel kernel-headers make
fi

# Install the Guest Additions CD
mkdir /tmp/vboxguest
mount -t iso9660 -o loop /home/vagrant/VBoxGuestAdditions.iso /tmp/vboxguest
cd /tmp/vboxguest
./VBoxLinuxAdditions.run
cd ~
sudo umount /tmp/vboxguest
sudo rm -f /home/vagrant/VBoxGuestAdditions.iso

# Setup SSH key environment
mkdir /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh
cd /home/vagrant/.ssh
wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -O authorized_keys
chmod 600 /home/vagrant/.ssh/authorized_keys
sudo chown -R vagrant:vagrant /home/vagrant/.ssh

# Add vagrant user (through admin group) to sudoers
/usr/sbin/groupadd -r admin
/usr/sbin/usermod -a -G admin vagrant
cp /etc/sudoers /etc/sudoers.orig
sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=admin' /etc/sudoers
sed -i -e 's/%admin ALL=(ALL) ALL/%admin ALL=NOPASSWD:ALL/g' /etc/sudoers
