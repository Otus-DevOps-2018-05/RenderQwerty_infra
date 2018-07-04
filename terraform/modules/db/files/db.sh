#!/bin/bash
# Description: Script for database init startup
# Author: Yurii Fisakov, fisakov.root@gmail.com

sudo sed -i 's/bindIp: 127.0.0.1/bindIp: 0.0.0.0/g' /etc/mongod.conf
sudo systemctl restart mongod
