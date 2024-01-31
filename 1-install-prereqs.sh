#!/bin/bash
if [ -n "$1" ]; then
  #probably ran as root
  MYUSER=$1
  THISDIR=$2
else
  MYUSER=$USER
  THISDIR=$PWD
fi

if [ "$EUID" -ne 0 ]; then
   echo "Enter root password"
    su - root -c ". ${THISDIR}/1-install-prereqs.sh ${USER} ${THISDIR}"
else
    #runs as root 
    #installs updates and software
    apt update
    apt install git vim sudo htop tmux dos2unix unzip software-properties-common -y
    apt-add-repository non-free -y
    dpkg --add-architecture i386
    apt update; apt upgrade -y
    #add my user to sudoers and make work in current prompt
    usermod -aG sudo $MYUSER
    rm /lib/systemd/system/sudo.service
    systemctl daemon-reload
    systemctl restart sudo
    systemctl mask sudo.service
    #install systemwide
    apt install steamcmd -y
    #don't prompt all the time
    echo Defaults:$MYUSER !tty_tickets >/etc/sudoers.d/tty_tickets
    #fix this dir if was a zip
    chmod -R ugo+x ${THISDIR}/*.sh
    dos2unix -q ${THISDIR}/*.sh
    dos2unix -q ${THISDIR}/*/*.sh
    echo 'Ready to run ./2-install-rust.sh'
fi
