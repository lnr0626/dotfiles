#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

git pull origin master;

function install() {
  setupHomeDirectory
  installDotFiles
  updateVim
}

setupHomeDirectory() {
  mkdir -p ${HOME}/{bin,code,etc,notes,tmp}

  if [ ! -f ${HOME}/etc/host.bashrc ]; then
    echo "# Host-specific bashrc settings here" >> ${HOME}/etc/host.bashrc
  fi

  if [ ! -f ${HOME}/.ssh/id_rsa ]; then
    ssh-keygen -b 2048 -t rsa -f ${HOME}/.ssh/id_rsa -q -N ""
    echo "New ssh key created at ${HOME}/.ssh/id_rsa"
    echo "Be sure to register it with whatever services are needed"
    echo
  fi
}

function installDotFiles() {
  rsync --exclude ".git/" \
        --exclude ".gitmodules" \
        --exclude "bootstrap.sh" \
        --exclude "README.md" \
        -avh --no-perms . ~;

  source ~/.bash_profile;
}

function updateVim() {
	vim +PluginInstall +qall
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
  install
else
  read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
  echo "";
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    install
  fi
fi;

unset install;

