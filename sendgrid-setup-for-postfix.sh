clear
echo "Configuring the server's existing Postfix installation to utilize SendGrid for outgoing emails"
echo "(Documentation: https://docs.sendgrid.com/for-developers/sending-email/postfix)"
echo ""
echo "=== PASTE THE CLIENT'S SENDGRID API KEY ==="
echo "-------------------------------------------"
echo "Hint: It should be stored within their 1Password vault."
echo "If it isn't there you'll need to generate a new API Key on SendGrid's website, first."
echo "Don't forget to save it in the client's vault in 1Password afterwards!"
echo ""
echo "Press Ctrl-C to quit or paste in the key now."
echo ""
read APIKEY
clear
echo "Using API Key \"$APIKEY\""
echo "Adding lines to /etc/postfix/main.cf..."
echo -e "\n\nsmtp_sasl_auth_enable = yes\nsmtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd\nsmtp_sasl_security_options = noanonymous\nsmtp_sasl_tls_security_options = noanonymous\nsmtp_tls_security_level = encrypt\nheader_size_limit = 4096000\nrelayhost = [smtp.sendgrid.net]:587" >> /etc/postfix/main.cf &&
echo "Creating file at /etc/postfix/sasl_passwd ..."
touch /etc/postfix/sasl_passwd 
echo "Defining the content in the new file (Including the API Key)..."
echo -e "[smtp.sendgrid.net]:587 apikey:$APIKEY" >> /etc/postfix/sasl_passwd && 
echo "Making sure the new file has restricted read and write access only for root..."
sudo chmod 600 /etc/postfix/sasl_passwd && 
echo "Updating Postfix's hashtables to use the new file..."
sudo postmap /etc/postfix/sasl_passwd && 
echo "Restarting the Posfix service..."
sudo systemctl restart postfix && 
echo "All Done! Now test the email works by trying a forgotten password reset on the website."
exit
