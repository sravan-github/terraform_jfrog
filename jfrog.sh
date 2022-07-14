#!/bin/sh
sudo apt update
sudo apt install wget -y
wget -qO - https://api.bintray.com/orgs/jfrog/keys/gpg/public.key | sudo apt-key add -
echo "deb https://jfrog.bintray.com/artifactory-debs bionic main" | sudo tee /etc/apt/sources.list.d/jfrog.list
sudo apt update
sudo apt install jfrog-artifactory-oss
