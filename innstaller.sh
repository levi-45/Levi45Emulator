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
    PACKAGE_PREFIX="enigma2-plugin-softcams-oscam-emu-levi45"
else
    PACKAGE_EXT="ipk"  
    INSTALL_CMD="opkg install --force-reinstall --force-overwrite"
    OSTYPE="Enigma2"
    PACKAGE_PREFIX="enigma2-plugin-softcams-oscam-emu-levi45"
fi

echo "Detected OS: $OSTYPE"

# Function to extract version number from filename - FIXED for BusyBox
extract_version() {
    echo "$1" | grep -oE '[0-9]+' | head -n 1
}

# Try to get file list from GitHub (simplified approach)
echo "Searching for latest $PACKAGE_EXT package..."

# Since GitHub API might be problematic, we'll try a direct approach
# List of possible versions (you can extend this list)
VERSIONS="11889 11888 11887 11886"

LATEST_PACKAGE=""
LATEST_VERSION=0

for version in $VERSIONS; do
    TEST_PACKAGE="${PACKAGE_PREFIX}_${version}-803_all.${PACKAGE_EXT}"
    # Check if file exists by trying to download it
    if wget -q --spider --no-check-certificate "$GIT_BASE_URL/$TEST_PACKAGE" 2>/dev/null; then
        if [ "$version" -gt "$LATEST_VERSION" ]; then
            LATEST_VERSION=$version
            LATEST_PACKAGE=$TEST_PACKAGE
        fi
    fi
done

if [ -n "$LATEST_PACKAGE" ]; then
    echo "Found latest package: $LATEST_PACKAGE"
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
    # Fallback to hardcoded version if auto-detection fails
    echo "Auto-detection failed, using fallback version..."
    FALLBACK_PACKAGE="${PACKAGE_PREFIX}_11889-803_all.${PACKAGE_EXT}"
    echo "Trying fallback: $FALLBACK_PACKAGE"
    
    wget -q --no-check-certificate "$GIT_BASE_URL/$FALLBACK_PACKAGE" -O "/tmp/$FALLBACK_PACKAGE"
    
    if [ -f "/tmp/$FALLBACK_PACKAGE" ]; then
        echo "Installing..."
        $INSTALL_CMD "/tmp/$FALLBACK_PACKAGE"
        rm -f "/tmp/$FALLBACK_PACKAGE"
        echo "$OSTYPE package installed successfully!"
    else
        echo "Error: No $PACKAGE_EXT packages found on GitHub!"
        exit 1
    fi
fi

echo "Installation completed successfully!"
echo "Please Restart GUI..."
exit