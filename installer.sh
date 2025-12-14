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
else
    PACKAGE_EXT="ipk"  
    INSTALL_CMD="opkg install --force-reinstall --force-overwrite"
    OSTYPE="Enigma2"
fi

# UPDATE THIS VERSION NUMBER WHEN YOU RELEASE NEW VERSIONS
CURRENT_VERSION="11907"

PACKAGE_NAME="enigma2-plugin-softcams-oscam-emu-levi45_${CURRENT_VERSION}-803_all.${PACKAGE_EXT}"

echo "Detected OS: $OSTYPE"
echo "Downloading version $CURRENT_VERSION..."

wget -q --no-check-certificate "$GIT_BASE_URL/$PACKAGE_NAME" -O "/tmp/$PACKAGE_NAME"

if [ -f "/tmp/$PACKAGE_NAME" ]; then
    echo "Installing..."
    $INSTALL_CMD "/tmp/$PACKAGE_NAME"
    rm -f "/tmp/$PACKAGE_NAME"
    echo "Installation completed successfully!"
    echo "Please Restart GUI..."
else
    echo "Error: Failed to download package: $PACKAGE_NAME"
    echo "Please check if the file exists on GitHub:"
    echo "$GIT_BASE_URL/$PACKAGE_NAME"
    exit 1
fi
