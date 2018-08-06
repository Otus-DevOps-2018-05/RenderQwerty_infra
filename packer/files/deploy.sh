#!/bin/bash
# Description: Script for reddit application installation
# Author: Yurii Fisakov, fisakov.root@gmail.com
# Comment: execute as root

git clone -b monolith https://github.com/express42/reddit.git $HOME/reddit && cd $HOME/reddit || exit
bundle install