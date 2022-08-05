clear
echo "I am running!"
echo "Configuring the server's existing Postfix installation to utilize SendGrid for outgoing emails"
echo "Documentation: https://docs.sendgrid.com/for-developers/sending-email/postfix"
echo ""
echo "=== PASTE THE CLIENT'S SENDGRID API KEY ==="
echo "-------------------------------------------"
echo "Hint: It should be stored within their 1Password vault."
echo "If it isn't you'll need to generate a new API Key on SendGrid's website, first."
echo "Don't forget to save it in the client's vault in 1Password afterwards!"
echo ""
echo "Press Ctrl-C to quit or paste in the key now."
echo ""
read APIKEY
clear
echo "Using API Key \"$APIKEY\""
touch output.txt
echo -e "\n\n#smtp_sasl_auth_enable = yes\n#smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd\n#smtp_sasl_security_options = noanonymous\n#smtp_sasl_tls_security_options = noanonymous\n#smtp_tls_security_level = encrypt\n#header_size_limit = 4096000\n#relayhost = [smtp.sendgrid.net]:587" >> /etc/postfix/main.cf &&
touch /etc/postfix/sasl_passwd2 
echo -e "[smtp.sendgrid.net]:587 apikey:$APIKEY" >> /etc/postfix/sasl_passwd2 && 
#echo "Making sure the file has restricted read and write access only for root..."
#sudo chmod 600 /etc/postfix/sasl_passwd && 
#echo "Updating Postfix's hashtables to use the new file..."
#sudo postmap /etc/postfix/sasl_passwd && 
#echo "Restarting the Posfix service..."
#sudo systemctl restart postfix
#echo "Cleaning up..."
#rm output.txt
#rm /etc/postfix/sasl_passwd2
echo "All Done!"
exit
