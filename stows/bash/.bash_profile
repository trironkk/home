# Secrets (not source-controlled).
# OPENAI_API_KEY    https://platform.openai.com/account/api-keys
# GEMINI_API_KEY    https://aistudio.google.com/api-keys
# ANTHROPIC_API_KEY https://platform.claude.com/settings/keys
[[ -f "$HOME/.secrets" ]] && source "$HOME/.secrets"

[[ -f "$HOME/.google.bash_profile" ]] && source "$HOME/.google.bash_profile"

export EDITOR=nvim
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin:$HOME/.tools:$HOME/.local/bin:$HOME/.npm-global/bin"

alias vim=nvim
alias vimdiff='nvim -d'
