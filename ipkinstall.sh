#!/bin/sh
#### "***********************************************"
#### "*Levi45 https://satellite-forum.com/index.php *"
#### "***********************************************"
# Downloading
echo "Downloading OscamEmu..."
wget -q --no-check-certificate "https://raw.githubusercontent.com/levi-45/Levi45Emulator/main/levi45_all.ipk" -O /tmp/levi45_all.ipk

# Force installation
echo "Installing..."
opkg install --force-reinstall --force-overwrite /tmp/levi45_all.ipk

# Cleanup tmp
rm -f /tmp/levi45_all.ipk
echo "Please Restart GUI..."
exit
