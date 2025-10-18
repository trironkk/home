autoload -U select-word-style
select-word-style bash
autoload -U compinit
compinit

export EDITOR=vim
# export GOROOT="$HOME/local/go/golang"
# export GOPATH="$HOME/local/go/packages"
export PATH="$PATH:$GOPATH/bin:$GOROOT/bin"
export PATH="$PATH:$HOME/.tools"
export PATH="$PATH:/usr/local/bin"
export PATH="$PATH:$HOME/.local/share/sf/bin"
export PATH="$PATH:$HOME/.npm-global/bin"

autoload -Uz add-zsh-hook

# Prompt.
autoload -U colors && colors
FG_COLOR=black
BG_COLOR=green
PROMPT_COMMAND="set_tmux_ps1_bg;$PROMPT_COMMAND"
PROMPT="%{$fg[$FG_COLOR]%}%{$bg[$BG_COLOR]%}%n%{$reset_color%}@%{$fg[$FG_COLOR]%}%{$bg[$BG_COLOR]%}%m%{$reset_color%}:%{$fg[$FG_COLOR]%}%{$bg[$BG_COLOR]%}%~%{$reset_color%}
$ "

# History configuration.
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=1000000
export SAVEHIST=1000000
setopt append_history
setopt extended_history
setopt hist_ignore_dups
zshaddhistory() { print -sr "${(z)1%%$'\n'}"; return 1 }

setopt interactivecomments

# FZF configuration.
export FZF_TMUX=1
export FZF_BASE="$USER/.fzf"
export FZF_CTRL_T_COMMAND="rg --no-ignore '' -l"
export FZF_CTRL_T_OPTS="--ansi --preview-window 'right:60%' --preview 'batcat --color=always --style=plain --line-range :300 {}'"
export FZF_DEFAULT_OPTS="--bind alt-up:preview-page-up,alt-down:preview-page-down"
source /usr/share/doc/fzf/examples/key-bindings.zsh
source /usr/share/doc/fzf/examples/completion.zsh


bindkey '\eb' vi-backward-word
bindkey '\ef' vi-forward-word

# Colorized man prompts.
man() {
    LESS_TERMCAP_md=$'\e[01;31m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;44;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;32m' \
    command man "$@"
}

# Allow Ctrl-z to toggle between suspend and resume.
function Resume {
  fg
  zle push-input
  BUFFER=""
  zle accept-line
}
zle -N Resume
bindkey "^Z" Resume

# Save and open current tmux pane.
function SaveTmuxPane {
  if [ "$TERM" != "tmux-256color" ] || [ -z "$TMUX" ]; then
    echo "Must run within tmux session to save tmux pane."
    return
  fi

  mkdir -p "$HOME/tmux-panes"
  save_file="$HOME/tmux-panes/$(tmux display-message -p '#W')_$(date +"%Y%m%d-%H%M%S")"
  tmux capture-pane -J -S -100000
  tmux save-buffer "$save_file"
  sed 's/\s\+$//' -i "$save_file"
  vim "$save_file" < /dev/tty
}
zle -N SaveTmuxPane
bindkey "^P" SaveTmuxPane

# Open Vim (without polluting terminal output)
function OpenVim {
  nvim
}
zle -N OpenVim
bindkey "^\`" OpenVim

# Google-specific configuration.
[[ -f "$HOME/.google.zsh" ]] && source "$HOME/.google.zsh"

# Secret configurations not to be source controlled.
# OPENAI_API_KEY: https://platform.openai.com/account/api-keys
# GOOGLE_API_KEY: https://console.cloud.google.com/apis/credentials/key/01cbe6c1-81f8-446a-bfe7-e112fb77dc18
[[ -f "$HOME/.secrets" ]] && source "$HOME/.secrets"
