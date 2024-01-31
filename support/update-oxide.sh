#!/bin/bash
# for use by rust user
cd ~/rust
oxide_url=https://github.com/OxideMod/Oxide.Rust/releases/latest/download/Oxide.Rust-linux.zip
echo ">> Downloading Oxide"
wget -N -q $oxide_url -O oxide.zip
if [ $? == 0 ]; then
  echo ">> Extracting Oxide"
  unzip -o -qq oxide.zip
else
  echo "failed download"
fi

#if [ -f CSharpCompiler ]; then
#  chmod u+x CSharpCompiler
#fi
