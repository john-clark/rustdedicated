***TEST***

1. install Debian with ssh/base utils
2. download archive `wget -qO- https://codeload.github.com/john-clark/rustdedicated/zip/refs/heads/main | busybox unzip -`
   * Rename folder `mv rustdedicated-main rustdedicated`
   * Otherwise `apt install git` and `git clone https://github.com/john-clark/rustdedicated.git`
3. Change to `cd rustdedicated/` folder
4. Run the scripts in the following order:
   * `. ./1-install-prereqs.sh`
   * `./2-install-rust.sh`
   * `./3-install-oxide.sh`
   * `./start-server.sh`
