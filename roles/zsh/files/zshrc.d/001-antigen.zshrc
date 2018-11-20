zstyle :omz:plugins:ssh-agent identities

source ~/antigen.zsh

# Load the oh-my-zsh library
antigen use oh-my-zsh

antigen bundle git
antigen bundle zsh_reload

if command -v brew > /dev/null; then
  antigen bundle brew
fi

if command -v kubectl > /dev/null; then
  antigen bundle kubectl
fi

if [ "$(uname)" = "Darwin" ]; then
  antigen bundle osx
fi

if command -v helm > /dev/null; then
  antigen bundle helm
fi

if command -v aws > /dev/null; then
  antigen bundle aws
fi

antigen bundle ssh-agent
antigen bundle vi-mode

antigen bundle zsh-users/zsh-completions

antigen bundle dracula/zsh
antigen theme https://github.com/dracula/zsh.git dracula

antigen apply
