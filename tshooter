#! /bin/bash

# This script was created to help troubleshoot issues realted to Jamf not loading properly
# Created by Austin Harshberger (2018)

# Function to check internet connection
function test_internet()
{
	echo "Checking fix..."
	sleep 2
	nc -z 8.8.8.8 53  >/dev/null 2>&1
	online=$?
	if [ $online -eq 0 ]; then
	    echo "Computer Online!"
        echo ""
	else
	    echo "Offline"
	    echo "----> Couldn't fix internet"
	    echo ""

	    while true; do
        read -p "Connect to AKQA-Guest? " yn
        case $yn in
            [Yy]* ) connect_to_guest; break;;
            [Nn]* ) echo "Consider plugging in ethernet (physical internet connection)"; break;;
            * ) echo "Please answer yes or no.";;
        esac
    done
	fi
}

# Function to confirm computer restart and then perform restart
function restart_yes_no()
{
    while true; do
        read -p "Are you sure you would like to restart? " yn
        case $yn in
            [Yy]* ) echo restarting; sudo shutdown -r now; break;;
            [Nn]* ) break;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

# Check and fix internet connection
function check_internet()
{
	echo "Checking internet connection..."
	nc -z 8.8.8.8 53  >/dev/null 2>&1
	online=$?
	if [ $online -eq 0 ]; then
	    echo "Computer Online"
	else
	    echo "Offline"
	    echo ""
	    echo "Trying to fix..."
	    echo ""
	    networksetup -setairportpower en0 off
	    echo "Turning on..."
	    echo ""
	    networksetup -setairportpower en0 on
	    sleep 5
	    test_internet
	fi
}

# Function to connect to guest Wifi at work
function connect_to_guest()
{
	# Notify
	echo "Connecting to AKQA-Guest Wifi..."
	# Connect to guest Wifi				SSID	   Wifi Password
	networksetup -setairportnetwork en0 AKQA-Guest discover
	#Pause to verify connection
	sleep 3
	# Check internet
	check_internet
}

# Function to request sudo privileges 
function ask_for_sudo()
{
	echo "Please enter user: ${USER}'s password to start script."
	# Request user to enter sudo priv
	if [ $EUID != 0 ]; then
	    sudo "$0" "$@"
	    exit $?
	fi

	clear
}

# Function to change to currenty directory
function change_dir()
{
	DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
	cd $DIR

	# Copy assets
	cp -rp ./Assets ~/Documents
}

# Function to update JSS inventory
function jamf_recon()
{
	sudo jamf recon &
	PREV=$!

	while kill -0 $PREV 2> /dev/null; do
		echo "Running Jamf Recon"
		clear
	    echo "Running Jamf Recon."
	    clear
	    echo "Running Jamf Recon.."
	    clear
	    echo "Running Jamf Recon..."
	done

	clear
	echo "Jamf Recon complete."

	sleep 2
}

function jamf_policy()
{
		# Checking w/ Jamf to make sure all policies are loaded
	sudo jamf policy &
	PREV=$!

	while kill -0 $PREV 2> /dev/null; do
		echo "Checking Jamf"
		clear
	    echo "Checking Jamf policies."
	    clear
	    echo "Checking Jamf policies for.."
	    clear
	    echo "Checking Jamf policies for updates..."
	done

	clear
	echo "Jamf policies up to date."

	sleep 2

}

function standard_dock()
{
	/usr/local/bin/dockutil --remove all --allhomes --no-restart
	/usr/local/bin/dockutil --add '~/Downloads' --no-restart
	/usr/local/bin/dockutil --add /Applications/Launchpad.app --no-restart
	/usr/local/bin/dockutil --add /Applications/Self\ Service.app --no-restart
	/usr/local/bin/dockutil --add /Applications/Safari.app --no-restart
	/usr/local/bin/dockutil --add /Applications/Google\ Chrome.app --no-restart
	/usr/local/bin/dockutil --add /Applications/Slack.app --no-restart
	/usr/local/bin/dockutil --add /Applications/Keynote.app --no-restart
	/usr/local/bin/dockutil --add /Applications/Skype\ for\ Business.app --no-restart
	/usr/local/bin/dockutil --add /Applications/Microsoft\ Outlook.app --no-restart
	/usr/local/bin/dockutil --add /Applications/Microsoft\ Word.app --no-restart
	/usr/local/bin/dockutil --add /Applications/Microsoft\ Excel.app --no-restart
	/usr/local/bin/dockutil --add /Applications/Microsoft\ PowerPoint.app --no-restart
	/usr/local/bin/dockutil --add /Applications/System\ Preferences.app
}

function creative_dock()
{
	/usr/local/bin/dockutil --remove all --allhomes --no-restart
	/usr/local/bin/dockutil --add '~/Downloads' --no-restart
	/usr/local/bin/dockutil --add /Applications/Launchpad.app --no-restart
	/usr/local/bin/dockutil --add /Applications/Self\ Service.app --no-restart
	/usr/local/bin/dockutil --add /Applications/Safari.app --no-restart
	/usr/local/bin/dockutil --add /Applications/Google\ Chrome.app --no-restart
	/usr/local/bin/dockutil --add /Applications/Slack.app --no-restart
	/usr/local/bin/dockutil --add /Applications/Keynote.app --no-restart
	/usr/local/bin/dockutil --add /Applications/Skype\ for\ Business.app --no-restart
	/usr/local/bin/dockutil --add /Applications/Microsoft\ Outlook.app --no-restart
	/usr/local/bin/dockutil --add /Applications/Microsoft\ Word.app --no-restart
	/usr/local/bin/dockutil --add /Applications/Microsoft\ Excel.app --no-restart
	/usr/local/bin/dockutil --add /Applications/Microsoft\ PowerPoint.app --no-restart
	/usr/local/bin/dockutil --add /Applications/Keynote.app --no-restart
	/usr/local/bin/dockutil --add /Applications/Adobe\ Bridge\ CC\ 2018/Adobe\ Bridge\ CC\ 2018.app --no-restart
	/usr/local/bin/dockutil --add /Applications/Adobe\ Photoshop\ CC\ 2018/Adobe\ Photoshop\ CC\ 2018.app --no-restart
	/usr/local/bin/dockutil --add /Applications/Adobe\ Illustrator\ CC\ 2018/Adobe\ Illustrator.app --no-restart
	/usr/local/bin/dockutil --add /Applications/Adobe\ InDesign\ CC\ 2018/Adobe\ InDesign\ CC\ 2018.app --no-restart
	/usr/local/bin/dockutil --add /Applications/FontExplorer\ X\ Pro.app --no-restart
	/usr/local/bin/dockutil --add /Applications/System\ Preferences.app
}

function set_dock()
{

	while true; do

			clear
			echo "Choose an option:"
			echo ""
			echo "0. Standard Dock"
			echo "1. Creative Dock"
			echo ""
			echo "2. Exit"
			echo ""
			echo "-> Enter either(0) or (1) ...(2) to exit"
			echo ""

			read choice
			only_number
			if [ $choice -eq 0 ]; then
				standard_dock
			elif [ $choice -eq 1 ]; then
				creative_dock
			elif [ $choice -eq 2 ]; then
				echo ""; echo "Going back to main menu..."; break;
			else 
				echo "-> Please choose either (0) or (1) ...(2) to exit"
			fi
	done
}

# Function to open Console to view Jamf policies
function open_console()
{
	opened=1
	if ! [ $choice -eq 4 ]; then
		open /private/var/log/jamf.log
	fi
}

# Function to troubleshoot Jamf
function jamf_troubleshooter(){

	while true; do

		clear
		echo "Choose an option:"
		echo ""
		echo "0. Enroll in Jamf via self-serve"
		echo "1. Run Jamf Recon (update JSS inventory w/ device)"
		echo "2. Run Jamf Policy (check for and update policies on JSS)"
		echo "3. Both"
		echo ""
		echo "4. Exit"
		echo ""
		echo "-> Enter an option between (0) and (3) ...(4) to exit"
		echo ""

		read choice
		only_number
		if [ $choice -eq 0 ]; then
			jamf_selfserve
		elif [ $choice -eq 1 ]; then
			open_console && time jamf_recon && sleep 3
		elif [ $choice -eq 2 ]; then
			open_console && time jamf_policy  && sleep 3
		elif [ $choice -eq 3 ]; then
			open_console && jamf_recon && jamf_policy
		elif [ $choice -eq 4 ]; then
			echo ""; echo "Going back to main menu..."; break;
		else 
			echo "-> Please choose between (0) and (3) ...(4) to exit"
		fi

		# Close console log
		if [ $opened -eq 1 ]; then
			osascript -e 'quit app "Console"'
		fi
		$opened=0

	done
}

# Function to check for updates
function check_updates()
{
	clear
	# Checking for and installing any macOS updates
	softwareupdate -ai
	while true; do
		echo ""
	    read -p "Do any updates require restart? " yn
	    case $yn in
	        [Yy]* ) restart_yes_no; break;;
	        [Nn]* ) break;;
	        * ) echo "Please answer yes or no.";;
	    esac
	done
}

# Function to download self-serve profile from internet + run policy updates
function jamf_selfserve()
{
	echo "Opening enrollment download in browser..."
	echo ""
	echo "***Please consider updating and running Jamf Policy when download is complete."
	echo ""
	sleep 2
	open https://jamfpro.na.akqa.net:8443/enroll

	while true; do
		echo ""
	    read -p "Finished installing MDM profile? " yn
	    echo ""
	    case $yn in
	        [Yy]* ) break;;
	        [Nn]* ) sleep 3;;
	        * ) echo "Please answer yes or no.";;
	    esac
	done

    # clean-up
    rm -rf ~/Downloads/enrollmentProfile.mobileconfig
    osascript -e 'quit app "Safari"'
    osascript -e 'quit app "System Preferences"'
}

# Restrict input to only be a number
function only_number()
{
	if ! [[ "$choice" =~ ^[0-9]+$ ]]
	    then
	        echo "***Please enter a number between 0-11 (In order to specify the action you want to perform)."
	        echo ""
	        sleep 2
	       	clear
	        continue

	fi
}

# Add Info page to Desktop with useful details for new employees
function info_page()
{
	change_dir
	cp ./Assets/info.html ~/Desktop/AKQA\ Tips\ +\ Tricks.html
}

# Function to securely obtain admin password for new admin account
function get_admin_password()
{
	LOCAL_ADMIN_FULLNAME="AKQA_IT"     # The local admin user's full name
	LOCAL_ADMIN_SHORTNAME="akqait"     # The local admin user's shortname
	
	echo -n "Enter admin password for new admin account -> ${LOCAL_ADMIN_FULLNAME}: " 
	
	read -s LOCAL_ADMIN_PASSWORD  		   # Get the local admin user's password
	
	echo ""
	echo ""
	echo "Admin password for ${LOCAL_ADMIN_FULLNAME} is: ${LOCAL_ADMIN_PASSWORD}"
	
	sleep 2
	
	while true; do
		echo ""
	    read -p "Want to change it? " yn
	    echo ""
	    case $yn in
	        [Yy]* ) get_admin_password; break;;
	        [Nn]* ) break;;
	        * ) echo "Please answer yes or no.";;
	    esac
	done

}

# Create Admin account
function create_admin()
{
	change_dir
	get_admin_password

	# Add user image
	sudo cp ~/Documents/Assets/user.png /Library/User\ Pictures

	# Create a local admin user account
	sudo dscl . -create /Users/$LOCAL_ADMIN_SHORTNAME
	sudo dscl . -create /Users/$LOCAL_ADMIN_SHORTNAME UserShell /bin/bash
	sudo dscl . -create /Users/$LOCAL_ADMIN_SHORTNAME RealName $LOCAL_ADMIN_FULLNAME
	sudo dscl . -create /Users/$LOCAL_ADMIN_SHORTNAME UniqueID 1001
	sudo dscl . -create /Users/$LOCAL_ADMIN_SHORTNAME PrimaryGroupID 81
	sudo dscl . -create /Users/$LOCAL_ADMIN_SHORTNAME NFSHomeDirectory /Local/Users/$LOCAL_ADMIN_SHORTNAME
	
	sudo dscl . -passwd /Users/$LOCAL_ADMIN_SHORTNAME $LOCAL_ADMIN_PASSWORD
	sudo dscl . -append /Groups/admin GroupMembership $LOCAL_ADMIN_SHORTNAME

	sudo dscl . create /Users/$LOCAL_ADMIN_SHORTNAME Picture "/Library/User Pictures/user.png"

	echo ""
	echo "Must restart to take effect..."
	echo ""
	restart_yes_no
}

# Check File Vault status
function check_file_vault()
{
	echo "Checking FileVault status..."
	echo ""
	fdesetup status
	echo ""
	while true; do
	    read -p "Want to enable FileVault? " yn
	    case $yn in
	        [Yy]* ) file_vault_enable; break;;
	        [Nn]* ) break;;
	        * ) echo "Please answer yes or no.";;
	    esac
	done
}

# To enable File Vault
function file_vault_enable()
{	
	echo ""
	echo "Verifying..."
	echo ""
	echo "Removing old plist..."
	echo ""
	sudo rm -rf /Library/Preferences/com.apple.security.FDERecovery.plist
	sudo fdesetup enable

	echo ""
	echo "To finish enabling FileVault, the machine needs to restart..."
	echo ""
	restart_yes_no
}


# Change Desktop wallpaper
function change_wall()
{
	change_dir
	cp ./Assets/AKQA_WP.jpg /Library/Desktop\ Pictures/
	osascript -e 'tell application "Finder" to set desktop picture to POSIX file "/Library/Desktop Pictures/AKQA_WP.jpg"'
}

# Clean up and beautify
function clean_beauty()
{
	# Open apps
	open /Applications/Enterprise\ Connect.app/

	# Clear trash
	rm -rf ~/.Trash*/

	# Change wallpaper
	change_wall

	echo "Done beautifying..."
	echo ""
}

# Function to prompt with options
function prompt()
{

	# Display choices
	echo ""
	echo "Choose an option:"
	echo ""
	echo "0. Add AKQA Tips + Tricks webpage to Desktop"
	echo "1. Test internet connection"
	echo "2. Connect to guest Wifi at AKQA"
	echo "3. Open self-serve"
	echo "4. Run Jamf troubleshooter"
	echo "5. Check for software updates"
	echo "6. Set AKQA wallpaper"
	echo "7. Configure Dock"
	echo "8. Create Admin user"
	echo "9. Enable FileVault"
	echo ""
	echo "10. Restart computer"
	echo "11. Clean and beautify"
	echo "12. Exit"
	echo ""
	
	# Get user choice
	echo "-> Enter an option between (0) and (11) ...(12) to exit"
	echo ""

	read choice
	only_number

	echo ""

	if [ $choice -eq 0 ]; then
		info_page
	elif [ $choice -eq 1 ]; then
		check_internet
	elif [ $choice -eq 2 ]; then
		connect_to_guest
	elif [ $choice -eq 3 ]; then
		open /Applications/Self\ Service.app/
	elif [ $choice -eq 4 ]; then
		jamf_troubleshooter
	elif [ $choice -eq 5 ]; then
		check_updates
	elif [ $choice -eq 6 ]; then
		change_wall
	elif [ $choice -eq 7 ]; then
		set_dock
	elif [ $choice -eq 8 ]; then
		create_admin
	elif [ $choice -eq 9 ]; then
		check_file_vault
	elif [ $choice -eq 10 ]; then
		restart_yes_no
	elif [ $choice -eq 11 ]; then
		clean_beauty
	elif [ $choice -eq 12 ]; then
		echo "Bye..." && echo "" && sleep 1 && clear && exit 0
	else
		echo "***Please enter a number between 0-12 (In order to specify the action you want to perform)."
		echo ""
	fi

}

# Start the script
clear

# Ask for user password
ask_for_sudo

# Start prompt
while true; do
	prompt
	sleep 1.5
	clear
done




