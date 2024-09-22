#!/bin/bash

echo "Starting package installation script..."

# Universal packages to install across all distributions
UNIVERSAL_PACKAGES=(zsh git ripgrep curl bat unzip fzf)

# Distro-specific packages
declare -A DISTRO_SPECIFIC_PACKAGES

DISTRO_SPECIFIC_PACKAGES=(
    ["ubuntu"]="build-essential python3-venv fd-find"
    ["debian"]="build-essential python3-venv fd-find"
    ["arch"]="base-devel fd"  # venv is included with python
    ["manjaro"]="base-devel fd"  # venv is included with python
    ["fedora"]="@development-tools python3-venv fd-find"
    ["opensuse"]="patterns-devel_basis python3-venv fd"
    ["suse"]="patterns-devel_basis python3-venv fd"
    ["centos"]="Development Tools python3-venv fd-find"
)

# Function to detect the Linux distribution
detect_distro() {
    if [ -f /etc/os-release ]; then
        # shellcheck disable=SC1091
        . /etc/os-release
        echo "$ID"
    else
        echo "unknown"
    fi
}

# Installation functions
install_apt() {
    echo "Using apt to install packages..."
    sudo apt update
    sudo apt install -y "${UNIVERSAL_PACKAGES[@]}" 
    sudo apt install -y ${DISTRO_SPECIFIC_PACKAGES[$DISTRO]}
}

install_pacman() {
    echo "Using pacman to install packages..."
    sudo pacman -Syu --noconfirm
    sudo pacman -S --noconfirm "${UNIVERSAL_PACKAGES[@]}" ${DISTRO_SPECIFIC_PACKAGES[$DISTRO]}
}

install_dnf() {
    echo "Using dnf to install packages..."
    sudo dnf check-update
    sudo dnf install -y "${UNIVERSAL_PACKAGES[@]}" ${DISTRO_SPECIFIC_PACKAGES[$DISTRO]}
}

install_zypper() {
    echo "Using zypper to install packages..."
    sudo zypper refresh
    sudo zypper install -y "${UNIVERSAL_PACKAGES[@]}" ${DISTRO_SPECIFIC_PACKAGES[$DISTRO]}
}

install_yum() {
    echo "Using yum to install packages..."
    sudo yum check-update
    sudo yum groupinstall -y "${DISTRO_SPECIFIC_PACKAGES[$DISTRO]}"
    sudo yum install -y "${UNIVERSAL_PACKAGES[@]}"
}

# Detect the distribution
DISTRO=$(detect_distro)

echo "Detected Linux distribution: $DISTRO"

# Install packages based on the distribution
case "$DISTRO" in
    ubuntu|debian)
        install_apt
        ;;
    arch|manjaro)
        install_pacman
        ;;
    fedora)
        install_dnf
        ;;
    opensuse|suse)
        install_zypper
        ;;
    centos)
        install_yum
        ;;
    *)
        echo "Unsupported Linux distribution: $DISTRO"
        exit 1
        ;;
esac

echo "Package installation script completed."

