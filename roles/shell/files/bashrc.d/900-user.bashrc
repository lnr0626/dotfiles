pathmunge() {
  if ! echo $PATH | egrep -q "(^|:)$1($|:)"; then
    if [ "$2" = "after" ]; then
      PATH=$PATH:$1
    else
      PATH=$1:$PATH
    fi
  fi
}

pathmunge ${HOME}/.local/bin
pathmunge ${HOME}/bin

export PATH

set -o vi

export EDITOR=nvim
