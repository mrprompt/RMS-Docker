#!/bin/bash

# Google DNS server IP
IP='8.8.8.8'

# Contact e-mail
RMSEMAIL="denis.vida@gmail.com"

# RMS config file
RMSCONFIG=~/RMS/.config

# Auto run enable flag file
RMSAUTORUNFILE=~/.rmsautorunflag

RMSSTARTCAPTURE=~/Desktop/RMS_StartCapture.sh
RMSUPDATESCRIPT=~/Desktop/RMS_Update.sh

# If the autorun file does not exist, create it and run the configuration
if [ ! -f $RMSAUTORUNFILE ]; then
  echo "0" > $RMSAUTORUNFILE
else
  # If the autorun file exists, check if the configuration was already done
  AUTORUNSTATUS=$(cat $RMSAUTORUNFILE)

  if [ "$AUTORUNSTATUS" = "1" ]; then

    # If the configuration was done, run recording
    bash $RMSSTARTCAPTURE
    exit 1
  fi
fi

# If autorun is not enabled, run the first setup

reset

echo "Hey, welcome to the Raspberry Pi Meteor Station (RMS) project!

This guide will help you to get your system up and running in no time!


IMPORTANT! Before you proceed make sure you have the following:

 1. Geo location of your camera (latitude +N, longitude +E, elevation).
   The latitude and longitude should be in degrees to at least 5 decimal
   places. Be careful that the longitude of places in the western hemisphere
   is negative. E.g. if your camera was installed on the Statue of Libery,
   the latitude would be 40.689298 and the longitude would be -74.044479.
   The elevation should be given in meters (NOT feet!)
   The easiest way to deterine these values is by using a GPS app on your phone.

 2. Unique station code. To obtain a station code, send an e-mail containing
    the following to Denis Vida ($RMSEMAIL):
      a) Geo coordinates from step 1.
      b) Your country.
      c) Brief description of the camera system (location, owner's name),
         e.g. Mike Henderson's camera in London, Ontario, Canada.

    You will then be given a unique station code which will look something
    like this: US1234. The first two letters is the ISO code of the country,
    and the last 4 characters are the unique alphanumeric identifier.

IMPORTANT: READ THE INSTRUCTIONS ABOVE BEFORE CONTINUING!

Press Q to continue.
" | less -X

echo "-----------------"
echo ""

echo "If you DON'T have the geo coordinares and/or the station code, press CTRL + C
to exit this guide.

Otherwise, press ENTER to continue."

read -p ""


echo ""
echo "This is a brief overview of this guide:"
echo "  0. Expand the file system (if you flashed this SD card yourself)."
echo "  1. Connect your Pi to the Internet. "
echo "  2. Change the default password for security reasons."
echo "  3. Generate a new SSH key."
echo "  4. Edit the RMS config file. "

echo ""

echo "
0) Expanding the file system
----------------------------
If you have bought a system that was already assembled, or the file system
has already been expanded, PRESS ANY KEY to continue.
"

read -n1 -r -p 'If you have flashed this SD card yourself, press ENTER.' key

if [[ "$key" = "" ]]; then
    lxterminal -e "sudo raspi-config"
    
    echo "
    Another window has opened where you can expand the file system.
    
    Go to:
    
    7 ADVANCED OPTIONS -->
      A1 EXPAND FILE SYSTEM -->
        < OK >

    < FINISH > (at the bottom) -->
      < YES > (reboot)

    Your Raspberry Pi will reboot.
    "

    read -p "Press ENTER to continue..."
fi

echo ""
echo ""

# Check if connected to the Internet
echo "1) Internet connection"
echo "----------------------"
echo "Checking if connected to the Internet..."
if ping -c 1 $IP &> /dev/null
then
  echo "Success!"
else
  echo "The device is not connected to the internet! Please connect the device to the Internet to proceed!" 
  exit 1
fi

echo ""
echo "2) Changing the default password"
echo "--------------------------------"
echo "The default password is 'raspberry'. Please change it so nobody can connect to your Raspberry Pi and hack your network!"

echo ""
read -n1 -r -p 'Press ENTER to change the password (recommended), or ANY OTHER KEY to skip this step...' key

if [[ "$key" = "" ]]; then
    passwd
fi

echo ""
echo ""
echo "3) Generating a new SSH key"
echo "---------------------------"

read -n1 -r -p 'Press ENTER to generate the SSH key (recommended), or ANY OTHER KEY to skip this step...' key

if [[ "$key" = "" ]]; then
  echo ""
  echo "Generating a new SSH key..."

  # Generate an SSH key wihtout a passphrase
  yes y | ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa >/dev/null

  # Copy the public SSH key to desktop
  cp ~/.ssh/id_rsa.pub ~/Desktop/.

  echo ""
  echo "A file called id_rsa.pub appeared on Desktop, please send this file to Denis "
  echo "Vida ($RMSEMAIL) before continuing!"

  read -p "Press ENTER to continue"

fi

echo ""
echo "Updating to the latest version of RMS..."
bash $RMSUPDATESCRIPT

echo ""
echo "4) Editing the configuration file"
echo "---------------------------------"
echo "Finally, edit the RMS configuration file."
echo "Put in the station code/ID and the geo coordinates of your camera, save the"
echo "file and you are good to go!"
echo ""

echo "
If you need to make changes to the configuration file in the future, you can
find a shorcut to it on desktop (RMS_config), or open it directly in
$RMSCONFIG.
"

read -p "The configuration file will open for edition after you press ENTER..."

# Open the config file
leafpad $RMSCONFIG

echo ""



while true; do

# Check if the config file was changed
statID=$(grep stationID $RMSCONFIG | cut -d ":" -f 2 | xargs)

if [ "$statID" = "CA0001" ]; then
  echo "The config file was not changed!"
  echo "Please change the station ID and the geo coordinates in the config file!"

 # Open the config file
  leafpad $RMSCONFIG
else
  break
fi
done

# Enable autorun
echo "1" > $RMSAUTORUNFILE


# If the configuration was done, run recording
bash $RMSSTARTCAPTURE
