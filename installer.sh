#!/bin/sh
#### "***********************************************"
#### "*Levi45 https://satellite-forum.com/index.php *"
#### "***********************************************"

GIT_BASE_URL="https://raw.githubusercontent.com/levi-45/Levi45Emulator/main"

# Detect if it's a Dreambox
if [ -f /etc/issue ] && grep -q "dreambox" /etc/issue; then
    IS_DREAMBOX=true
elif [ -f /etc/version ] && grep -q "dreambox" /etc/version; then
    IS_DREAMBOX=true
elif [ -f /etc/model ] && grep -q "dm" /etc/model; then
    IS_DREAMBOX=true
else
    IS_DREAMBOX=false
fi

# Function to extract version number from filename
extract_version() {
    echo "$1" | grep -oE '[0-9]+' | head -1
}

# Function to find latest package file
find_latest_package() {
    # Get the raw file listing from GitHub
    wget -q -O - "https://api.github.com/repos/levi-45/Levi45Emulator/contents/" | \
    grep -oE '"name": *"[^"]+"' | \
    cut -d'"' -f4
    
    # Alternative method using GitHub pages if API has rate limits
    # wget -q -O - "https://levi-45.github.io/Levi45Emulator/" | \
    # grep -oE 'href="[^"]*(ipk|deb)"' | \
    # cut -d'"' -f2
}

# Find available packages
echo "Searching for available packages..."
AVAILABLE_FILES=$(find_latest_package)

if [ "$IS_DREAMBOX" = true ]; then
    # Dreambox - look for deb packages
    echo "Dreambox detected, looking for deb packages..."
    
    # Filter deb files and find the latest version
    LATEST_DEB=""
    LATEST_VERSION=0
    
    for file in $AVAILABLE_FILES; do
        if echo "$file" | grep -q "\.deb$" && echo "$file" | grep -q "oscam-emu"; then
            VERSION=$(extract_version "$file")
            if [ "$VERSION" -gt "$LATEST_VERSION" ]; then
                LATEST_VERSION=$VERSION
                LATEST_DEB=$file
            fi
        fi
    done
    
    if [ -n "$LATEST_DEB" ]; then
        echo "Found latest deb package: $LATEST_DEB"
        echo "Downloading..."
        wget -q --no-check-certificate "$GIT_BASE_URL/$LATEST_DEB" -O "/tmp/$LATEST_DEB"
        
        echo "Installing deb package..."
        dpkg -i --force-overwrite "/tmp/$LATEST_DEB"
        
        # Cleanup
        rm -f "/tmp/$LATEST_DEB"
    else
        echo "Error: No deb packages found on GitHub!"
        exit 1
    fi
    
else
    # Normal Enigma2 box - look for ipk packages
    echo "Enigma2 box detected, looking for ipk packages..."
    
    # Filter ipk files and find the latest version
    LATEST_IPK=""
    LATEST_VERSION=0
    
    for file in $AVAILABLE_FILES; do
        if echo "$file" | grep -q "\.ipk$" && echo "$file" | grep -q "oscam-emu"; then
            VERSION=$(extract_version "$file")
            if [ "$VERSION" -gt "$LATEST_VERSION" ]; then
                LATEST_VERSION=$VERSION
                LATEST_IPK=$file
            fi
        fi
    done
    
    if [ -n "$LATEST_IPK" ]; then
        echo "Found latest ipk package: $LATEST_IPK"
        echo "Downloading..."
        wget -q --no-check-certificate "$GIT_BASE_URL/$LATEST_IPK" -O "/tmp/$LATEST_IPK"
        
        echo "Installing ipk package..."
        opkg install --force-reinstall --force-overwrite "/tmp/$LATEST_IPK"
        
        # Cleanup
        rm -f "/tmp/$LATEST_IPK"
    else
        echo "Error: No ipk packages found on GitHub!"
        exit 1
    fi
fi

echo "Installation completed successfully!"
echo "Please Restart GUI..."
exit