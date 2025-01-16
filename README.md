# Discord Updater
[![made-with-bash](https://img.shields.io/badge/Made%20with-Bash-1f425f.svg?color=green)](https://www.lua.org/)
[![GitHub license](https://img.shields.io/badge/License-GPL_3.0-green.svg)](https://www.gnu.org/licenses/gpl-3.0.html#license-text)
[![Release](https://img.shields.io/badge/Release-v1.1.0-green.svg)](https://github.com/joseareia/discord-updater/releases)
[![Maintenance](https://img.shields.io/badge/Maintained%3F-Yes-green.svg)](https://github.com/joseareia/discord-updater/graphs/commit-activity)

An auto-updater script for Discord with Systemd Service and Timer integration for seamless, automatic updates.

## Why?
If you’ve installed [Discord](https://discord.com) on Linux via a Debian package, you know it doesn’t update automatically. Who wants to manually download and install new versions all the time?

To solve this, I created a simple [Bash](https://github.com/joseareia/discord-updater/blob/master/discord-updater.sh) script that checks if your installed version of Discord matches the latest version available on their website. If they differ, the script will automatically update Discord for you.

Additionally, a `systemd` service ensures that the script runs every time you log in, checking for updates. If an update is available, you'll see a graphical notification informing you that Discord is either up-to-date or outdated, and the update will be installed. Afterward, you'll get another notification, and you can open Discord safely!

## Dependecies

This project requires the following utilities (_though they may already be installed on your system_):

```bash
sudo apt install curl jq make libnotify-bin
```

## Installation

Follow these steps to install and configure the utility:

#### 1. Download the Latest Release
Visit the [releases page](https://github.com/joseareia/discord-updater/releases) to download the most recent version of the utility.

#### 2. Update Your `$PATH`
Add the installation directory to your `$PATH` by running the following commands in your terminal:

```bash
echo 'export PATH="$HOME/.discord-updater/bin/:$PATH"' >> $HOME/.bashrc
source $HOME/.bashrc
```

#### 3. System Configuration
Configure your system and set up a policy to request a password each time there is a new update. Use the following command (requires `sudo` privileges):

```bash
sudo make
```

#### 4. Install the Utility
Complete the installation process **without requiring `sudo` or superuser privileges:**

```bash
make install
```

#### 5. Post-Installation Setup
After installation, the following will be ready to use:

- **Utilities**: `discord-updater` and `discord-version-checker` are available system-wide.
- **System Services**: A new `systemd` service and timer are configured to automate updates.
- **Policy Setup**: A `polkit` action policy is created for secure update handling.

#### 6. Cleanup
Once the installation is complete, you can safely remove the downloaded release file.

## Additional Configurations

If you wish to modify the utility, edit the `discord-updater.sh` file, then follow the installation steps again.

>[!TIP]
>If you prefer not to be prompted to enter your password every time a new update is available, edit the `com.discord.updater.policy` file. Set both `allow_any` and `allow_inactive` to `yes`. After making these changes, run `sudo make` again.

If you desire to unninstall the utility, you can simply run:

```bash
make uninstall
```
This will remove the `discord-updater` utility, as well as the associated `systemd` service and timer.

## Getting Help
If you have any questions, encounter issues, or need assistance, feel free to open an issue on this repository or contact me via email at <a href="mailto:jose.apareia@gmail.com">jose.apareia@gmail.com</a>.

## Contributing
Contributions are welcome! If you find bugs, have suggestions, or would like to add new features, feel free to submit a pull request. I appreciate your feedback and contributions to improve this utility.

## License
This project is under the [GPL 3.0](https://www.gnu.org/licenses/gpl-3.0.html#license-text) license.