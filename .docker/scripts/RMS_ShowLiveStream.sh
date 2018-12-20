#!/bin/bash
echo "Starting RMS..."
sleep 10
#source ~/vRMS/bin/activate
cd ~/RMS
python -m Utils.ShowLiveStream

read -p "Press any key to continue... "