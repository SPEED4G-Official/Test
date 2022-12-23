#!/bin/bash

version=`curl -s https://api.github.com/repos/AikoCute-Offical/AikoR/releases/latest | grep "tag_name" | cut -d '"' -f4`
wget https://github.com/AikoCute-Offical/AikoR/releases/download/"${version}"/AikoR-linux-64.zip
# Unzip the file and remove the zip file Go to the directory /etc /aikor and overwrite all file
unzip -o AikoR-linux-64.zip -d ./AikoR-linux-64/etc/aikor/
rm -rf AikoR-linux-64.zip

# Build the package
dpkg -b ./AikoR-linux-64/ AikoR-"${version}"-amd64.deb

# rename Version number from file : /AikoR-linux-64/DEBIAN/control
sed -i "s|Version:.*|Version: ${version}|" ./AikoR-linux-64/DEBIAN/control
