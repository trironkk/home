alias vim=nvim
alias vimdiff='nvim -d'

[[ -f "$HOME/.google.bash_profile" ]] && source "$HOME/.google.bash_profile"

export GOPATH=$HOME/go 
export GOBIN=$GOPATH/bin 
export PATH=$PATH:$GOPATH 

# Secret configurations not to be source controlled.
# OPENAI_API_KEY: https://platform.openai.com/account/api-keys
# GOOGLE_API_KEY: https://console.cloud.google.com/apis/credentials/key/01cbe6c1-81f8-446a-bfe7-e112fb77dc18
# GEMINI_API_KEY: https://aistudio.google.com/api-keys
[[ -f "$HOME/.secrets" ]] && source "$HOME/.secrets"
