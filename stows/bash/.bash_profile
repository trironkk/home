alias vim=nvim
alias vimdiff='nvim -d'

[[ -f "$HOME/.google.bash_profile" ]] && source "$HOME/.google.bash_profile"

export GOPATH=$HOME/go 
export GOBIN=$GOPATH/bin 
export PATH=$PATH:$GOPATH 
