#!/bin/bash
# Description: Create preemptible instance with reddit application
# Author: Yurii Fisakov, fisakov.root@gmail.com

gcloud compute instances create reddit-full-test --image-family=reddit-full --machine-type=g1-small --preemptible --tags=puma-server
