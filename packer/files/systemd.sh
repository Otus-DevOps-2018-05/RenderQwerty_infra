#!/bin/bash
# Description: get systemd unit from storage bucket and enable unit
# Author: Yurii Fisakov, fisakov.root@gmail.com
# Comment: for make this trick to work i urged to change acl on file with this command 'gsutil acl ch -u AllUsers:R gs://script_storage/reddit.service'

curl https://storage.googleapis.com/script_storage/reddit.service -o /etc/systemd/system/reddit.service
systemctl daemon-reload
systemctl enable reddit.service && systemctl start reddit.service
systemctl status reddit.service