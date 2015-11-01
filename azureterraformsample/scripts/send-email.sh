#!/bin/bash

apt-get -y install ssmtp
apt-get -y install mailutils
sudo sed -i 's/^mailhub.*$/mailhub=smtp.gmail.com:587\nAuthUser={{your sender gmail address ending with @gmail.com}}\nAuthPass={{password for your sender gmail account}}\nUseTLS=YES\nUseSTARTTLS=YES\n/' /etc/ssmtp/ssmtp.conf

for email in "$@"
do
        su - ${SUDO_USER:-$USER} -c "echo 'FYI - Your Azure host ['`hostname`'] was set up successfully by terraform' | \
        mail -s 'Do Not Reply - Azure VM Setup Notification' $email"
done
