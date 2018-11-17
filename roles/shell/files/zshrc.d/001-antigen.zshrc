source ~/antigen.zsh

# Load the oh-my-zsh library
antigen use oh-my-zsh

antigen bundle git
antigen bundle zsh_reload

if command -v brew; then
  antigen bundle brew
fi

if command -v kubectl; then
  antigen bundle kubectl
fi

if [ "$(uname)" == "Darwin" ]; then
  antigen bundle osx
fi

if command -v helm; then
  antigen bundle helm
fi

if command -v aws; then
  antigen bundle aws
fi

antigen bundle ssh-agent
antigen bundle vi-mode

antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-syntax-highlighting

antigen bundle zsh-users/zsh-history-substring-search # load after zsh-syntax-highlighting

antigen theme robbyrussell

antigen apply

bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1
