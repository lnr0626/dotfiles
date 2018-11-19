#!/usr/bin/env bash

# TODO: Install ansible if it's not already present

ansible-playbook local.yml -c local -i hosts -l $(hostname)
