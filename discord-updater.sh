#!/bin/bash

# Variables.
DISCORD_PATH="/usr/share/discord/resources/build_info.json"
TEMP_DIR="/tmp"
DOWNLOAD_URL="https://discord.com/api/download/stable?platform=linux&format=deb"

# Check if Discord is installed and get the installed version.
if [ -f "$DISCORD_PATH" ]; then
    installed_version=$(jq -r ".version" < "$DISCORD_PATH")
else
    installed_version=""
fi

# Get the latest version from Discord's server.
deb_url=$(curl -s -I "$DOWNLOAD_URL" | grep -i "location:" | awk -F': ' '{print $2}' | tr -d '\r\n')
current_version=$(basename "$deb_url" | sed 's/^discord-\(.*\).deb/\1/')

# Compare versions and update if necessary.
if [[ "$installed_version" != "$current_version" ]]; then
    notify-send -a "Discord Updater" "Discord Updater" "Updating Discord ($current_version)." --icon=dialog-information
    echo "Installed version ($installed_version) differs from the current version ($current_version)."
    echo "Downloading and updating to version $current_version..."

    file_name="$TEMP_DIR/discord-$current_version.deb"
    if curl -s "$deb_url" -o "$file_name"; then
        notify-send -a "Discord Updater" "Discord Updater" "Updating Discord..." --icon=dialog-information
        echo "Installing Discord..."
        if sudo dpkg -i "$file_name"; then
            notify-send -a "Discord Updater" "Discord Updater" "Discord updated successfully!" --icon=dialog-ok
            echo "Discord updated successfully."
        else
            notify-send -a "Discord Updater" "Discord Updater" "Installation failed. Fixing dependencies..." --icon=dialog-error
            echo "Installation failed. Attempting to fix broken dependencies..."
            sudo apt-get -f install -y
        fi
        rm -f "$file_name"
    else
        notify-send -a "Discord Updater" "Discord Updater" "Failed to download Discord package." --icon=dialog-error
        echo "Failed to download Discord package."
    fi
else
    notify-send -a "Discord Updater" "Discord Updater" "Discord is already up-to-date." --icon=dialog-information
    echo "Discord is already up-to-date (version $installed_version)."
fi