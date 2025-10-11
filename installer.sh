#!/bin/sh
#### "***********************************************"
#### "*Levi45 https://satellite-forum.com/index.php *"
#### "***********************************************"

GIT_BASE_URL="https://raw.githubusercontent.com/levi-45/Levi45Emulator/main"

# Detect OS type
if [ -f /var/lib/dpkg/status ]; then
    PACKAGE_URL="$GIT_BASE_URL/enigma2-plugin-softcams-oscam-emu-levi45_*_all.deb"
    INSTALL_CMD="dpkg -i --force-overwrite"
    OSTYPE="DreamOS"
else
    PACKAGE_URL="$GIT_BASE_URL/enigma2-plugin-softcams-oscam-emu-levi45_*_all.ipk"
    INSTALL_CMD="opkg install --force-reinstall --force-overwrite"
    OSTYPE="Enigma2"
fi

echo "Detected OS: $OSTYPE"
echo "Downloading latest package..."

# Download directly with wildcard - GitHub will serve the actual file
wget -q --no-check-certificate "$PACKAGE_URL" -O "/tmp/oscam-latest.${PACKAGE_EXT}"

if [ -f "/tmp/oscam-latest.${PACKAGE_EXT}" ]; then
    echo "Installing..."
    $INSTALL_CMD "/tmp/oscam-latest.${PACKAGE_EXT}"
    rm -f "/tmp/oscam-latest.${PACKAGE_EXT}"
    echo "Installation completed successfully!"
    echo "Please Restart GUI..."
else
    echo "Error: Failed to download package from: $PACKAGE_URL"
    exit 1
fi