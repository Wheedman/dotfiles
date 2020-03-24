#!/bin/bash
function print_help_msg() {
	cat <<-EOF
	Usage: install.sh TARGET
	TARGET := { all,
				nogui
				android_studio_canary
				android_studio_release
				autorandr
				bash
				git
				ideavim
				intellij_idea
				ranger
				readline
				vim
				zsh
				X
			}
EOF
}

function get_distribution_name() {
	IFS="="
	read -a test < /etc/os-release
	echo "${test[1]:1:-1}"
}

function get_packager_cmd() {
	case "$(get_distribution_name)" in
		"Arch Linux" )
			if yay_location="$(type -p yay)" && [ -n "$yay_location" ]; then
				echo "yay -S"
				return 0
			elif trizen_location="$(type -p trizen)" && [ -n "$trizen_location" ]; then
				echo "trizen -S"
				return 0
			elif yaourt_location="$(type -p yaourt)" && [ -n "$yaourt_location" ]; then
				echo "yaourt -S"
				return 0
			elif pacman_location="$(type -p pacman)" && [ -n "$pacman_location" ]; then
				echo "sudo pacman -S"
				return 0
			fi
			;;
	esac
	echo ""
	return 1
}

function install() {
	local TARGET="$1"
	echo -e "Do you want to install \033[1;33m$TARGET\033[0m [(Y)es/(n)o]:"
	read line
	if [[ "$line" == Y* ]] || [[ "$line" == y* ]] || [ -z "$line" ]; then
		echo -e "Do you want to install the packages for \033[1;33m$TARGET\033[0m [(Y)es/(n)o]:"
		read line
		if [[ "$line" == Y* ]] || [[ "$line" == y* ]] || [ -z "$line" ]; then
			install_packages $TARGET
		fi
		install_additional $TARGET
		post_install $TARGET
		link_config $TARGET
	fi
}

echo "Detected distribution $(get_distribution_name)"

# Check if script is called from the dotfiles folder
# If not, link creation will not work
if [[ $0 != "./install.sh" ]]; then
	echo "Please execute the install script in the dotfiles folder"
	exit 1
fi

echo "Starting installation..."
if [[ $# -eq 0 ]]; then
	print_help_msg
	exit 0
elif [[ $# -gt 1 ]]; then
	echo "You can only specify one target"
	exit 1
else
	if [[ $1 = all ]]; then
		install android_studio_canary
		install android_studio_release
		install autorandr
		install bash
		install git
		install ideavim
		install intellij_idea
		install ranger
		install readline
		install vim
		install zsh
		install X
	elif [[ $1 == nogui ]]; then
		install bash
		install git
		install ranger
		install readline
		install vim
		install zsh
	elif [[ $1 = android_studio_canary ]]; then
		install android_studio_canary
	elif [[ $1 = android_studio_release ]]; then
		install android_studio_release
	elif [[ $1 = autorandr ]]; then
		install autorandr
	elif [[ $1 = bash ]]; then
		install bash
	elif [[ $1 = git ]]; then
		install git
	elif [[ $1 = ideavim ]]; then
		install ideavim
	elif [[ $1 = intellij_idea ]]; then
		install intellij_idea
	elif [[ $1 = ranger ]]; then
		install ranger
	elif [[ $1 = readline ]]; then
		install readline
	elif [[ $1 = vim ]]; then
		install vim
	elif [[ $1 = zsh ]]; then
		install zsh
	elif [[ $1 = X ]]; then
		install X
	else
		echo "$1 is not a valid Target"
		print_help_msg
	fi
fi
