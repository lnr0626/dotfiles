#!/usr/bin/env bash

# TODO: Make it work when not run from pwd
SCRIPT_DIR=.
HOSTS_FILE=${SCRIPT_DIR}/hosts
PLAYBOOK_FILE=${SCRIPT_DIR}/local.yml

function distro() {
    # Determine OS platform
    UNAME=$(uname | tr "[:upper:]" "[:lower:]")
    # If Linux, try to determine specific distribution
    if [ "$UNAME" == "linux" ]; then
        # If available, use LSB to identify distribution
        if [ -f /etc/lsb-release -o -d /etc/lsb-release.d ]; then
            export DISTRO=$(lsb_release -i | cut -d: -f2 | sed s/'^\t'//)
        # Otherwise, use release info file
        else
            export DISTRO=$(ls -d /etc/[A-Za-z]*[_-][rv]e[lr]* | grep -v "lsb" | cut -d'/' -f3 | cut -d'-' -f1 | cut -d'_' -f1)
        fi
    fi
    # For everything else (or if above failed), just use generic identifier
    [ "$DISTRO" == "" ] && export DISTRO=$UNAME
    unset UNAME
    echo $DISTRO
}

function hname() {
    command -v hostname &>/dev/null && hostname || cat /etc/hostname
}

function confirm() {
    [ ! -z "$BASH" ] && read -p "${1} " -n 1 -r
    [ ! -z "$ZSH_NAME" ] && read -k "REPLY?${1} "
    echo $REPLY
}

function prompt() {
    [ ! -z "$BASH" ] && read -p "${1}" -r
    [ ! -z "$ZSH_NAME" ] && read "REPLY?${1}"
    echo $REPLY
}

function install_homebrew() {
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install > ./.brew-install
    less ./.brew-install
    REPLY=$(confirm "Do you want to run the script? [y/N]")
    echo # (optional) move to a new line
    if [[ ! "${REPLY}" =~ ^[Yy]$ ]]
    then
        rm -f ./.brew-install
        [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
    fi

    /usr/bin/ruby ./.brew-install
    rm -f ./.brew-install
}

function install_dependencies() {
    DISTRO=$(distro)
    if echo ${DISTRO} | grep -qi darwin; then
        command -v brew &>/dev/null || install_homebrew
        brew install python@2 ansible
    elif echo ${DISTRO} | grep -qi fedora; then
        sudo dnf install python ansible
    fi
}

function set_hostname() {
    NEW_HOSTNAME=${1}
    echo "Setting hostname to ${NEW_HOSTNAME}"
    DISTRO=$(distro)
    if echo ${DISTRO} | grep -qi darwin; then
        sudo scutil --set ComputerName "${NEW_HOSTNAME}"
        sudo scutil --set HostName "${NEW_HOSTNAME}"
        sudo scutil --set LocalHostName "${NEW_HOSTNAME}"
        sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "${NEW_HOSTNAME}"
    elif echo ${DISTRO} | grep -qi fedora; then
        sudo hostnamectl set-hostname "${NEW_HOSTNAME}"
        sudo tee -a /etc/hosts > /dev/null <<EOF
127.0.0.1 ${NEW_HOSTNAME}.localdomain ${NEW_HOSTNAME}
::1 ${NEW_HOSTNAME}.localdomain ${NEW_HOSTNAME}
EOF
    fi
}

function add_hostname_to_inventory() {
    echo "Adding $1 to the inventory"
    echo $1 >> ${HOSTS_FILE}
    echo "${1} was added to the inventory file. You should run 'git commit -am \"Added ${1} as a new host\"' and push."
}

function setup_hostname() {
    HOSTNAME=$(hname)
    if grep -q ${HOSTNAME} ${HOSTS_FILE}; then
        echo "Hostname is already present in inventory file"
    else
        echo -n "Adding hostname to the inventory... "
        REPLY=$(confirm "Do you want to change the hostname (from ${HOSTNAME})? [y/N]")
        echo
        if [[ "${REPLY}" =~ ^[Yy]$ ]]
        then
            HOSTNAME=$(prompt "What should the new hostname be? [${HOSTNAME}] ")
            set_hostname ${HOSTNAME}
        fi

        add_hostname_to_inventory ${HOSTNAME}
    fi
}

function run_playbook() {
    ansible-playbook local.yml -c local -i hosts -l $(hname) -K
}

install_dependencies

setup_hostname

run_playbook
