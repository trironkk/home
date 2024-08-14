export THEME_COLOR=green

export PS1="${debian_chroot:+($debian_chroot)}\u@$(hostname -f):\w\$ "

source /usr/share/doc/fzf/examples/key-bindings.bash

[[ -f "$HOME/.google.bash" ]] && source "$HOME/.google.bash"

source ~/.bash_profile
