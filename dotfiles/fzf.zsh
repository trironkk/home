# Setup fzf
# ---------
if [[ ! "$PATH" == *$HOME/local/github.com/junegunn/fzf/bin* ]]; then
  export PATH="$PATH:$HOME/local/github.com/junegunn/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "$HOME/local/github.com/junegunn/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "$HOME/local/github.com/junegunn/fzf/shell/key-bindings.zsh"

# Enable fzf-tmux integration.
export FZF_TMUX=1
export FZF_DEFAULT_COMMAND='ag -g ""'
export FZF_CTRL_T_COMMAND='ag -g ""'
