# DO NOT MODIFY
#
# Instead make customizations to ~/etc/bashrc.d/900-user.bashrc or
# ~/etc/.bashrc.d/999-host.bashrc

# Source global definitions
if [ -f /etc/zshrc ]; then
	. /etc/zshrc
fi

export EDITOR=nvim

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'

source ~/antigen.zsh

# Load the oh-my-zsh library
antigen use oh-my-zsh

antigen bundle git
antigen bundle brew
antigen bundle kubectl
antigen bundle zsh_reload
antigen bundle osx
antigen bundle helm
antigen bundle aws
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

for rc in $(find ${HOME}/etc/zshrc.d/ -name "*.zshrc" -type f); do
  source ${rc};
done

