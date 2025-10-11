#!/bin/sh
#### "***********************************************"
#### "*Levi45 https://satellite-forum.com/index.php *"
#### "***********************************************"

GIT_BASE_URL="https://raw.githubusercontent.com/levi-45/Levi45Emulator/main"

# Detect OS type using package manager status
if [ -f /var/lib/dpkg/status ]; then
    PACKAGE_EXT="deb"
    INSTALL_CMD="dpkg -i --force-overwrite"
    OSTYPE="DreamOS"
    PACKAGE_PATTERN="enigma2-plugin-softcams-oscam-emu-levi45_*_all.deb"
else
    PACKAGE_EXT="ipk"  
    INSTALL_CMD="opkg install --force-reinstall --force-overwrite"
    OSTYPE="Enigma2"
    PACKAGE_PATTERN="enigma2-plugin-softcams-oscam-emu-levi45_*_all.ipk"
fi

echo "Detected OS: $OSTYPE"
echo "Searching for package..."

# Download using wildcard pattern (GitHub serves the actual file if pattern matches one file)
echo "Downloading latest package..."
wget -q --no-check-certificate "$GIT_BASE_URL/$PACKAGE_PATTERN" -O "/tmp/oscam-latest.${PACKAGE_EXT}"

if [ -f "/tmp/oscam-latest.${PACKAGE_EXT}" ]; then
    echo "Installing latest package..."
    $INSTALL_CMD "/tmp/oscam-latest.${PACKAGE_EXT}"
    
    # Cleanup
    rm -f "/tmp/oscam-latest.${PACKAGE_EXT}"
    echo "Installation completed successfully!"
    echo "Please Restart GUI..."
else
    echo "Error: No package found matching pattern: $PACKAGE_PATTERN"
    echo "Please check if package exists on GitHub"
    exit 1
fi