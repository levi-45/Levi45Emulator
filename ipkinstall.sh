#!/bin/sh
#### "***********************************************"
#### "*Levi45 https://satellite-forum.com/index.php *"
#### "***********************************************"
# Download fresh copy
echo "Downloading OscamEmu..."
wget -q --no-check-certificate "https://raw.githubusercontent.com/levi-45/Multicam/main/Cams_ipk/All/enigma2-plugin-softcams-oscam-emu-*_all.ipk" -O /tmp/OscamEmu.ipk

# Force install (ignore version checks)
echo "Installing..."
opkg install --force-reinstall --force-overwrite /tmp/OscamEmu.ipk

# Cleanup
rm -f /tmp/OscamEmu.ipk
echo "Please Restart GUI..."
exit
