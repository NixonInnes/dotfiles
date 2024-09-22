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



fzfw() {
  # Check if at least one argument is provided
  if [[ $# -eq 0 ]]; then
    echo "Usage: fzfw <search_pattern>"
    return 1
  fi

  # Combine all arguments into a single search pattern
  local pattern="$*"
  local selected
  
  selected=$(rg --line-number --column --color=always "$pattern" | \
        fzf --height 40% --layout=reverse --ansi --preview-window 'right:60%' --preview '
            filename=$(echo {} | cut -d: -f1)
            line=$(echo {} | cut -d: -f2)

            # Get total number of lines in the file
            total=$(wc -l < "$filename")

            # Get the total number of lines in the terminal
            term_lines=$(tput lines)

            # Calculate preview window height based on fzfs preview-window percentage (60%)
            preview_height=$(( (term_lines * 40) / 100 ))

            # Calculate context lines (half of the preview window height)
            context=$(( (preview_height / 2) - 1 ))

            # Calculate start and end lines, ensuring they stay within file bounds
            start=$(( line - context ))
            if [ "$start" -lt 1 ]; then
                start=1
            fi

            end=$(( line + context ))
            if [ "$end" -gt "$total" ]; then
                end="$total"
            fi

            # Display the subset of lines with batcat, highlighting the matched line
            batcat --color=always --style=numbers,changes --line-range="$start":"$end" --highlight-line="$line" "$filename"
        ')

  # Check if a selection was made
  if [[ -n "$selected" ]]; then
    # Extract file path and line number from the selected line
    local file line
    file=$(echo "$selected" | cut -d: -f1)
    line=$(echo "$selected" | cut -d: -f2)

    # Open the selected file in Neovim at the specified line
    nvim +"$line" "$file"
  fi
}


# Add this function to your shell configuration file (~/.bashrc or ~/.zshrc)
fzfd() {
  # Set default depth
  local depth=0

  # If a depth argument is provided, validate it
  if [[ -n "$1" ]]; then
    if [[ "$1" =~ ^[0-9]+$ ]]; then
      depth="$1"
    else
      echo "Usage: fcd [depth]" >&2
      echo "       depth must be a non-negative integer." >&2
      return 1
    fi
  fi

  # Use fd to list directories, limit depth if specified
  local dirs
  if [[ "$depth" -gt 0 ]]; then
    dirs=$(fd --type d --hidden --follow --max-depth "$depth" . | sort -u)
  else
    dirs=$(fd --type d --hidden --follow . | sort -u)
  fi

  # Check if any directories were found
  if [[ -z "$dirs" ]]; then
    echo "No directories found." >&2
    return 1
  fi

  # Use fzf to select a directory
  local selected_dir
  selected_dir=$(echo "$dirs" | fzf --height=40% --layout=reverse --prompt="Select directory: ")

  # If a directory was selected, change to it
  if [[ -n "$selected_dir" ]]; then
    cd "$selected_dir" || {
      echo "Error: Failed to change directory to '$selected_dir'." >&2
      return 1
    }
  else
    echo "No directory selected." >&2
    return 1
  fi

  return 0
}



