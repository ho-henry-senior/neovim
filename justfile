# Validate config by loading full plugins in headleass mode
check:
	#!/usr/bin/env bash
	set -euo pipefail
	echo "🔍 Validating Neovim config (including plugins)..."
	OUTPUT=$(nvim --headless -c "lua vim.print('NVIM_CONFIG_OK')" -c "quitall!" 2>&1)
	if echo "$OUTPUT" | grep -q "NVIM_CONFIG_OK"; then
		echo "✅ Config and plugins are valid"
	else
		echo "❌ Config validation did not complete:"
		echo "$OUTPUT"
		exit 1
	fi

fmt:
	@echo "Formatting Lua files..."
	@stylua .
	@echo "✅ Formatting complete"

fmt-check:
	@echo "Checking code formatting..."
	@stylua --check .
	@echo "✅ Formatting valid!"

validate: check fmt-check
