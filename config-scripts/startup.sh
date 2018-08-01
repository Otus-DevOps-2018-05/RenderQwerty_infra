#!/bin/bash
# Description: Script for reddit-app installtion
# Author: Yurii Fisakov, fisakov.root@gmail.com
# Comment: Combines all install & deploy scripts into one script. Should be used for startup script on gcloud compute instance

# There is no sudo as root because gcloud executes this script from metadata by default as root user

apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list
apt -y update && apt install -y ruby-full ruby-bundler build-essential mongodb-org
systemctl start mongod && systemctl enable mongod
cd /home/appuser/ || exit
git clone -b monolith https://github.com/express42/reddit.git
chown -R appuser:appuser ./reddit
cd ./reddit || exit
sudo -u appuser bundle install && puma -d
