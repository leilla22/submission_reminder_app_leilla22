#!/bin/bash
#asking the user to enter the name
echo "The directory has to have names"
read -p "Enter your directory names: " names
if [ -z "$names" ]; then
	echo "Please enter your names:"
	echo "the input is empty"
	exit 1
fi
#creating the folder
dir="submission_reminder_$names"
mkdir -p "$dir"
