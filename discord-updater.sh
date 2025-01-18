#!/bin/bash

function notify-send() {
    # Find the first X socket and ensure it's found.
    local socket=$(ls /tmp/.X11-unix/X* 2>/dev/null | head -n 1)
    if [[ -z "$socket" ]]; then
        echo "No X socket found!"
        return 1
    fi

    # Extract display name, user, and user ID.
    local display=":$(echo $socket | sed 's#/tmp/.X11-unix/X##')"
    local user uid
    read user uid <<< $(stat -c '%U %u' "$socket")

    # Check if stat command succeeded.
    if [[ -z "$user" || -z "$uid" ]]; then
        echo "Failed to extract user and UID from socket."
        return 1
    fi

    # Send notification as the correct user.
    sudo -u "$user" DISPLAY="$display" DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/"$uid"/bus notify-send "$@"
}

# Variables
TEMP_DIR="/tmp"
NAME="Discord Updater"
DISCORD_PATH="/usr/share/discord/resources/build_info.json"
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

if [[ "$installed_version" != "$current_version" ]]; then
    notify-send -a "$NAME" "$NAME" "Updating Discord ($installed_version to $current_version)." --icon=dialog-information
    echo "Installed version ($installed_version) differs from the current version ($current_version)."
    echo "Downloading and updating to version $current_version..."

    file_name="$TEMP_DIR/discord-$current_version.deb"
    if curl -s "$deb_url" -o "$file_name"; then
        # notify-send -a "$NAME" "$NAME" "Installing version $current_version." --icon=dialog-information
        echo "Installing Discord..."
        if dpkg -i "$file_name"; then
            notify-send -u critical -a "$NAME" "$NAME" "Discord updated successfully!" --icon=dialog-ok
            echo "Discord updated successfully."
        else
            notify-send -a "$NAME" "$NAME" "Installation failed. Fixing dependencies." --icon=dialog-error
            echo "Installation failed. Attempting to fix broken dependencies..."
            apt-get -f install -y
        fi
        rm -f "$file_name"
    else
        notify-send -u critical -a "$NAME" "$NAME" "Failed to download Discord package." --icon=dialog-error
        echo "Failed to download Discord package."
    fi
else
    echo "Discord is already up-to-date (version $installed_version)."
fi