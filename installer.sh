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

# Function to get the actual package filename from GitHub
get_package_filename() {
    # Get the raw HTML of the GitHub directory and extract IPK/DEB filenames
    wget -q -O - --no-check-certificate "https://github.com/levi-45/Levi45Emulator/tree/main" | \
    grep -oE 'href="[^"]*\.('"$PACKAGE_EXT"')"' | \
    sed 's/href=".*\///' | sed 's/"//' | \
    grep "enigma2-plugin-softcams-oscam-emu-levi45" | \
    grep "_all\.${PACKAGE_EXT}" | \
    head -n 1
}

echo "Searching for latest package..."
PACKAGE_NAME=$(get_package_filename)

if [ -z "$PACKAGE_NAME" ]; then
    echo "Trying alternative detection method..."
    # Alternative: Try to find by downloading a file list
    PACKAGE_NAME=$(wget -q -O - --no-check-certificate "https://api.github.com/repos/levi-45/Levi45Emulator/contents/" | \
    grep -oE '"name": *"[^"]*"' | \
    cut -d'"' -f4 | \
    grep "enigma2-plugin-softcams-oscam-emu-levi45" | \
    grep "_all\.${PACKAGE_EXT}" | \
    head -n 1)
fi

if [ -n "$PACKAGE_NAME" ]; then
    echo "Found package: $PACKAGE_NAME"
    echo "Downloading..."
    wget -q --no-check-certificate "$GIT_BASE_URL/$PACKAGE_NAME" -O "/tmp/$PACKAGE_NAME"
    
    # Verify it's a valid package file
    if [ -f "/tmp/$PACKAGE_NAME" ]; then
        FILE_TYPE=$(file "/tmp/$PACKAGE_NAME")
        if echo "$FILE_TYPE" | grep -q "Zip archive\|Debian binary package"; then
            echo "Installing..."
            $INSTALL_CMD "/tmp/$PACKAGE_NAME"
            INSTALL_RESULT=$?
            
            # Cleanup
            rm -f "/tmp/$PACKAGE_NAME"
            
            if [ $INSTALL_RESULT -eq 0 ]; then
                echo "Installation completed successfully!"
                echo "Please Restart GUI..."
                exit 0
            else
                echo "Installation failed with error code: $INSTALL_RESULT"
                exit 1
            fi
        else
            echo "Error: Downloaded file is not a valid package!"
            echo "File type: $FILE_TYPE"
            rm -f "/tmp/$PACKAGE_NAME"
            exit 1
        fi
    else
        echo "Error: Failed to download package!"
        exit 1
    fi
else
    echo "Error: No package found for $OSTYPE"
    echo "Available package patterns:"
    echo "IPK: enigma2-plugin-softcams-oscam-emu-levi45_*_all.ipk"
    echo "DEB: enigma2-plugin-softcams-oscam-emu-levi45_*_all.deb"
    exit 1
fi