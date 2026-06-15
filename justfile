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

doctor:
	#!/usr/bin/env bash
	set -euo pipefail

	missing_required=0

	check_tool() {
		local name="$1"
		local required="${2:-required}"

		if command -v "$name" >/dev/null 2>&1; then
			printf "  ✓ %s\n" "$name"
		elif [[ "$required" == "required" ]]; then
			printf "  ✗ %s\n" "$name"
			missing_required=1
		else
			printf "  ! %s\n" "$name"
		fi
	}

	echo "Core"
	check_tool nvim
	check_tool rg
	check_tool fd
	check_tool tree-sitter
	check_tool stylua
	check_tool node
	check_tool python

	echo
	echo "Language servers and formatters"
	check_tool lua-language-server
	check_tool bash-language-server
	check_tool vscode-css-language-server
	check_tool vscode-html-language-server
	check_tool vscode-json-language-server
	check_tool typescript-language-server
	check_tool yaml-language-server
	check_tool pyright-langserver
	check_tool ruff
	check_tool marksman
	check_tool prettier

	echo
	echo "Optional workflows"
	check_tool lazygit optional
	check_tool terraform-ls optional
	check_tool terraform optional
	check_tool harper-ls optional
	check_tool dotnet optional
	check_tool csharp-ls optional
	check_tool eslint optional
	check_tool vscode-eslint-language-server optional
	check_tool jest optional
	check_tool mocha optional

	if [[ "$missing_required" -ne 0 ]]; then
		echo
		echo "Missing required tools"
		exit 1
	fi

	echo
	echo "Required tools available"

fmt:
	@echo "Formatting Lua files..."
	@stylua .
	@echo "✅ Formatting complete"

fmt-check:
	@echo "Checking code formatting..."
	@stylua --check .
	@echo "✅ Formatting valid!"

validate: check fmt-check
