#!/bin/bash
# Description: Script for ruby dev utils installation
# Author: Yurii Fisakov, fisakov.root@gmail.com
# Comment: execute as root


apt update -y && apt install -y ruby-full ruby-bundler build-essential

# check ruby installation
if [[ $(dpkg -s ruby | grep Status | cut -d' ' -f3,4) == "ok installed" ]]; then
    echo "Ruby installed"
else
    echo "Ruby WAS NOT INSTALLED. Something terrible happend!!" >&2 && exit 1
fi

# check bundler installation
if [[ $(bundler --version | awk '{print $1}') == "Bundler" ]]; then
    echo "Bundler installed"
else
    echo "Bundler WAS NOT INSTALLED. Something terrible happend!!" >&2 && exit 1
fi
