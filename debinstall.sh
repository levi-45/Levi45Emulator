#!/bin/sh
#### "***********************************************"
#### "*Levi45 https://satellite-forum.com/index.php *"
#### "***********************************************"
# Downloading
echo "Downloading OscamEmu..."
wget -q --no-check-certificate "https://raw.githubusercontent.com/levi-45/Levi45Emulator/main/levi45_all.deb" -O /tmp/levi45_all.deb

# Force installation
echo "Installing..."
dpkg -i --force-reinstall --force-overwrite /tmp/levi45_all.deb

# Cleanup tmp
rm -f /tmp/levi45_all.deb
echo "Please Restart GUI..."
exit
