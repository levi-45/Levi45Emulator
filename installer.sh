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

echo "Detected OS: $OSTYPE"

# Get directory listing and find the matching package
echo "Searching for latest package..."

# Get raw directory listing from GitHub
PACKAGE_LIST=$(wget -q -O - --no-check-certificate "https://api.github.com/repos/levi-45/Levi45Emulator/contents/" | grep -o '"name": *"[^"]*'"$PACKAGE_EXT"'"' | cut -d'"' -f4)

# Find the oscam package for our architecture
PACKAGE_NAME=$(echo "$PACKAGE_LIST" | grep "enigma2-plugin-softcams-oscam-emu-levi45.*_all.${PACKAGE_EXT}" | head -n 1)

if [ -n "$PACKAGE_NAME" ]; then
    echo "Found package: $PACKAGE_NAME"
    echo "Downloading..."
    wget -q --no-check-certificate "$GIT_BASE_URL/$PACKAGE_NAME" -O "/tmp/$PACKAGE_NAME"
    
    if [ -f "/tmp/$PACKAGE_NAME" ]; then
        echo "Installing..."
        $INSTALL_CMD "/tmp/$PACKAGE_NAME"
        
        # Cleanup
        rm -f "/tmp/$PACKAGE_NAME"
        echo "Installation completed successfully!"
        echo "Please Restart GUI..."
    else
        echo "Error: Failed to download package!"
        exit 1
    fi
else
    echo "Error: No package found for $OSTYPE"
    echo "Available files:"
    echo "$PACKAGE_LIST"
    exit 1
fi