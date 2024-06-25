#!/bin/bash  

RSYNC_OPTIONS="-chavuP --exclude='*.swp'"

if [ "$1" == "--dry" ]; then
	echo "This is a dry run..."
	echo ""
	RSYNC_OPTIONS="${RSYNC_OPTIONS}n"
else 
	echo "Synchronization in progress"
	echo "" 
fi


read -p "Enter the remote username: " REMOTE_USER
rsync $RSYNC_OPTIONS --delete -e ssh Alpine_Inception:/home/$REMOTE_USER/project .
 
