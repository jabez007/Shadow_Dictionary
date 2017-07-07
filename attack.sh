#!/bin/bash

# Set the internal field separator
IFS=$'\n'

hash_algo="sha-512"

if [ -z "$3" ]
then
        shadow_file="/etc/shadow"
else
        if [ -r "$3" ]
        then
                shadow_file="$3"
        else
                echo "Bad shadow file: $3"
                exit 1
        fi
fi

if [ $(cat "$shadow_file" | grep "$1:") ]
then
        echo "Username $1 is good"
        pass_hash=$(cat "$shadow_file" | grep "$1:" | cut -d ":" -f 2)
        salt=$(echo "$pass_hash" | cut -d "$" -f 3)
        echo "password hash salt: $salt"

        if [ -z "$2" ]
        then
                usr_pass=$(mkpasswd -s -m "$hash_algo" -S "$salt")
                if [ "$usr_pass" == "$pass_hash" ]
                then
                        echo "Password is good"
                else
                        echo "Password is bad"
                fi
                exit 0
        fi
        
        if [ -r "$2" ]
        then
                for pass in $(cat "$2")
                do
                        if [ "$(echo -n "$pass" | mkpasswd -s -m "$hash_algo" -S "$salt")" == "$pass_hash" ]
                        then
                                echo "Password $pass is good"
                                exit 0
                        else
                                echo "Password $pass is bad"
                        fi
                done
        else
                if [ "$(echo -n "$2" | mkpasswd -s -m "$hash_algo" -S "$salt")" == "$pass_hash" ]
                then
                        echo "Password $2 is good"
                else
                        echo "Password $2 is bad"
                fi
        fi

else
        echo "Bad username: $1"
fi

unset IFS

exit 0
