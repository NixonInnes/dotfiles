#!/bin/bash
#
# Script to setup symbolic links in a system to point to associated .dotfiles

# Function to create a link (origin) to a (dotfiles) destination.
# If the link already exists, rename it to {link}-backup
create_link() {
  # Require two arguments; origin & destination
  if [ "$#" -ne 2 ]; then
    echo "Usage: create_symlink <origin> <destination>"
    return 1
  fi

  local orig="$1"
  local dest="$2"
  local orig_bkp="${orig}-backup"

  # Ensure the destination exists
  if [ ! -e "$dest" ]; then
    echo "Error: Destination '$dest' does not exist."
    return 1
  fi
  
  # Rename the origin if it exists
  if [ -e "$orig" ] || [ -L "$orig" ]; then
    echo "Info: '$orig' already exists."
    
    # Check if a backup already exists, and fail if it does
    if [ -e "$orig_bkp" ] || [ -L "$orig_bkp"]; then
      echo "Error: A backup of '$orig' already exists ('$orig_bkp'). Please remove before proceeding."
      return 1
    fi
    
    # Rename origin
    mv "$orig" "$orig_bkp"
    if [ "$?" -ne 0 ]; then
      echo "Error: Failed to rename '$orig' to '$orig_bkp'."
      return 1
    fi

    echo "Info: Renamed '$orig' to '$orig_bkp'."
  fi

  ln -s "$dest" "$orig"
  if [ "$?" -ne 0 ]; then
    echo "Error: Failed to create symbolic link from '$orig' to '$dest'."
    return 1
  fi

  echo "Success: Created symbolic link '$orig' -> '$dest'."
  return 0
}

create_link "${HOME}/.zshrc" "${HOME}/.dotfiles/.zshrc"
create_link "${HOME}/.zsh" "${HOME}/.dotfiles/.zsh"
create_link "${HOME}/.config/nvim" "${HOME}/.dotfiles/.config/nvim"
create_link "${HOME}/.config/alacritty" "${HOME}/.dotfiles/.config/alacritty"

