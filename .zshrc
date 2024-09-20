#!/bin/zsh

# PATH extensions
export PATH="$HOME/.local/bin:$PATH"

# Locations
ZSH="$HOME/.zsh"
ZSH_CACHE_DIR="$HOME/.cache/zsh"
ZSH_CONF_DIR="$ZSH/config"
ZSH_FPATH_DIR="$ZSH/fpath"
ZSH_PLUGINS_DIR="$ZSH/plugins"


## Options 
setopt correct                                                  # Auto correct mistakes
setopt extendedglob                                             # Extended globbing. Allows using regular expressions with *
setopt nocaseglob                                               # Case insensitive globbing
setopt rcexpandparam                                            # Array expension with parameters
setopt nocheckjobs                                              # Don't warn about running processes when exiting
setopt numericglobsort                                          # Sort filenames numerically when it makes sense
setopt nobeep                                                   # No beep
setopt appendhistory                                            # Immediately append history instead of overwriting
setopt histignorealldups                                        # If a new command is a duplicate, remove the older one
setopt autocd                                                   # if only directory path is entered, cd there.
setopt inc_append_history                                       # save commands are added to the history immediately, otherwise only when shell exits.
setopt histignorespace                                          # Don't save commands that start with space

ZSH_CONFIG_FILES=(
  "$ZSH_CONF_DIR/completions.zsh"
  "$ZSH_CONF_DIR/keybinds.zsh"
  "$ZSH_CONF_DIR/aliases.zsh"
  "$ZSH_CONF_DIR/appearance.zsh"
  "$ZSH_CONF_DIR/plugins.zsh"
  "$ZSH_CONF_DIR/terminal.zsh"
  "$ZSH_CONF_DIR/apps.zsh"
  "$ZSH_CONF_DIR/prompt.zsh"
)

source_config_files() {
  for config_file in "${ZSH_CONFIG_FILES[@]}"; do
    if [[ -f "$config_file" ]]; then
      source "$config_file"
    else
      print "Warning: Configuration file not found: $config_file"
    fi
  done
}

source_config_files

export LS_OPTIONS='--color=auto'
eval "$(dircolors -b)"
alias ls='ls $LS_OPTIONS'
