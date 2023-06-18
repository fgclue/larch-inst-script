echo "Welcome to Arch Linux!"
echo "==> Create user:"
accountCreation() {
	read -p "Username: " usernameSelected
	if [[ $usernameSelected =~ ^[[:lower:]_][[:lower:][:digit:]_-]{2,15}$ ]]
	then
		echo "=> Valid username. Creating account!"
		passwd $usernameSelected
		echo "==> Configuring system..."
		echo "=> Downloading dotfiles..."
		git clone https://github.com/fgclue/dotfiles
		cd dotfiles
		rm -rf .git
		rm README.md
		rm screenshot.png
		rm screenshot.xcf
		rm screenshot1.png
		mv .bashrc /home/$usernameSelected/
		mv .vimrc /home/$usernameSelected/
		mv * /home/$usernameSelected/.config/
		echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers
		echo "==> Please log in as the user you created. DO NOT LOGIN AS ROOT!"
		read -p "Press any key to reboot."
	else
		echo "=> Invalid username. Please try again."
		accountCreation
	fi
}
accountCreation
