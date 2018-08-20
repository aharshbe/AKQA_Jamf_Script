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
	# Request user to enter sudo priv
	if [ $EUID != 0 ]; then
	    sudo "$0" "$@"
	    exit $?
	fi
}

# Function to change to currenty directory
function change_dir()
{
	DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
	cd $DIR

	# Copy assets
	cp -rp ./Assets ~/Documents
}

# Function to troubleshoot Jamf
function jamf_troubleshooter(){

	# Open Console to view Jamf policies
	open /private/var/log/jamf.log

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
	echo "Jamf check complete."

	# Close console log
	osascript -e 'quit app "Console"'
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
		echo "!! Please consider running update and troubleshooter when download is complete. !!"
		echo ""
		sleep 2
		open https://jamfpro.na.akqa.net:8443/enroll

    	while true; do
    		echo ""
	        read -p "Run updates and troubleshooter? " yn
	        case $yn in
	            [Yy]* ) jamf_troubleshooter && check_updates; break;;
	            [Nn]* ) break;;
	            * ) echo "Please answer yes or no.";;
	        esac
    	done

    	while true; do
	        read -p "Open Self-serve? " yn
	        case $yn in
	            [Yy]* ) open /Applications/Self\ Service.app/; break;;
	            [Nn]* ) break;;
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
	        echo "!! Please enter a number between 0-11 (In order to specify the action you want to perform)."
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

# Create Admin account
function create_admin()
{
	change_dir
	
	LOCAL_ADMIN_FULLNAME="AKQA_IT"     # The local admin user's full name
	LOCAL_ADMIN_SHORTNAME="akqait"     # The local admin user's shortname
	LOCAL_ADMIN_PASSWORD="C0mr@de$"      # The local admin user's password

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
	open /Applications/Egnyte\ Desktop\ Sync.app
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
	echo "3. Enroll in Jamf via self-serve"
	echo "4. Run Jamf troubleshooter"
	echo "5. Check for software updates"
	echo "6. Set AKQA wallpaper"
	echo "7. Create Admin user"
	echo "8. Enable FileVault"
	echo "9. Restart computer"
	echo ""
	echo "10. Clean and beautify"
	echo "11. Exit"
	echo ""
	
	# Get user choice
	echo "-> Enter an option between (0) and (10) ...(11) to exit"
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
		jamf_selfserve
	elif [ $choice -eq 4 ]; then
		jamf_troubleshooter
	elif [ $choice -eq 5 ]; then
		check_updates
	elif [ $choice -eq 6 ]; then
		change_wall
	elif [ $choice -eq 7 ]; then
		create_admin
	elif [ $choice -eq 8 ]; then
		check_file_vault
	elif [ $choice -eq 9 ]; then
		restart_yes_no
	elif [ $choice -eq 10 ]; then
		clean_beauty
	elif [ $choice -eq 11 ]; then
		echo "Bye..." && echo "" && sleep 1 && clear && exit 0
	else
		echo "!! Please enter a number between 0-11 (In order to specify the action you want to perform)."
		echo ""
	fi

}

# Start the script

# Ask for user password
ask_for_sudo

# Start prompt
while true; do
	prompt
	sleep 1.5
	clear
done




