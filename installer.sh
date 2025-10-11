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

# Function to extract version number from filename - FIXED for BusyBox
extract_version() {
    echo "$1" | grep -oE '[0-9]+' | head -n 1
}

# Function to find latest package file - SIMPLIFIED approach
find_latest_package() {
    # Simple pattern matching for your specific file naming convention
    if [ "$PACKAGE_EXT" = "ipk" ]; then
        LATEST_FILE="enigma2-plugin-softcams-oscam-emu-levi45_11889-803_all.ipk"
    else
        LATEST_FILE="enigma2-plugin-softcams-oscam-emu-levi45_11889-803_all.deb"
    fi
    echo "$LATEST_FILE"
}

echo "Searching for latest $PACKAGE_EXT package..."
LATEST_PACKAGE=$(find_latest_package)

if [ -n "$LATEST_PACKAGE" ]; then
    echo "Found package: $LATEST_PACKAGE"
    echo "Downloading..."
    wget -q --no-check-certificate "$GIT_BASE_URL/$LATEST_PACKAGE" -O "/tmp/$LATEST_PACKAGE"
    
    if [ -f "/tmp/$LATEST_PACKAGE" ]; then
        echo "Installing..."
        $INSTALL_CMD "/tmp/$LATEST_PACKAGE"
        
        # Cleanup
        rm -f "/tmp/$LATEST_PACKAGE"
        echo "$OSTYPE package installed successfully!"
    else
        echo "Error: Failed to download package!"
        exit 1
    fi
else
    echo "Error: No $PACKAGE_EXT packages found!"
    exit 1
fi

echo "Installation completed successfully!"
echo "Please Restart GUI..."
exit