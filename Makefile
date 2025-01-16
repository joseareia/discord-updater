# Author: José Areia (jose.apareia@gmail.com)
# Date: 2025/01/15
# Version: 1.0.0

PROG_UPDATER=discord-updater
PROG_CHECKER=discord-version-checker

INSTALL_DIR=$(HOME)/.discord-updater/bin/
SERVICE_DIR=$(HOME)/.config/systemd/user

HOME_PATH=/home/$(SUDO_USER)

SCRIPT_UPDATER=$(PROG_UPDATER).sh
SCRIPT_CHECKER=$(PROG_CHECKER).sh

SERVICE=$(PROG_UPDATER).service
TIMER=$(PROG_UPDATER).timer

CLR_GREEN=\033[92m
CLR_RED=\033[91m
CLR_RESET=\033[0m

config:
	@if [ "$$(id -u)" -ne 0 ]; then \
		echo "[ $(CLR_RED)ERROR$(CLR_RESET) ] Policy configuration requires superuser privileges. Please run 'sudo make'."; \
		exit 1; \
	fi
	@echo "[ $(CLR_GREEN)OK$(CLR_RESET) ] Updating policy file with the correct path."
	@sed "s|HOMEPATH|$(HOME_PATH)|g" com.discord.updater.policy > /tmp/com.discord.updater.policy.tmp && \
	sudo mv /tmp/com.discord.updater.policy.tmp /usr/share/polkit-1/actions/com.discord.updater.policy && \
	echo "[ $(CLR_GREEN)OK$(CLR_RESET) ] Policy file moved to /usr/share/polkit-1/actions."

install:
	@echo "[ $(CLR_GREEN)OK$(CLR_RESET) ] Installing $(SCRIPT_CHECKER) to $(INSTALL_DIR)..."
	@mkdir -p $(INSTALL_DIR)
	@install -m 755 $(SCRIPT_CHECKER) $(INSTALL_DIR)/$(PROG_CHECKER)
	@install -m 755 $(SCRIPT_UPDATER) $(INSTALL_DIR)/$(PROG_UPDATER)

	@echo "[ $(CLR_GREEN)OK$(CLR_RESET) ] Installing $(SERVICE) and $(TIMER) to $(SERVICE_DIR)..."
	@mkdir -p $(SERVICE_DIR)
	@sed "s|HOMEPATH|$(HOME)|g" $(SERVICE) > /tmp/discord-updater.service
	@sed "s|HOMEPATH|$(HOME_PATH)|g" com.discord.updater.policy > /tmp/com.discord.updater.policy.tmp
	@install -m 644 /tmp/discord-updater.service $(SERVICE_DIR)/$(SERVICE)
	@install -m 644 $(TIMER) $(SERVICE_DIR)/$(TIMER)

	@echo "[ $(CLR_GREEN)OK$(CLR_RESET) ] Enabling $(TIMER)..."
	@systemctl --user daemon-reload
	@systemctl --user enable $(TIMER)
	
	@echo "[ $(CLR_GREEN)OK$(CLR_RESET) ] Starting $(TIMER)..."
	@systemctl --user start $(TIMER)
	@echo "[ $(CLR_GREEN)OK$(CLR_RESET) ] Installation completed."

uninstall:
	@echo "[ $(CLR_GREEN)OK$(CLR_RESET) ] Stopping and disabling $(TIMER)..."
	@systemctl --user stop $(TIMER) || true
	@systemctl --user disable $(TIMER) || true

	@echo "[ $(CLR_GREEN)OK$(CLR_RESET) ] Removing $(SERVICE) and $(TIMER) from $(SERVICE_DIR)..."
	@rm -f $(SERVICE_DIR)/$(SERVICE)
	@rm -f $(SERVICE_DIR)/$(TIMER)
	
	@echo "[ $(CLR_GREEN)OK$(CLR_RESET) ] Removing $(SCRIPT_CHECKER) and $(SCRIPT_UPDATER) from $(INSTALL_DIR)..."
	@rm -f $(INSTALL_DIR)/$(PROG_UPDATER)
	@rm -f $(INSTALL_DIR)/$(PROG_CHECKER)
	
	@echo "[ $(CLR_GREEN)OK$(CLR_RESET) ] Removing policy file from /usr/share/polkit-1/actions..."
	@sudo rm -f /usr/share/polkit-1/actions/com.discord.updater.policy
	@echo "[ $(CLR_GREEN)OK$(CLR_RESET) ] All program, service, and policy files were uninstalled."

clean:
	@echo "[ $(CLR_GREEN)OK$(CLR_RESET) ] No build artifacts to clean."