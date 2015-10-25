#!/bin/bash
sudo /usr/sbin/setenforce 0
sudo sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers
sudo sed -i "s/#UseDNS yes/UseDNS no/" /etc/ssh/sshd_config
sudo sed -i "s/#Port 22/Port 62323/" /etc/ssh/sshd_config
sudo sed -i "s/SELINUX=enforcing/SELINUX=disabled/" /etc/selinux/config

sudo rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
sudo yum -y install gcc make automake autoconf libtool gcc-c++ kernel-headers-`uname -r` kernel-devel-`uname -r` zlib-devel openssl-devel readline-devel sqlite-devel perl wget nfs-utils bind-utils
sudo yum -y --enablerepo=epel install dkms

# Installing vagrant keys
mkdir -pm 700 /home/vagrant/.ssh
wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -O /home/vagrant/.ssh/authorized_keys
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant /home/vagrant/.ssh

cd /tmp
sudo mount -o loop /home/vagrant/VBoxGuestAdditions.iso /mnt
sudo sh /mnt/VBoxLinuxAdditions.run
sudo umount /mnt
rm -rf /home/vagrant/VBoxGuestAdditions*.iso
sudo /etc/rc.d/init.d/vboxadd setup

sudo curl -L https://www.chef.io/chef/install.sh | sudo bash
