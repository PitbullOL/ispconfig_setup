#---------------------------------------------------------------------
# Function: InstallMailman
#    Install Mailman
#---------------------------------------------------------------------

InstallMailman (){
echo -n "Installing Mailman... "
echo "================================================================================================"
echo "You will be prompted for some information during the install."
echo "Select the languages you want to support and hit OK when told about the missing site list"
echo "You will also be asked for the email address of person running the list & password for the list."
echo "Please enter them where needed."
echo "================================================================================================"
echo "Press ENTER to continue.."
read DUMMY

#Install Mailman
apt-get install -yqq mailman
newlist mailman

mv /etc/aliases /etc/aliases.backup

cat > /etc/aliases.mailman <<"EOF"
mailman:              "|/var/lib/mailman/mail/mailman post mailman"
mailman-admin:        "|/var/lib/mailman/mail/mailman admin mailman"
mailman-bounces:      "|/var/lib/mailman/mail/mailman bounces mailman"
mailman-confirm:      "|/var/lib/mailman/mail/mailman confirm mailman"
mailman-join:         "|/var/lib/mailman/mail/mailman join mailman"
mailman-leave:        "|/var/lib/mailman/mail/mailman leave mailman"
mailman-owner:        "|/var/lib/mailman/mail/mailman owner mailman"
mailman-request:      "|/var/lib/mailman/mail/mailman request mailman"
mailman-subscribe:    "|/var/lib/mailman/mail/mailman subscribe mailman"
mailman-unsubscribe:  "|/var/lib/mailman/mail/mailman unsubscribe mailman"
EOF

cat /etc/aliases.backup /etc/aliases.mailman > /etc/aliases

newaliases

service postfix restart

ln -s /etc/mailman/apache.conf /etc/apache2/conf.d/mailman.conf

service apache2 restart

service mailman start

echo -e "[${green}DONE${NC}]\n"
}

