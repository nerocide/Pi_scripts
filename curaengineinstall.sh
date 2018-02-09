#!/bin/bash
# install cura engine 15.04 on raspberry for octoprint and cura plugin
wget https://github.com/Ultimaker/CuraEngine/archive/15.04.6-RC2.tar.gz
tar xzvf 15.04.6-RC2.tar.gz
cd CuraEngine-15.04.6-RC2/
make
cp build/CuraEngine /bin/
