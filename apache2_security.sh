#!/bin/bash
# Securing Apache2 Server Script
# Date: 17th of July, 2014
# Version 1.0
#
# Author: John McCarthy
# Email: midactsmystery@gmail.com
# <http://www.midactstech.blogspot.com> <https://www.github.com/Midacts>
#
# To God only wise, be glory through Jesus Christ forever. Amen.
# Romans 16:27, I Corinthians 15:1-4
#---------------------------------------------------------------
function install_mod_security(){
	# Install libapache2-mod-security
		echo
		echo -e '\e[34;01m+++ Installing libapache2-mod-security...\e[0m'
		apt-get install libapache2-mod-security
		echo -e '\e[01;37;42mlibapache2-mod-security has been successfully installed!\e[0m'

	# Enabled mod-security
		echo
		echo -e '\e[34;01m+++ Enabling mod-security...\e[0m'
		a2enmod mod-security
		echo -e '\e[01;37;42mmod-security has been successfully enabled!\e[0m'

	# Restarts the apache2 service
		echo
		echo -e '\e[01;34m+++ Restarting the apache2 service\e[0m'
		service apache2 restart
		echo -e '\e[01;37;42mThe apache2 service has been successfully restarted!\e[0m'
}
function install_mod_evasive(){
	# Installs libapache2-mod-evasive
		echo
		echo -e '\e[34;01m+++ Installing libapache2-mod-evasive...\e[0m'
		apt-get -y install libapache2-mod-evasive
		echo -e '\e[01;37;42mlibapache2-mod-evasive has been successfully installed!\e[0m'

	# Creates the evasive log directory and sets the directory's permissions
		echo
		echo -e '\e[34;01m+++ Editingmod-evasive.load file...\e[0m'
		mkdir -p /var/log/apache2/evasive
		chown -R www-data:root /var/log/apache2/evasive

	# Stores the email address in the $email variable
		echo
		echo -e "\e[33mWhat \e[33;01memail address\e[0m \e[33mwould you like to use for future notifications ?\e[0m"
		read email

	# Edits the mod-evasive.load file
		cat <<EOB >> /etc/apache2/mods-available/mod-evasive.load
DOSHashTableSize 2048
DOSPageCount 20
DOSSiteCount 300
DOSPageInterval 1.0
DOSSiteInterval 1.0
DOSBlockingPeriod 10.0
DOSLogDir “/var/log/apache2/evasive”
DOSEmailNotify $email
EOB
		echo -e '\e[01;37;42mThe mod-evasive.load file has been successfully edited!\e[0m'

	# Restarts the apache2 service
		echo
		echo -e '\e[01;34m+++ Restarting the apache2 service\e[0m'
		service apache2 restart
		echo -e '\e[01;37;42mThe apache2 service has been successfully restarted!\e[0m'
}
function install_mod_qos(){
	# Installs libapache2-mod-qos
		echo
		echo -e '\e[34;01m+++ Installing libapache2-mod-qos...\e[0m'
		apt-get -y install libapache2-mod-qos
		echo -e '\e[01;37;42mlibapache2-mod-qos has been successfully installed!\e[0m'

	# Edits the qos.conf file
		echo
		echo -e '\e[34;01m+++ Editing the qos.conf file...\e[0m'
		sed -i  's/#QS_SrvRequestRate/QS_SrvRequestRate/g' /etc/apache2/mods-available/qos.conf
		sed -i  's/#QS_SrvMaxConn/QS_SrvMaxConn/g' /etc/apache2/mods-available/qos.conf
		sed -i  's/#QS_SrvMaxConnClose/QS_SrvMaxConnClose/g' /etc/apache2/mods-available/qos.conf
		sed -i  's/#QS_SrvMaxConnPerIP/QS_SrvMaxConnPerIP/g' /etc/apache2/mods-available/qos.conf
		echo -e '\e[01;37;42mqos.conf has been successfully edited!\e[0m'

	# Restarts the apache2 service
		echo
		echo -e '\e[01;34m+++ Restarting the apache2 service\e[0m'
		service apache2 restart
		echo -e '\e[01;37;42mThe apache2 service has been successfully restarted!\e[0m'
}
function install_mod_spamhaus(){
	# Install libapache2-mod-spamhaus
		echo
		echo -e '\e[34;01m+++ Installing libapache2-mod-spamhaus...\e[0m'
		apt-get -y install libapache2-mod-spamhaus
		echo -e '\e[01;37;42mlibapache2-mod-spamhaus has been successfully installed!\e[0m'

	# Creates the /etc/spamhaus.wl file
		echo
		echo -e '\e[34;01m+++ Configuring mod-spamhaus...\e[0m'
		touch /etc/spamhaus.wl

	# Edits the apache2.conf file for spamhaus
		cat << EOC >> /etc/apache2/apache2.conf
<IfModule mod_spamhaus.c>
  MS_METHODS POST,PUT,OPTIONS,CONNECT
  MS_WhiteList /etc/spamhaus.wl
  MS_CacheSize 256
</IfModule>
EOC
		echo -e '\e[01;37;42mmod-spamhaus has been successfully configured!\e[0m'

	# Restarts the apache2 service
		echo
		echo -e '\e[01;34m+++ Restarting the apache2 service\e[0m'
		service apache2 restart
		echo -e '\e[01;37;42mThe apache2 service has been successfully restarted!\e[0m'
}
function edit_apache2.conf(){
		echo
		echo -e '\e[34;01m+++ Editing the /etc/apache2/apache2.conf file...\e[0m'
		sed -i 's/Options FollowSymLinks/Options None/g' /etc/apache2/apache2.conf
		sed -i '/Options None/{ N; s/Options None/Options None\n  LimitRequestBody 512000/}' /etc/apache2/apache2.conf

		sed -i 's/ServerTokens OS/ServerTokens off/g' /etc/apache2/apache2.conf
		sed -i 's/ServerSignature On/ServerSignature off/g' /etc/apache2/apache2.conf

		sed -i '/Timeout/c\Timeout 30' /etc/apache2/apache2.conf
		sed -i '/Timeout 30/{ N; s/Timeout 30/Timeout 30\nMaxClients 25/}' /etc/apache2/apache2.conf
		echo -e '\e[01;37;42mThe apache2.conf file has been successfully edited!\e[0m'

	# Restarts the apache2 service
		echo -e '\e[01;34m+++ Restarting the apache2 service\e[0m'
		service apache2 restart
		echo -e '\e[01;37;42mThe apache2 service has been successfully restarted!\e[0m'
}
function doAll(){
	# Calls Function 'install_mod_security'
		echo
		echo
		echo -e "\e[33m=== Install the mod_seurity Apache2 module ? (y/n)\e[0m"
		read yesno
		if [ "$yesno" = "y" ]; then
			install_mod_security
		fi

	# Calls Function 'install_mod_evasive'
		echo
		echo -e "\e[33m=== Install the mod_evasive Apache2 module ? (y/n)\e[0m"
		read yesno
		if [ "$yesno" = "y" ]; then
			install_mod_evasive
		fi

	# Calls Function 'install_mod_qos'
		echo
		echo -e "\e[33m=== Install the mod_qos Apache2 module ? (y/n)\e[0m"
		read yesno
		if [ "$yesno" = "y" ]; then
			install_mod_qos
		fi

	# Calls Function 'install_mod_spamhaus'
		echo
		echo -e "\e[33m=== Install the mod_spamhaus Apache2 module ? (y/n)\e[0m"
		read yesno
		if [ "$yesno" = "y" ]; then
			install_mod_spamhaus
		fi

	# Calls Function 'edit_apache2.conf'
		echo
		echo -e "\e[33m=== Edit the /etc/apache2/apache2.conf ? (y/n)\e[0m"
		read yesno
		if [ "$yesno" = "y" ]; then
			edit_apache2.conf
		fi

	# End of Script Congratulations, Farewell and Additional Information
		clear
		FARE=$(cat << EOZ


             \e[01;37;42mWell done! You have completed your securing Apache2! \e[0m


  \e[30;01mCheckout similar material at midactstech.blogspot.com and github.com/Midacts\e[0m

                            \e[01;37m########################\e[0m
                            \e[01;37m#\e[0m \e[31mI Corinthians 15:1-4\e[0m \e[01;37m#\e[0m
                            \e[01;37m########################\e[0m
EOZ
)

		#Calls the End of Script variable
		echo -e "$FARE"
		echo
		echo
		exit 0
}

# Check privileges
	[ $(whoami) == "root" ] || die "You need to run this script as root."

# Welcome to the script
	clear
	welcome=$(cat << EOA


             \e[01;37;42mWelcome to Midacts Mystery's Securing Apache2 Script!\e[0m


EOA
)

# Calls the welcome variable
	echo -e "$welcome"

# Calls the doAll function
	case "$go" in
		* )
			doAll ;;
	esac

exit 0

