# Author: José Areia (jose.apareia@gmail.com)
# Date: 2025/01/15
# Version: 1.0.0

PROG_NAME=discord-updater
INSTALL_DIR=/usr/local/bin
SERVICE_DIR=$(HOME)/.config/systemd/user
SCRIPT=$(PROG_NAME).sh
SERVICE=$(PROG_NAME).service
TIMER=$(PROG_NAME).timer
CLR_GREEN=\033[92m
CLR_RED=\033[91m
CLR_RESET=\033[0m

install:
	@echo "[ $(CLR_GREEN)OK$(CLR_RESET) ] Installing $(SCRIPT) to $(INSTALL_DIR)..."
	@sudo install -m 755 $(SCRIPT) $(INSTALL_DIR)/$(PROG_NAME)
	@echo "[ $(CLR_GREEN)OK$(CLR_RESET) ] Installing $(SERVICE) and $(TIMER) to $(SERVICE_DIR)..."
	@mkdir -p $(SERVICE_DIR)
	@install -m 644 $(SERVICE) $(SERVICE_DIR)/$(SERVICE)
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
	@echo "[ $(CLR_GREEN)OK$(CLR_RESET) ] Removing $(SCRIPT) from $(INSTALL_DIR)..."
	@sudo rm -f $(INSTALL_DIR)/$(PROG_NAME)
	@echo "[ $(CLR_GREEN)OK$(CLR_RESET) ] Both program and service were uninstalled."

clean:
	@echo "[ $(CLR_GREEN)OK$(CLR_RESET) ] No build artifacts to clean."

.PHONY: install uninstall clean