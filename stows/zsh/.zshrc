autoload -Uz compinit select-word-style colors add-zsh-hook
compinit
select-word-style bash
colors

# Prompt.
PROMPT='%F{black}%K{green}%n@%m%k%f:%F{black}%K{green}%~%k%f
$ '

# History.
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=1000000
export SAVEHIST=1000000
setopt append_history extended_history hist_ignore_dups interactivecomments
zshaddhistory() { print -sr "${(z)1%%$'\n'}"; return 1 }

# Keybindings.
bindkey '\eb' vi-backward-word
bindkey '\ef' vi-forward-word

# FZF.
export FZF_TMUX=1
export FZF_BASE="$HOME/.fzf"
export FZF_CTRL_T_COMMAND="rg --no-ignore '' -l"
export FZF_CTRL_T_OPTS="--ansi --preview-window 'right:60%' --preview 'batcat --color=always --style=plain --line-range :300 {}'"
export FZF_DEFAULT_OPTS="--bind alt-up:preview-page-up,alt-down:preview-page-down"
[[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]] \
	&& source /usr/share/doc/fzf/examples/key-bindings.zsh
[[ -f /usr/share/doc/fzf/examples/completion.zsh ]] \
	&& source /usr/share/doc/fzf/examples/completion.zsh

# Colorized man pages.
man() {
	LESS_TERMCAP_md=$'\e[01;31m' \
	LESS_TERMCAP_me=$'\e[0m' \
	LESS_TERMCAP_se=$'\e[0m' \
	LESS_TERMCAP_so=$'\e[01;44;33m' \
	LESS_TERMCAP_ue=$'\e[0m' \
	LESS_TERMCAP_us=$'\e[01;32m' \
	command man "$@"
}

# Ctrl-Z toggles between suspend/resume.
Resume() { fg; zle push-input; BUFFER=""; zle accept-line }
zle -N Resume
bindkey "^Z" Resume

# Save and open current tmux pane in nvim.
SaveTmuxPane() {
	if [[ -z "$TMUX" ]]; then
		echo "Must run within a tmux session."
		return 1
	fi
	mkdir -p "$HOME/tmux-panes"
	local save_file="$HOME/tmux-panes/$(tmux display-message -p '#W')_$(date +%Y%m%d-%H%M%S)"
	tmux capture-pane -J -S -100000
	tmux save-buffer "$save_file"
	sed -i 's/[[:space:]]\+$//' "$save_file"
	nvim "$save_file" < /dev/tty
}
zle -N SaveTmuxPane
bindkey "^P" SaveTmuxPane

# Open nvim without polluting terminal output.
OpenNvim() { nvim }
zle -N OpenNvim
bindkey "^\`" OpenNvim

# History cleanup utilities.
source "$HOME/.scripts/functions/hd"
source "$HOME/.scripts/functions/hist-clean"

[[ -f "$HOME/.google.zsh" ]] && source "$HOME/.google.zsh"
