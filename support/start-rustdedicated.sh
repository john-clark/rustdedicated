#!/bin/bash
#for use by rust user
export templdpath=$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=./linux64:$LD_LIBRARY_PATH
#
#options commented out below are not implemented 

### Remote Administration Options
rcon_ip="0.0.0.0"              # open to all
rcon_port=28017                # This port is TCP
#rcon_web=1 	               # If set to true, use websocket rcon. If set to false use legacy, source engine rcon.
rcon_pw="admin"                # Sets the RCON password
#rcon_ssl="/etc/ssl/cert.pfx"  # (Required for secure websockets) Sets the path to the PKCS12 PFX
#rcon_sslpw=""                 # (Required for secure websockets) to decrypt the private key in the PFX

### Server configuration
hostname="server"      # server list infoi (example: Server Name|Location|rate|mods info|no or wipe|PVP or PVE)
identity="server1"     # path to server files rust/server/identity aka multiple instances.
#ip="0.0.0.0"          # to only listen on one ip
sport=28015            # This port is UDP
qport=28016            # query port
#aport=28018           # app port
url=""                 # URL displayed at login screen
image="https://i.imgur.com/SG9I9D4.png" # 1024x512 or 512x256px JPG/PNG headerimage link here
description="Private"  # Description displayed while login
steamgroup=""          # limit to server players to group
maxplayers="50"        # 
tickrate="10"          # Server refresh (not above 30)
level="Procedural Map" # Server Map (Procedural Map) values: Barren, Craggy Island, Hapis, Savas Island
dsize="6000"           # Defines the size of the map generated (min 1000, max 6000)
seed="17762077"        # Replace with a random number
mode="softcore"        # vanilla, survival, hardcore, softcore

### InGame variables
#decay_tick=0           # Larger amount increases the applied decay damage to entity. (600)
decay_scale=1          # 1 = normal decay, 0,5 = 50%, 0 = turn decay off (1)
#stability==0           # If false, building will have 100% stability no matter how high you build.
#radiation=1
#upkeep=0

logfile="server/${identity}/${identity}.log"
cd ~/rust
#Save last Logfile
if [ -f ${logfile} ]; then
    mv ${logfile} ${logfile}-{"$(date +%Y%m%d-%H%M%S)"}
    ./RustDedicated -load  \
	        -batchmode \
		-nographics \
		-logFile $logfile \
		-silent-crashes \
		-autoupdate \
		+rcon.ip "${rcon_ip}" \
		+rcon.port "${rcon_port}" \
		+rcon.password "${rcon_pw}" \
		+server.port "${sport}" \
		+server.identity "${identity}" \
		+server.maxplayers "${maxplayers}" \
		+server.hostname "${hostname}" \
		+server.logoimage "${image}" \
		+server.description "${description}" \
		+server.url "${url}"  \
		+server.level "${level}"  \
		+server.seed "${seed}"  \
		+server.worldsize "${size}" \
		+server.gamemode "${mode}" \
		+decay.scale "${decay_scale}"
else
    #no log = new server
    ./RustDedicated \
	        -batchmode \
	        -nographics \
		-logFile $logfile \
		-silent-crashes \
		-autoupdate \
		+rcon.ip "${rcon_ip}" \
		+rcon.port "${rcon_port}" \
		+rcon.password "${rcon_pw}" \
		+server.port "${sport}" \
		+server.identity "${identity}" \
		+server.maxplayers "${maxplayers}" \
		+server.hostname "${hostname}" \
		+server.logoimage "${image}" \
		+server.description "${description}" \
		+server.url "${url}"  \
		+server.level "${level}"  \
		+server.seed "${seed}"  \
		+server.worldsize "${size}" \
		+server.gamemode "${mode}" \
                +decay.scale "${decay_scale}"
fi
