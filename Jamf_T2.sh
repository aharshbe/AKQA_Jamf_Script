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
	        echo "!! Please enter a number between 1-9 (In order to specify the action you want to perform)."
	        echo ""
	        sleep 2
	       	clear
	        continue

	fi
}

# Add Info page to Desktop with useful details for new employees
function info_page()
{
	DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

	cd $DIR
	cp -rp ./Assets ~/Documents
	cp ./Assets/info.html ~/Desktop/AKQA\ Tips\ +\ Tricks.html
}

# Create Admin account
function create_admin()
{
	account_name="AKQA IT"

	dscl . -create /Users/$account_name
	dscl . -create /Users/$account_name UserShell /bin/bash
	dscl . -create /Users/$account_name RealName "AKQA IT" 
	dscl . -create /Users/$account_name UniqueID "510"
	dscl . -create /Users/$account_name PrimaryGroupID 80
	dscl . -create /Users/$account_name NFSHomeDirectory /Users/$account_name
	dscl . -passwd /Users/$account_name password
	dscl . -append /Groups/admin GroupMembership $account_name

	echo ""
	echo "Must restart to take effect..."
	echo ""
	restart_yes_no
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
	echo "6. **Update software & Jamf policies"
	echo "7. Create Admin user"
	echo "8. Restart computer"
	echo "9. Clear screen"
	echo ""
	echo "10. Exit"
	echo ""
	
	# Get user choice
	echo "-> Enter an option between (0) and (9) ...(10) to exit"
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
		jamf_troubleshooter && check_updates
	elif [ $choice -eq 7 ]; then
		create_admin
	elif [ $choice -eq 8 ]; then
		restart_yes_no
	elif [ $choice -eq 9 ]; then
		clear && prompt
	elif [ $choice -eq 10 ]; then
		clear && exit 0
	else
		echo "!! Please enter a number between 1-10 (In order to specify the action you want to perform)."
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




