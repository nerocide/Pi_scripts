# Pi_scripts

Here are a bunch of helper scripts that help you turn your raspberry pi into a 3D printer box control.

__Even if the set of script is genereic, there is no garanty it will work for your environnement__

This one launch all others, it also provides installation for fail2ban.

	$ ./FullPiInstall.sh

## Octoprint

This script help you to install and setup [octoprint](https://octopi.octoprint.org/)
If for any reasons you have to reinstall(-r) from scratch, your data will be saved and restored automatically.
 
	pi@raspberrypi:~ $ ./Octoprint_reinstall.sh
	You are Pi :) <3 Let's start <3
	Please provide arguments
	Usage: Octoprint_reinstall.sh [option]
	Version 0.1 
	 		-h	print help
	 		-a	Autodetect actions
	 		-i	Install
	 		-u	Update
	 		-r	Reinstall


##  Slic3r

[Slic3r](http://slic3r.org/) is the famous opensource STL to gcode slicer.

	$ ./Slic3r_install_Octoprint.sh

This script dowload and install Slic3r (forced version 1.2.9)

Thanks to Javier Martínez Arrieta

## Mjpg-streamer

This script help to install [MJPG streamer](https://github.com/jacksonliam/mjpg-streamer) and set it up as a service.

	$ ./Mjpg-streamer_install.sh

## HA proxy

This script helps you to install and setup HA proxy for Octoprint, so that you can easily access all your services from a single URL

By default it :

* listens on **tcp/80** & **tcp/443**
* the webcam URL is **/webcam/**
* it redirects to **localhost:5000**

Use as is:

	$ ./HAproxyInstall.sh

