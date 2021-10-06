#!/bin/bash

# create locales
cat <<EOF > /etc/locale.gen
# locales supported by CFW
en_US.UTF-8 UTF-8
de_DE.UTF-8 UTF-8
nl_NL.UTF-8 UTF-8
fr_FR.UTF-8 UTF-8
EOF

locale-gen

#TODO: May fail if /etc/ssh/ssh_config contains "SendEnv LANG LC_*" (default) and the TX-Pi setup is run headless via SSH
update-locale --no-checks LANG="de_DE.UTF-8"
