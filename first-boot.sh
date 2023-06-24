echo "Welcome to Arch Linux!"
echo "==> Create user:"
accountCreation() {
	read -p "Username: " usernameSelected
	if [[ $usernameSelected =~ ^[[:lower:]_][[:lower:][:digit:]_-]{2,15}$ ]]
	then
		cd /root/
		echo "=> Valid username. Creating account!"
		passwd $usernameSelected
		echo "==> Configuring system..."
		echo "=> Downloading dotfiles..."
		cd dotfiles
		rm -rf .git
		rm -rf old
		rm README.md
		mv .bashrc /home/$usernameSelected/
		mv .vimrc /home/$usernameSelected/
		mv * /home/$usernameSelected/.config/
		echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers
		echo "==> Please log in as the user you created. DO NOT LOGIN AS ROOT! Use /second-boot.sh if it does not automatically run."
		cd ..
		rm -rf dotfiles
		rm /root/.bash_profile
		cp /root/.bash_profile.bkp /root/.bash_profile
		cp /home/$usernameSelected/.bash_profile.bkp
		echo "/second-boot.sh" >> /home/$usernameSelected/.bash_profile
		read -p "Press any key to reboot."
	else
		echo "=> Invalid username. Please try again."
		accountCreation
	fi
}
accountCreation
