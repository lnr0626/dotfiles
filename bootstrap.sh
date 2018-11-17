#!/usr/bin/env bash

ansible-playbook local.yml -c local -i hosts -l $(hostname)
