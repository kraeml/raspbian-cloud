#!/bin/bash

## Hide cursor and disable screensaver
#cat <<EOF > /etc/X11/xinit/xserverrc
##!/bin/sh
#for f in /dev/input/by-id/*-mouse; do
#
#    ## Check if the glob gets expanded to existing files.
#    ## If not, f here will be exactly the pattern above
#    ## and the exists test will evaluate to false.
#    if [ -e "\$f" ]; then
#        CUROPT=
#        # run framebuffer copy tool in background
#        /usr/bin/fbc &
#        sh -c 'sleep 2; unclutter -display :0 -idle 1 -root' &
#    else
#        CUROPT=-nocursor
#    fi
#
#    ## This is all we needed to know, so we can break after the first iteration
#    break
#done
#
#exec /usr/bin/X -s 0 dpms \$CUROPT -nolisten tcp "\$@"
#EOF
