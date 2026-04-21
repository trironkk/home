source "$HOME/.bash_profile"

export PS1="${debian_chroot:+($debian_chroot)}\u@\h:\w\$ "

[[ -f /usr/share/doc/fzf/examples/key-bindings.bash ]] \
	&& source /usr/share/doc/fzf/examples/key-bindings.bash

[[ -f "$HOME/.google.bash" ]] && source "$HOME/.google.bash"
