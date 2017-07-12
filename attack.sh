#!/bin/bash

# Set the internal field separator
IFS=$'\n'

if [ -z "$1" ]
then
	printf "No dictionary file given\n"
	exit 1
else
        if [ -r "$1" ]
        then
                dictionary_file="$1"
        else
                echo "Bad dictionary file: $1"
                exit 1
        fi
fi

if [ -z "$2" ]
then
	shadow_file="/etc/shadow"
else
	if [ -r "$2" ]
	then
		shadow_file="$2"
	else
		echo "Bad shadow file: $2"
		exit 1
	fi
fi

printf "Attacking %s using %s\n" "$shadow_file" "$dictionary_file"


while read -r line
do
	test_pass="$(printf "%s" "$line" | cut -d ":" -f 2)"
	if [ ${#test_pass} -gt 3 ]
        then
		echo "=========================="

                username=$(printf "%s" "$line" | cut -d ":" -f 1)
                printf "Username: %s\n" "$username"

                pass_hash=$(printf "%s" "$line" | cut -d ":" -f 2)
                #printf "%s\n" "$password"

		unset hash_algo
		algo_id=$(printf "%s" "$pass_hash" | cut -d "$" -f 2)
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
        	printf "Hashing algorithm: %s\n" "$hash_algo"

                salt=$(printf "%s" "$pass_hash" | cut -d "$" -f 3)
                #printf "%s\n" "$salt"

		for word in $(cat "$dictionary_file")
                do
                        if [ "$(echo -n "$word" | mkpasswd -s -m "$hash_algo" -S "$salt")" == "$pass_hash" ]
                        then
				printf "\nFound password: %s\n" "$word"
                		echo "=========================="
                		break
                        else
                                printf "."
                        fi
                done

        fi

done < "$shadow_file"

unset IFS

printf "\n"
exit 0
