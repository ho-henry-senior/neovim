# Validate config by loading full plugins in headless mode
check:
	#!/usr/bin/env bash
	set -euo pipefail
	echo "Validating Neovim config (including plugins)..."
	OUTPUT=$(nvim --headless -c "lua vim.print('NVIM_CONFIG_OK')" -c "quitall!" 2>&1)
	if echo "$OUTPUT" | grep -q "NVIM_CONFIG_OK"; then
		echo "✓ Config and plugins are valid"
	else
		echo "✗ Config validation did not complete:"
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

	check_file() {
		local label="$1"
		local path="$2"
		local required="${3:-required}"

		if [[ -x "$path" ]]; then
			printf "  ✓ %s\n" "$label"
		elif [[ "$required" == "required" ]]; then
			printf "  ✗ %s\n" "$label"
			missing_required=1
		else
			printf "  ! %s\n" "$label"
		fi
	}

	check_tool_or_file() {
		local name="$1"
		local path="$2"
		local required="${3:-required}"

		if command -v "$name" >/dev/null 2>&1 || [[ -x "$path" ]]; then
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
	check_tool_or_file roslyn-language-server "$HOME/.dotnet/tools/roslyn-language-server" optional
	check_tool_or_file csharpier "$HOME/.dotnet/tools/csharpier" optional

	echo
	echo "Optional workflows"
	check_tool lazygit optional
	check_tool hunk optional
	check_tool terraform-ls optional
	check_tool terraform optional
	check_tool harper-ls optional
	check_tool dotnet optional
	check_tool vscode-eslint-language-server optional

	if [[ -f package.json ]]; then
		echo
		echo "Project-local Node tools"
		check_file eslint node_modules/.bin/eslint optional
		check_file jest node_modules/.bin/jest optional
		check_file mocha node_modules/.bin/mocha optional
	fi

	if [[ "$missing_required" -ne 0 ]]; then
		echo
		echo "Missing required tools"
		exit 1
	fi

	echo
	echo "Required tools available"

profile:
	#!/usr/bin/env bash
	set -euo pipefail
	PROFILE_DIR="${TMPDIR:-/tmp}/nvim-profile"
	PROFILE="$PROFILE_DIR/startuptime.log"
	mkdir -p "$PROFILE_DIR/state"
	: > "$PROFILE"
	export NVIM_LOG_FILE="$PROFILE_DIR/nvim.log"
	export XDG_STATE_HOME="$PROFILE_DIR/state"
	echo "Writing Neovim startup profile to $PROFILE..."
	nvim --headless --startuptime "$PROFILE" --cmd "set shadafile=NONE" -c "quitall!"
	echo "✓ Startup profile written"

lazy-check:
	#!/usr/bin/env bash
	set -euo pipefail

	TEST_DIR="${TMPDIR:-/tmp}/nvim-lazy-check"
	mkdir -p "$TEST_DIR/state"

	run_nvim() {
		NVIM_LOG_FILE="$TEST_DIR/nvim.log" \
		XDG_STATE_HOME="$TEST_DIR/state" \
		nvim --headless --cmd "set shadafile=NONE" "$@"
	}

	assert_output() {
		local label="$1"
		local expected="$2"
		shift 2
		local output

		output="$(run_nvim "$@" 2>&1)"
		if [[ "$output" == *"$expected"* ]]; then
			printf "  ✓ %s\n" "$label"
		else
			printf "  ✗ %s\n" "$label"
			printf "Expected output containing: %s\n" "$expected"
			printf "Actual output:\n%s\n" "$output"
			exit 1
		fi
	}

	LUA_FILE="$TEST_DIR/lazy-check.lua"
	printf 'local value={a=1,b=2}\n' > "$LUA_FILE"

	echo "Checking lazy-loading lifecycle assumptions..."
	assert_output "conform stays unloaded on empty startup" "false" \
		-c "lua vim.print(package.loaded['conform'] ~= nil)" \
		-c "quitall!"
	assert_output "gitsigns setup is active on empty startup" "true" \
		-c "lua vim.print(require('gitsigns.config').config.current_line_blame)" \
		-c "quitall!"
	assert_output "opening a Lua file loads conform" "true" \
		"$LUA_FILE" \
		-c "lua vim.print(package.loaded['conform'] ~= nil)" \
		-c "quitall!"
	assert_output "opening a Lua file sets up gitsigns" "true" \
		"$LUA_FILE" \
		-c "lua vim.print(require('gitsigns.config').config.current_line_blame)" \
		-c "quitall!"
	assert_output "SessionLoadPost loads conform" "true" \
		-c "doautocmd SessionLoadPost" \
		-c "lua vim.print(package.loaded['conform'] ~= nil)" \
		-c "quitall!"
	echo "✓ Lazy-loading checks passed"

fmt:
	@echo "Formatting Lua files..."
	@stylua .
	@echo "✓ Formatting complete"

fmt-check:
	@echo "Checking code formatting..."
	@stylua --check .
	@echo "✓ Formatting valid!"

validate: check lazy-check fmt-check
