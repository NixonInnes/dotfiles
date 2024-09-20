# vim:ft=zsh ts=2 sw=2 sts=2
#
# My janky theme, loosely based off agnoster's theme

CURRENT_BG='NONE'

END_SEP=$'\ue0b4'
START_SEP=$'\ue0b6'

lhs_block() {
  # If the prev background is different, add a separator with fg=prev_background and bg=new_background
  if [[ $CURRENT_BG != 'NONE' && $CURRENT_BG != $1 ]]; then
    echo -n "%K{$1}%F{$CURRENT_BG}$END_SEP"
  fi
  CURRENT_BG=$1
  echo -n "%K{$1}%F{$2} $3 %k%f%b"
}

block_lhs_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n "%k%F{$CURRENT_BG}$END_SEP"
  else
    echo -n "%k"
  fi
  echo -n "%f"
  CURRENT_BG=''
}

rhs_block() {
  echo -n "%K{$CURRENT_BG}%F{$1}$START_SEP"
  CURRENT_BG=$1
  echo -n "%K{$1}%F{$2}$3 "
}

indicator() {
  local line

  line+='\n'

 [[ $RETVAL -ne 0 ]] && line+='%F{red}\uea87'
 [[ $UID -eq 0 ]] && line+='%F{yellow}\uf1867'
 [[ $(jobs -l | wc -l) -gt 0 ]] && line+='%F{cyan}\uf013'

  line+="%F{blue}󰅂 %k%f%b"
  echo -n "$line"
}

block_host() {
  lhs_block magenta white '\uf108 %m'
}

block_location() {
  lhs_block blue white '\uf07b %~'
}

function __git_prompt_git() {
  GIT_OPTIONAL_LOCKS=0 command git "$@"
}

function parse_git_dirty() {
  local STATUS
  local -a FLAGS
  FLAGS=('--porcelain')
  if [[ "$(__git_prompt_git config --get oh-my-zsh.hide-dirty)" != "1" ]]; then
    if [[ "${DISABLE_UNTRACKED_FILES_DIRTY:-}" == "true" ]]; then
      FLAGS+='--untracked-files=no'
    fi
    case "${GIT_STATUS_IGNORE_SUBMODULES:-}" in
      git)
        # let git decide (this respects per-repo config in .gitmodules)
        ;;
      *)
        # if unset: ignore dirty submodules
        # other values are passed to --ignore-submodules
        FLAGS+="--ignore-submodules=${GIT_STATUS_IGNORE_SUBMODULES:-dirty}"
        ;;
    esac
    STATUS=$(__git_prompt_git status ${FLAGS} 2> /dev/null | tail -n 1)
  fi
  if [[ -n $STATUS ]]; then
    echo "+"
  else
    echo ""
  fi
}

block_git() {
  local line
  (( $+commands[git] )) || return
  if [[ "$(command git config --get oh-my-zsh.hide-status 2>/dev/null)" = 1 ]]; then
    return
  fi
  local PL_BRANCH_CHAR
  PL_BRANCH_CHAR=$'\ue0a0'         # 
  local ref dirty mode repo_path

  if [[ "$(command git rev-parse --is-inside-work-tree 2>/dev/null)" = "true" ]]; then
    repo_path=$(command git rev-parse --git-dir 2>/dev/null)
    dirty=$(parse_git_dirty)
    ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
    ref="◈ $(command git describe --exact-match --tags HEAD 2> /dev/null)" || \
    ref="➦ $(command git rev-parse --short HEAD 2> /dev/null)"

    local ahead behind
    ahead=$(command git log --oneline @{upstream}.. 2>/dev/null)
    behind=$(command git log --oneline ..@{upstream} 2>/dev/null)
    if [[ -n "$ahead" ]] && [[ -n "$behind" ]]; then
      PL_BRANCH_CHAR=$'\u21c5'
    elif [[ -n "$ahead" ]]; then
      PL_BRANCH_CHAR=$'\u21b1'
    elif [[ -n "$behind" ]]; then
      PL_BRANCH_CHAR=$'\u21b0'
    fi

    if [[ -e "${repo_path}/BISECT_LOG" ]]; then
      mode=" <B>"
    elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
      mode=" >M<"
    elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]]; then
      mode=" >R>"
    fi

    setopt promptsubst
    autoload -Uz vcs_info

    zstyle ':vcs_info:*' enable git
    zstyle ':vcs_info:*' get-revision true
    zstyle ':vcs_info:*' check-for-changes true
    zstyle ':vcs_info:*' stagedstr '✚'
    zstyle ':vcs_info:*' unstagedstr '±'
    zstyle ':vcs_info:*' formats ' %u%c'
    zstyle ':vcs_info:*' actionformats ' %u%c'
    vcs_info

    line="${${ref:gs/%/%%}/refs\/heads\//$PL_BRANCH_CHAR }${vcs_info_msg_0_%% }${mode}"

    if [[ -n $dirty ]]; then
      rhs_block yellow black "$line"
    else
      rhs_block green black "$line"
    fi
  fi
}

block_clock() {
  rhs_block black white "\uf017 %*%K{black}%F{white}"
}

build_lhs_prompt() {
  RETVAL=$?
  block_host
  block_location
  block_lhs_end
  indicator
}

build_rhs_prompt() {
  block_git
  block_clock
}

PROMPT="%{%f%b%k%}
$(build_lhs_prompt)"

RPROMPT="%{%f%b%k%}$(build_rhs_prompt)"
