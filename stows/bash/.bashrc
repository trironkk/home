export THEME_COLOR=green

export PS1="${debian_chroot:+($debian_chroot)}\u@$(hostname -f):\w\$ "

[[ -f "$HOME/.fzf.bash" ]] && source "$HOME/.fzf.bash"
[[ -f "$HOME/.google.bash" ]] && source "$HOME/.google.bash"
