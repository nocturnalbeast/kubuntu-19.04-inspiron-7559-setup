#!/bin/bash

################################################################################
# This is a setup script that installs a few things such as preferred
# applications and themes, and and fixes the DPI issues with KDE.
# Use the command './setup.sh -h' to know about the things installed,
# or just read the script.
# Happy setup!
################################################################################


NAME=$(basename "$0")
VER="1.0"

function echo_message() {

	local COLOR=$1
	local MESSAGE=$2
	if ! [[ $COLOR =~ '^[0-9]$' ]] ; then
		case $(echo -e $COLOR | tr '[:upper:]' '[:lower:]') in
			error) COLOR=1 ;;
			success) COLOR=2 ;;
			warning) COLOR=3 ;;
			info) COLOR=4 ;;
			question) COLOR=5 ;;
			normal) COLOR=6 ;;
			*) COLOR=7 ;;
		esac
	fi
	tput bold
	tput setaf $COLOR
	echo -e " -- $MESSAGE"
	tput sgr0

}

function usage() {

echo
echo_message white "$NAME -- version $VER

    Usage: $NAME [OPTIONS]
    
    Options:
      -h, --help         Show this help window
      -v, --version      Display script version
      -u, --update       Run package update
      -i, --install      Install NVIDIA drivers and fix GRUB
      -f, --fixdpi       Fix KDE's scaling
      -t, --tools        Install preferred tools, fonts and themes"

}

function update_system() {

	# you know what this does.
	echo_message info "Updating system packages..."
	sudo apt update
	sudo apt -y upgrade

}

function install_nvidia() {

	# first let's add the nonfree graphics drivers repo
	echo_message info "Adding nonfree graphics drivers repository..."
	sudo add-apt-repository ppa:graphics-drivers/ppa
	# then let's update the system before we continue
	update_system
	# then install nvidia-390, a stable driver
	echo_message info "Installing drivers for NVIDIA GPU..."
	sudo apt install nvidia-390
	# but we don't want to use the GPU all the time, do we?
	echo_message info "Setting the default GPU to Intel..."
	sudo prime-select intel
	# let's eke out a little more battery life out of this one
	echo_message info "Installing TLP for better battery management..."
	sudo apt install tlp tlp-rdw

}

function setup_boot() {

	# first let's add some pizazz
	echo_message info "Installing Poly theme by shvchk..."
	echo_message question "Which do you prefer, the light variant or the dark one? [L/d]" && read CH
	case $CH in
		[Ll]* ) wget -O - https://github.com/shvchk/poly-light/raw/master/install.sh | bash ;;
		[Dd]* ) wget -O - https://github.com/shvchk/poly-dark/raw/master/install.sh | bash ;;
		* ) wget -O - https://github.com/shvchk/poly-light/raw/master/install.sh | bash ;;
	esac

	echo_message info "Setting up GRUB..."

	# then let's use the preset GRUB configuration file we have here
	sudo cp ./files/grub /etc/default/grub

	# then proceed to update GRUB
	sudo update-grub

}

function install_tools() {

	# install vs-code
	echo_message info "Installing VS Code..."
	wget 'https://go.microsoft.com/fwlink/?LinkID=760868' -o code.deb
	sudo dpkg -i code.deb
	sudo apt install --fix-missing

	# install preferred vs-code extensions
	echo_message info "Installing preferred VS Code extensions..."
	for EXT in $(cat ./files/code-exts.list); do
		code --install-extension $EXT
	done

	# install gimp
	echo_message "Installing GIMP..."
	sudo apt install gimp

	# remove vlc and install mpv
	echo_message info "Installing MPV..."
	sudo apt purge --auto-remove vlc
	sudo apt install mpv

	# install typora
	echo_message info "Installing Typora..."
	wget -qO - https://typora.io/linux/public-key.asc | sudo apt-key add -
	sudo add-apt-repository 'deb https://typora.io/linux ./'
	sudo apt-get update
	sudo apt-get install typora

	# deadbeef for music
	echo_message info "Installing DeadBeef..."
	sudo apt-add-repository ppa:starws-box/deadbeef-player
	sudo apt update
	sudo apt install deadbeef

	# install libreoffice
	echo_message info "Installing Libreoffice..."
	sudo apt install libreoffice

}

# TODO: ...
function install_fonts() {
}

# TODO: finish it.
function install_themes() {

	# install the papirus icon theme
	echo_message info "Installing Papirus icon theme..."
	sudo add-apt-repository ppa:papirus/papirus
	sudo apt-get update
	sudo apt-get install papirus-icon-theme

	# install the papirus libreoffice theme, cause the default one isn't that great
	sudo apt-get install libreoffice-style-papirus

	# install the KDE-story theme

	# setup the SDDM theme
	echo_message info "Installing SDDM theme..."
	git clone https://github.com/Eayu/sddm-theme-clairvoyance
	sudo apt install fonts-firacode
	cp ./files/wall-blur.jpg sddm-theme-clairvoyance/Assets/Background.jpg
	sudo mv sddm-theme-clairvoyance /usr/share/sddm/themes/clairvoyance
	# TODO: set active SDDM theme

	# change the wallpaper
	echo_message info "Getting you a wallpaper that doesn't wanna make you puke..."
	mkdir -p ~/Pictures/Wallpapers
	cp wall.jpg ~/Pictures/Wallpapers/
	# TODO: set wallpaper

	# color scheme for terminal
	echo_message info "Spicing up that terminal..."
	cp -r ./files/konsole ~/.local/share/
	# TODO: set terminal profile

	# set the fonts and themes
}

function fix_kde_dpi() {

	# use our supplied file, which fixes the virtual keyboard bug and also scales well for HiDPI
	echo_message info "Fixing SDDM scaling..."
	sudo cp ./files/sddm.conf /etc/sddm.conf

	# copy over the files from config, which contains fixes for scaling on HiDPI screens
	echo_message info "Fixing KDE scaling..."
	cp ./files/config/* ~/.config/

}

for ARG in "$@"; do
	case $ARG in
		-h|--help)
			usage
			exit 0
			;;
		-v|--version)
			echo_message info "$NAME -- version $VER"
			exit 0
			;;
		-u|--update)
			update_system
			exit 0
			;;
		-i|--install)
			install_nvidia
			setup_boot
			exit 0
			;;
		-f|--fixdpi)
			fix_kde_dpi
			exit 0
			;;
		-t|--tools)
			install_tools
			install_fonts
			install_themes
			exit 0
			;;
		*)
			echo_message error "Option does not exist: $ARG"
			echo_message error "Use $NAME -h for help."
			exit 2
			;;
	esac
done







