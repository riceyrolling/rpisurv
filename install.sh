#!/bin/bash

if [ ! "$BASH_VERSION" ] ; then
    echo "ERROR: Please use bash not sh or other shells to run this installer. You can also run this script directly like ./install.sh"
    exit 1
fi

show_version() {
    grep fullversion_for_installer "$BASEPATH/surveillance/surveillance.py" | head -n 1 | cut -d"=" -f2
}

is_vlc_mmal_present() {
 sed -i 's/geteuid/getppid/' /usr/bin/vlc
 if /usr/bin/vlc -H  2>/dev/null | grep -q -- '--mmal-layer';then
    return 0
 else
    return 1
 fi
}

echo "Use this installer on your own risk. Make sure this host does not contain important data and is replacable"
echo "This installer will disable graphical login on your pi, please revert with the raspi-config command if needed."
echo
echo -n "The following version will be installed:"
show_version
echo
#echo "By using this software, you agree that by default limited and non-sensitive (runtime, unique id and version) stats"
#echo "will be sent on a regular interval to a collector server over an encrypted connection."
#echo "You can disable this anytime by changing the update_stats: config option to False."
#echo "This has been introduced to get an idea of how much users are testing a beta version of the software."
#echo "Once the software comes out of beta, stats sending will be disabled by default."
#echo
echo "Do you want to continue press <Enter>, <Ctrl-C> to cancel"
read



#Install needed packages
sudo apt-get update
sudo apt-get install vlc rsync sed coreutils fbset ffmpeg openssl procps python3-pygame python3-yaml python3-openssl python3 libraspberrypi-bin -y

if ! is_vlc_mmal_present;then
    echo "Your version of vlc does not have the needed mmal options. Rpisurv needs those"
    echo "Minimum tested vlc version for Rpisurv is (VLC media player 3.0.11 Vetinari (revision 3.0.11-0-gdc0c5ced72)"
    echo "Aborting installation, upgrade to latest vlc player with mmal support"
    exit 2
fi