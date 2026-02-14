#!/usr/bin/env bash
# ==============================================
# Ubuntu Installation Script for common apps
# This script installs Obsidian and VS Code via snap
# ==============================================

set -euo pipefail   # Exit on error, unset vars, and fail on pipe errors
IFS=$'\n\t'         # Safe handling of spaces in filenames

# Function to check if snap is installed
check_snap() {
    if ! command -v snap >/dev/null 2>&1; then
        echo "Snap is not installed. Installing snapd..."
        sudo apt update
        sudo apt install -y snapd
    fi
}

# Function to install a snap package if not already installed
install_snap() {
    local package=$1
    local classic_flag=${2:-""}

    if snap list | grep -q "^$package "; then
        echo "$package is already installed."
    else
        echo "Installing $package..."
        sudo snap install "$package" $classic_flag
    fi
}

# Ensure snap is available
check_snap

# Install apps
install_snap obsidian --classic
install_snap code --classic

echo "All installations complete."
