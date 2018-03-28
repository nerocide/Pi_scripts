#!/bin/bash
#
# Purpose: Install/Update Octoprint without loosing configuration
#
# Require: bash, echo
#
# Author: JM Collongette
#
# Licence: none
#
# Change Log:
#       0.1
#       - 
#
# TODO :
#       - 
# Variables
my_date=`date +%F`
version=0.1
nb_args=$#
octohome=$HOME/OctoPrint
usage="Usage: `basename $0` [option]\nVersion $version
\n
\t\t-h\tprint help\n
\t\t-a\tAutodetect actions\n
\t\t-i\tInstall\n
\t\t-u\tUpdate\n
\t\t-r\tReinstall\n
"

#cd ~
#mkdir ~/.octoprint

###############Functions###################
# stop
stop(){
	sudo service octoprint stop
}
# start
start(){
	sudo service octoprint start
}
# backup_config(){
backup_config(){
	sudo /bin/cp -dprf .octoprint .octoprint_backup.$my_date
}

# restore_config
restore_config(){
	sudo mv .octoprint_backup.$my_date .octoprint
}

# install prerequisites
install_prereq(){
	sudo apt-get update
	sudo apt-get -y upgrade
	sudo apt-get -y install python-pip python-dev python-setuptools python-virtualenv git libyaml-dev
}
# install
install(){
	cd $HOME
	git clone https://github.com/foosel/OctoPrint.git
	cd $octohome
	virtualenv --system-site-packages venv
	./venv/bin/python setup.py install
	sudo usermod -a -G tty pi
	sudo usermod -a -G dialout pi
	# copy service file for service management
	sudo cp scripts/octoprint.init /etc/init.d/octoprint
	sudo chmod +x /etc/init.d/octoprint
	sudo cp scripts/octoprint.default /etc/default/octoprint
	# change config to fit ours
	sudo sed -i "s/#BASEDIR/BASEDIR/" /etc/default/octoprint
	sudo sed -i "s/#DAEMON/DAEMON/" /etc/default/octoprint
	sudo sed -i "s/#CONFIGFILE/CONFIGFILE/" /etc/default/octoprint
	# enable octoprint at startup
	sudo systemctl enable octoprint

}
# update
update(){
	cd $octohome
	git pull
	./venv/bin/python setup.py install
}

# delete
delete(){
	sudo rm -Rf OctoPrint
	sudo rm -Rf .octoprint
}
#
function check_args(){
	if [ $nb_args -eq 0 ]
	then
		echo "Please provide arguments"
		echo -e $usage
		exit 1
	fi
}
# autodetect
autodetect(){
 echo "autodetect"
}
######################################
# Check pi user
if [ `whoami` = "pi" ] 
then
	echo "You are Pi :) <3 Let's start <3"
	#Process arguments
else
	echo "Pi user is expected to run this script"
	exit 1
fi

# Making sure we know what to do...processing arguments check
check_args
#
while getopts "iruah" optname 
do
	case "$optname" in
		"h")
			echo -e $usage
			exit 0;
			;;
		"i")
			install_prereq
			install
			exit 0;
			;;
		"r")
			echo "Forced reinstall"
			stop
			backup_config
			delete
			install
			#restore_config
			start
			;;
		"u")
			echo "Updating"
			stop
			update
			start
			;;
		"a")
			echo "Autodetect not implemented yet"
			;;
		"?")
			echo "Unknown option $OPTARG"
			exit 0;
			;;
		":")
			echo "No argument value for option $OPTARG"
			exit 0;
			;;
		*)
			echo "Unknown error while processing options"
			exit 0;
			;;
	esac
done
 
