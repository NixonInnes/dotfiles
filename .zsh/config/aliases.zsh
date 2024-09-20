#!/bin/zsh

alias aptup='sudo apt update;sudo apt upgrade'

alias cp="cp -i"                                                # Confirm before overwriting something
alias df='df -h'                                                # Human-readable sizes
alias free='free -m'                                            # Show sizes in MB
alias gitu='git add . && git commit && git push'
alias reload='. $HOME/.zshrc'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias ls='ls --color=tty'
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -la'

