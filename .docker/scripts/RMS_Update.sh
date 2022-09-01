#!/bin/bash

# This script is used for updating the RMS code from GitHub

# WARNING: The update might fail when new dependencies (libraires)
#  are introduced! Further steps might have to be undertaken.


RMSSOURCEDIR=~/RMS

RMSBACKUPDIR=~/.rms_backup

# Make the backup directory
mkdir $RMSBACKUPDIR

# Back up the config and the mask
cp $RMSSOURCEDIR/.config $RMSBACKUPDIR/.
cp $RMSSOURCEDIR/mask.bmp $RMSBACKUPDIR/.

cd $RMSSOURCEDIR

git stash
git pull

# Activate the virtual environment
# source ~/vRMS/bin/activate

# Run the python setup
python setup.py install

# Copy the config and the mask back
cp $RMSBACKUPDIR/.config $RMSSOURCEDIR/.
cp $RMSBACKUPDIR/mask.bmp $RMSSOURCEDIR/.
