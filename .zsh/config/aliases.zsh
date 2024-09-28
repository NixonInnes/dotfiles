#!/bin/zsh
#

# Use the ID to help define distro specific aliases
source /etc/os-release

# General Aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias cp="cp -i" 
alias df='df -h'                                                # Human-readable sizes
alias free='free -m'                                            # Show sizes in MB
alias gitu='git add . && git commit && git push'
alias ldock='lazydocker'
alias lgit='lazygit'
alias reload='. $HOME/.zshrc'

# Distro Specific Aliases
if [ "$ID" = "ubuntu" ]; then
  echo "Using Ubuntu aliases"
  alias aptup='sudo apt update;sudo apt upgrade'
  alias cat='batcat'
  alias fd='fdfind'
  alias ls='exa'
  alias l='exa'
  alias la='exa -a'
  alias ll='exa -la'
  alias tree='exa --tree'
elif [ "$ID" = "manjaro" ]; then
  echo "Using Manjaro aliases"
  alias cat='bat'
  alias ls='eza'
  alias l='eza'
  alias la='eza -a'
  alias ll='eza -la'
  alias tree='eza --tree'
fi

