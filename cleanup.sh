#!/bin/bash
# Clean up script by regplayz

gum style --border double --margin "1" --padding "1" --border-foreground "cyan" --foreground "magenta" "Starting System Cleanup..."

sleep 1
clear
install_platform="$(cat ~/.config/ml4w/settings/platform.sh)"
figlet -f smslant "Cleanup"
echo

# ------------------------------------------------------
# Confirm Start
# ------------------------------------------------------

gum confirm "DO YOU WANT TO START THE CLEANUP NOW?" && echo ":: Cleanup started." || { echo ":: Cleanup canceled."; exit; }

# Check if platform is supported
case $install_platform in
    arch)
        aur_helper="$(cat ~/.config/ml4w/settings/aur.sh)"

        # Clear Pacman cache
        echo "Cleaning Pacman cache..."
        sudo pacman -Sc --noconfirm

        # Remove orphaned packages
        echo "Removing orphaned packages..."
        sudo pacman -Rns $(pacman -Qdtq) --noconfirm || echo "No orphans to remove."

        # Clean logs
        echo "Clearing system logs..."
        sudo journalctl --vacuum-time=7d  # Keep only the last 7 days

        # Selectively clear user cache, but **exclude** pywal's cache directory
        echo "Clearing selected user cache (excluding pywal)..."
        
        # Example of clearing specific cache files or directories
        # You can add or remove directories here as needed
        rm -rf ~/.cache/thumbnails/*
        rm -rf ~/.cache/mozilla/firefox/*  # Example: Firefox cache

        # Remove unnecessary AUR build files
        echo "Cleaning AUR build cache..."
        rm -rf ~/.cache/yay/*

        # Clear temp files
        echo "Clearing temporary files..."
        sudo rm -rf /tmp/*

        # Empty Trash
        echo "Emptying Trash..."
        rm -rf ~/.local/share/Trash/*
        
        ;;
    fedora)
        sudo dnf clean all
        ;;
    *)
        echo ":: ERROR - Platform not supported"
        echo "Press [ENTER] to close."
        read
        ;;
esac

notify-send "Cleanup complete"

echo
gum style --border double --margin "1" --padding "1" --border-foreground "green" --foreground "yellow" "Cleanup Complete! System storage has been freed up."
echo
echo "Press [ENTER] to close."
read

