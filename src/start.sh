#!/bin/bash

sudo docker stack deploy -c /home/vagrant/workdir/src/docker-compose.yaml app
sudo curl -L https://downloads.portainer.io/ce2-21/portainer-agent-stack.yml -o portainer-agent-stack.yml
sudo docker stack deploy -c portainer-agent-stack.yml portainer