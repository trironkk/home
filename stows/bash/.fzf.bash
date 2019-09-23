# Setup fzf
# ---------
if [[ ! "$PATH" == */home/trironkk/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/trironkk/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/trironkk/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/trironkk/.fzf/shell/key-bindings.bash"
