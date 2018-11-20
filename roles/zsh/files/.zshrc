# DO NOT MODIFY
#
# Instead make customizations to ~/etc/bashrc.d/900-user.bashrc or
# ~/etc/.bashrc.d/999-host.bashrc

# Source global definitions
if [ -f /etc/zshrc ]; then
	. /etc/zshrc
fi

export ANTIGEN_CHECK_FILES=${HOME}/etc/zshrc.d/001-antigen.zshrc

for rc in $(find ${HOME}/etc/zshrc.d/ -name "*.zshrc" -type f | sort); do
  source ${rc};
done
