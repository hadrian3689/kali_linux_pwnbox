#!/bin/bash

new_terminal () {

	echo "Changing Terminals"
	for homedir in /home/*; do cp "$homedir"/.zshrc "$homedir"/.zshrc.bak; done 
	for homedir in /home/*; do cp zshrc "$homedir"/.zshrc; done
	cp ~/.zshrc ~/.zshrc.bak 
	cp zshrc ~/.zshrc
	echo "Done! Open up a terminal to see the changes!"
	echo "Your original terminals are in ~./zshrc.bak for each user"
	echo "All of the essential files have been put in place. Please follow the remaining steps from https://readysetexploit.wordpress.com/2021/09/24/hack-the-box-kali-pwnbox/#pwnboxtheme"
	exit 0
}

file_moving () {
	echo "Creating DIR /opt/pwnbox/"
	mkdir /opt/pwnbox
	echo "Copying Scripts"
	cp vpn*.sh /opt/pwnbox/
	chmod +x /opt/pwnbox/*.sh
	echo "Copying Remaining essential files:"
	cp -R htb/ /usr/share/icons/
	cp -R Material-Black-Lime-Numix-FLAT/ /usr/share/icons/
	cp *.jpg /usr/share/backgrounds/
	new_terminal

}

vpn_copy () {
	echo "Copying VPN file to /etc/openvpn/"
	file=$(echo *.ovpn | sed 's/.ovpn//') 
	cp *.ovpn /etc/openvpn/"$file".conf
	file_moving
}


file_check () {
	read -p "Do you have your VPN file in this current directory? y or n? " answer

	if [[ "$answer" == "y" ]];then
		if [ -f *.ovpn ]; then 
			vpn_copy
		else
			echo "Make sure VPN file is in the current directory then run this script"
			exit 1
		fi	

	elif [[ "$answer" == "n" ]]; then
		echo "Make sure VPN file is in the current directory then run this script"
		exit 1
	else
		echo "Wrong input try again"
		exit 1
	fi
}

root_check () {
	if [[ "$(whoami)" != root ]]; then
		echo "You are not root. You are the $(whoami) user. Run this script as root with sudo ./initial_file_setup.sh or or sudo su to root and ./initial_file_setup.sh :)"
		exit 1
	else
		echo "You are root :) let's begin"
		file_check 
	fi
}

root_check