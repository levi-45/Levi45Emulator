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

# Function to find latest package file
find_latest_package() {
    wget -q -O - "https://api.github.com/repos/levi-45/Levi45Emulator/contents/" | \
    grep -oE '"name": *"[^"]+"' | \
    cut -d'"' -f4
}

# Function to extract version number from filename
extract_version() {
    echo "$1" | grep -oE '[0-9]+' | head -1
}

echo "Searching for latest $PACKAGE_EXT package..."
AVAILABLE_FILES=$(find_latest_package)

LATEST_PACKAGE=""
LATEST_VERSION=0

for file in $AVAILABLE_FILES; do
    if echo "$file" | grep -q "\.${PACKAGE_EXT}$" && echo "$file" | grep -q "oscam-emu"; then
        VERSION=$(extract_version "$file")
        if [ "$VERSION" -gt "$LATEST_VERSION" ]; then
            LATEST_VERSION=$VERSION
            LATEST_PACKAGE=$file
        fi
    fi
done

if [ -n "$LATEST_PACKAGE" ]; then
    echo "Found latest package: $LATEST_PACKAGE"
    echo "Downloading..."
    wget -q --no-check-certificate "$GIT_BASE_URL/$LATEST_PACKAGE" -O "/tmp/$LATEST_PACKAGE"
    
    echo "Installing..."
    $INSTALL_CMD "/tmp/$LATEST_PACKAGE"
    
    # Cleanup
    rm -f "/tmp/$LATEST_PACKAGE"
    echo "$OSTYPE package installed successfully!"
else
    echo "Error: No $PACKAGE_EXT packages found on GitHub!"
    exit 1
fi

echo "Installation completed successfully!"
echo "Please Restart GUI..."
exit