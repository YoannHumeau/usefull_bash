#!/bin/bash

#########################################################
#                                                       #
# I created this script for getting automaticaly rights #
# every 10 seconds for develop on android and arduino   # 
# because the owner is always back on root user         #
#                                                       #                                                       
#                                                       #
#               *** Ubuntu Example ***                  #
#                                                       #
# - Put this script in /bin/user_access.sh              #
# - Give him rights: sudo chmod 755 /bin/user_access.sh #
# - Edit the root crontab: sudo crontab -e              #
#   (and add the line bellow)                           #
#                                                       #
#   * * * * * bash /bin/android_chmod_kvm.sh            #
#                                                       #
#                                                       #
# More informations and over scripts at                 #
# https://github.com/YoannHumeau/usefull_bash           #
#                                                       #
#########################################################



# User that you want own the access (That will be the same who will have notification)
user="device"

# List of elements to check, spearte by a space. 
# Example (/dev/elem1 /dev/elem2 /dev/elem3)
elems=(/dev/kvm /dev/ttyUSB0)

owner=""

# Function that change the owner to user if it is not even
rights()
{
        owner=$(stat -c '%U' $elem)
        if [ $owner != $user ]
        then
                chown -R $user: $elem
                su device -c 'notify-send "'$elem' rights" " - Prev owner: '$owner'\n - New owner:  '$(stat -c '%U' $elem)'"'
        fi
}

# Main loop function that run every 10 secondes 6 times
main()
{
        for i in {1..6}
        do
                # For each elements to check
                for elem in "${elems[@]}"
                do
                        # If elem exists check rights
                        if test -e $elem
                        then
                                rights
                        fi
                done
                sleep 10
        done
}

# Run the script
main
