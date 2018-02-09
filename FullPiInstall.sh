#!/bin/bash
cd /home/pi
# we assume the pi is connected to the internet and tcp/22 is open OUT > IN
# install fail2ban to secure the machine a little
sudo apt-get -y install fail2ban
sudo systemctl restart fail2ban
# install octoprint
./Octoprint_reinstall.sh -i
# install haproxy
./HAproxyInstall.sh
# DL/compile/install Slic3r
./Slic3r_install_Octoprint.sh
# DL/compile/install mjpg streamer service
./Mjpg-streamer_install.sh
