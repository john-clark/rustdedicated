#!/bin/bash
if ! [ -n "$TMUX" ]; then
	#not in sudo
        if ! [ -n "$SUDO_USER" ]; then
                #check installed
                if ! which sudo; then
                        echo "no sudo - run step 1"
                        exit
                fi
                #check scripts
                if ! sudo [ -f /home/rust/tmux-help.sh ]; then
                        echo "no scripts - run step 2"
                        exit
                fi
        fi

	sudo -v -S
	echo "Starting Rust Dedicated Server"
	#
	tmux set-option remain-on-exit on
	tmux new-session -d -s RUST -n "Run"
	tmux send-keys 'sudo -i -u rust ./start-rustdedicated.sh' 'C-m'
	#
	tmux split-window -v -p 50
	tmux rename-window "htop"
	tmux send-keys 'htop' 'C-m'
	#
	tmux split-window -h -p 50
	tmux rename-window "cmd"
	tmux send-keys 'sudo -i -u rust ./tmux-help.sh' 'C-m'
	#
	tmux select-pane -t 0
	tmux split-window -h -p 50
	tmux rename-window "Log"
	tmux send-keys 'sudo -i -u rust ./tail-rust-server1.sh' 'C-m'
	#
	tmux -2 attach-session -t $sn
else
	echo "DO NOT RUN IN TMUX"
fi
