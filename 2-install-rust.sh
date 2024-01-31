#!/bin/bash
WorkingDir="${PWD}"

#check for sudo access otherwise scripts wont work
if [ ! "$SUDO_USER" ]; then
    if sudo "./$(basename "$0")"; then
        exit
    else
        echo 'Did you run the 1st script?'
    fi
fi

#################################################################################################################

function create_rust_user {
  tmpfile="/tmp/create_rust_user.sh"
  cat >$tmpfile << EOF
#!/bin/bash
if id rust >/dev/null 2>&1; then
exit
else
echo '>> adding rust user'
adduser rust --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password
echo rust:rust_pw | chpasswd
usermod -aG sudo rust
rm /lib/systemd/system/sudo.service
systemctl daemon-reload
systemctl unmask sudo.service
systemctl restart sudo
systemctl mask sudo.service
fi
EOF
  chmod +x $tmpfile
  sudo -i -u root $tmpfile
#  rm $tmpfile
}

function install_steam {
  tmpfile="/tmp/install_steam.sh"
  cat >$tmpfile << EOF
#!/bin/bash
echo ">> Installing rust as \$USER in \$PWD"
if [ ! -f /home/rust/.steam/steam/steamcmd/steamcmd.sh ]; then
  #setup steamcmd for user
  steamcmd +login anonymous +quit
fi
#fix for steam bug
if [ ! -f /home/rust/.local/share/Steam/steamcmd/steamclient.so ]; then
  ln -s /home/rust/.local/share/Steam/steamcmd/linux32/steamclient.so /home/rust/.local/share/Steam/steamcmd/steamclient.so
fi
if [ ! -f /home/rust/.steam/sdk64/steamclient.so ]; then
  mkdir /home/rust/.steam/sdk64/
  mkdir /home/rust/.steam/sdk32/
  ln -s /home/rust/.steam/steamcmd/linux64/steamclient.so /home/rust/.steam/sdk64/
  ln -s /home/rust/.steam/steamcmd/linux32/steamclient.so /home/rust/.steam/sdk32/
fi
#install rust now
/home/rust/.steam/steam/steamcmd/steamcmd.sh +force_install_dir ~/rust +login anonymous +app_update 258550 +quit
EOF
  chmod +x $tmpfile
  sudo -i -u rust $tmpfile
#  rm $tmpfile
}

function copy_scripts {
  tmpfile="/tmp/update_rust_scripts.sh"
  cat >$tmpfile << EOF
#!/bin/bash
if [ ! -f /home/rust/tmux-help.sh ];then
echo '>> Installing server scripts'
cp ${WorkingDir}/support/* /home/rust/
chown rust:rust /home/rust/*.sh
chmod +x /home/rust/*.sh
fi
EOF
  chmod +x $tmpfile
  sudo -i -u root $tmpfile
#  rm $tmpfile
}

#################################################################################################################

#check for rust user
if [ -d /home/rust ]; then
  install_steam
  copy_scripts
else
  echo 'No rust dir, creating user'
  if create_rust_user
  then
    install_steam
    copy_scripts
  fi
fi

echo 'Ready to run ./start-server.sh'
