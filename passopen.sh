#!/bin/bash
startdir=$PWD
passdir="$HOME/.password-store/"

# Automatisation for pass (the linux password store)
# the filestructure should be like the following:
#
# with link:
# /home/user/.password-store/pass1_link.gpg"
# /home/user/.password-store/pass1_user.gpg"
# /home/user/.password-store/pass1_pass.gpg"
# or without link:
# /home/user/.password-store/pass1_user.gpg"
# /home/user/.password-store/pass1_pass.gpg"
# or in subfolder:
# /home/user/.password-store/subfolder/pass3_link.gpg"
# /home/user/.password-store/subfolder/pass3_user.gpg"
# /home/user/.password-store/subfolder/pass3_pass.gpg"


if [ $# -eq 1 ]; then
    
    echo "try_link $passdir/$1link.gpg"
    if [ -f "$passdir/$1link.gpg" ]; then
        echo "start firefox"
        firefox --new-tab `pass "$1link"` & > /dev/null
    fi
    
    echo "copy_user"
    pass -c "$1user"
    if [ $? -ne 0 ]; then
        exit 1
    fi
    echo "Press key to continue..."
    read -n 1
    
    echo "copy_pass"
    pass -c "$1pass"
    if [ $? -ne 0 ]; then
        exit 1
    fi
    
    sleep 5
    echo cleared | xclip -selection c
    echo cleared
    exit 0
else
    cd $passdir
    complete -f -d find
    echo "choose entry?:"
    read -e -p "" entry
    entry=${entry/".gpg"/""}
    entry=${entry/"_link"/"_"}
    entry=${entry/"_user"/"_"}
    entry=${entry/"_pass"/"_"}
    $startdir/passopen.sh $entry
    cd $startdir
    exit 0
fi

exit 2