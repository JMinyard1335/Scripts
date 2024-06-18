#!/bin/bash

PACKAGE_LIST=(
    perl
    make
    cmake
    clang
    clang-tools-extra
    gcc
    gdb
    python
    python-pip
    python-numpy
    python-virtualenv
    emacs
    aspell
    git
    github-cli
    nodejs
    gnupg
)
PS3='Select an option: '
options=("Set Info" "Update pacman" "Install Packages" "Set Up Git" "Set up Emacs" "Quit")

get_info() {
    read -p "Enter Your Name: " name
    read -p "Enter Your Email: " email
    export MYNAME=$name
    export MYEMAIL=$email
}

# Function to check internet connection using ping
check_ping() {
    ping -c 1 8.8.8.8 &> /dev/null
}

# Function to check internet connection using curl
check_curl() {
    curl -s --head http://www.google.com | head -n 1 | grep "HTTP/1.[01] [23].." &> /dev/null
}

checking_for_network() {
    if check_ping | check_curl; then
        echo "Internet connection is available."
	return 0
    else
	echo "No Conectionn"
	return 1
    fi
}

# Function to update pacman
update_pacman() {
    pacman -Syu
}

install_packages() {
    read -p "Installing Packages May take a bit. Continue? (y/n) " res
    if [ $res == "y" ]; then
	pacman -S "${MINGW_PACKAGE_PREFIX}-${PACKAGE_LIST[@]}"    
    else
	echo "Packages will not be installed."
    fi    
}

clone_repos() {
    git config --global user.name $MYNAME
    git config --global user.email $MYEMAIL
    echo "your git credentials are:"
    git config --global user.name
    git config --global user.email
    sleep 2
    echo "Configuring Git Branch"
    git config --global init.defaultBranch main
    echo "Login In to github with https, This will open a web browser"
    gh auth login -p https -w
}

set_up_emacs() {
    gh repo clone JMinyard1335/Emacs-Stuff
    mkdir ~/.emacs.d/
    cp Emacs-Stuff/init.el ~/.emacs.d/init.el 
}

while true; do
    select opt in "${options[@]}"; do
	case $opt in
	    "Set Info")
		get_info
		echo "Your Info is as Follows: "
		echo  "User Name: ${MYNAME}"
		echo "Email: ${MYEMAIL}"
		break
		;;
	    "Update pacman")
		echo "Checking for a Network Connection"
		if checking_for_network; then
		    echo "Updating Pacman"
		    update_pacman
		fi
		break
		;;
	    "Install Packages")
		install_packages
		break
		;;
	    "Set Up Git")
		clone_repos
		break
		;;
	    "Set up Emacs")
		set_up_emacs
		break
		;;
	    "Quit")
		echo "Closing Setup"
		exit 0
		;;
	    *) echo "Invalid option"
	       ;;
	esac
    done
done

