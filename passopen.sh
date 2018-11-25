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

# non interactive mode:
# ./passopen.sh subfolder/pass3_

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
        exit 2
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
    shortened_entry=${entry/"_link"/"_"}
    shortened_entry=${shortened_entry/"_user"/"_"}
    shortened_entry=${shortened_entry/"_pass"/"_"}
    $startdir/passopen.sh $shortened_entry
    if [ $? -eq 1 ]; then
        pass -c "$entry"
        sleep 1
    fi
    cd $startdir
    exit 0
fi

exit 3
