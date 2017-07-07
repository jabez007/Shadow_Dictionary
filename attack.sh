#!/bin/bash

# Set the internal field separator
IFS=$'\n'

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
        
        algo_id=$(echo "$pass_hash" | cut -d "$" -f 2)
        if [ "$algo_id" == "1" ]
        then
                hash_algo="md5"
        fi
        if [ "$algo_id" == "2a" ] || [ "$algo_id" == "2y" ]
        then
                hash_algo="blowfish"
        fi
        if [ "$algo_id" == "5" ]
        then
                hash_algo="sha-256"
        fi
        if [ "$algo_id" == "6" ]
        then
                hash_algo="sha-512"
        fi
        echo "hashing algorithm: $hash_algo"
        
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
