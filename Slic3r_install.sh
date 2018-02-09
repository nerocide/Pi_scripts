#!/bin/bash
# prérequis? https://github.com/alexrj/Slic3r/wiki/Running-Slic3r-from-git-on-GNU-Linux
sudo apt-get install -y build-essential cpanminus liblocal-lib-perl
sudo apt-get build-dep slic3r
sudo apt-get install -y libxmu-dev freeglut3-dev libwxgtk-media2.8-dev 
sudo apt-get install -y  libboost-thread-dev libboost-system-dev libboost-filesystem-dev
sudo apt-get install -y cpan
#
if [ -d ./Slic3r ]
then
	cd Slic3r 
	git pull 
else
	git clone git://github.com/alexrj/Slic3r 
	cd Slic3r 
fi
git checkout 1.2.9
export LDLOADLIBS=-lstdc++
sudo perl Build.PL 
sudo perl Build.PL --gui
sudo perl Build.PL install
