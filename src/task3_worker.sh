#!/bin/bash 

apt update
apt upgrade -y
apt install -y docker.io

docker swarm join --token $(cat /vagrant/src/swarm_token) $1:2377