#!/bin/bash
echo "Starting RMS..."
sleep 10
# source ~/vRMS/bin/activate
cd ~/RMS
python -m RMS.StartCapture

read -p "Press any key to continue... "

$SHELL